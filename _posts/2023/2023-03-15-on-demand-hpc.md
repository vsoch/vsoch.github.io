---
title: On-Demand, Flexible HPC
date: 2023-03-15 22:30:00
---

I've been thinking a lot lately about workflows as I've been developing
the <a href="https://github.com/flux-framework/flux-operator" target="_blank">Flux Operator</a>.
For some background, the Flux Operator is a <a href="https://kubernetes.io/docs/concepts/extend-kubernetes/operator/" target="_blank">Kubernetes operator</a> 
that submits jobs to a Flux "MiniCluster" - or a Flux cluster running in networked pods on Kubernetes.
This is a prime example of what we call <a href="https://vsoch.github.io/2022/converged-computing/" target="_blank">Converged Computing</a>,
or technologies that bring together the best of Cloud and HPC. How do you use it? There are many
ways, actually:

<ul class='custom-counter'>
  <li>Submit a single job to run on one MiniCluster (e.g., LAMMPS)</li>
  <li>Bring up a persistent MiniCluster to submit jobs to as you please.</li>
  <li>Bring up a multi-user MiniCluster to be shared among users.</li>
  <li>Bring up a MiniCluster with a RESTFul API to interact with.</li>
</ul>

You can read about the many different use cases in our <a href="https://flux-framework.org/flux-operator/tutorials/jobs.html" target="_blank">job submission</a>
page. Why are there so many? Well, we are still figuring it out ourselves. For example,
I loved the idea of the RESTful API to authenticate users via a more standard OAuth2 flow.
This might be hugely useful for (in the future) deploying the Flux Operator as a service
alongside another authentication service. However, to submit (and manage) jobs, after I
added <a href="https://flux-framework.org/flux-operator/tutorials/interactive.html" target="_blank">interactive mode</a>
I liked that a little better, because it removed one layer of needing to communicate through a RESTFul API.
But for larger jobs that you submit to Flux (that spawn off other jobs or Flux instances) you can't
go wrong with starting the MiniCluster with a single command, and getting around the etcd/API bottlenecks
that were hugely spoken of at Kubecon last year (I watched the videos)! 
In summary, the Flux Operator gives you an on-demand HPC cluster in the cloud, a la Kubernetes.

## What about workflows?

All of our early development assumed launching a single job, or multiple jobs that
largely didn't have complex components. But (at least in HPC land) complexity is the name of the game!
We have machine learning models being trained for simulations that are then passed into visualizations
and if there is some condition along the way, we need special logic. In traditional HPC, we have 
resources running all the time, and we use our allocations (and some workflow tool) to request what we need.
But cloud land is different.

> In the cloud, you only need to be using what you need.

This might be an over-simplified point, but hear me out. My vision for a converged computing
workflow is that it is able to use exactly what it needs, when it needs
it, and bring down resources when they aren't needed. This led me to the question - how does the
Flux Operator, which knows how to bring up a MiniCluster of a particular size and node flavor,
handle this kind of complexity?

## Further Analysis of the DAG

One great thing about (many) workflow tools is that they create DAGs, or Directed Acyclic Graphs.
This tells us what depends on what, meaning what step A needs to be done before step B, what outputs
are expected, etc. It's also common in these tools to define for each step the resources needed.
So given this graph and resource specifications, would it not be possible to come up with an algorithm
that can determine the minimum number of MiniClusters needed to satisfy all steps in the job, bringing them
up when they are needed, and bringing them down when they are done? I've articulated this a bit in
<a href="https://github.com/alpha-unito/streamflow/issues/88" target="_blank">this issue</a> and I'll
be repetitive here. Let's say I have two processing jobs that look like this:

```console

job1 -> preprocess (cpu) --> postprocess (cpu) --> analysis (gpu) --> visualization (cpu)
job2 -> preprocess (cpu) --> postprocess (cpu) --> analysis (gpu) --> visualization (cpu)

```

It might even be that job1 and job2 share a common ancestor, some single processing that needs to happen
before they each spin off into individual steps

```console

                           --> postprocess (cpu) --> analysis (gpu) --> visualization (cpu)
job1+job2 preprocess (cpu) 
                           --> postprocess (cpu) --> analysis (gpu) --> visualization (cpu)

```

Or you could imagine the opposite pattern - many jobs simplifying into fewer):

```console

job1 -> preprocess (cpu) --> postprocess (cpu) 
                                               --> analysis (gpu) --> visualization (cpu)
job2 -> preprocess (cpu) --> postprocess (cpu) 

```

In any case, it could be that each of the steps in the examples above needs a different specification of resources. 
On a job submission system  you would ask for different node types. 
For a Kubernetes operator like this one you'd need to ask for a different MiniCluster. Taking the idea I brought up above,
you can imagine two extremes:

<ul class='custom-counter'>
  <li>Every step is given a new, customized MiniCluster</li>
  <li>Every step is run on the same MiniCluster</li>
</ul>

Do you see the tradeoff? The first option means that we have the optimal resources per job step. The cons are that we might
have to wait a little longer (on the order of minutes) to bring up and down the different MiniClusters.
The second approach is advantageous in that we only need to bring up a MiniCluster once, but then we only have one 
set of resources. Now you know where I'm going - there is a compromise right? If we could somehow
group the DAG steps into logical groupings based on resources (including container bases needed), and then bring up
the minimal number of MiniClusters that will successfully support all the jobs.
That might look like this:

```console

---- Bring up CPU MiniCluster ----
job1 preprocess (cpu)     job2 preprocess (cpu)
job1 postprocess (cpu)    job2 postprocess (cpu)

---- Bring up GPU MiniCluster ----
job1 analysis (gpu)       job2 analysis (gpu)

---- Bring up CPU MiniCluster ----
job1 visualization (cpu)  job2 visualization (cpu) 

```

And so what this problem comes down to is breaking a DAG further into components based on
some set of resources we deem important. This is the problem that I'm interested in, and 
I've created a simple <a href="https://github.com/snakemake/snakemake/pull/2174" target="_blank">proof of concept</a>
with Snakemake (and <a href="https://asciinema.org/a/567278?speed=2" target="_blank">asciinema</a>) 
to demonstrate the idea:

<script async id="asciicast-567278" src="https://asciinema.org/a/567278.js" data-speed="2"></script>

This is mostly a prototype because I dynamically assign steps to MiniClusters
as I go based on the container base and nodes needed. This algorithm would need to be more intelligent, and also
take into account cleaning up un-used MiniClusters, and ensuring we don't go over some total resource limit.
However, the cool thing about this entire approach is that we don't have to worry about scheduling
within a MiniCluster. We submit jobs as we please, and Flux handles that for us!

## An Optimal Algorithm

> for On-Demand, Flexible HPC (in the cloud!)

I want to propose that an optimal algorithm for this could either dynamically or
pre-deterministally do assignment. Dynamically is always easier because you figure it
out as you go, but the drawback is you might get halfway through and realize you are going
to need too many resources. The latter is likely a sounder approach, of course would
require calculation up-front. I'm not sure which is better at this point - maybe you
can help me think about it? This is what I am calling on-demand, flexible HPC, or converged
computing. Now I want to propose that an optimal algorithm might do the following:

<ul class='custom-counter'>
  <li>Further partition a DAG into logical groupings (MiniCluster assignments) based on order and resource needs</li>
  <li>Create a new MiniCluster when it is deemed needed.</li>
  <li>Delete a MiniCluster when it is no longer being used (and won't be used in the near future).</li>
  <li>Be able to provide this plan upfront to the user.</li>
</ul>

In the land of converged computing, I imagine that we only run the resources that we need,
when we need them. The above algorithm would be able to take a workflow and allow for that. 
It could even be a nice design if we would create some kind of spec (that any workflow tool
could create) to give to the Flux Operator to make this kind of request. However, more likely
we will start on the level of individual workflow tool implementations.
Given that some workflow tool is the controller, given that we have a 
<a href="https://github.com/flux-framework/flux-operator/blob/main/sdk/python/v1alpha1/examples/interactive-submit.py">Python SDK</a> for the Flux Operator
(and could support other languages) it would be reasonable to define the Flux Operator as an executor
for a workflow tool, and add this logic. The last bullet would also 
allow us to do things further like cost and time estimation.

## Can we work together?

If this is interesting to you - please ping me (or join us on the Flux Slack) to
talk about your ideas! I am a bit ashamed that a lot of our workflow tooling in the HPC
community is not up to speed with the biosciences in terms of reproducibility, but I'm
hopeful we can do better. Notably, in thinking about this for the Flux Operator I am
not interested in designing "yet another workflow tool" (and then there were 15!)
but rather thinking about a way to have the Flux Operator be an executor in existing tools,
and adding in this needed component of a new algorithm.

There is still much work to do for the Flux Operator - for example storage is possible but still
trickly, and ideally we shouldn't place a strict requirement on having Flux installed in the 
container (as we do now). If you like some of these ideas and like to join in on the discussion
or fun, please <a href="https://github.com/flux-framework/flux-operator" target="_blank">find us on GitHub</a>
or <a href="https://flux-framework.readthedocs.io/en/latest/" target="_blank">check out Flux Framework</a>.
And if you are passive but are wanting to learn more, look out for my <a href="https://sched.co/1HyaG" target="_blank">Kubecon talk</a>
discussing our early experiments with the Flux Operator and the MPI Operator. Cheers!
