---
title: "Elasticity and the Flux Operator"
date: 2023-05-20 12:30:00
---

A part of our [converged computing work](https://vsoch.github.io/2022/converged-computing/) is to explore elasticity. 
We started with [scheduling](https://www.youtube.com/watch?v=9VwAcSOtph0) and have moved into
[running a cluster in Kubernetes](https://youtu.be/rGOT-1SiZtU) with the Flux Operator. The latter will serve
as the environment for these early experiments around elasticity.

## How do I define elasticity, or scaling?

In layman's terms, elasticity is how you imagine it - I want to take some set of resources and scale them up and down according to the demands of a workflow or application.  The Flux Operator is running, inside of Kubernetes, a Flux cluster, and so it provides a nice environment for
testing and developing these ideas. In this post, I'll talk through some of the ideas and learning that we've done so far.
There is still a lot more to do, but we are making good progress!

## Step 1: Understanding the Broker Leader

I asked fairly early on when I started helping with Flux and associated tools about dynamism and state. I wanted to be able to change the size of my Flux Cluster running in Kubernetes, could I do that? I had some early conversations with my colleagues, and the general sentiment was that it could be possible, but couldn't be a priority for official development into Flux at the time. This made total sense, as the team is fairly small given the large amount of work that needs to be done! But more thinking revealed a potential hack. The hack is that Flux is a high performance computing job manager, and it needs to be flexible to nodes (or machines) going offline. The entire cluster can't fall to pieces if one machine has an issue and goes down. This means (and theoretically at the time) that we could tell Flux about nodes that didn't actually exist, and then bring them online or offline as needed. The main broker running the cluster in the operator would not need to be stopped or restarted, and the only limitation was knowing a max number of nodes or workers you'd want. The reason for this is because we write a config file for the broker to use to register workers, and when we bring up a cluster (in the case of the Flux Operator, a "MiniCluster" in Kubernetes) we only get to write that file once. We could technically change it, but we would need to stop or pause a queue, and then restart everything again. We do not want to do that :)

## Step 2: Understanding State

My first venture into scaling actually started with state. I thought we could mimic a scaling if we started with a cluster of some size, paused all the jobs, and then saved the state of the queue, brought down the MiniCluster, and brought up a new (larger) one. Yes, this would mean a bit of waiting - we would need to wait for the queue to finish, pause, and then save to an archive, and then tell old pods to terminate and new ones to come up. The filesystem contents could persistent given a shared volume between the two MiniCluster. I had a lot of fun poking the core Flux devs about how these commands work (and these small, fun interactions are so fun!) and did this early work in March of 2023, first to [do a basic save of state](https://github.com/flux-framework/flux-operator/pull/110), and then to actually [pause a running queue and reload jobs into a new cluster](https://github.com/flux-framework/flux-operator/pull/115). You can read the consolidated [learning here](https://flux-framework.org/flux-operator/tutorials/state.html). The essential commands that we would learn about are how to interact with the queue, or how to save an archive that could be loaded later via a basic flag to the broker.

```console
# Stop the queue
flux queue stop

# This should wait for running jobs to finish
flux queue idle

# And then do the dump!
flux dump /state/archive.tar.gz
```

You can watch a quick demo here:

<script async id="asciicast-566800" src="https://asciinema.org/a/566800.js"></script>

This learning could still be useful for older versions of Kubernetes (we will get to why later) and for cases when you don't plan for scaling but need to stop and continue a job later. The cons of this approach, as far as I can tell, is that sometimes there is a job or two lost between the transfer. But the jobs do seem to (for the most part) transition nicely - a job on the previous queue can get scheduled to a now larger or smaller cluster. And actually, the broker has a nice flag that will tell it to always load from an archive, if it exists.

```console
-Scontent.restore=/tmp/path/my-archive.tar.gz
```

## Step 3: Tricking Flux in Scaling

I was content with this early work for saving state, albeit it wasn't true scaling or elasticity, as it was a lot of manual fiddling, and the method was imperfect in that it was a bit slow and could result in lost jobs. To be frank, I kind of forgot about this goal for about a month and a half - this is when we had both a Kubecon talk, and a talk at the HPC Now Knowledge day. I also was immersed in a lot of improvements to the operator to remove the extra certificate generator pod, ensure that worker pods complete correctly, and figure out a <a href="https://github.com/kubernetes/kubernetes/issues/117819" target="_blank">weird networking bug</a> that I discovered along the way. It wasn't until two days ago that I remembered the next step in this learning journey toward elasticity, and this was trying to exploit this hack we know about the Flux broker config.

Speaking with a colleague from the batch-wg team (side note, I am so joyful about the Flux Operator project and Kubecon for the new people it afforded me to meet!), I learned that elasticity of an Indexed job (what the Flux Operator uses for the cluster)was possible, but would require [Kubernetes 1.27 and later](https://github.com/kubernetes/enhancements/tree/master/keps/sig-apps/3715-elastic-indexed-job#motivation). As I alluded to earlier, this is why the "brute force scaling" approach may not be entirely useless, because other means of scaling weren't supported in earlier Kubernetes versions. Could I install 1.27? Yeah, no problemo! We could spin up MiniKube or Kind with that version. I wrote these notes up (that are now a part of the [scaling page](https://flux-framework.org/flux-operator/tutorials/scaling.html)) on my first foray into the space, and designing the logic that is now a part of the operator.

<ol class="custom-counter">
<li>We tell Flux to create a cluster at the maximum size that would be needed</li>
<li>We update the resource spec to reflect that.</li>
<li>The cluster cannot be smaller than 1 node, meaning only a broker.</li>
<li>A cluster defined with an initial "size" can be scaled down (and back up)</li>
<li>A cluster cannot be larger than it's original "size" or "maxSize"</li>
<li>You are allowed to start smaller and specify a maxSize to expand to</li>
</ol>


There are subtle details in there, but basically we can give the MiniCluster custom resource definition (YAML file) a "maxSize" parameter,
and Flux is told (tricked!) that it has that many nodes. I did this work (relatively speaking) more recently, in early May also of 2023, when 
[basic scaling](https://github.com/flux-framework/flux-operator/pull/160) was supported, followed quickly by [allowing the user to set a maxSize](https://github.com/flux-framework/flux-operator/pull/161) to scale up to it.

To get this working, we also relax a requirement that all nodes need to be online before starting to run a job. We will dive into cases as our work progresses, but very likely in the scaling use case, you wouldn't want to just be running one job using a particular number of tasks - things would potentially go wrong in your application if you scaled down, and the resources couldn't easily be integrated if you scaled up. Thus, a good solution is to use the launcher or interactive mode of the operator. For the first, you have a workflow tool or similar submitting jobs, and so if a new node comes up, it can simply submit to it. For interactive mode, we are starting a broker, but we aren't scoping anything to a set number of tasks, so a new addition is added to the cluster and available for interactive use. To learn more and see examples of the above, I recommend checking out the [scaling page](https://flux-framework.org/flux-operator/tutorials/scaling.html). At this point, we had tricked Flux into scaling, meaning making the cluster larger or smaller, up to a limit, based on a user request, and without stopping or restarting anything. Hurrah!

## Step 4: How to automate?

For the next few weeks, I placed the next step on my mental backburner. Sometimes more progress is made when things are in my subconscious,
because a solution bubbles up on my run, or after a good sleep. And as a side note - this is why I am so ademant about taking care of my brain and body.
I know they are working hard (even when I am not) and I don't want to lose that gift. Yeah, I'm pretty sure that I'm doing close to nothing, and it's the small army of robot dinosaurs in my head that are figuring out anything hard. I'm just a human shell or vehicle for transmission of information! 😁️

So I knew that I wanted to do the above, but not have it controlled by the user. I wanted the automation bit.
We had a meeting with some experts in the space, and I very poorly asked my question about how to do this, and didn't get a good answer.
Actually, they may have given me a fine answer, but I didn't totally follow the logic because I wasn't familiar with all the Kubernetes concepts they mentioned. This is a good example of how speaking in a Jargon can impair communication, but I digress! We all do our best that we can at the time, and I should have been more prepared. My understanding at this point in time was that it wasn't possible to interact with the operator from inside of the pod. How could that even make sense, from a security perspective? My best idea was to make a sidecar service that could somehow interact with both. But I didn't like that idea much either, because it added more complexity to the design.

Of course then I did what any engineer does - you ask the internet! I posted in slacks and browsed quite a bit, 
and (finally) I had an epiphany that if we could have an address for the Kubernetes API within the cluster, and there was a concept of
an "in cluster config," and if it was possible to interact with my operator (from say, Python) from outside of the cluster, with the right permissions,
it must be possible to interact from the inside, right? This was actually just Thursday night, where I stayed up way too late
having Kubernetes rocking my mind, and wrote the first demo of the Flux Operator with (what I would call) a more proper elasticity:

<script async id="asciicast-585802" src="https://asciinema.org/a/585802.js"></script>

The difference here from the "saving state" or even previous scaling example is that the application
that is running inside of the cluster is making a request to scale up or down. And given this feature of Kubernetes 1.27 and later,
we don't need to do anything janky like deleting and saving the state of a cluster and job to create a new one, we simply
update the custom resource definition to be a larger size, and it works! It took me a little bit to get the permissions (called rbac)
correct, but once I was able to issue requests to the API from inside the pod I have to tell you, I felt pure joy. I
created a story to go along with the demo, "Gopherlocks and the (not) three bears" and even [opened a funny issue based on one of my character's comments](https://github.com/flux-framework/flux-core/issues/5189). I highly recommend that you watch the demo - it's very stupid and funny,
and you can read full details under the [basic example](https://flux-framework.org/flux-operator/tutorials/elasticity.html) on the elasticity page.
Ha! And since I merged this in the middle of the night (morning), technically speaking it was [just yesterday](https://github.com/flux-framework/flux-operator/pull/173)! It's amazing how time can both speed up and slow down when you are having fun.

## Step 5: Another way?

It wasn't even a few hours later (well, when I woke up after my night of fun) that I engaged with folks on the Kubernetes slack about this development (they had given me pointers and links when I asked about APIs earlier) and I learned about something new and interesting - that there is this thing called a [scale sub-resource](https://book.kubebuilder.io/reference/generating-crd.html#scale) that can be defined for a custom resource definition, and then our running application pod can provide metrics that are used to scale up or down. This approach would have us use a concept called [horizontal pod autoscaling](https://cloud.google.com/kubernetes-engine/docs/concepts/horizontalpodautoscaler) (HPA) as the entity to do the automation. The pros of this approach would be that we wouldn't need to create these additional (likely too permissive) rbac rules, and we could create an HPA (it's basically another controller) that is matched specifically to namespaced and named job (or set of pods with a selector, more on this later).  I did a pretty good job summarizing [in this thread](https://twitter.com/vsoch/status/1659816289001701377) and I'll try again here, but with a bit more detail. This is also when I learned the difference between vertical and horizontal scaling, at least for Kubernetes:

<ol class="custom-counter">
<li>Horizontal scaling is adding pods</li>
<li>Vertical scaling is adding resources to pods (e.g., more memory or CPU).</li>
</ol>

It's amazing that I can hear people talk about those two things for many years, but not really hear or listen (or care) until I actually did.
I suppose I have very selective attention for things I'm interested in. But once I'm interested, I'm sticky like "the thing that wouldn't leave"
and you won't be able to get rid of me (cue Dr. Seuss)!

### The Horizontal Pod Autoscaler

The first approach that I detailed above required extra rbac permissions for a pod to issue requests directly to the API, and basically modify the custom resource to change its size. This worked with what I had previously implemented for scaling, because in the operator logic we check for a change of size, and if we find one, we validate it (it can't be too small or too big!) and then issue the update. Given Kubernetes 1.27 or later, the cluster scales or shrinks, and Flux running inside the pods of the Indexed Job is like "no biggie!" But with horizontal pod auto-scaling (HPA), we can allow a MiniCluster to scale dynamically using a separate control loop. This requires installing the HPA to the specific namespace and named object, but doesn't require an additional rbac.

The nice thing about this approach is that it allows us to define scaling based on resources or metrics (e.g., "keep between sizes 2 and 4 based on this percentage of CPU"). Since it was a bit hairy to figure out, I want to share some quick notes about what I learned. First, implementation or user details! 

#### 1. Add a scale subresource

The first thing I did was to add annotations to our MiniCluster spec, and that looked like this:


```go
// MiniCluster is the Schema for a Flux job launcher on K8s
// +genclient
// +k8s:deepcopy-gen:interfaces=k8s.io/apimachinery/pkg/runtime.Object
// +kubebuilder:object:root=true
// +kubebuilder:subresource:status
// +kubebuilder:subresource:scale:specpath=.spec.size,statuspath=.status.size,selectorpath=.status.selector
type MiniCluster struct {
	metav1.TypeMeta   `json:",inline"`
	metav1.ObjectMeta `json:"metadata,omitempty"`

	Spec   MiniClusterSpec   `json:"spec,omitempty"`
	Status MiniClusterStatus `json:"status,omitempty"`
}
```

Do you see the last one that details the subresource for "scale" ? That's a nice shorthand to tell the generation tool, kubebuilder, to
add logic to the YAML the operator installs from that we want to add the scaling subresource, and we want to use the following fields:

<ol class="custom-counter">
<li><b>.Spec.Size</b> is the field we want to scale up and down (the size of the MiniCluster) and this already existed</li>
<li><b>.Status.Size</b> is a new field that will be served in this subresource endpoint to communicate to the HPA</li>
<li><b>.Status.Selector</b> is a pod selector (a label) the HPA can use to find pods of interest</li>
</ol>


In practice, this comes down to adding this section to the flux operator YAML (the manifest you use to install):

```yaml
subresources:
  scale:
    labelSelectorPath: .status.selector
    specReplicasPath: .spec.size
    statusReplicasPath: .status.size
  status: {}
```

This means that if you aren't using this generator, you could just add this snippet. But note that you still need
to honor the paths of those fields, meaning the two sizes and selector to your Spec and Status for your custom resource definition, respectively.
Here is what that looks like, first for the status fields:

```go
// MiniClusterStatus defines the observed state of Flux
type MiniClusterStatus struct {

	// These are for the sub-resource scale functionality
	Size     int32  `json:"size"`
	Selector string `json:"selector"`

...
}
```

And (for my use case) the MiniCluster Spec size already existed! It's like, the core of a MiniCluster!

```go
// MiniCluster is an HPC cluster in Kubernetes you can control
// Either to submit a single job (and go away) or for a persistent single- or multi- user cluster
type MiniClusterSpec struct {

	// Size (number of job pods to run, size of minicluster in pods)
	// This is also the minimum number required to start Flux
	// +kubebuilder:default=1
	// +default=1
	// +optional
	Size int32 `json:"size,omitempty"`

...
}
```

For those interested, I think this is what enables the "kubectl scale" command.

#### 2. Check the endpoint

If you build and test your operator now, you should be able to issue a request to this
new endpoint and see a vanilla response that reflects a current spec and status.
What we are actually doing with the fields above is mapping our operator fields (that we called size)
to the autoscaler fields, which are called "replicas." Don't be afraid when you see this term
and not your own - this is expected.

```bash

# kubectl get --raw /apis/<group>/v1alpha1/namespaces/<namespace>/<plural>/<name>/scale | jq
$ kubectl get --raw /apis/flux-framework.org/v1alpha1/namespaces/flux-operator/miniclusters/flux-sample/scale | jq

{
  "kind": "Scale",
  "apiVersion": "autoscaling/v1",
  "metadata": {
    "name": "flux-sample",
    "namespace": "flux-operator",
    "uid": "581c708a-0eb2-48da-84b1-3da7679d349d",
    "resourceVersion": "3579",
    "creationTimestamp": "2023-05-20T05:11:28Z"
  },
  "spec": {
    "replicas": 2
  },
  "status": {
    "replicas": 0,
    "selector": "job-name=flux-sample"
  }
}
```

The first important note is that we see our cluster / operator is using "autoscaling/v1" above. This will be important
to remember when you create the HPA, as the wrong version won't be accepted (the spec changed a bit)!
I'll also note that when I first tried this out, I didn't fully understand the idea of a selector, so it wasn't present in
my output. We will talk about that next.

#### 3. Selector logic

The point of the selector is to provide the HPA (the controller of the scaling) with an ability to select your pods, inspect some metric,
and then decide to scale up or down (or do nothing). Without jumping ahead, before I understood this (and thought this through) I hadn't defined
one, and when I looked at the HPA it just reported the current resources as "unknown." I then put two and two together, and realized that
I needed to give the HPA a way to find my pods of interest, and we do this with a label. Since we already have a label
for our headless service, a label of "job-name" that corresponds to the custom resource definition name, I grabbed and used that,
and ensured that it was provided under that status field.

```go
// addScaleSelector populates the fields the horizontal auto scaler needs.
// Meaning: job-name is used to select pods to check. The size variable
// is updated later.
func (r *MiniClusterReconciler) addScaleSelector(
	ctx context.Context,
	labels map[string]string,
	cluster *api.MiniCluster,
) (ctrl.Result, error) {

	// Update the pod selector to allow horizontal autoscaling
	selector := "job-name=" + labels["job-name"]
	if cluster.Status.Selector == selector {
		r.log.Info("MiniCluster", "ScaleSelector", selector, "Status", "Ready")
		return ctrl.Result{}, nil
	}
	cluster.Status.Selector = selector
	err := r.Client.Status().Update(ctx, cluster)
	r.log.Info("MiniCluster", "ScaleSelector", selector, "Status", "Updating")
	return ctrl.Result{Requeue: true}, err
}
```

In the above, we retrieve the "job-name" label and add it to the field that the HPA knows to look for the selector in.
Of course now I'm realizing that I should not have used the service selector label, as this could include sidecar pods
that are external services. This is a tiny bug that I'll fix by adding just another label selector - after I write this post!

#### 4. Operator Logic

At this point you could deploy your operator with an HPA (more on this later) and you'd see it getting resources, but you
wouldn't see any change in the size of your cluster. Doh! We wrote our operator, and that is logic we have to write.
Since I had already written logic for our cluster to scale (from a manual request by way of applying an updated custom resource definition)
we largely already had this logic, shown in the function below:

```go
// resizeCluster will patch the cluster to make a larger (or smaller) size
func (r *MiniClusterReconciler) resizeCluster(
	ctx context.Context,
	job *batchv1.Job,
	cluster *api.MiniCluster,
) (ctrl.Result, error) {

	// We absolutely don't allow a size less than 1
	// If this happens, restore to current / original size
	if cluster.Spec.Size < 1 {
		return r.restoreOriginalSize(ctx, job, cluster)
	}

	// ensure we don't go above the max original size, which should be saved on init
	// If we do, we need to patch it back down to the maximum - this isn't allowed
	if cluster.Spec.Size > cluster.Status.MaximumSize {
		return r.disallowScale(ctx, job, cluster)
	}

	// If we get here, the size is smaller and we allow it!
	return r.allowScale(ctx, job, cluster)
}
```

In the above, you see checking all the edge case rules for it we are going to allow
the scale, or disallow and fall back to a reasonable default. The addition that I needed to
add to each of the subfunctions above was, in addition to updating the Spec Size, to also
update the Status Size. Here is an example of that:


```diff
// disallowScale is called when the size is > the maximum size allowed, and we only scale up to that
func (r *MiniClusterReconciler) disallowScale(
	ctx context.Context,
	job *batchv1.Job,
	cluster *api.MiniCluster,
) (ctrl.Result, error) {

	r.log.Info("MiniCluster", "PatchSize", cluster.Spec.Size, "Status", "Denied")
	patch := client.MergeFrom(cluster.DeepCopy())
	cluster.Spec.Size = cluster.Status.MaximumSize
+	cluster.Status.Size = cluster.Status.MaximumSize

	// Apply the patch to restore to the original size
	err := r.Client.Patch(ctx, cluster, patch)

	// First update fixes the status
+	r.Client.Status().Update(ctx, cluster)
	return ctrl.Result{Requeue: true}, err
}
```

And that was all that was needed in terms of updates to the operator code. I cleaned it up
quite a bit, because I tend to get more unhappy with my own code as time passes, but that's another story.

#### 4. Creating the HPA

Now let's talk about creating the horizontal pod autoscaler. Since this is a controller,
or an object known in Kubernetes land, we need to make a yaml for it. For a job called "flux-sample"
in the "flux-operator" namespace, that might look like this:

```yaml
apiVersion: autoscaling/v1
kind: HorizontalPodAutoscaler
metadata:
  name: flux-sample-hpa
  namespace: flux-operator
spec:
  minReplicas: 2
  maxReplicas: 4
  # This is purposefully set to be really low so it triggers!
  # I need to read more about other metrics we can set
  targetCPUUtilizationPercentage: 2
  scaleTargetRef:
    apiVersion: flux-framework.org/v1alpha1
    kind: MiniCluster
    name: flux-sample
```

This brings up another important note that we alluded to earlier - the version of autoscaler is important.
The current version is v2, and it has more granularity or control in terms of defining metrics. Since this is what
I had running at the time (and I was totally green) I stuck with the simpler of the two first. In the future
I'd be interested to try version 2. The important note here is:

> 🥑 We must match the version of our operator auto-scaler endpoint to the one we create (yes, YAML)

Also note that the HPA above is scoped to a namespace and name. This is kind of cool because it means that we can create separate HPA for different named jobs. Note that we also set a target CPU. In version 2 you get an entire metrics section with [much more verbosity](https://www.pulumi.com/registry/packages/kubernetes/api-docs/autoscaling/v2/horizontalpodautoscalerlist/). When I applied this YAML file to create it, I learned
fairly quickly another lesson:

> 🥑 The pods of the MiniCluster indexed job MUST have a resource spec

Without the resource spec, the HPA couldn't do intelligent calculations about the pod. The other note is that your cluster needs to have a metrics
server. I won't detail how to do that here, but there is a complete description [in the elasticity docs for the Flux Operator](https://flux-framework.org/flux-operator/tutorials/elasticity.html#running-the-example).


#### 5. Watch it scale!

Once I had the operator logic added, the metrics server and HPA running, and then I could stress my MiniCluster CPU, I saw it scale!

```bash
$ kubectl get -n flux-operator hpa -w
NAME              REFERENCE                 TARGETS   MINPODS   MAXPODS   REPLICAS   AGE
flux-sample-hpa   MiniCluster/flux-sample   0%/2%     2         4         2          33m
flux-sample-hpa   MiniCluster/flux-sample   0%/2%     2         4         2          34m
flux-sample-hpa   MiniCluster/flux-sample   3%/2%     2         4         2          34m
flux-sample-hpa   MiniCluster/flux-sample   0%/2%     2         4         3          34m
```

This was a very stupid example because I set the target very low (2% of CPU) to ensure it triggered, but you
could imagine this being more reasonable to coincide with the needs of a job. As I watched the cluster "replicas" change
from 2 to 4 (as shown above) I could list pods in my MiniCluster, and see the same change. They would
scale up and down according to CPU, up to the maxSize that the Flux broker would allow, and there was no need
to stop or re-create the MiniCluster.

> Houston, we have elasticity! 🥳️


## Summary: how does it work?

To summarize the above, this is my understanding as of working on this for a whopping 24 hours.
How does it work?¶

<ol class="custom-counter">
<li>We provide the autoscaler with a field (size) and selector for pods for the scale endpoint</li>
<li>The HPA pings our endpoint for our CRD to get the current selector and size</li>
<li>It retrieves the pods based on the selector</li>
<li>It compares the actual vs. desired metrics</li>
<li>If scaling is needed, it applies a change to the field indicated, directly to the CRD</li>
<li>The change request comes into our operator!</li>
</ol>

What I love about this design is that the request coming in looks the same to the operator whether it's from a user explciitly applying a YAML file with an updated size, vs. a change to the custom resource triggered by the autoscaler. I love that because we have one function
that handles changing the size in the operator, and it's one stream of logic to maintain.
It also is really nice because if an autoscaler isn’t installed to the cluster, we have those fields but nothing happens, or no action is taken. 

## Summary: what are next steps?

Before I talk about next steps, I want to step back and express immense gratitude for the people that are a consistent source of support and knowledge. I've been in many situations where this is lacking, and it's hugely obvious to me (and appreciated) when it's not. This includes the Flux Framework and 
 Converged Computing teams (and those two overlap quite a bit), along with my scattered collaborators and friends on the various Kubernetes or other cloud or container slacks or social media. My style of long threads and brain dumping my learning or questions is probably really annoying at times. I don't know why I'm verbose like that and sometimes I really am down on myself about it, but I'll just say it means that world to find people that can tolerate that and work with and support me, and it's absolutely everything. 💗️

The next steps (if you haven't guessed) are to integrate this with an actual scaling of a Kubernetes cluster, meaning adding actual nodes.
My main concern here is how quickly a cloud provider could do that, but that adventure is for another day!

Thanks for reading - I did a lot of writing today and had a lot of fun. I think it's really important, when we work on something
exciting (or possibly complex) to take time to put it down in writing. It's almost a guarantee that others (and future you!)
won't remember the details just a few months down the road. For full updates on elasticity, you can
[follow this page](https://flux-framework.org/flux-operator/tutorials/elasticity.html) or follow [my Twitter](https://twitter.com/vsoch)
where I throw things out into the void and hope that one person might read them, and it might help them.
Happy Saturday friends!
