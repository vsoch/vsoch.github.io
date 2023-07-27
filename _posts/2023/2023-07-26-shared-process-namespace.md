---
title: "Shared Process Namespace between Pods in Kubernetes"
date: 2023-07-26 17:30:00
---

I was working on something else earlier this week, and during my exploration to find a solution for a different problem,
stumbled on this idea of [shared process namespaces](https://kubernetes.io/docs/tasks/configure-pod-container/share-process-namespace/). It blew my mind because it meant that we could inspect or monitor processes in one container to another, and perhaps have a consumer/producer or controller/application model. it also meant that I could separate application logic from a "something else" - something I've wanted to do for some time! I'm really excited about this discovery, and although the work is early, in this post I want to share some of what I learned.

## Early Experiments

First, let's briefly show how this can work. This is a simple pod pair setup that I came up with. Your pods don't have to be in a [JobSet](https://github.com/kubernetes-sigs/jobset/), but I'm enjoying using them now (and the design) so this was my choice.


```yaml
apiVersion: jobset.x-k8s.io/v1alpha2
kind: JobSet
metadata:
  name: goshare
spec:
  replicatedJobs:
  - name: workers
    template:
      spec:
        parallelism: 2
        completions: 2
        backoffLimit: 0
        template:
          spec:
            shareProcessNamespace: true            
            containers:

            # The server will start the main process to listen for commands
            - name: server
              image: golang:1.20
              stdin: true
              tty: true

            # The client needs to be able to read the server fs
            - name: client
              image: golang:1.20
              securityContext:
                capabilities:
                  add:
                    - SYS_PTRACE
              stdin: true
              tty: true
              
```

I also chose Go bases because ultimately I tried creating a simple socket server using Go, where one container could connect to the other via a shared socket (done via the shared filesystem under proc - more about this next!) The important pieces in the above are setting "shareProcessNamespace" to true, and then adding the "SYS_PTRACE" capability under the client container. And then it just works. A note to Kubernetes developesr - I love you! 🥰️

### Flux Shared Socket

When I discovered this, my first idea was to create a Jobset with a pod and two containers, each running Flux.
What I was able to do is interactively start a flux instance in Container A, run a job in it, and then (via the shared namespace)
connect to the socket in Container A's filesystem via the `/proc/<pid>/root` directory from Container B. I discovered this
by way of [reading about proc](https://man7.org/linux/man-pages/man5/proc.5.html). And actually, there is so much rich
content there my head is teeming with ideas for what else we can do! But I digress. Let's step back and walk through
how I approached this. After starting a flux instance and submitting a job in Container A, I could shell into
Container B and then easily see processes that are shared across the containers via "ps aux":

```
 fluxuser@flux-flux-0-0:~$ ps aux
USER         PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
65535          1  0.0  0.0    972     4 ?        Ss   21:46   0:00 /pause
fluxuser       7  0.0  0.0  22004  3380 ?        Ss   21:48   0:00 start --test-size=4 sleep infinity
fluxuser      19  0.1  0.1 1253084 17824 ?       Sl   21:48   0:00 /usr/libexec/flux/cmd/flux-broker --setattr=...
fluxuser      20  0.0  0.0 630192 10992 ?        Sl   21:48   0:00 /usr/libexec/flux/cmd/flux-broker --setattr=...
fluxuser      21  0.0  0.0 621828 11044 ?        Sl   21:48   0:00 /usr/libexec/flux/cmd/flux-broker --setattr=...
fluxuser      22  0.0  0.0 621960 11008 ?        Sl   21:48   0:00 /usr/libexec/flux/cmd/flux-broker --setattr=...
fluxuser      55  0.0  0.1 1187532 17296 pts/0   Ssl  21:48   0:00 /usr/libexec/flux/cmd/flux-broker /bin/bash
munge         73  0.0  0.0  71180  1940 ?        Sl   21:48   0:00 /usr/sbin/munged
fluxuser     196  0.0  0.0   8968  3828 pts/0    S+   21:48   0:00 /bin/bash
fluxuser     256  0.0  0.0   7236   580 ?        S    21:48   0:00 sleep infinity
fluxuser     288  0.0  0.0  51920 10508 ?        S    21:50   0:00 /usr/libexec/flux/flux-shell 2411808687104
fluxuser     289  0.0  0.0   7236   516 ?        S    21:50   0:00 sleep 900
fluxuser     291  0.0  0.0   8968  3884 pts/1    Ss   21:51   0:00 bash
```

Note that pid 7 is our process of interest, as it was my flux start command, and (akin to the others) is shared between the containers. Also note that both containers are running as root (uid 0). From this process we can peek into the entire filesystem:

```bash
$ ls /proc/7/root/tmp/flux-jhgpJK/
content.sqlite  jobtmp-0-ƒ26MYGwXM  local-0  local-1  local-2  local-3  start  tbon-0  tbon-1
```

Then by way of just connecting to that socket, I could see the job that was submit in the other container!

```bash
 fluxuser@flux-flux-0-0:~$ flux proxy local:///proc/7/root/tmp/flux-jhgpJK/local-1 bash
ƒ(s=4,d=0) fluxuser@flux-flux-0-0:~$ flux jobs -a
       JOBID USER     NAME       ST NTASKS NNODES     TIME INFO
   ƒ26MYGwXM fluxuser sleep       R      1      1   3.654m flux-flux-0-0
```

This was the point earlier this week when my head exploded 🤯️, and I had to clean up my brains and excitement
before going out for my evening run! 😆️ And we were able to do this just via a shared filesystem socket. But there is more! If you read the [man page](https://man7.org/linux/man-pages/man5/proc.5.html) for this namespace, it is really rich with information! 
I only took advantage of the content of "root" but there is just so much here.

```console
/proc/pid                  # The virtual address space of a PID, from the other container!
/proc/pid/attr             # API for security modules
/proc/pid/attr/current     # Current security attributes of the process
....
/proc/7/autogroup          # I see "nice" so I think this is CPU scheduling related?
/proc/7/auxv               # "Contents of the ELF interpreter"
/proc/7/cgroup             # control group (e.g., 0::/../cri-containerd-a3cd74dfc...)
/proc/7/clear_refs         # Write only file that can be used for assessing memory usage
/proc/7/cmdline            # Nuts! This is the command line! (I see the nginx start command)
/proc/7/comm               # Command name (e.g., I see "nginx")
/proc/7/coredump_filter    # This controls (filters) what parts of a coredump are written to file
/proc/7/cpuset             # "confine memory and processes to memory subsets" I see the same cgroup here
/proc/7/cwd/               # Wow, symbolic link to CWD of process - I see the root of the nginx container
/proc/7/environ            # Environment when process executed
/proc/7/exe                # Actual symbolic link to binary executed
/proc/7/fd                 # Directory that shows all the file descriptors the process has open
/proc/7/fdinfo
```

Given they are being run by the same user, the permissions should work. If you try to peek into a process being run by a different UID, it will give you a permission denied error. This early experiment is [here](https://github.com/converged-computing/benchmark-operator/tree/main/hack/test/process-sharing). When I was able to connect across the containers and connect to the other container's flux socket, I got really excited. This week has been fun and exciting because of just learning this new thing... <strong>#vanessaproblems</strong>.

### Go Application

It occurred to me that (external to Flux) given the ability to peek into the other filesystem (and actually read and write to it) I could use this as a technique to have one container request a command to be run on the other container. This was slightly unrelated to my actual goal, but since it would provide a means for learning, I decided to jump in!  I came up with an early design for a producer and consumer model, which would allow sharing commands between containers in Kubernetes. I decided to try doing this using gRPC over unix domain sockets (UDS) via:

<ol class="custom-counter">
  <li>Running a process in the consumer (server) container listening on a socket.</li>
  <li>This creates a PID that the producer (client) can find in /proc/$pid</li>
  <li>Starting the producer, pointing it to the socket of the consumer</li>
  <li>We expect this socket to be at a known path in /proc/$pid/root</li>
  <li>The producer client then issues a request to run a command to the consumer</li>
</ol>

It's really a fiendish trick for not just communicating via shared processes, but also sharing a storage space, which is hard in Kubernetes. It only applies for containers within the same pod, but I still think this is pretty great. At this point, we can run the producer client as many times as needed, providing a command to give to the consumer to execute. The consumer receives the command, executes it, and along the way returns the PID and the output. In this design I tested first a unary interaction, meaning there was a request and response, but ultimately converged on a bi-directional interaction where it would be expected to first return the pid, and then the output and then close the connection. I had a lot of fun creating a library in Go that used unix sockets, and proto3 (my first time!) for defining the communication protocol. For those interested, [my library is here](https://github.com/converged-computing/goshare), there are [examples with Go and LAMMPS](https://github.com/converged-computing/goshare/tree/main/test), and you can read more about [proto here](https://grpc.io/docs/what-is-grpc/core-concepts/). I was able to get this example working in vanilla Jobsets, along with a prototype in the Flux operator. An example watching the logs of two containers is shown below.

<div style="padding:20px">
<a href="{{ site.baseurl }}/assets/images/posts/process-sharing/process-sharing.png"><img src="{{ site.baseurl }}/assets/images/posts/process-sharing/process-sharing.png"></a>
</div>

In the picture above, I start the server (the container with some application of interest) to listen for requests. This is the blue on the left. The second container (the client) waits until it sees the process (identified by name and grep, ha) and then issues commands to the expected socket located in the pid root directory. This is the picture on the right, in purple. In the client purple picture, I run both a "hello world" and LAMMPS example. We can see on both sides that server and client are sending messages back and forth to communicate PIDs and output. Of course LAMMPS is only running on this local node - to connect to other nodes we'd need to think a bit harder about the design.

## Next Steps

I originally stumbled into this wanting to run benchmarks for storage, because it's really hard on Kubernetes and I want to explore the space to better understand and work on it. No, I don't care that I don't know anything about how to do that - that's what makes it fun, diving in and finding out! I have some ideas for storage and ABI, but I didn't have a good strategy for peeking into processes (without requiring my benchmarking application to be installed alongside in the same container). I think this might be a viable strategy, and I am excited to explore the space more. Can we have an entire application logic based on interacting with separate application containers? Can we share more than one? Is using a shared socket file worth it (e.g., why not just use the local network?) How can we use this to assess ABI - something perhaps in "/proc/pid/maps" ? There are a lot of questions, indeed! I want to call out this design and share with others in case you have other use cases too.

There are so many exciting things to learn, and I hope that others out there might share my excitement to stumble on a new space to work in. I absolutely love containers and Kubernetes, and this seems to be spilling out of containers a bit too? 😁️ Program on, friends!
