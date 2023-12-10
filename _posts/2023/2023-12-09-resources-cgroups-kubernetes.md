---
title: "Controlling of Resources for Pods in Kubernetes"
date: 2023-12-9 10:00:00
---

This story starts a few months ago, when I was having a small hackathon with [Antonio](https://github.com/aojea) and he showed me something magic. At the time, we were debugging networking for the Flux Operator, but on the cluster he had created, the resource [requests and limits](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/#requests-and-limits) that we specified for the container running Flux were actually honored. Instead of Flux seeing, for example, 704 tasks (8 nodes, one pod per node, with 88 cores each) we saw what the limit was set to, only (75 * 8 == 600). You can see an example MiniCluster configuration for that [here](https://gist.github.com/vsoch/53c6cc59f8e47fa42c979697909c1b67). I was astounded. I had been setting resource limits and requests for many months, but never thought they were actually honored. I assumed it was a scheduling tactic. I asked him about it, and he explained it was controlled by [cgroups](https://kubernetes.io/docs/concepts/architecture/cgroups/) (specifically version 2.0) and we didn't go into detail beyond that. This turned into a bit of a debugging adventure as (later) I tried to reproduce what I saw Antonio do.

## A Bit of Background

Before we jump into our adventure, I want to tell you why this is even a thing. For Flux Framework, part of the resource management part is knowing what resources are available to schedule a job for. There is a quick mention in our [Administrator's Guide](https://flux-framework.readthedocs.io/en/latest/guides/admin-guide.html?h=hwloc#system-prerequisites):

> Flux uses hwloc to verify that configured resources are present on nodes. Ensure that the system installed version includes any plugins needed for the hardware, especially GPUs.

### Portable Hardware Locality

[hwloc](https://www.open-mpi.org/software/hwloc/v2.0/), what? There are various mentions in our scattered [docs](https://flux-framework.readthedocs.io/en/latest/projects.html#request-for-comments), but I'll give a high level summary, because I've taken a liking to this little library. There is a nice [overview here](https://www.open-mpi.org/projects/hwloc/doc/v2.10.0/) and (in my own words) you use hwloc to discover hardware. It provides a series of command line tools and language bindings (that for example can be added to flux) to "sniff" the nodes. It can tell you about simple information like processors, NUMA memory nodes, I/O devices, and caches. I think it's primarily been used in HPC land, but (granted we can share it more broadly) I think it could hugely help the larger community too. As an example, I added it as a metric to the [Metrics Operator](https://converged-computing.github.io/metrics-operator/getting_started/metrics.html#sys-hwloc) and can now easily run it on Kubernetes to generate graphics that show a machine:

<div style="padding:20px">
   <a href="https://github.com/converged-computing/metrics-operator-experiments/blob/main/aws/performance/run0/results/metric/hwloc/iter-0/analysis/architecture.png?raw=true" target="_blank"><img src="https://github.com/converged-computing/metrics-operator-experiments/blob/main/aws/performance/run0/results/metric/hwloc/iter-0/analysis/architecture.png?raw=true"/></a>
</div>

or a [nice dump of XML](https://github.com/converged-computing/metrics-operator-experiments/blob/main/aws/performance/run0/results/metric/hwloc/iter-0/analysis/machine.xml). This means that (at a high level) Flux uses hwloc when you boot up brokers to say:

> Hey, how many nodes and cores are in the audience today?

And here is the problem with that. If you were to run multiple pods on the same node, without controlling resources via cgroups, each Flux broker would think (and tell Flux) that it had that many resources available. More specifically, if we deployed 4 flux brokers on one physical node with 80 cores, instead of each broker knowing that it should only schedule to 20 cores, it would tell Flux there is a total of 80 x 4 (320) cores. Things would break very quickly! For this reason of using hwloc, in order to actually schedule multiple Flux brokers (containers) on one physical node, we have to set actual limits with cgroups. Get it? OK, let's now start our adventure!

## The Adventure Begins

After our Hackathon we were going into Supercomputing, Kubecon, and another venue I was giving a talk for, so I only tried out reproducing the case twice. Each time, I tried bringing up a cluster akin to what I saw Antonio do, but I never reproduced it. No matter what limits and requests I put, Flux inside the pod using "flux resource list." I started to think maybe I had hallucinated, or there was some major detail (e.g., Kubernetes version) that I was missing. I really just needed to take a concerted afternoon and think about it and try several things to figure it out. Let's go!

### A Saturday Afternoon

I don't know how others manage time, but I have a small list in my head of "itches that must be scratched" and when I run out of things to do, this list is often referenced. This happened to me today. I was going to go outside for some fun in the snow, but it was still a little early. I then remembered the itch I wanted to scratch, and very casually started to bring up a cluster. Actually, maybe that's a tip if you find you have a hard time starting working on hard problems.

> Don't think about it, just dive in, often starting with a small trivial task.

#### Experiment 1: Affinity

My first attempt was wrong. I wondered if the limits/requests weren't working to specify more than one pod per node because of Affinity and Anti Affinity. Maybe the [Affinity and Anti Affinity](https://github.com/flux-framework/flux-operator/blob/ac23df49e93abf15078b32f0f0d6d221bef6fa78/controllers/flux/job.go#L110-L156) that Antonio had contributed were (ironically) preventing the resource limits and requests from working. This wouldn't make sense that I had never seen it before (before the rules were added) but I thought it would be worth a try. Toward this goal, I [added a parameter](https://github.com/flux-framework/flux-operator/pull/208/commits/ac23df49e93abf15078b32f0f0d6d221bef6fa78) to the Flux Operator these rules. I was wrong about this, because I brought up the cluster and it didn't matter with or without the rules - Flux always saw all the resources. I decided to leave the parameter for some use case that might find it useful.

#### Experiment 2: cpu Manager Policy

After this failure I remembered another detail, but I wasn't sure why it mattered. I had remembered that he deployed his cluster with node policies. I had thought they were mostly specific to networking (and in retrospect, they were) but just in case I was wrong about that, I went to read the documentation again. And there it was! I found something important - that using the static "cpuManagerPolicy" (you can [read about it here](https://kubernetes.io/docs/tasks/administer-cluster/cpu-management-policies/#static-policy)) was the way to control CPU. Specifically:

> The static policy allows containers in Guaranteed pods with integer CPU requests access to exclusive CPUs on the node. This exclusivity is enforced using the cpuset cgroup controller.

I was certain this was it, and by creating a cluster with this config. More specifically, here is the config I created the cluster with:

```yaml
kubeletConfig:
  cpuManagerPolicy: static
linuxConfig:
 sysctl:
   net.core.somaxconn: '2048'
   net.ipv4.tcp_rmem: '4096 87380 16777216'
   net.ipv4.tcp_wmem: '4096 16384 16777216'
```

Dear reader, it absolutely did not work. This is another reason to not set high expectations, like ever. There are many surprises and gotchas that will render (what you believe) to be 30 minutes of work into several hours. Let's continue debugging.

#### Experiment 3: cpuManagerPolicy and QoS

Before today I didn't know that pods have "QoS" or quality of service classes. I glanced at [it here](https://kubernetes.io/docs/tasks/configure-pod-container/quality-service-pod/#create-a-pod-that-gets-assigned-a-qos-class-of-guaranteed) and assumed that assigning a resource limit for each of memory and CPU would do it. I was surprised when my cluster still saw all the node resources. But it was a quick sanity check of my assumptions that helped me here. With a "kubectl describe pods" I can double check the status. And... what?

```
QoS Class:                   Burstable
```
Those jerks! Why were they given a status of Burstable? I did [more reading](https://kubernetes.io/docs/tasks/configure-pod-container/quality-service-pod/#create-a-pod-that-gets-assigned-a-qos-class-of-guaranteed) (same place) and oh crap.  I missed this:

> These restrictions apply to init containers and app containers equally. Ephemeral containers cannot define resources so these restrictions do not apply.

The reason my pods were not Guaranteed is because the init container (a new added feature for the [Flux Operator Refactor](https://github.com/flux-framework/flux-operator/issues/211) to add Flux on demand to any application container on the fly) did not have anything. So I [exposed the resources](https://github.com/flux-framework/flux-operator/pull/208/commits/aaffc3888ea8f42a476113f2b89ea2d107827aff) of the init container, and then tried again.


The other gotcha (so the above didn't work) is that the pod needs to have Guaranteed status. This means that ALL containers (even init)! need to share the same resource requests and limits. [Read more about it here](https://kubernetes.io/docs/tasks/configure-pod-container/quality-service-pod/#create-a-pod-that-gets-assigned-a-qos-class-of-guaranteed). I found that with the right config, the flux operator pods still didn't work, even with memory and CPU. The reason was the init container.  Did it work?

```
QoS Class:                   Guaranteed
```

Nice! It's really great when you read something, try it, and it works! 🥳️
Honestly, before today I didn't even know QoS was a thing. It's one of those fields in the metadata that I've just glanced over and didn't think about.  And then I could try it out - first limiting the amount of CPU that each Flux container could see on a pod (with an actual available amount of ~50). It worked! I was able to create the cluster (pods) and limit the CPU for each pod seen by flux:

```bash
source /mnt/flux/flux-view.sh 
flux proxy $fluxsocket bash
flux resource list
```
```console
[root@flux-sample-0 /]# flux resource list
     STATE NNODES   NCORES    NGPUS NODELIST
      free      4      160        0 flux-sample-[0-3]
 allocated      0        0        0 
      down      0        0        0 
```

In the above, Flux is deploying pods to (some number of nodes) and I am only allowing it to see and use 40 cores per Flux container (40 x 4 == 160). I then went the other way, increasing the number of Flux pods to run on a greater number than the physical node afforded:

```bash
source /mnt/flux/flux-view.sh 
flux proxy $fluxsocket bash
flux resource list
```
```console
[root@flux-sample-0 /]# flux resource list
     STATE NNODES   NCORES    NGPUS NODELIST
      free      7      140        0 flux-sample-[0-6]
 allocated      0        0        0 
      down      0        0        0 
```

For the above, we are running 7 Flux containers on 4 physical nodes, and each Flux container can only see 20 cores on each. Complete notes (and the MiniCluster yaml files) are [here](https://github.com/converged-computing/operator-experiments/tree/main/google/resources). 

## Gotchas

OK, now let's review the gotchas. There were quite a few in this exploration.

### Static Policy

If you don't customize your node config to use a [static policy](https://kubernetes.io/docs/tasks/administer-cluster/cpu-management-policies/#static-policy) it doesn't matter what you do. Again:

> The static policy allows containers in Guaranteed pods with integer CPU requests access to exclusive CPUs on the node. This exclusivity is enforced using the cpuset cgroup controller.

### Resource Limits and Requests

Even with a static policy, you need to specify cpu AND memory fully for your container resources. This will give it a QoS class of [Guaranteed](https://kubernetes.io/docs/tasks/configure-pod-container/quality-service-pod/#create-a-pod-that-gets-assigned-a-qos-class-of-guaranteed). This includes init containers! It will be ignored (and the pod given status "Burstable") if you forget an init container.

### Quantity (memory or CPU)

EVEN when you do the first two properly, you have to get the numbers right! When I asked for too high a value for what the node could provide, the status was Burstable and the limits were not set. In other words, if you get the numbers wrong, your request will be silently ignored (maybe there is a warning somewhere, actually, but it's not obvious and in your face) and it will fall back to being created as if you forgot to specify them at all. 

### OOMKIlled

And finally, the amount that you set matters. If you give each Flux container (or init container) too limit memory? It's going to be OOMKilled (out of memory killed). In practice, I found that I couldn't create a container with only 50M of memory to copy the view and start Flux. I needed to reduce my Flux MiniCluster size to 7, allowing each Flux container to have slightly more memory (65M I think) for the cluster to come up. Even when I did this, I think one of my pods OOMKilled once, but it worked on the restart. It's again, something that is a delicate balance (that you can get wrong)!

## Summary

OK, let's summarize what we learned! If you want your cluster (whatever it might be) to have controlled specification of more than one pod per node, and controlled by cgroups version 2, you need to ensure:

<ol class="custom-counter">
<li>The node config sets cpuManagerPolicy to static</li>
<li>All containers (including init!) need to have both memory and cpu set</li>
<li>You can double check the above with the pod QoS being "Guaranteed"</li>
<li>The amount you ask for actually works (QoS will be wrong if not</li>
<li>None of your pods are OOMKilled (init containers can have this happen too)</li>
</ol>

And if you are using Flux, the last sanity check is with "flux resource list" that should show a controlled view of resources (not too many, not too few)! Remember if you create a MiniCluster with more pods than Physical nodes and cgroups isn't working, your cores will be much larger than it should. For future work and next steps, we will likely want to understand how the node config is exposed for other clouds (or not). We will also likely want to understand the use cases we want to test. The limiting factor here doesn't seem to be how small we can break up a single node, but rather the actual resources that are needed by any container (as it will be killed if it goes over).

This also makes me wonder if, given we had this running for our Flux Operator testing experiments on c3, if the reason the workers were often killed did come down to memory? I don't remember seem OOMKilled for the pod, but maybe MPI hit the limit first and killed it? It's an interesting idea!

## Final Tip: Waiting for Nodes!

And one quick tip for Google Cloud - I found that for (what I suspect is) a highly demand instance (c3-standard-112) even with a small number of 4 nodes, it wasn't able to give me the allocation. GKE usually spins up clusters really quickly, but at the 15 minute mark I could see I only had 2/4 nodes. The issue here is that because the node group is "updating" it doesn't let you edit it (or delete it), either from the web interface or the command line. This can be a hugely stressful, anxiety provoking scenario if you are trying to bring up a large cluster (and already paying for half the nodes, but you can't use it yet)! What you have to do is dig into the cluster -> nodes -> node group -> instances, and when you are there you will actually be looking at them in Compute Engine. I had to first delete the allocated instances (I had two, green) and then when that was done, manually ask to delete the node group (it would deny) but then the checkboxes became selectable, and I could select (via said checkboxes) the individual "spinning" instances. Once they were deleted so was the node group, and I could finally delete the cluster. It was a bit stressful, but not so terrible since the cluster was small. But hey Google - we really need a way to say "Please give me this size cluster, and I don't want to get access to it (and pay for it) until you've REALLY given me the whole thing! I think this is the case with most clouds, not to call out Google specifically. When you ask for an allocation and need all the nodes but you only get a partial set? That doesn't seem right to charge the customer for (ultimately) an allocation that you cannot provide. Hopefully this helps someone in the future!
