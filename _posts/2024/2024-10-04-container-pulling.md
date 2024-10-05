---
title: "Pulling Containers and the SOCI Snapshotter"
date: 2024-10-04 10:00:00
---

How does one pull containers in Kubernetes, you ask? Well, if you don't think much about it, the answer is pretty slowly. Of course it depends on the size of your containers. If you don't want to read, this is what I found (and discuss here):

<ol class="custom-counter">
<li>Moving containers to a registry local to the cloud didn't have obvious impact</li>
<li>Adding a local SSD improved pull times by 1.25x</li>
<li>The SOCI snapshotter improved times by 15-120x (!)</li>
</ol>

My biggest surprise was the SOCI snapshotter, which I expected to work well but not THAT well. 

> Note that the huge variation likely has to do with the index of the archive, and the extent of what the entrypoint needs, which is retrieved on demand. The containers that had a 120x improvement in pull time weren't real application containers - they were generated programatically. The containers that saw a 15x improvement were spack images, and for a machine learning container I saw a 10x improvement. I still need to do more work to understand the details.

Finally, I didn't see that AWS had provided a means to install with a daemonset, which (imho) is a more flexible strategy than having to install to the AMI or node. I [created a daemonset installer](https://github.com/converged-computing/soci-installer) this morning before going on a bike ride. 🚲 The rest of this post will detail my brief exploration (and fun) of this space, starting with observations from a recent performance study, and finishing with the creation of a daemonset for SOCI.

## An example from the wild

For a recent performance study we had moderately sized containers (in the order of less than 10 GB) and the slowest ones took a few minutes. Here is a quick shot of that - and mind you this includes pulling partial containers, where we've already pulled some layers. That's why you see some times close to 0.

<div style="padding:20px">
<img src="https://github.com/converged-computing/performance-study/raw/main/analysis/container-sizes/data/img/pull_times_experiment_type_aws_eks_cpu.png">
</div>

This full data is [available on GitHub](https://github.com/converged-computing/performance-study/tree/main/analysis/container-sizes) with a DOI, if you are interested [![DOI](https://zenodo.org/badge/837429553.svg)](https://zenodo.org/doi/10.5281/zenodo.13738495). If you use our data, please cite it! I can also show you how similar these containers are.  This (so far) is my favorite plot from the study. It's so beautiful, and (if you know what you are looking at) says a lot too. 

<div style="padding:20px">
<img src="https://github.com/converged-computing/performance-study/blob/main/analysis/container-sizes/data/similarity/cluster-container-layer-content-similarity.png?raw=true">
</div>

I really like this plot because it shows (with quite neat separation) the clustered environments we used for the study. First, the plot shows similarity of containers based on layer content digests using the Jacaard coefficient, which is the set intersection of two containers over the union. Note that this image doesn't show every label. So what are we looking at? 👀

<ol class="custom-counter">
<li>Containers that aren't similar to any others (browns) in the diagonal are spack builds</li>
<li>The top left green square is shared by containers for Google Cloud and Amazon (with libfabric) for GPU builds</li>
<li>The next tiny square (note the image doesn't show every label) has Google GPU images</li>
<li>The box toward the middle is CPU images, from both Google Cloud and AWS (with libfabric)</li>
<li>The space between the next clusters is an amg2023 image built with spack</li>
<li>The next little square (third from the bottom on the diagonal) is rockylinux (Compute Engine CPU)</li>
<li>The last two squares are Azure, first for GPU then CPU</li>
<li>The very last entries in the matrix are two more amg2023 images, unlike even each other.</li>
</ol>

The build of the containers (done by yours truly) is done intentionally to maximize redundancy of layers. This means a shared base (different depending on the environment) with added dependencies for Flux and oras, and only the application logic at the end. Now, if you build a spack environment into a container, you'll get one big, chonky layer with the application and all dependencies. I did this for a recent experiment (a small set) just to compare, and the "spack builds" matrix was all browns.

<div style="padding:20px">
<img src="https://github.com/converged-computing/container-chonks/blob/main/experiments/similarity/data/similarity/spack/cluster-container-similarity.png?raw=true">
</div>

And that is exactly what I expected.

## A controlled example

I had a week between taking a road trip and coming back where it was fairly quiet, and I decided to have some fun. I wanted to do an experiment where I could control the number of layers and range of image sizes, and then see how long they took to pull -- first using no strategy aside from "whatever the cloud is doing" and then trying different (more established) ones. I created a tool, the [container-crafter](https://github.com/converged-computing/container-crafter) in Go that would take a parameter study file, and then sploot out the set of builds, where every layer in each build was guaranteed to be unique. I chose a range of image sizes based on percentiles derived from parsing 77K Dockerfile from the scientific community, provided by the [Research Software Database](https://rseng.github.io/web). I wrote this into a full paper, and also did a huge analysis of the larger ecosystem, but I'll share a few of the fun plots that are specific to the pulling parts.

### Does number of layers matter?

I wasn't sure what I'd find here! It's definitely the case that if you try to use layers close to (or over) the registry limit of 10GB, you can get ImagePullBackoff and then retry. I made sure not to go over that limit (and didn't see any of these events in my data). But what did I see? I saw that number of layers doesn't seem to matter at all.

<div style="padding:20px">
<img src="https://github.com/converged-computing/container-chonks/blob/main/experiments/pulling/analysis/data/test/img/pull_times_test_duration_by_size_n1-standard-64.png?raw=true">
</div>

What does matter (in that plot) was the total size. The largest size there (19GB) took about 2 minutes to pull. The variation looks random. The other ones were so tiny they were insignificant, from a pulling standpoint. But I couldn't be absolutely sure that it never mattered, so I chose to stick with the median number of layers (9) and the max (which is actually 125, enforced by Docker).


<div style="padding:20px">
<img src="https://github.com/converged-computing/container-chonks/raw/main/experiments/pulling/analysis/data/run1/img/pull_times_test_duration_by_size_run1.png">
</div>

When I looked at that much larger range of sizes I started to see the curve that I expected. This (with added sizes along the slope) would be the set of sizes for my experiment.

### How does pull time scale with size?

Logically, the first thing we want to look at is how pull time varies with size. And we see what we expect - that time increases as the images get larger. It's hard to see with these plots (and often the plots aren't super great with showing the quartiles) but it does appear superficially that having fewer layers leads to a larger variance in the size. Here is for 125 layers:

<div style="padding:20px">
<img src="https://github.com/converged-computing/container-chonks/blob/main/experiments/pulling/analysis/data/run1/img/pull_times_duration_by_size_run1_125_layers.png?raw=true">
</div>

And 9 layers:

<div style="padding:20px">
<img src="https://github.com/converged-computing/container-chonks/blob/main/experiments/pulling/analysis/data/run1/img/pull_times_duration_by_size_run1_9_layers.png?raw=true">
</div>

Eyeballing the means, the 125 layers is maybe 10 seconds slower? Could that be the time needed for extraction? I didn't dwell on this, because the reality is that people are going to build images with the number of layers that they need, and not artificially try to put content into more. People are not building 125 layer images. Thus, moving on, I chose to use the median from the dataset, 9 layers.

### How does using a local registry influence pull time?

I've been told a few times that moving the containers to be "closer" to the cloud can make a difference. In this case, that would mean a registry hosted by the same cloud provider, and in the same region. Sure, worth a try! But guess what - it made no difference. 

<div style="padding:20px">
<img src="https://github.com/converged-computing/container-chonks/blob/main/experiments/pulling/analysis/data/run1/img/pull_times_duration_by_size_run1_125_layers.png?raw=true">
</div>

### How does using a local SSD influence pull time?

The filesystem has a huge impact in pulling. After all, you are writing and extracting, so having good IOPS must be a variable. And indeed it was! There is a quota for the quantity of SSD per instance family, so I could only go up to a size 64 cluster, but I did see pull times go down a bit.

<div style="padding:20px">
<img src="https://github.com/converged-computing/container-chonks/blob/main/experiments/pulling/analysis/data/run3/img/pull_times_duration_by_size_run3_9_layers.png?raw=true">
</div>

We can see that adding a local SSD improves pull times by 1.25x. This particular image is a log of the times, and you can see the full set of images in the [repository](https://github.com/converged-computing/container-chonks/tree/main/experiments/pulling). If you want a simple solution, this storage is pretty cheap so probably worth it. You will need to ask for more quota for larger clusters, however.


### Big daddy SOCI snapshotter!

I was first exposed to this idea of "image streaming" through a [flag provided by Google](https://cloud.google.com/blog/products/containers-kubernetes/introducing-container-image-streaming-in-gke) and I have to give it to Google, they continue to be a leader in usability. I had not yet learned about the requirements for (what I suspect under the hood) is the SOCI snapshotter (or more likely an optimized derivative), but they made it work with GKE and a flag, and I just needed my images in their artifact registry. I already had tagged and pushed them there. Dear lord, I was shook.

<div style="padding:20px">
<img src="https://github.com/converged-computing/container-chonks/blob/main/experiments/pulling/analysis/data/run4/img/pull_times_duration_by_size_run4_9_layers.png?raw=true">
</div>

I didn't even believe the data I was seeing. Containers that had taken minutes before were now pulling in around a second. Since I was very skeptical, I gave image streaming a challenge. I built spack images (meaning ONE huge layer with all application logic and dependencies) and I would [run an experiment](https://github.com/converged-computing/container-chonks/blob/main/experiments/pulling/run-streaming-experiment.py) that would require running the applications and seeing the output. With these applications (albeit smaller containers, but with one main layer) I still saw a 15x improvement in pull times. To be more specific, this is the event recorded by the Kubelet, and it's the time when you see the container go from creating to running. I used [this event exporter](https://github.com/resmoio/kubernetes-event-exporter) to collect my data.f

<div style="padding:20px">
<img src="https://github.com/converged-computing/container-chonks/blob/main/experiments/pulling/analysis/data/streaming/img/pull_times_duration_by_nodes.png?raw=true">
</div>

The above is running LAMMPS, amg2023, the OSU Benchmark All Reduce, and Minife. And yes, [all of the output is present](https://github.com/converged-computing/container-chonks/tree/main/experiments/pulling/metadata/streaming). These experiments (unlike the first pulling experiments that used a Job) use the [Flux Operator](https://github.com/flux-framework/flux-operator). After observing this (on Google Cloud) I had to dig in and at least guess what was going on under the hood. This is when I found SOCI.

## The SOCI Snapshotter

The SOCI "Seekable OCI" Snapshotter is (I think) a beautiful design that combines the work of the reference types working group in OCI (I participated in a few years ago) and an ability to index a compressed archive. I think it started as a fork off of [the stargz snapshotter](https://github.com/containerd/stargz-snapshotter), which is a great (similar) tool that requires an [eStargz format](https://github.com/containerd/stargz-snapshotter/blob/main/docs/estargz.md) (also pushed to a registry). But here is the insight that maybe stargz missed. People largely don't want to do too much extra work. Using stargz, as I understand it, requires another build step. From the [project README](https://github.com/awslabs/soci-snapshotter?tab=readme-ov-file#project-origin) it sounds like AWS did a fork (that they kept) after substantial changes that likely would have been hard to accept upstream. This isn't new news -- it was done a [few years ago](https://aws.amazon.com/about-aws/whats-new/2022/09/introducing-seekable-oci-lazy-loading-container-images/) and it's mostly been that I'm (relatively speaking) a newer developer (end of 2022) when it comes to Kubernetes that I didn't try it until now. Side note - why haven't you made us an easy to deploy flag still, AWS?  The insight that was found in a [paper from 2016](https://www.usenix.org/conference/fast16/technical-sessions/presentation/harter) is that:

> Waiting for all of the data is wasteful in cases when only a small amount of data is needed for startup. Prior research has shown that the container image downloads account for 76% of container startup time, but on average only 6.4% of the data is needed for the container to start doing useful work. 

I think it's funny that industry isn't super paper focused, but somehow I've seen this paper referenced in a gazillion places to justify this (and similar) work. And thus it makes sense that while you are waiting for the rest of the container to pull, you might as well make progress with running things! Especially when GPUs are involved, these cloud clusters get expensive very fast. Waited for too many containers? There goes your retirement! Just kidding. But maybe not, depending on how big of a mistake it is... I digress! 

Without going into details, containerd runs on all the kubelet nodes to handle pulling of containers. SOCI itself is a [containerd plugin](https://github.com/containerd/containerd/blob/main/docs/PLUGINS.md#proxy-plugins) called a snapshotter, which means that it handles creating a directory to unpack layers for an image. There is a [really nice article](https://dev.to/napicella/what-is-a-containerd-snapshotters-3eo2) I found that illustrates this. So when you use SOCI, you create an artifact called a SOCI index that has your expected manifest, and then a set of "zTOCs" that are akin to a table of contents for the index manifest. Concretely speaking, this would be like saying "The binary is located at XX offset in the archive, and has this span (size)." There is a nice [glossary of terms](https://github.com/awslabs/soci-snapshotter/blob/main/docs/glossary.md) if you want more details. Now, it won't create these indices for ALL layers - just ones above a [certain size](https://github.com/awslabs/soci-snapshotter/blob/212fe220f061413eb9f1a86556057128b25f4cab/soci/soci_index.go#L61) (10MiB).

My (naive) understanding for these remote shapshotters is that instead of extracting all layers to a directory and then allowing start of the image, they mount (and lazily fetch) the image contents instead. This is why we need to have fuse fs installed, and we need the ztoc as associated artifacts to the image available via the referrers API! A socket path is added to the containerd config, and containerd uses that socket (along with the index for the archive manifests) to fetch additional content from a registry on demand. Here is a much more nicely articulated summary:

> One approach for addressing this is to eliminate the need to download the entire image before launching the container, and to instead lazily load data on demand, and also prefetch data in the background.

I am only a few days into learning about SOCI and need to do my [codebase reading](https://github.com/awslabs/soci-snapshotter/tree/main) to get a better understanding, so that's the explanation I can give for now. I'm also interested in cases for which this works really well, and cases for which is does not. For example, what about shared libraries? I'll need to do more experiments to see when SOCI isn't as good, or even when it breaks. My mind is also already spinning in happy loops discovering that these plugins exist, period, and dreaming up what I might create.

## A daemonset

I'll briefly review my strategy for creating the daemonset. I knew that I wanted to start with nsenter to process 1, which is on init, and that would also mean I'd leave the pod and be present on the node, which is where the kubelet and associated tooling is installed. If you look in my [daemonset](https://github.com/converged-computing/soci-installer/blob/main/daemonset-installer.yaml) you'll also see there is a shared mount with the host, and that is there so I can copy files from the pod container onto the host. The main [entrypoint](https://github.com/converged-computing/soci-installer/blob/main/docker/entrypoint.sh) for that pod is primarily interested in doing that copy, and running the script to install SOCI with nsenter.  The main [install script](https://github.com/converged-computing/soci-installer/blob/main/docker/install-soci.sh) can then install dependencies (toml for parsing the config.toml in Python, the aws credential helper, SOCI itself, and fuse). I have [one script](https://github.com/converged-computing/soci-installer/blob/main/docker/write_config.py) to edit the containerd configuration file (to configure SOCI as a proxy plugin) and then (importantly) I authenticate with the registry that is serving the node pause image. This was a bit of a catch-22, because we needed to restart containerd, but in doing so, we would kill our pod. Then if we wanted to pull the pause image, we couldn't because we didn't have the pause image! You can see that [AWS lists it as a limitation here](https://github.com/awslabs/soci-snapshotter/blob/212fe220f061413eb9f1a86556057128b25f4cab/docs/kubernetes.md#limitations). Maybe my approach is dumb, but I decided to just pull it? I retrieve the URI for the pause container (and region and registry) from the containerd configuration, authenticate with nerdctl, and then allow the script to exit with a non-zero code and restart, and on restart I pull it with nerdctl.

```bash
sudo /usr/local/bin/nerdctl pull --snapshotter soci ${sandbox_image}
```

It felt like a dumb approach, but it worked! The example provided by AWS goes from taking 71 seconds to pull down to 7, which is a ~10x improvement. That's pretty good. 😊

## Summary

That's all I have for today - I already took a bike ride but I want to go outside again soon. Some caveats! I made this in a morning. It could hugely be improved, and I welcome you to open issues for discussion or pull requests. The daemonset is currently oriented for Amazon EKS (GKE has a flag that works out of the box, and I'm not sure about Azure, I don't have an account with credits there now), and I haven't tested "all the authentication ways" but they seem fairly straight forward if someone wants to contribute or make a request. Also note that I already see design details that I would change, but I'm content for now. I also have not tested this at any kind of scale, mostly because we need to ask AWS permission to use credits, and I only had blessing for this small development.

And that's all folks! 🥕 I'll very much be doing more exploration of this space in the future, and all of the above somehow materialized in a 9 page paper. I feel like I'm pretending to be an academic sometimes because I'm much more suited to building things, and that is how I want to have impact. But I figure while I sit where I sit, I can just rock both. 😎
