---
title: SSH Tunnels
date: 2022-06-26 12:30:00
categories: [rse, hpc]
---

Today I want to talk about ssh tunnels. Very abstractly, we would want to use an ssh
tunnel to securely send information. In the case of HPC, you are probably familiar with ssh,
(Secure Shell or Secure Socket Shell) when you login to your node. You might do something like this:

```bash
$ ssh dinosaur@server.address.edu
```

Or if you have a proper setup in your `~/.ssh/config` (with a named server) you might just do:

```bash
$ ssh dinosaur
```

I like to use <a href="https://en.wikibooks.org/wiki/OpenSSH/Cookbook/Multiplexing" target="_blank">ssh connection multiplexing</a>
so the connection is kept alive for a bit, but I won't go into detail because
this post isn't specifically about the details of ssh. The use case I'm interested in (and the thing
that HPC is very bad at) is how to deploy something interactive on an HPC cluster. 

## SSH Tunnel with Ports

Given that a cluster has exposed ports (either the login node, or both the login node and compute nodes)
creating a tunnel is fairly straight forward! In the past I created a tool called <a href="https://github.com/vsoch/forward" target="_blank">forward</a> to handle all the manual steps to get this working, meaning:

<ol class="custom-counter">
  <li>Show the user <a href="https://github.com/vsoch/forward#ssh-config" target="_blank">how to set up their ~/.ssh/config</a> (once)</li>
  <li>Define (once) parameters like a port, memory, GPUs, and if the cluster has isolated nodes</li>
  <li>Start any number of provided apps that come with forward (e.g., jupyter, singularity, etc.)</li>
</ol>

An interaction using forward might look like any of the following:

```bash
# Run a Singularity container that already exists on your resource (recommended)
bash start-node.sh singularity-run /scratch/users/vsochat/share/pytorch-dev.simg

# Execute a custom command to the same Singularity container
bash start-node.sh singularity-exec /scratch/users/vsochat/share/pytorch-dev.simg echo "Hello World"

# Run a Singularity container from a url, `docker://ubuntu`
bash start-node.sh singularity-run docker://ubuntu

# Execute a custom command to the same container
bash start-node.sh singularity-exec docker://ubuntu echo "Hello World"

# To start a jupyter notebook in a specific directory ON the cluster resource
bash start.sh jupyter <cluster-dir>

# To start a jupyter notebook with tensorflow in a specific directory
bash start.sh py3-tensorflow <cluster-dir>
```

Note that the last set of commands are pertaining to notebooks, which is where these tunnels come into play!
A notebook is going to be run on a compute node that looks something like the following:

```bash
$ jupyter notebook --no-browser --port=$PORT
```

And if you ran this with a Singularity container, you'd also want to bind jovyan's home to be the user's, along with the jupyter config directory:

```bash
$ singularity exec --home ${HOME} \
    --bind ${HOME}/.local:/home/jovyan/.local \
    --bind ${HOME}/.jupyter:/home/jovyan/.jupyter \  
    datascience_notebook.sif jupyter notebook --no-browser --port=$PORT --ip 0.0.0.0
```

As we described earlier <a href="https://github.com/vsoch/forward#ssh-port-forwarding-considerations" target="_blank">here</a>,
there are subtle differences between making a tunnel (with a port) given that you have isolated nodes (or not).
You can determine this based on your ability to ssh into a non-login node (meaning where your job is running) from "the outside world"
that is your computer. If you cannot, your nodes are isolated, which we will discuss next.

### Isolated Nodes

Let's say that we need to create a tunnel (using ports) to an isolated node. This means that we are basically going
to establish a tunnel to the login node, and then from the login node another one to the compute node.
We might use a command that looks like this:

```bash
$ ssh -L $PORT:localhost:$PORT ${RESOURCE} ssh -L $PORT:localhost:$PORT -N "$MACHINE" &
```

In the command above, the first half (`ssh -L $PORT:localhost:$PORT ${RESOURCE}`) is executed on the local machine, which establishes a port forwarding to the login node. The "-L" in the above (from the <a href="https://linuxcommand.org/lc3_man_pages/ssh1.html" target="_blank">man pages</a>) :

> Specifies that connections to the given TCP port or Unix socket on the local (client) host are to be forwarded to the
> given host and port, or Unix socket, on the remote side.
> This works by allocating a socket to listen to either a TCP
> port on the local side, optionally bound to the specified
> bind_address, or to a Unix socket.  Whenever a connection is
> made to the local port or socket, the connection is for‐
> warded over the secure channel, and a connection is made to
> either host port hostport, or the Unix socket remote_socket,
> from the remote machine.

Or in layman's terms:

> Forward whatever is running on the second port on my resource to my local machine.

Since we are forwarding ports, this would require minimally the login node to expose ports.
The next line `ssh -L $PORT:localhost:$PORT -N "$MACHINE" &` is a second command run from the login node, 
and port forwards it to the compute node, since you can only access the compute node from the login nodes.
You'll notice it looks just like the first, and this works because ssh commands can be chained.
The `-N` says "don't execute a remote command (and just forward the port)."
Finally, the last `$MACHINE` is the node that the jupyter notebook is running on.

### Not Isolated

For HPCs where the compute node is not isolated from the outside world the ssh command for port forwarding first establishes a connection the login node, but then continues to pass on the login credentials to the compute node to establish a tunnel between the localhost and the port on the compute node. The ssh command in this case utilizes the flag `-K` that forwards the login credentials to the compute node:

```bash
$ ssh "$DOMAINNAME" -l $FORWARD_USERNAME -K -L  $PORT:$MACHINE:$PORT -N  &
```

I'm not sure in practice how common this is anymore. At least at my current employer it's not even the case
that ports are exposed on the login node! It's probably better that way, because in cases where you do get ports it's sort of a 
"pick a port above this range and hope that no other user picks the same one!" It's messy. 
So let's talk about the case of not having ports exposed next, since this was the entire reason I wanted to write this post!

## SSH Tunnel with Socket

More than a year ago, I had this realization that a lot of people at Stanford used the "forward" tool, and just for notebooks (and this
was before they were available via Open OnDemand, which is what I'd recommend to a Stanford user at this point). I decided I wanted to make a new 
open source tool, "tunel" (an elegant derivation of "tunnel") <a href="https://github.com/vsoch/tunel" target="_blank">vsoch/tunel</a> to make it easy
to run what I call "apps" on an HPC cluster. Are there better ways of exposing user interfaces on HPC? Yes, indeed. But not everyone
has easy access. It was also a stubborn "I want this to work" proof of concept. This new tool would be like forward, but a little nicer.
Because I, along with every other HPC developer and user, wishes we could have nice things 😭️.

At this time I had just started a new role at a national lab, and I realized that none of my old techniques for launching
the job worked because of the lack of exposed ports. Thinking this was impossible, I abandoned it for a year. But then this last week I found 
<a href="https://github.com/jupyter/notebook/pull/4835" target="_blank">this</a>! I was motivated! I was excited! The basic launch command of the notebook looks like this:

```bash
$ jupyter notebook --sock /tmp/test.sock --no-browser
```

And then with a different looking tunnel, we could forward this socket to the host, and map it to a port! My excitement was then brought down
by what led to two days of struggling. I first tried my entire tunel workflow, meaning launching a job on a node,
and then running that command, and providing the instruction to the user to create the tunnel as follows:

```bash
$ ssh -L 8888:/tmp/test.sock -N user@this_host
```

That didn't work (and remember this socket was created on the isolated node, that's important to remember for later). So I started looking at the socket with "nc"  - "arbitrary TCP and UDP connections and listens" from the login node. The "-U" below is for UNIX sockets:

```bash
$ nc -U /tmp/test.sock
```

And from the head node I saw:

```bash
Ncat: Connection refused.
```

So then I knew I needed a simpler, dummier example. I got rid of tunel and just ran the notebook command on the head node.
Dear reader, it still did not work. I <a href="https://github.com/jupyter/notebook/issues/6459" target="_blank">opened an issue</a> and asked <a href="https://twitter.com/vsoch/status/1540546526044250112" target="_blank">Twitter for help</a>. Someone else on Twitter reported that <a href="https://twitter.com/al3x609/status/1540846694262243328" target="_blank">it worked for them</a>, and that (in my opinion) is the challenge and story of HPC - given the huge differences in setups, it's hard to reproduce what another person does unless you scope to a very specific
environment or technology and hugely go out of your way to do it. I'm always grateful when someone tries to help, but when the ultimate answer is just
"But it works on my machine!" I (and I think all of us) are like:

<span style="font-size:50px; color:darkorchid">(╯°□°)╯︵ ┻━┻</span>

🤣️

Please know that is intended to be funny, and I really am grateful for the attempt to help! Anyway, the first night I was devastated because I was so excited about the possibility of this working! But of course (as it usually does) my quasi-sadness turned again into relentless stubborn-ness, and for my Saturday
I embarked on trying everything. I call this the stubborn brute force approach, and it actually leads to some pretty good outcomes?

### Socket from Login Node

First from the login node, I started reading about flags in detail, again from the <a href="https://linuxcommand.org/lc3_man_pages/ssh1.html" target="_blank">man pages</a>. It occurred to me that the suggested command included "-L" (discussed earlier) but there were a ton of other flags to try, and maybe I need them for my setup? The command that wound up working (after much trial and error) was just:

```bash
# Running on login node
$ ssh -NT -L 8888:/tmp/test.sock user@server
```

And here again was the suggested command:

```bash
$ ssh -L 8888:/tmp/test.sock -N user@this_host
```

So they are very similar - and the main difference is the `-T` is to "Disable pseudo-terminal allocation."
So I suspect (also based on the version of ssl I'm using) that without the flag, you might be making a request for a pty to the server
(<a href="https://stackoverflow.com/questions/10330678/gitolite-pty-allocation-request-failed-on-channel-0/10346575#10346575" target="_blank">more details here</a>) and then it could abort. Adding the flag just skips this, because we don't need that - we just need the simple forward. And yes, this indeed feels very specific to your ssh setup, version of ssh, and server configuration. Of course, this was only the beginning of figuring things out, because I had no idea how to get this working from one level deeper - an isolated compute node.

### Socket with Isolated Nodes

Remember that when we created the socket on the isolated node and we tried this out from the login node:

```bash
$ nc -U /tmp/test.sock
```

And the result was this:


```bash
Ncat: Connection refused.
```

My spidey senses were telling me that this should work. Indeed, when I ssh into the isolated node from the login node,
that same command allowed me to connect (meaning it hung / there was no error output). So my first task, I decided, was to try
and "forward" this socket to the login node. Again, back to the man pages! I wound up with something like this (run from the login node):

```bash
$ ssh isolated-node -NT -L /home/dinosaur/login-node.sock:/home/dinosaur/jupyter.sock
```

The above is again using `-L` but instead of a port (which aren't exposed) we are using a socket! It's kind of neat you can switch out those two. 
When I tried the same nc command from the login
node, we had progress (no connection refused message!) 🎉️ And then I moved this up one level to see if I could make this same request from my local machine, sort of combining the first command that worked with the login node notebook with this one. That looked like this (and yes this took more trial and error):

```bash
$ ssh -NT user@server ssh isolated-node -NT -L /home/dinosaur/login-node.sock:/home/dinosaur/jupyter.sock
```

And to confirm it was working, I'd ssh into the server and again run that nc command to ensure that the newly forwarded socket was readable from
the login node. After this, again with more trial and error, I tried running a second command to just forward that (now working socket) to my host.
That eventually looked like this:

```bash
# And another for the local socket
$ ssh -NT -L 8899:/home/dinosaur/login-node.sock user@server
```

And then (all together now!) I tried putting them together.

```bash
$ ssh -NT -L 8899:/home/dinosaur/login-node.sock user@server ssh isolated-node \
       -NT -L /home/dinosaur/login-node.sock:/home/dinosaur/jupyter.sock
```

And then I spent some time integrating it into tunel, and *surprise!* the first implementation didn't work. The first bug was that I needed to clean up old sockets each time the "same" app was run (determined by the job name and organizational namespace so the user can only run one of a particular interactive app at once, and not forget about previous runs). The second issue was about opening the tunnel - it didn't seem to work if the process exited and/or it was run in a subshell (that also probably exits). I realized that (for the time being) running this connection step on behalf of the user, since it's something the user should have more control over, probably wasn't the right way to go. If the user hasn't added something like an rsa key to `~/.ssh/authorized_keys` on their clusters, it would also ask for a password interactively, making it harder for me to manage. So for simplicity sake, and assuming that we really should put the user in control of deciding when to start/stop the tunnel, I simply print the full ssh command in the terminal and let them copy paste it. A successful connection might then prompt them for their password for that second ssh, which (by default) I don't think is carrying forward auth from the first.

So that was my adventure! Mind you, this entire adventure was only about two days, and that included time to write this post, so I still have lots in front of me to work on. However, with these updated commands (and some nice tweaks from Python's <a href="https://github.com/Textualize/rich" target="_blank">rich</a> library) I quickly had a nice set of commands to run and stop an app with an interactive jupyter notebook, and using sockets on isolated nodes!

```bash
$ tunel run-app server slurm/socket/jupyter
$ tunel stop-app server slurm/socket/jupyter
```

<script id="asciicast-504370" src="https://asciinema.org/a/504370.js" data-speed="2" async></script>

As a sidenote, one thing I like about rich is that it puts the aesthetic as a first class citizen.
So many tools just don't consider this, and I love that with rich I can think about colors, presentation,
and even animations like spinners!

<script id="asciicast-504268" src="https://asciinema.org/a/504268.js" async></script>

Getting a socket working  means I'll be able to continue working on this library (hooray!) so if you have ideas or requests for apps
you'd like to run on HPC, assuming just this basic technology, please give me a ping and I'd love to chat and support them.
I'm also going to be requesting an allocation on the Open Science Grid, which hopefully will give me other kinds of clusters
to test on. I hope this was interesting to read, thanks for doing that!
