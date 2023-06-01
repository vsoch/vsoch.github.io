---
title: "Autoscaling with Custom Metrics in Kubernetes"
date: 2023-05-31 12:30:00
---

We've been working on implementing [elasticity in the Flux Operator](https://vsoch.github.io/2023/elasticity/).
In that specific post, I talk about the journey going from simply saving state of a cluster through 
using the [autoscaling/v1](https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/) API to ask the Horizontal Pod Autoscaler to scale the Flux MiniCluster based on a percentage of CPU. This turned into the autoscaling version 1 example [here](https://flux-framework.org/flux-operator/tutorials/elasticity.html#horizontal-autoscaler-v1-example). I alluded to some next steps:

> The next steps (if you haven’t guessed) are to integrate this with an actual scaling of a Kubernetes cluster, meaning adding actual nodes. My main concern here is how quickly a cloud provider could do that, but that adventure is for another day!

And the other next step (not explicitly stated) was to get the version 2 of autoscaling working (more on what that means later)
along with implementing a custom metric. This will be what I talk about in this post.

## Testing Kubernetes Scaling

The step that comes before testing two things together is testing them separately, and I had yet to test if it was reasonable
to scale an actual Kubernetes cluster up and down. My intuition (based on the time to bring up a cluster on different clouds)
was that it would be too slow. And so, this was my first point of action.

I was able to most easily test this on Google Cloud (my favorite cloud!) and do some basic experiments to look at adding
and removing two nodes. I found that the [times are actually quite reasonable](https://github.com/converged-computing/operator-experiments/tree/2070bc49e73a75eb2671371a7eafc39742a29bd2/google/autoscale/run1). As a quick example, here are times it takes to add or remove one or two nodes
from a cluster. This is calculated across 10 different clusters, and from sizes 0 through 32, so there is quite a bit of data.

<div style="padding:20px">
<img src="https://github.com/converged-computing/operator-experiments/blob/2070bc49e73a75eb2671371a7eafc39742a29bd2/google/autoscale/run1/img/add_vs_remove_1_nodes_with_outliers_mpis.png?raw=true">
</div>

You can see that adding a node is much less costly than removing one, and there is much less variation in the timing. This is good news for the Flux Operator, because we really only care about the time it takes for the node to come up and be ready. As soon as the node goes offline Flux will no longer see it, so we don't mind if it takes a little longer to go down (aside from the extra marginal cost, maybe). After doing these basic experiments (that overall showed adding a new node in ~30 seconds and 10 new nodes in ~40 seconds) I was convinced that this would be an OK thing to do. Maybe it wouldn't make sense to do very frequently, but for a few times to match a workflow it makes sense.

## Autoscaling Version 2

And now we start the adventure with Autoscaling version 2 with the Horizontal Pod Autoscaler (HPA)! As a reminder, for any kind of autoscaling for an operator custom resource definition, we first needed to add a [HPA + Scale sub-resource](https://book.kubebuilder.io/reference/generating-crd.html#scale) in our custom resource definition. This allowed the operator to expose a count for the number of replicas and selector for some HPA.
This allowed our application running in the MiniCluster can then provide custom metrics based on which we set up the scaling. 

Now let's talk about the differences in the version 1 vs the version 2 API.
The APIs for v1 and v2 of the autoscaler [are subtly different](https://www.pulumi.com/registry/packages/kubernetes/api-docs/autoscaling/v1/horizontalpodautoscaler/). In layman's terms, in the version 1 example we first developed, there is support for very basic metrics like CPU utilization. 
However, in version 2 we are hoping to use [custom metrics](https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale-walkthrough/#autoscaling-on-multiple-metrics-and-custom-metrics), which could be anything we dream up! We are interested in this technique not only because we want special metrics from Flux, but also because the requests can [come from an external service](https://cloud.google.com/kubernetes-engine/docs/concepts/horizontalpodautoscaler), meaning we could have a single service (paired with application logic, optionally) to handle scaling both node and MiniClusters, and coordinating the two.

### The Journey Started with FLUB!

My journey started with testing FLUX, or Flux Bootstrapping. As of the writing of this post, this was about [four days ago](https://github.com/flux-framework/flux-core/pull/5184#issuecomment-1565737130) and I had [created a pull request](https://github.com/flux-framework/flux-operator/pull/177) that felt close - I was able to create two MiniClusters and have one see nodes from the other. But I didn't totally understand the expected use case at the time. I had wanted to somehow get a handle to control a Flux leader broker, and give control to a second MiniCluster. I thought if this simple idea could be extended or scaled, it would mean having brokers control other brokers *between* MiniClusters at any level of scaling. I learned in that linked discussion that this wasn't that, but instead was adding an allowance for a single MiniCluster to add nodes. As we [already talked about](https://vsoch.github.io/2023/elasticity/#step-3-tricking-flux-in-scaling), we had a trick that worked quite well for that, and so in that [discussion](https://github.com/flux-framework/flux-core/pull/5184#issuecomment-1565737130) I stepped back and started to discuss my desires for this kind of elasticity for autoscaling. 


### And then there was Prometheus

In that discussion I laid out a basic plan for how it might work - using [custom metrics](https://github.com/kubernetes-sigs/custom-metrics-apiserver),
and that led me to [Prometheus](https://prometheus.io/) and an [adapter for it](https://github.com/kubernetes-sigs/prometheus-adapter) that would allow exposing metrics from a Prometheus data exporter to the horizontal pod autoscaler. You can see my plan laid out in that early post:

<ol class="custom-counter">
  <li>Write a Flux plugin that exports prometheus metrics</li>
  <li>Combine that with the Flux Operator + horizontal pod autoscaler with a custom metric (autoscaler/v2)</li>
  <li>Install the HPC/metrics-server and submit jobs, asking for more than we have (hope it works!)</li>
</ol>

Lol! In retospect I'm a terrible planner - I'm basically like "DO THE THING AND SEE IT WORKS!" This is something I've mentioned before that is part of my work style - I learn by doing and building and don't spend much time in advance writing down some perfect solution, because there is just no way I could know. Anyway, since it was bad practice to be talking about a different issue on a pull request for something else (oups) I wound up opening a [new issue for discussion](https://github.com/flux-framework/flux-core/issues/5214). And let me tell you how stupid I am with writing C/C++ code. At the time I chose the wrong library (one in C++ instead of C), [this one](https://github.com/jupp0r/prometheus-cpp) that I ultimately setup and then (oops) needed to use a C library, [this one](https://github.com/digitalocean/prometheus-client-c/). Hey - we all make stupid mistakes sometimes!

### Writing a C Plugin for Flux

This last weekend I set out on this journey to write a plugin for Flux, and while I've done a lot of work around Flux (Python, automake and builds, documentation and CI and containers) I had not ventured too deeply into actually writing C. The first part of this process was understanding, because there wasn't a tutorial or anything how to write a plugin or module, or how they worked. I did quite a bit of reading code and some scattered documentation to write the start of a guide for how to write a plugin (or actually, broker module) that is currently just a [GitHub gist](https://gist.github.com/vsoch/756f10b52f7889e1b781ccdc599fa8cc). Although I don't go into the nitty gritty details of the plugin itself, it walks through adding the plugin and getting all the automake files setup, which is a non-trivial thing! Within about a day I had a [prototype](https://github.com/flux-framework/flux-core/pull/5215)
(that warranted further discussion) and I had done quite a bit of [learning about how broker modules work](https://github.com/flux-framework/flux-core/issues/5214#issuecomment-1566310645). I've said this before and I'll say it again - I am continually impressed by the design of Flux and the various components. I think there could be a few more helpful guides for contributing components, and I'm trying to help with that as best as I can. But TLDR: the way that plugins (or modules) work with Flux is super cool.

This learning and implementation was a joy for me, because (to be frank) with the VSCode environment setup with Flux and an ability to quickly compile and load and unload my broker module to test, it was a joy to develop. Yes, there were definitely errors, but instead of my console throwing up on me, since I had gotten an "empty" module building and loading first, this meant moving forward I could work carefully and make small changes, and then test loading and unloading, and so any errors that came up I could work through. Here is a quick lesson that I think is good for any project:

> Step 1 for any kind of focused work is setting up a comfortable development environment!

For maybe the first time, writing C felt almost comfortable. A bit part of that, aside from preparing myself the nice developer environment and setup, was having a lot of other modules to look at for examples (I learn really well from looking at code). I was almost a little bit relieved, because I had never had a good reason to work on C, and wasn't sure I could do it. I'm proud that I can, and I bet I can do more!

### Writing Prometheus Flux (in Python)

One of the [suggestions](https://github.com/flux-framework/flux-core/issues/5214#issuecomment-1567238494) in that thread (actually suggested by two people) was to write a Python service instead. I took this to heart, because I realized that the design wouldn't likely be better. I don't think broker plugins are supposed to run consistent services like I had in mind for this prometheus exporter. So that's what I did in writing [prometheus-flux](https://github.com/converged-computing/prometheus-flux). That library is a simple Python client that you run from inside a Flux instance, and it uses [starlette](https://www.starlette.io/) (that I wanted to try) to provide a simple "/metrics" endpoint that will serve the expected Prometheus metrics. If you want to see what this looks like, take a look at the repository link above. It's basically a page dump of single line metrics in an expected format. OK great - so we had our data exporter! I could run this in the Flux Operator and play around with Prometheus + the adapter. I set up my developer environment to work on that but... then it hit me like a ton of bricks when I faced having to deploy Prometheus onto my tiny cluster.

> I hate having extra dependencies!! 😭️

I generally don't like solutions that require extra complexity. And in fact I'll go through quite a bit of extra work to avoid it. I don't know why I didn't ponder this earlier - maybe I was too excited about the custom metrics. So despite making this Prometheus Flux data exporter (which might be useful outside of this particular use case) I decided to start from scratch. At this point it's only been about two days, and a weekend, so it was a tiny sunk cost. I really don't care about "lost work" because I want to do things the right way, generally.

### Writing a Custom Metrics API

I decided to step back and look closely at what exactly a custom metrics API looked like. I found [this article on Medium](https://medium.com/swlh/building-your-own-custom-metrics-api-for-kubernetes-horizontal-pod-autoscaler-277473dea2c1) but I couldn't actually read it (lol) but I concluded from the title that if this dude wrote it up that he made one, well I could too (I totally know that's not a lot to go off of, but generally I don't need a lot of activation energy to get excited about something, and I was excited)! I first started very stupidly and copied the server logic of the flux prometheus library (it already had a nice developer environment with Flux, and a web server that I liked)! I started perusing the internet for what the API responses from the custom metrics API should look like, and found articles like [this one](https://towardsdatascience.com/kubernetes-hpa-with-custom-metrics-from-prometheus-9ffc201991e). And it was ultimately the [implementation in Go](https://github.com/kubernetes-sigs/custom-metrics-apiserver) where I found the exact details I was looking for. With this information, I was able to make a simple server that dumped out information that (I thought) would be correct to be parsed by the horizontal pod autoscaler. I started with simple metrics from Flux like the number of nodes and cores up vs. free. You can imagine we will eventually want stats about the queue or resources needed vs. existing. But there is so much detail to share here! Let me try to walk through the steps, because largely it's not documented anywhere (except maybe in that Medium article I can't access...)


#### Kubernetes and High Level

For our indexed job to scale, we still need [Kubernetes 1.27 and later](https://github.com/kubernetes/enhancements/tree/master/keps/sig-apps/3715-elastic-indexed-job#motivation). If you need a reminder for how an autoscaler works, it's basically going to be asking some cluster level API (typically a metrics server) for some kind of metric like CPU, and then it's going to decide (based on the spec you've defined) if it needs to scale up or down. Given a decision to scale, it will ping your custom resource definition and change the attribute you've defined (for us, the size of the MiniCluster).

#### Version 2 Autoscaler for CPU

A simple design for a version 2 autoscaler, based on CPU, and not requiring the custom metrics API, would look like this:

```yaml
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: flux-sample-hpa
  namespace: flux-operator
spec:
  scaleTargetRef:
    apiVersion: flux-framework.org/v1alpha1
    kind: MiniCluster
    name: flux-sample
  minReplicas: 2
  maxReplicas: 4
  metrics:
  - type: Resource
    resource:
      name: cpu
      # This is explicitly set to be very low so it triggers
      target:
        type: Utilization
        averageUtilization: 2
```

After installing a metrics server and the autoscaler above, and having the scale subresource on my operator, I would see the cluster
scale up (or down) based on the CPU utilization. I wanted to show this because you can see the overall design for metrics. The main type
is a Resource. And either way, the operator is exposing it's current state via this endpoint:


```bash
$ kubectl get --raw /apis/flux-framework.org/v1alpha1/namespaces/flux-operator/miniclusters/flux-sample/scale | jq
```
```console
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
    "selector": "hpa-selector=flux-sample"
  }
}
```

I won't go into the details of this entire setup, but you can read about them [here](https://flux-framework.org/flux-operator/tutorials/elasticity.html#autoscaler-with-cpu). It was fairly simple to using the autoscaling/v1, but with the slightly different format of the spec
shown above.

#### Version 2 Autoscaler for Custom Metrics

At this point, I had the [flux-metrics-api](https://github.com/converged-computing/flux-metrics-api) that was exporting... something, and that something I thought might be useful for the autoscaler. I'll walk through this in the steps that I finally got working, but know that the path there was anything but straight! For starters, I think most of these API servers are expected to be run in the "kube-system" namespace, and as their own pod. Since I wanted to run from the index 0 pod of an Indexed Job, and scoped within a namespace, I had to pave my own road for a different design, and figure out some extra tricks. 

##### Secrets

The first was generating certificates that I would provide in a secret and then give to my APIService,
and since this was being served by the Flux Operator MiniCluster, I had to add support for adding an existing secret as a Volume Mount.
After this, I had certificates at "/etc/certs" available for my application. I followed the advice [here](https://github.com/kflansburg/py-custom-metrics/tree/39ad121047b8c798dde380f94abc97b1589ba4ed/scripts) to generate them. Creating the secret from the files looked like this:

```bash
$ kubectl create secret tls -n flux-operator certs --cert=server.crt --key=server.key
```

And then I could define it as an existing volume mount in the [minicluster.yaml](https://github.com/flux-framework/flux-operator/blob/d7baba54e2dd446478d8f50026f8174ce07ba9cd/examples/elasticity/horizontal-autoscaler/v2-custom-metric/minicluster.yaml#L27-L30).

##### MiniCluster

After bringing up the [minicluster](https://github.com/flux-framework/flux-operator/blob/d7baba54e2dd446478d8f50026f8174ce07ba9cd/examples/elasticity/horizontal-autoscaler/v2-custom-metric/minicluster.yaml) in interactive mode, I could connect to the broker (running inside the Flux instance)
and manually start the API server. I made all of these variables customizable anticipating I might want to change them, of course.

```bash
$ flux-metrics-api start --port 8443 \
    --ssl-certfile /etc/certs/tls.crt
    --ssl-keyfile /etc/certs/tls.key
    --namespace flux-operator
    --service-name custom-metrics-apiserver
```

I opened another interactive console connected to the broker and first tested hitting these endpoints. I'd want to just sanity check that I saw the same responses as when debugging the library in isolation:

```bash
$ curl -s http://0.0.0.0:8080/apis/custom.metrics.k8s.io/v1beta2/namespaces/flux-operator/metrics/node_up_count | jq
$ curl -s http://flux-sample-0:8080/apis/custom.metrics.k8s.io/v1beta2/namespaces/flux-operator/metrics/node_up_count | jq
```
```console
{
  "items": [
    {
      "metric": {
        "name": "node_up_count"
      },
      "value": 2,
      "timestamp": "2023-05-30T22:20:07+00:00",
      "windowSeconds": 0,
      "describedObject": {
        "kind": "Service",
        "namespace": "flux-operator",
        "name": "custom-metrics-apiserver",
        "apiVersion": "v1beta2"
      }
    }
  ],
  "apiVersion": "custom.metrics.k8s.io/v1beta2",
  "kind": "MetricValueList",
  "metadata": {
    "selfLink": "/apis/custom.metrics.k8s.io/v1beta2"
  }
}
```

Nice! And I could see the output in the other console (the server log running, not shown).

##### Service

To step back, at this point we have a custom metrics server running from inside of a pod, and we need to somehow tell
the cluster to provide a service with a particular address being served from that pod. Here are the logical steps we will take
to do that:

<ol class="custom-counter">
<li>Add a label selector on the index 0 pod (the leader broker with the metrics API running)</li>
<li>Create a service that uses the selector to point the particular port service to the pod</li>
<li>Create an API service that targets that service name to create a cluster-scoped API</li>
</ol>

It's Kubernetes so the order of operations (and figuring this out to begin with) was kind of weird.
Let's do those steps one at a time. First, adding the selector label to the leader broker pod:

```bash
$ kubectl label pods -n flux-operator flux-sample-0-xxx api-server=custom-metrics
```

And the adding the service that knows how to select that. Here is what I came up with:

```bash
$ kubectl apply -f ./scripts/service.yaml
```
```yaml
apiVersion: v1
kind: Service
metadata:
  name: custom-metrics-apiserver
  namespace: flux-operator
spec:
  # This says "the service is on the pod with this selector"
  selector:
    api-server: custom-metrics
  ports:
    - protocol: TCP
      port: 443
      targetPort: 8443
```

Notice that we are serving port (8443) our application to 443 (which is why we need the certificates!)
I'm not sure Kubernetes will accept an API service that doesn't have that. The selector is the label
we just applied to our pod. Once I applied that, I could see that there is a cluster IP address serving a secure port:

```bash
kubectl get svc -n flux-operator 
NAME                       TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)   AGE
custom-metrics-apiserver   ClusterIP   10.96.20.246   <none>        443/TCP   5s
flux-service               ClusterIP   None           <none>        <none>    12m
```

##### API Service

At this point I wanted to create the cluster API service. I first started developing this with full
SSL, but ultimately got lazy and proceeded without it.

```bash
# Without TLS (no changes needed to file)
$ kubectl apply -f ./scripts/api-service.yaml

# This would be WITH TLS (uncomment lines in file)
# This needs to be -b=0 for Darwin
export CA_BUNDLE=$(cat ./scripts/ca.crt | base64 --wrap=0)
cat ./scripts/api-service.yaml | envsubst | kubectl apply -f -
```

And the API service YAML (for the case without SSL):

```yaml
apiVersion: apiregistration.k8s.io/v1
kind: APIService
metadata:
  name: v1beta2.custom.metrics.k8s.io
spec:
  # You'll want to not do this in production
  insecureSkipTLSVerify: true
  service:
    name: custom-metrics-apiserver
    namespace: flux-operator
  group: custom.metrics.k8s.io
  version: v1beta2
  groupPriorityMinimum: 1000
  versionPriority: 5
  # caBundle: ${CA_BUNDLE}
```

I originally got some errors, and it was because of version mismatches. If you get an error, ensure the versions 
installed to your cluster match up with what you are trying to create:

```bash
$ kubectl api-resources | grep apiregistration
apiservices                                    apiregistration.k8s.io/v1              false        APIService
```

I also found a nice way to debug the service:

```bash
$ kubectl describe apiservice v1beta2.custom.metrics.k8s.io
```

For example, when I first created it, I hadn't actually added SSL / certificates to my endpoints
so I saw an error that the connection was refused. When it works, you will see this endpoint get hit a LOT.

```console
INFO:     10.244.0.1:4372 - "GET /apis/custom.metrics.k8s.io/v1beta2 HTTP/1.1" 200 OK
INFO:     10.244.0.1:34610 - "GET /apis/custom.metrics.k8s.io/v1beta2 HTTP/1.1" 200 OK
INFO:     10.244.0.1:40447 - "GET /apis/custom.metrics.k8s.io/v1beta2 HTTP/1.1" 200 OK
INFO:     10.244.0.1:54072 - "GET /apis/custom.metrics.k8s.io/v1beta2 HTTP/1.1" 200 OK
INFO:     10.244.0.1:6895 - "GET /apis/custom.metrics.k8s.io/v1beta2 HTTP/1.1" 200 OK
INFO:     10.244.0.1:64937 - "GET /apis/custom.metrics.k8s.io/v1beta2 HTTP/1.1" 200 OK
INFO:     10.244.0.1:48753 - "GET /apis/custom.metrics.k8s.io/v1beta2 HTTP/1.1" 200 OK
INFO:     10.244.0.1:58257 - "GET /apis/custom.metrics.k8s.io/v1beta2 HTTP/1.1" 200 OK
INFO:     10.244.0.1:17035 - "GET /apis/custom.metrics.k8s.io/v1beta2 HTTP/1.1" 200 OK
INFO:     10.244.0.1:54047 - "GET /apis/custom.metrics.k8s.io/v1beta2 HTTP/1.1" 200 OK
```

I think it's doing a constant health check, and this is why we have to provide a 200 response
there to get it working. This is what it should look like when it's working:

```bash
kubectl get apiservice v1beta2.custom.metrics.k8s.io
NAME                            SERVICE                                  AVAILABLE   AGE
v1beta2.custom.metrics.k8s.io   flux-operator/custom-metrics-apiserver   True        22m
```

And wow - we now have an API service running at this endpoint! While I won't go into
detail, looking at the Go variant of this code revealed that I needed to provide many other
endpoints, including a resource list and one that described my particular metrics. You
can look at the [flux-metrics-api](https://github.com/converged-computing/flux-metrics-api/blob/main/flux_metrics_api/routes.py) 
for all the routes I wound up making. Let's make some autoscaler stuff!

##### Finally the Horizontal Pod Autoscaler (HPA) Version 2!

Now we have our custom metrics server running - and the cool part that I realized in this process is that we don't
actually need a full metrics server to use the custom-metrics server! They are different API endpoints. Next,
 let's create the autoscaler! Here is what I came up with eventually. This took me a hot minute to get somewhat right:

```bash
$ kubectl apply -f hpa-flux.yaml
```
```yaml
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: flux-sample-hpa
  namespace: flux-operator
spec:
  scaleTargetRef:
    apiVersion: flux-framework.org/v1alpha1
    kind: MiniCluster
    name: flux-sample
  minReplicas: 2
  maxReplicas: 4
  metrics:

  - type: Object
    object:
      # This is the service we created
      target:
        value: 4
        type: "Value"

      # Where to get the data from
      describedObject:
        kind: Service
        name: custom-metrics-apiserver

      # This should scale until we hit 4
      metric:
        name: node_up_count

  # Behavior determines how to do the scaling
  # Without this, nothing would happen
  # https://www.kloia.com/blog/advanced-hpa-in-kubernetes
  behavior:

    # select the preferred policy dynamically, "Max" or "Disabled"
    scaleUp:
      selectPolicy: Max
      stabilizationWindowSeconds: 120
      policies:
      - type: Percent
        value: 100
        periodSeconds: 60

    scaleDown:
      selectPolicy: Max
      stabilizationWindowSeconds: 120
      policies:
      - type: Percent
        value: 100
        periodSeconds: 60
```

What made it hard is not understanding how to actually act on a custom metric. My recipe above started with the entire top without the "behavior" section on the bottom, and I saw the HPA hitting my custom metric endpoints, but no action taken. What to do!? I figured out reading the spec that it must be related to behavior, and then by trial and error, came up with the above. That's when I saw more pods added, and the HPA working! Hooray!

##### An interesting bug?

Note that when I was working on this, I first hit [this error](https://github.com/kubernetes/kubernetes/blob/18e3f01deda3bc1ea62751553df0b689598de7a7/staging/src/k8s.io/metrics/pkg/client/custom_metrics/discovery.go#L101) and had to find that spot in the source code, and then realize that the `/apis` root endpoint was being pinged for some kind of "preferred version."  I think this goes back to the original observation that I am deploying this in a non-traditional way - perhaps an APIService on the correct level would also have this endpoint easily defined. The strange thing is that the endpoint worked perfectly fine with "kubectl get --raw" from outside of my pod. So I figured - why not give it what it wants? I first tried mocking it with a partial response (just for the resource I was serving) and crashed my entire cluster (hooray)! Then I tried mocking the endpoint with a full json dump, and when that seemed to work, I also figured out that I could authenticate with the Kubernetes API from the pod, and forward the actual response. I eventually added some caching to that so we wouldn't need to call it every time. Likely I'd want to add some timeout for that cache to expire, but that's for another day. When these endpoints were provided, I started seeing the autoscaler actually pinging my server for the metric!

```console
INFO:     10.244.0.1:10333 - "GET /openapi/v2 HTTP/1.1" 200 OK
Requested metric node_up_count in  namespace flux-operator
INFO:     10.244.0.1:31834 - "GET /apis/custom.metrics.k8s.io/v1beta2/namespaces/.../node_up_count HTTP/1.1" 200 OK
INFO:     10.244.0.1:12095 - "GET /apis HTTP/1.1" 200 OK
INFO:     10.244.0.1:33736 - "GET /apis/custom.metrics.k8s.io/v1beta2 HTTP/1.1" 200 OK
INFO:     10.244.0.1:43900 - "GET /apis/custom.metrics.k8s.io/v1beta2 HTTP/1.1" 200 OK
INFO:     10.244.0.1:53777 - "GET /apis/custom.metrics.k8s.io/v1beta2 HTTP/1.1" 200 OK
INFO:     10.244.0.1:28114 - "GET /apis/custom.metrics.k8s.io/v1beta2 HTTP/1.1" 200 OK
INFO:     10.244.0.1:4014 - "GET /apis/custom.metrics.k8s.io/v1beta2 HTTP/1.1" 200 OK
Requested metric node_up_count in  namespace flux-operator
INFO:     10.244.0.1:16713 - "GET /apis/custom.metrics.k8s.io/v1beta2/namespaces/.../node_up_count HTTP/1.1" 200 OK
```

##### Scaling Based on a Custom Metric!

At this point we are retrieving the metric, and the behavior defined in the hpa yaml file will determine how scaling is done.
This dummy example I posted above is what I ultimately got working, and I found it helpful to get status -> conditions
to debug this:

```console
$ kubectl get hpa -n flux-operator flux-sample-hpa -o json | jq .status.conditions
[
  {
    "lastTransitionTime": "2023-05-31T19:50:20Z",
    "message": "recommended size matches current size",
    "reason": "ReadyForNewScale",
    "status": "True",
    "type": "AbleToScale"
  },
  {
    "lastTransitionTime": "2023-05-31T19:52:35Z",
    "message": "the HPA was able to successfully calculate a replica count from Service metric node_up_count",
    "reason": "ValidMetricFound",
    "status": "True",
    "type": "ScalingActive"
  },
  {
    "lastTransitionTime": "2023-05-31T20:30:54Z",
    "message": "the desired count is within the acceptable range",
    "reason": "DesiredWithinRange",
    "status": "False",
    "type": "ScalingLimited"
  }
]
```

And note that with the above HPA YAML, the scaling was done (we started at 2 and went up to 4!):

```bash
$ kubectl get -n flux-operator pods
NAME                  READY   STATUS    RESTARTS   AGE
flux-sample-0-kg8mq   1/1     Running   0          42m
flux-sample-1-dntwk   1/1     Running   0          42m
flux-sample-2-p8vhn   1/1     Running   0          2m3s
flux-sample-3-pvg6l   1/1     Running   0          2m3s
```


## Conclusions

This was a lot of fun learning over the last few days! It is just a prototype and would need more work (enabling SSL again and getting more feedback on the design) but I'm fairly happy to get the result above. Likely I'll more custom metrics to our little Python library, and maybe look into
this other strategy for using [External](https://github.com/GoogleCloudPlatform/bank-of-anthos/blob/a32d4cf14a6a030705f00fc9d0dbf2d547ef1231/extras/postgres-hpa/hpa/frontend.yaml#L16) endpoints for autoscaling.  The TLDR:

<ol class="custom-counter">
<li>We have prototypes for autoscaling directly from anything we want out of Flux</li>
<li>If someone is interested in Prometheus + Flux in the future, we have stuff for that too now.</li>
<li>Thank you to the Flux team, namely Garlick (Jim) and Grondo (Mark) that engaged with me</li>
</ol>


Some lessons? As always, we can see from this small journey that learning and development is not linear. When you don't know what you are doing, starting with some step one, and ensuring you have a good developer environment, is a good strategy. And often we need to do things wrong a few times before we decide on a way that we want to pursue, and even then there is no guarantee of correctness. I hope someone finds this useful eventually, I guess I can just keep building and learning in the meantime. And I hope someone else is excited about these ideas too - sometimes it feels a little lonely to be going on these development adventures alone, but maybe this is a me-problem.
