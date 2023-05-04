---
title: "Service Timing"
date: 2023-05-04 12:30:00
---

> The start of the story for what appears to be a Kubernetes Service Bug!

This is a fun story of debugging, which I like to write every so often because I find
debugging generally satisfying, and like an adventurers story that others might enjoy or learn from.

## It started with a re-design...

The Flux Operator started with a design that would use a one-off service container to
generate a certificate. We did this by way of creating the container using the same
base (with Flux) used by the workflow, and running `flux keygen`. If you used the operator 
at this time, you might see the following for pods:

```bash
$ kubectl get -n flux-operator pods
NAME                         READY   STATUS      RESTARTS   AGE
flux-sample-0-p5xls          1/1     Running     0          7s
flux-sample-1-nmtt7          1/1     Running     0          7s
flux-sample-cert-generator   0/1     Completed   0          7s
```

Note the last pod - this was the "one-off" service pod that would come up and down
in under 3 seconds, and generate our curve certificate for zeromq. But after our 
talk at [Kubecon](https://t.co/vjRydPx1rb), we started engaging with the [kueue team](https://github.com/kubernetes-sigs/kueue/issues/716),
and one of the changes we discussed to improve the operator was removing
this extraneous service pod. This was made possible by way of [installing bindings for zeromq](https://github.com/flux-framework/flux-operator/pull/152) directly in the operator, and it would result in not needing to generate
that certificate pod:

```bash
$ kubectl get -n flux-operator pods
NAME                         READY   STATUS      RESTARTS   AGE
flux-sample-0-p5xls          1/1     Running     0          7s
flux-sample-1-nmtt7          1/1     Running     0          7s
```

However, this change had unintended consequences!

## And then there were problems

As I started testing the new version of the operator, I started seeing something weird.
Previous runs that had taken between 10-20 seconds (and likely 12-15 on average) started to
have times closer to 40 seconds... and sometimes 140 seconds! I reported these strange times 
[in this issue](https://github.com/kubernetes-sigs/jobset/issues/104). 

I started digging into what was going on. As a second desired feature discussed with the kueue team, we also wanted the worker
pods to complete (at the end, to go from state "Running" to "Completed." This wasn't
happening because in order to get them running, we needed to keep the start command
in a loop, not being able to anticipate when the broker would start relative to the other
pods. For more detail, if the worker pods starts and cannot register to the main broker
within a certain time period, it will exit, and we put it in a loop to try again.

To fix this issue, we were able to add a [broker flag to the Flux operator](https://github.com/flux-framework/flux-operator/pull/159)
to enable zeromq logging. What this revealed that helped me debug the aforementioned
slowness, was that when the broker came up, the network wasn't ready. To step back,
the MiniCluster has a headless service that provides fully qualified domain names
across the cluster. These names are used by the broker (and zeromq) for networking of the cluster.
So what was happening was two fold:

<ol class="custom-counter">
<li>The network wasn't ready when the broker came up, leading to zeromq to timeout and start a retry sequence</li>
<li>The retry sequence had some kind of exponential backoff, leading to the huge times that we saw</li>
</ol>

This gave us something to work with! 

## Testing zeromq connect timeout

For the first bug, we were able to find a flag for a connect timeout for zeromq, and
[add it to the Flux Operator](https://github.com/flux-framework/flux-operator/pull/162).
This added a variable to define a set backoff (e.g., 5s by default).
I was then able to do testing to see how the fix worked, and how varying the timeout changed the ultimate runtime.

### Setup

To run this experiment, I first made the code changes to the operator to allow defining the connect timeout for zeromq.
I then created a production GKE cluster with coredns, and I
I was able to install the operator, and then do this via the Python SDK (script included here as 
[time-minicluster-lammps.py](https://github.com/converged-computing/operator-experiments/blob/main/google/service-timing/time-minicluster-lammps.py). Creating the cluster looked like this:

```bash
$ gcloud container clusters create flux-operator --cluster-dns=clouddns --cluster-dns-scope=cluster \
   --region=us-central1-a --project $GOOGLE_PROJECT \
   --machine-type n1-standard-2 --num-nodes=4 --enable-network-policy \
   --tags=flux-cluster --enable-intra-node-visibility
```

To install the operator, this is how I do that for development (from the root of the repository):

```bash
$ make test-deploy
$ kubectl create namespace flux-operator
$ kubectl apply -f examples/dist/flux-operator-dev.yaml
```

And then I ran the experiments! This saved the data files [here](https://github.com/converged-computing/operator-experiments/tree/main/google/service-timing):

```bash
$ python time-minicluster-lammps.py
```

And generated the plots:

```bash
$ python plot-times.py
```

And this resulted in the plot below:

![lammps-times.png](https://raw.githubusercontent.com/converged-computing/operator-experiments/main/google/service-timing/lammps-times.png)

And of course, don't forget to clean up:


```bash
$ gcloud container clusters delete flux-operator
```

## Results

What we learn from the above is that a zeromq connect timeout between 1s and 5s is best, and likely I'll set it to 5s as 
a reasonable value. The service consistently makes the runtime faster, except for the case of 8s, and I don't know what happened
there. We overall see that the service is impactful, because when we have it, the runtimes are largely consistent, which I believe
is happening because zeromq connects right off the bat the first time the broker tries. Ideally this pattern of increasing times would not happen
without the service! I will need to figure out how to reproduce this outside of the operator and properly report a bug.

What does this mean for the operator, before and after? With the bug, you might see creation times between 40-140 
seconds (40 seconds on a production cluster, 140 on MiniKube) for a single MiniCluster, which is abysmal.
With the fix to zeromq, this goes does to 19-20. With the further addition of adding the warmup service, it goes
down to ~16. With the service plus a better networking setup than kube-dns, it returns to the original 11-12 seconds.

## Summary

There seems to be a bug with a headless service network provided to an IndexedJob, where the network readiness is influenced by
the creation of an unrelated sidecar service. Regardless of where we ran these testing jobs (and indeed there was variance between a production cluster like GKE and MiniKube) we saw that having another random service somehow served as a warmup for the operator MiniCluster. It was consistently faster,
even across zeromq timeouts (as we showed here) when a service existed, even when the service was entirely unrelated.
While we still need to generate a reproducing case for a Kubernetes team to look at (without the Flux Operator)
the experiment here was important to do in order to test again against a variant of the operator with a fix to
the initial zeromq issue.
