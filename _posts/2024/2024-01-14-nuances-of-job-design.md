---
title: "Nuances of Job Design: Testing with Kueue"
date: 2024-01-14 10:00:00
---

This weekend I delved into (what I thought might be) a very simple project. For some context, the week earlier (this last week) was completely lovely - I was doing my first [exploration into understanding](https://docs.google.com/document/d/18FwTJdOgWu7ksGAoSApW08BReg8TvWr7viNiwgJGRfU/edit?usp=sharing) of a queueing system for Kubernetes, "Kueue," and was spending many hours working on our custom scheduler, Fluence, and in my happiest of states - thrown into something complex that I totally didn't understand and mostly not getting things to work as I wanted. Actually, there was an insightful thought I had falling asleep the other night:

> Solving hard problems is about being wrong about them, 1000 times, until you’ve learned enough that you are not.

And I truly believe that. If you can find a way to find joy in the process, the learning comes. For me I find meaning and purpose through this work, as if my [brain is sticky](https://en.wikipedia.org/wiki/Nominal_rigidity) for complexity of specific kinds of problems, and (despite getting older) that doesn't seem to be changing. Along with this learning I was lucky enough to have a few hackathons with my team (these are so fun, and consistently fill me with joy) and finished the week almost at a point where I could prototype a working custom scheduler in a more scaled environment. I decided this would be a goal for my long weekend, of course with little actual consequences if I wasn't successful (that's another good piece of advice - always set low expectations for yourself and consistently be content with the outcome). I don't know if I should say this, but I also set low expectations for others, and then am not disappointed, but take notice when they strive for excellence.

Why did I want to do this at all? The first goal I had was to reproduce a modified variant of some early work my [team had done](https://ieeexplore.ieee.org/abstract/document/10029991/) for CANOPIE 2022. In summary, I wanted to test a custom scheduler against the Kubernetes default scheduler, and run with jobs of varying sizes (each a [Flux Operator](https://github.com/flux-framework/flux-operator) MiniCluster running LAMMPS) that would be over 1200 pods for jobs of varying sizes. I would submit them in-masse to challenge the scheduler. While I won't go into the details of this work (I suspect it will be more of an actual investigation to be written up) I learned an immense amount that I want to share here today.

## The Things I was Wrong About

When I first started working on this, I had reduced the problem to something too simple - one of sorting. In particular "queueSort" is [one of the types of plugins](https://kubernetes.io/docs/reference/scheduling/config/#extension-points) and is implemented via a "Less" function where two Pods are provided, and then your plugin decides (based on however you please) how to sort them. For our custom scheduler, it was immensely important that we had groups of pods intending to be run together (e.g., an [Indexed Job](https://kubernetes.io/blog/2021/04/19/introducing-indexed-jobs/) scheduled together), because if that didn't happen, the entire job wouldn't run. That basically meant they needed to be sorted alongside one another, and then the scheduler would ensure they run as a group. That's it, right? Right?

### PodGroup 

The first of our troubles was the fact that [PodGroup](https://github.com/kubernetes-sigs/scheduler-plugins/blob/d9c3dcc709abaa45075db9de0e3ecf5afb1e4c3e/apis/scheduling/v1alpha1/types.go#L119-L133) (I was told) is stale. It wasn't good usability to have to create one, and it was likely to go away. I was worried about this, and I also didn't like the fact that it wasn't a part of the default scheduler, added extra need for the user to create it, and might go away. So my first goal was to try and get rid of it. I spent a few days with various strategies to represent it internally. The high level goal was to have some timestamp that would exist exactly when the group was created, and serve as a sorting root for the group. Two pods coming in from different groups would be sorted appropriately based on comparing their group creation timestamps. The PodGroup custom resource definition (CRD) provided this nicely because it was another object in the cluster with a creation time that (likely) matched the group (given they were created from within the same applied YAML file) and would persist alongside the scheduler. 

My first attempt to have the scheduler create the PodGroup did not work for two reasons. First, it would be problematic to have a different owner, or minimally (at least I think) the owner should be the same entity that created the group in question. Secondly, it was really hard to get the actual point of inception. I first very naively, in the sort function, did a listing of pods and found the earliest created one. But that doesn't work for pods in groups for which they are created in batches, and some clean up before others. I thought I had this entirely working until I (very confusingly) was testing with indexed jobs, and always saw very similar timestamps. It was because the earliest pods were completing and I was always getting just the latest ones (which happened to be more close in time given existing at the same time). Thus, this approach wouldn't work because the listing won't hold the timestamp of when the job was created. This was when I said "Why can't I just be scheduling jobs (or other high level abstractions)!" Indeed that would provide a single timestamp for the group of pods. Could we get that instead? Sure, and likely this is what other tools do (ahem, Kueue)! However, a scheduler needs to be concerned with the smallest unit, and that is a Pod. And since we get the timestamp of the pods that are still existing, the "list what is running now" approach wouldn't work. A job created much earlier would have a timestamp for much later, and your sorting would be off.

I next decided to try saving state alongside the custom scheduler. I know this is likely bad practice (the state is supposed to be in the cluster objects) but I've seen other operators do it, so I thought it was worth a go. I created a more complex struct that would mimic the PodGroup, including a size, name, and a few other attributes. I could then (at the earliest point I could find) look at pod labels to identify a group name and size, and create one of these cached objects. When I found a new pod I could look up the cached object, and update the timestamp to earlier if this pod happened to be created earlier. I ran into several problems here. The first was that the "Sort" function is definitely not near the point of submitting a request to the Kubernetes API. Before it comes a box that has gating, and I considered hackily using one of those functions, but decided against it. Aside from being bad practice to use something for something else, it required enabling a feature gate and I decided that was one thing too many to use a scheduler. 

This is where [reading about Kueue](https://docs.google.com/document/d/18FwTJdOgWu7ksGAoSApW08BReg8TvWr7viNiwgJGRfU/edit?usp=sharing) really clicked for me. In Kueue, the suspend feature of a job (telling jobs to not schedule yet) is set to true via an admission webhook, and then the Job can be wrapped in Kueue's "Workload" CRD, and handed off to a queue, to be given to the "scheduler" (a controller running in the Kueue operator namespace) to pop off of a head when it is selecting jobs to run. This design I found so clever because I could imagine someone being in the same headspace as me right at that moment - "I need to control scheduling, but way before the earliest handle that is given to me... how about with a webhook right after the user submits to the Kubernetes API?" Complete brilliance. My hat is off to you, Kueue developers!

The first issue with this last design was the observation that, for smaller jobs, for some reason I never saw them show up in [sort](https://kubernetes.io/docs/concepts/scheduling-eviction/scheduling-framework/#queue-sort) (Less). It could have been a bug that I introduced, but I spent quite a bit of time wondering why they weren't assigned a pod group, and then I realized it's because the function to ensure the group was created was in Sort, and I never saw it being called for the smallest sizes. I never figured that one out (I posted in the Kubernetes scheduling slack) but instead I added another check for the group in [PreFilter](https://kubernetes.io/docs/concepts/scheduling-eviction/scheduling-framework/#pre-filter), much later, but better than never. After that, in retrospect I can say that I think everything was actually working. But at the time, I noticed what I thought was an off by one error - a large job would be scheduled, and then all but one pod would be Running (and the last one Pending). I wound up abandoning much of that design (and a few days work) thinking it was totally flawed, and sticking to the original PodGroup object that I didn't love. In retrospect I think it was actually something else. Let's dig into that a big.

### Job Equality

Up to this point, I had a very simple view of Jobs and scheduling them. They had a particular size, needed a specific set of resources, and then as long as they were sorted correctly the scheduler would handle the rest. Right? Probably not. I think I'm really wrong about this, and in fact the design of your jobs is immensely important. Let me explain some of the things that happened and I noticed. To continue our story, I jumped into running experiments today (err, yesterday, Saturday) with this prototype scheduler. While it had worked for my test cases, I was really surprised (and disappointed in myself) to see these "one off" errors happening in my larger scaled studies. But it wasn't just that, they were happening with the default scheduler too, and for varying numbers of pods. What the heck? 

I am going to call this phenomena "clogging." It results when you have a very strict requirement for a job size, and you are missing escape routes. For example, it should be the case that a MiniCluster could be flexible to start at a slightly smaller size than what it is given. I don't know what is going on with the underlying scheduler, but if pods are scheduled in batches, and let's say with my extremely spammy submission of jobs via Multiprocessing workers we actually do have job groups with the same creation timestamp, this would lead to interleaving. The interleaving would mean that pods might start not ordered entirely by their group. Now, I also think there might be a bug somewhere with the resources that I'm requesting for the pods vs. what is seen for the node, because you could imagine with a mismatch the scheduler would see room to schedule, but the pod would not be able to. A simple example is an affinity rule, which might require 1 pod per node, and this not being considered by the scheduler. The scheduler would be very happy to allocate two pods per node, get that back in the allocation result (basically an assignment of pods to nodes) but then in practice run out of options, leaving the job hanging with some number of pods Pending. Clogging might happen in any case when we think we can schedule something, and then allow more than one job group through, and neither job can complete its set.

While there is a <strong>ton</strong> of thinking and debugging to do for the above, for now I want to approach the problem from the other side, and take the opinion that perhaps I can't understand the cause of this behavior, but maybe I can find strategies to handle it? The strategy (so far) I've found that leads to less clogging (and sometimes none)! is to give wiggle room and flexibility. These are the practices I am finding helpful. I'd like to talk about some of these next.

#### Large Jobs can be Dangerous

> under particular conditions!

When I was running size 64 jobs on a size 149 cluster (side note, the GKE COMPACT limit is supposed to be 150 but in practice you are limited to 149 because of the requirement of some burst node, which I couldn't disable even when I set the flag to 0):

```console
ERROR: (gcloud.container.clusters.create) ResponseError: code=400, 
message=NodePool's initial node count combined with max surge is above allowed compact placement limit of 150 nodes.
```

With this setup of the job size being almost half the cluster size, clogging was almost certain. Funnily enough, it didn't happen all the time using our custom scheduler (so maybe it's doings something right) but it almost always happened with the default scheduler. In retrospect I don't blame the schedulers for this - this is some design flaw with the Flux Operator. It shouldn't be the case that large jobs are dangerous, because they should be flexible to having slight variation in size, for whatever reason. It should be the case that if a job doesn't start in some time, we know to clean it up and try again later. But for the time being, I'm going to say, assuming that you can have scheduling issues that lead to pending jobs in a job group:

> In the case of non-elastic jobs, a higher ratio of job size to node size is likely to lead to more clogging.

In practice, I found the ratio of about 10% (where a single job doesn't need more than 10% of cluster resources) to be a sweet spot. At least it avoided the clogging or locking cases that I observed before, and my experiments would run to completion. I suspect you could study this, but better to just allow your jobs to be flexible.

#### Elasticity is King

All of the above would be resolved if the jobs were allowed to be elastic. I did an on-the-fly feature for the Flux Operator to support a minimum size, meaning that the Flux quorum would be set to a number that is lower than the cluster size (and allowed to start) but I forget to adjust the number of tasks for the job, so in practice the quorum would be flagged as full but the job still not run missing resources. I'll need to think more about that, because I'd like it to be the case that I can wait some period of time, and then after the maximum wait time, get the exact number of tasks (and workers) that are available to use. That isn't supported. The high level thing I learned is that if our MiniCluster jobs had more flexibility to how they are starting, we could better use the (likely variable) resource set that we ultimately get, and this would help this clogging case above. If we could allow this smaller size in any scenario, the pod group size could also be set to it. However, we'd still have the leftover pending pods. You could either use a JobSet and have a [success policy](https://github.com/kubernetes-sigs/jobset/blob/c1b5a4b7f1dce9261d5b90ef5210d2504b191ee8/api/jobset/v1alpha2/jobset_types.go#L176) that says when the lead broker is done, everyone else is too, or you could have another strategy for cleaning up the dangling workers. One option would be to ensure they don't retry if they exit with an error code (and this would happen if they tried to bootstrap and failed. This is how the Flux Operator is designed -- we break from a loop on a successful exit, return code 0, and retry otherwise, which allows the pods to be flexible to a weird startup order). You could also just be watching for the lead broker to Complete, and delete the entire CRD after that. I was already doing the latter of those two, which leads me to my next point.

#### Clean up as you go

I was at first launching many multi-processing jobs, waiting for the result, and then cleaning up the MiniCluster (an Indexed Job, config maps, and service) at the end. While this works find for small test cases, if we have any clogging, this could mean a bunch of dangling pods hanging around taking up valuable node resources. I adjusted my experiments to delete the MiniClusters right when they were finished running, and this also seemed to improve the clogging.

#### Another way out

I realized that there was another option for large job sizes that required all workers (where something could potentially go wrong) - a simple timeout! A lot of these jobs would be waiting around for 5 to 10 minutes. Actually, Flux (and the Flux Operator) already expose a timeout. We could basically set it, allow the job to fail and the pods to clean up, and then recreate the job to run again.
It's a dumb approach (maybe)? but I think that's a common design in cloud things. You expect a lot of failures, and your goal is resiliency. Make more replicas! Restart! Wash, rinse, and repeat! But overall, I am still of the mindset it would be better to get rid of the hard requirement and allow the jobs to be flexible in size.

#### Can Kueue solve our problems?

I brought both schedulers over to Kueue, thinking that perhaps it could add in some magic to ensure that the ordering (or something else was just right), and while I liked seeing my queues (job admitted, yay!) I reproduced the same errors. So Kueue wouldn't help me here, although I am planning to do more experimenting with it in the future.

## Summary

In summary, this exercise has taught me about the importance of not just scheduling something, but of job design. I think that elastic jobs (e.g., think of being able to add or remove a worker on the fly and keep going, and setting some minimum size for scheduling only to the smallest number of workers required) are really important. If you can't do that, timeouts or other fallbacks for detecting and handling a clogged queue are important. When I step back and think about it, everything we've run with the Flux Operator has been in serial. We create a cluster of a specific size, and then run jobs one at a time, cleaning up as we go. It doesn't mimic anything like a real use case, and if we are to be successful in our designs, we need to account for these too. I'm somewhat convinced now that the errors I've run into this week were less about the scheduler, and more about the rigidity of the Flux Operator design, but that's good because it's something I can work on. 

As a side note, if you want to test the Flux Operator, our [version 2](https://github.com/flux-framework/flux-operator/issues/211) branch is the way to go. I won't be working on the first version any longer, and the only reason we are waiting on merging is awaiting a response from a paper to submission to F1000 Research. They didn't think the Flux Operator deserved a software paper, and perhaps the mistake was including a small experiment result (the one I presented at Kubecon in early 2023). Publishing is annoying at times, but I'm really proud of this particular piece of software, the fact that we've collaborated on it across industry, and I hope this journal sees that too. I hope they also realize this absolutely belongs in a software paper. I will absolutely follow up with several redesigns, because that's how I tend to develop. I don't want to write three separate papers for that, the F1000 Research design that allows updating is perfect.

### The Things I am Happy About

As I write this, there is still much to figure out! I'm really enjoying learning about scheduling because it's in fact many different things, and immensely complex. The more I learn, the more I want to know, and the more I want to build and try out (often terrible) ideas. I was reflecting on this last week, and I really didn't mind doing a bunch of work that ultimately I scrapped (at least for now) because I learned so much. I had fun. I am happiest when I'm lost in these challenges, somewhere in my head just putting together all the pieces. And I'm really happy that we are just at the very beginning. I think my biggest challenge, at least being at a national lab, will be finding the means to hold onto this thread of work that I've come to love. It's not just the work, it's also the people. I've said this before, but I'm inspired and (even with a small team) feel supported and that we are working toward a common vision. I've wanted that for so long.

Anyway, there is so much joy in this process, if it isn't obvious. Here I am, it's actually 3:30am in the morning, and I'm absolutely terrible because I just want to write and run experiments. But I'm also exhausted and really should be off to bed. I think I'll sleep a lot tomorrow, finish up this post, and then look at some of the data from the experiments that are finishing right now (update from the next day, I did indeed sleep until after noon, and it was glorious)! If you ever need someone to sleep like a dead person, I'm your dead person :).

Where do we find meaning? For me, it's in the quiet of the evening when I am absorbed in understanding something, or immersed in code with music flowing into my ears down into my fingers and into streaming output on the screen, or on a run when I feel like I can fly, or even in a virtual call with my team where just for a tiny parcel of time, I am with a group of people that care about the things that I do, and we are trying to understand something together.