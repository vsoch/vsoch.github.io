---
title: "Hairballs and Binaries"
date: 2023-09-27 10:00:00
---

I mean it with the utmost affection when I say that many high performance computing applications are like hairballs. Often when we are aspiring for peak performance, we bring in many system and shared libraries, and (in contrast to a single binary that might be compiled by Rust or Go), our larger applications tend to be hairballs -- tangled in an intimate web with our operating systems and kernels to produce a lovely monster.

But now let's talk about cloud, and what this means for it. Features of cloud-native applications that are important are portability, and efficiency not in how they run, but how they deploy. Although I might be able to build an entire HPC application into a single container to run in either place, there are specific features of working in the cloud that are not easy to satisfy in the context of an HPC application. Let me give you an example. It's often the case that we want to quickly add an application or binary to a container. I've seen this with container bases that needed an aws compiled binary added "on the fly," or for Seqera Labs fusion filesystem, a binary compiled from Go that is quickly downloaded, extracted and used. I've even designed a [container storage interface](https://github.com/converged-computing/oras-csi) or CSI that knows how to add OCI Registry as Storage (ORAS) artifacts on the fly. 

## The Chonkers, they be too chonky

So what happens when you want to do this with something massive - a complex application like HPCToolkit or Flux? Or one of the actual scientific workflows at the lab? I won't tell you the workflow, but I built the dependencies into a container and it was ~25GB. For the latter, we might see a container around 900MB or a few GB. My point is that aside from the tangled nature of the software, the size is immense. Packaging them into one layer (which I've also tried) didn't work super well, unless you are OK with going on a small vacation while your container(s) is/are pulling. But this also set the stage for our problem. We need a strategy that renders a big, hairbally HPC-thing portable and quickly usable in a container, to be added on demand. Now let me begin my story.

## It started with HPCToolkit

This first adventure actually started with HPCToolkit. I wanted to add it to the Metrics Operator as a metric, but I realized quickly that I had a flaw in my operator design. It was way too complex because I was trying to define different kinds of "Metric Set" where a metric set is one or more metrics of a particular type, like storage, application, or performance. I would then match a design for a JobSet to a particular kind. For example, an application metric set could have a [shared process namespace](https://vsoch.github.io/2023/shared-process-namespace/). A storage metric set expected a volume. This made sense for some metrics (e.g., IO) but quickly turned into a mess, because I realized the categories were limited. I wound up putting most of the new metrics into a catch all category I called "standalone" that meant "this matches no pattern." By a few weeks into the operator existing, I already hated it.

I realized that I wanted a simpler design, one where a Metric Set is one simple thing, a set of metrics (or more realistically, just one), and onto which you add "addons" to customize it. So I had several 2-3am late coding evenings [to do that refactor](https://github.com/converged-computing/metrics-operator/pull/63). It's sessions like these that are both magical and (in retrospect) give me pause that I really was able to do that much programming in such a short period of time. But for this new design - I had an idea that I loved, and this was the idea of an "addon." An addon is a very generic entity that can customize a jobset in really just about any way. It can add volumes, config maps, capabilities, customize entrypoint commands, or even deploy containers alongside the sidecar. Implementation wise, the main JobSet that is created for the metric is handed to the addon and then (via a set of common interfaces) can tweak it as it pleases. That's another part of the design I could talk about for a while - my use of interfaces to allow for shared functionality across the operator. I'll hold off for now.

So where does HPCToolkit come in? Well, the first challenge was that it uses [LD_AUDIT](https://vsoch.github.io/2021/ldaudit/). So any hope of using a shared process namespace was not going to work (and I tried it) because the libraries all needed to be present. I needed to physically get HPCToolkit into the container, quickly and on demand (cue visual of a gigantic monster trying to shove itself into a small box). The next challenging thing was that the only way I figured out how to install it was with spack. Even the developers don't have other suggestions - spack is "the current way." That led me to the problem of looking at their GitLab, and seeing that their Dockerfile recipes had COPY commands for assets that weren't shared. So I needed to start from scratch, and the developers in the slack recommended containerize. After about 3-4 failures, I finally had some luck. But spack was a blessing in disguise because it gave me a a crazy idea. When I paused working on a while back, there was the concept of a copy view. It was broken at the time, but I had faith it would be working by now! So if spack's view, specifically a copy view to create an isolated root with all the files, could work... could I create some kind of isolated location in a container that could be moved between containers? 🤔️

## Empty Volume to the rescue!

The insight here is that although volumes in Kubernetes are hard, empty volumes are not. An empty volume is exactly that - its a read/write location that can be shared between containers in the same pod. And this was absolutely perfect, because I'd want HPCToolkit to be present in every pod alongside some application container. My "simple" idea, which seemed impossible at the time, was to build this container with HPCToolkit in a spack view, create the empty volume, have one container (the sidecar with the view) copy it into the empty volume, and then have the second container wait for it to finish, and then use it.

Dear reader, it absolutely worked. And this is why the idea of the addon was so beautiful. HPCToolkit was an addon, and it knew how to add itself as a container, create the empty volume, copy the view to it, and then customize the main job (e.g., your application) entrypoint to wait for the copy to finish, finalize any setup, and then wrap the original command with the monitoring command "hpcrun." Although it would take the developer user a bit of tweaking to get it right, once that was done, it was a recipe that was easy to use. The custom resource definition (YAML file to make it all work for the operator) looked like this:

```yaml
apiVersion: flux-framework.org/v1alpha2
kind: MetricSet
metadata:
  name: metricset-sample
spec:
  # Number of pods for lammps (one launcher, the rest workers)
  pods: 4

  metrics:

   # Running more scaled lammps is our main goal
   - name: app-lammps
     options:
       command: lmp -v x 2 -v y 2 -v z 2 -in in.reaxc.hns -nocite
       workdir: /opt/lammps/examples/reaxff/HNS

     # Add on hpctoolkit, will mount a volume and wrap lammps
     addons:
       - name: perf-hpctoolkit
         options:
           mount: /opt/mnt
           events:  "-e REALTIME@10000"
           prefix: mpirun --hostfile ./hostlist.txt -np 4 --map-by socket
           workdir: /opt/lammps/examples/reaxff/HNS
           containerTarget: launcher
```

In the above, we deploy the metric "lammps" as a proxy app, and hpctoolkit as an addon that will be added on the fly,
and wrap lammps directly, which is to be wrapped further by mpirun. I actually screwed this up the first time and had hpcrun wrap mpirun too (noob mistake). Everything is hugely customizable thanks to the operator, and I'm glad to report this is working well, although I do need to better understand using HPCToolkit.

## Could it work for Flux?

It was just a few days ago I had this idea pop into my head - and actually it would be a potential solution to a problem that has been keeping me up at night for almost a year, or almost as long as the [Flux Operator](https://github.com/flux-framework/flux-operator) has existed. For those not familiar, the Flux Operator deploys a workflow manager, Flux, in Kubernetes. It's an example of converged computing, or combining the best worlds of HPC and cloud. I'll have a paper on it out sooner than later, so I won't go into more detail than that. But the biggest flaw, and something that I absolutely hated, was the need to have Flux always installed alongside the application container. Akin to many things in HPC, the software was tangled, and in this case, the job manager was tangled with the application. It was not possible to use the Flux Operator without building your application into a container with Flux. This was at best annoying, at worst, just an awful design. I felt (and feel) responsible and like my work was not good enough.

So this idea I had - could it be possible to apply the same thing to Flux? Could we build Flux into a copy view with spack, and then copy it over into some application container, and most importantly, an application container that didn't require Flux to be installed? I absolutely had to find out.


## It started last night

No, seriously! I have been working on the second of two talks in a short amount of time, and it felt (still feels) like death by Power Point. I really enjoy giving talks in retrospect, but making them (and [I work hard on them](https://vsoch.github.io/2023/speaking-opportunities/)) is incredibly draining. On a side note, it's interesting how different things are draining to different people. I could program forever, but I have very little patience for making slides. So last night, because I deemed that I had worked "hard" during the day (cough, maybe did 20 slides?) I decided to reward myself with a little programming. And holy hell, by the end of the night I almost had something working. There was a bug with ZeroMQ, and specifically that the handshake failed. This turned out to be me being an idiot, because I ran the certificate generation command (ZeroMQ uses a curve certificate to encrypt messages) in every container, resulting in many different ones when there should be one. The solution was to have the main launcher container generate one certificate and then distribute it to the workers. The second bug the next morning was that my custom entrypoint forgot to source the setup script for intel MPI, which was automatically added to the profile.d directory. I realized this because when I interactively shelled in, it worked. That directory being sourced was the easy to identify difference between the two cases.
Between the previous night and that morning, the [work was done](https://github.com/converged-computing/metrics-operator/pull/68). That was another PR that gave me pause - ~1000 lines fairly quickly? When this keeps happening I have to wonder what is wrong with me. Oh well. 🤷‍♀️️

## Hairballs added as quickly as binaries

Now let's review the design as it stands now. To summarize, the goal was to find a solution for a quick, on-demand add of a large and complex HPC application that is spread across a filesystem with shared libraries. We take the following approach:

<ol class="custom-counter">
<li>We build the software into an isolated spack "copy" view</li>
<li>The software is then (generally) at some /opt/view and /opt/software</li>
<li>The flux container is added as a sidecar container to your pod for your replicated job.</li>
<li>Additional setup is done here, directly into the spack view.</li>
<li>We can then create an empty volume that is shared by your metric or scaled application</li>
<li>The entire tree is copied over into the empty volume</li>
<li>When the copy is done, indicated by the final touch of a file, final configuration is done.</li> 
<li>The updated container entrypoint is then run. </li>
<li>Flux is then running your application!</li>
</ol>

For the fourth step, the configuration is done taking into account the new path the view will have as seen by the second container in the shared empty volume. For the seventh step (final configuration) this usually means copying over the shared curve certificate, which the launcher has generated, and checking paths, permissions, and running user requested logic. For example, to use intel MPI I needed to source a file, and I could do that here. This is also where there is one bad apple in the design - we need munge installed and started as a service. It's unlikely the container will have it, so I install it, first trying yum and falling back to apt-get. This is also the slowest step, so it would be nice to optimize it. This will also be where (in the future) I more properly create a flux user. I didn't here because I was just kind of lazy at the moment to do it right. :)

For the eighth step, the entrypoint has different logic for the launcher (lead broker) vs worker (follower broker) containers. For a worker, we just start a follower broker and wait. For the launcher, we update the original command (a lammps command) and wrap it in a flux submit or run (or however you configure the addon).

> It’s astounding! 🦩️

Oh hey, pink FluxBird that knows things. I thought that I [ate you](https://flux-framework.readthedocs.io/en/latest/comics/fluxonomicon.html)? I guess you have more than one life! But if I find you in my radishes again... 

The custom resource definition might look like this:

```yaml
apiVersion: flux-framework.org/v1alpha2
kind: MetricSet
metadata:
  name: metricset-sample
spec:
  pods: 4
  metrics:
   - name: app-lammps
     image: ghcr.io/converged-computing/metric-lammps-intel-mpi:rocky
     options:
       command: lmp -v x 2 -v y 2 -v z 2 -in in.reaxc.hns -nocite
       workdir: /opt/lammps/examples/reaxff/HNS
     addons:
       - name: workload-flux
         options: 
           preCommand: . /opt/intel/mpi/latest/env/vars.sh
           workdir: /opt/lammps/examples/reaxff/HNS
```

It's again conceptually simple - we are running our lammps app, and we add flux to it. That's it!
You can watch an entire demo below:

<script async id="asciicast-610740" src="https://asciinema.org/a/610740.js"></script>

The reason this is so amazing is because the application logic is now separate from the logic to setup Flux. We do need to add views that are built on different OS (this original one was Rocky) and add support for running as the Flux user (I was mostly lazy) but wow - I pulled this off in an evening and am feeling so happy! And you are probably wondering - will this end up in the Flux Operator? Very likely yes, of course with more testing, and likely after Kubecon (November) because I'll be up to my ears in these experiments and the talk until then! It's actually an OK place to be in, because I'm beyond excited, inspired, and my colleagues are backing me with support that I am so grateful for.

Speaking of lazy... I need to go back to making slides. It's going to be at least another week and then two to practice and *gulp* I'm going to have to keep working really hard to pull this together. If you are interested, [here is a song](https://youtu.be/rfxnmIPCzIc?si=WrJ9X0ymwAlmF_yI) that is making my heart sing at the moment. There is something romantic about it, especially the scenes that are underwater and the lightning... maybe some day I will find my love too, someone that sees me for all the ways I am different and loves me just for that. I certainly have a lot of joy and love to share. ❤️ And if that never happens? It's probably OK - it feeds me, and I've realized a big part of my drive and purpose is to bring light to the lives of others around me.
