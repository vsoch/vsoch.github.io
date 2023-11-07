---
title: "Multiple Types for a Mutating Admission Webhook"
date: 2023-11-06 10:00:00
---

I thought the hard part was over with webhooks with the cert-manager and correct uncommecting of YAML manifests for kustomize, but oh, was I wrong! 😆️ This took me a hot minute (about two days) to figure out so I want to briefly write it up for others. If you don't want to read, [here is the commit](https://github.com/converged-computing/oras-operator/commit/2bda5f1812e13d806494378a1ec06025fc54321a) with all the changes that made it work, and I'll summarize:

<ol class="custom-counter">
<li>Don't use the controller-runtime builder, but instead Register</li>
<li>kubebuilder can start you off, but won't generate the correct thing</li>
<li>The struct for your webhook needs to be private in the package</li>
<li>update can lead to forever termination (just use create)</li>
<li>A build can pass but generate fail because of controller-gen</li>
</ol>

And add more detail in sections below.

## entrypoint in main.go

You'll find several examples for how to generate a webhook. The default controller-runtime will have you use a [builder](https://github.com/kubernetes-sigs/controller-runtime/blob/c30c66d67f47feeaf2cf0816e11c6ec0260c6e55/examples/builtins/main.go#L74-L81) that looks something like this in main.go:


```go
if err = (&api.OrasCache{}).SetupWebhookWithManager(mgr); err != nil {
	setupLog.Error(err, "unable to create webhook", "webhook", "OrasCache")
	os.Exit(1)
}
```

And then maybe that function "SetupWebhookWithManager" looks like this:

```go
func (o *OrasCache) SetupWebhookWithManager(mgr ctrl.Manager) error {
    return ctrl.NewWebhookManagedBy(mgr).
        For(o).
        Complete()
}
```

Note that you could just call the contents of that function within the main.go, that's a technicality. There are many examples of this online if you [search GitHub](https://github.com/search?q=SetupWebhookWithManager&type=code). The expectation is that you are providing your own custom resource definition (CRD). This was the first sign that I was trying to do something slightly non-traditional, but I did find [this documentation](https://book.kubebuilder.io/reference/webhook-for-core-types) that suggested I was not entirely off in left field. But it still used that builder strategy above that only allowed for one object with "For." But I went with it for the first shot, and figured that I would figure out the multiple object use case later. What I first did is take my CRD (the OrasCache) as a "whatever" argument, and then just have the kubebuilder annotation and function actually watch for pods:

```go
var orascachelog = logf.Log.WithName("orascache-resource")

type PodInjector struct{}

func (r *OrasCache) SetupWebhookWithManager(mgr ctrl.Manager) error {
	return ctrl.NewWebhookManagedBy(mgr).
		For(&corev1.Pod{}).
		WithDefaulter(&PodInjector{}).
		Complete()
}

var _ webhook.CustomDefaulter = &PodInjector{}

// Default is the expected entrypoint for a webhook
func (a *PodInjector) Default(ctx context.Context, obj runtime.Object) error {
	pod, ok := obj.(*corev1.Pod)
	if !ok {
		return fmt.Errorf("expected a Pod but got a %T", obj)
	}
	return oras.InjectPod(ctx, pod)
}
```

And that [looked like this](https://github.com/converged-computing/oras-operator/blob/b787fd187225643027ef7ff1475c81d403e953cc/api/v1alpha1/orascache_webhook.go). That actually worked fine for just one type (Pod) and fueled [my last post](https://vsoch.github.io/2023/oras-kubernetes-cache/). You could have also done:

```go
if err := builder.WebhookManagedBy(mgr).
	For(&corev1.Pod{}).
	WithDefaulter(&podAnnotator{}).
	Complete(); err != nil {
	entryLog.Error(err, "unable to create webhook", "webhook", "Pod")
	os.Exit(1)
}
```

And this worked totally fine... until I wanted to add a second type! E.g., "watch for Jobs <italic>and</italic> Pods." 

## adding another type

The reason we would want to support both is because for pods, there are many abstractions that have an underlying Pod we could hit (Deployment, StatefulSet, etc.) but on the other hand, let's say we create a Batch Job with 1K pods. It's much more efficient to tweak the PodTemplateSpec of the Job once than do it 1K+ times (for each pod that is to be generated). So I wanted to do both. Here are some early ideas I came up with:

<ol class="custom-counter">
<li>Add a flag to the entrypoint (main.go) to control which to choose</li>
<li>Put a field on the CRD and then use the Kubernetes client to retrieve</li>
<li>Find a way to support two types</li>
</ol>

For the first idea, I didn't like the idea that a controller in a cluster would limit all oras caches to use just one strategy. For the second, I talked with Aldo (incredibly awesome and knowledgable on just about everything Kubernetes!) and he pointed out we'd likely have a race condition. This meant that we needed to support two types. I was worried about spamming the webhook, but if it returns quickly maybe this isn't an issue. It certainly would be more efficient to monitor the parent objects of pods (e.g., Job) instead of every pod generated! So I proceeded with the third bullet.

## kubebuilder annotation

The next thing that burned me was the kubebuilder annotation. They typically work fairly well to generate the manifests. This is what should have worked:

```
//+kubebuilder:webhook:path=/mutate-v1-sidecar,mutating=true,failurePolicy=fail,sideEffects=None, \
groups=core;batch,resources=pods;jobs,verbs=create,versions=v1, \
name=morascache.kb.io,admissionReviewVersions=v1
```

(cut for readability). But there are several issues:

<ol class="custom-counter">
<li>The builder will generate a name based on the group / type that does not match</li>
<li>The groups won't be parsed into a list, regardless of what you try</li>
</ol>

For the first, I found via inspecting the created object that "/mutate--pod-v1" was generated and changed
it to that. But when the list wasn't generated correctly, I couldn't use the annotation. I [commented it out](https://github.com/converged-computing/oras-operator/blob/2bda5f1812e13d806494378a1ec06025fc54321a/api/v1alpha1/orascache_webhook.go) and then tweaked the partially correct one at "config/webhooks/manifests.go" to be [what I needed](https://github.com/converged-computing/oras-operator/blob/2bda5f1812e13d806494378a1ec06025fc54321a/config/webhook/manifests.yaml). Primarily the "gotchas" here were getting all the groups I needed to match the objects, and (of course) allowing for multiple object types to begin with (pod and job). My strategy at the end of the day was to use the kubebuilder annotation to generate an initial manifests.yaml, but then comment it out and use my own tweaked one.

## webhook struct

This was by far the hardest part! We first had to have the wisdom that the builder generating the default webhook name based on one type would not fly. So instead of that pattern, we needed something like:

```go
mgr.GetWebhookServer().Register("/mutate-v1-sidecar", 
	&webhook.Admission{Handler: &SidecarInjector{}}
)
```

But actually a little more than that, because we need a decoder that carries the schemas our controller knows about.

```go
mgr.GetWebhookServer().Register("/mutate-v1-sidecar", &webhook.Admission{
    Handler: &SidecarInjector{
        Client:   mgr.GetClient(),
        decoder:  admission.NewDecoder(mgr.GetScheme()),
    },
})
```

For the above, that meant my struct had:

```go
type SidecarInjector struct {
	Client  client.Client
	decoder *admission.Decoder
}

func (a *SidecarInjector) Handle(ctx context.Context, req admission.Request) admission.Response {
	...
}
```

And it worked perfectly with my function to build the container, namely because we just ran a build and didn't use controller-gen! When I ran "make" locally, oh no:

```
(*in).DeepCopyInto undefined (type *admission.Decoder has no field or method DeepCopyInto)
```

And that alone took me down 4 hours of rabbit holes. I tried removing the extra objects on the struct and writing different functions to convert raw request objects to types (didn't work), making global variables for the decoder and schemas (also didn't work) and even writing a wrapper around the sidecar struct to add the missing DeepCopyInto (also didn't work)! It was an insight that I read that the generator will only generate those functions for exported things that led me to the [current solution](https://github.com/converged-computing/oras-operator/blob/2bda5f1812e13d806494378a1ec06025fc54321a/api/v1alpha1/orascache_webhook.go), namely that it will all work fine if the silly struct is private to the package (lowercase). Ack, so simple.

Anyway, I spent an entire day and some change on this, but now this is a fairly OK way (I think) to have a mutating admission webhook that supports two (or more!) Kubernetes objects. Hooray! Onward to pick up where I should have been maybe yesteray. 😆️😭️
