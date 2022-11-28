---
title: "Singularity Hub Archive"
date: 2021-03-31 17:30:00
categories: [rse, hpc]
---

As of 5:00pm today, April 26th 2021, the Singularity Hub cloud space, including
storage of over 9TB of containers, a registry server and builders maintained by
me (and literally only me) since 2016, is shut off. Before you worry,
we've migrated all the existing containers (before the 19th of this month) to
an archive so they will continue to be pullable at their previous URLs, something 
I'll discuss briefly later in this post. For now, let's take a few moments
to appreciate the server previously known as Singularity Hub, now known as 
Singularity Hub archive.

## Too Long, Didn't Read

If you have hosted containers on Singularity Hub, you primarily should know that they
will continue to be pullable from the archive, however you won't be able to build
new containers. You should disable the previous webhook in your GitHub repositories,
an oversight I realized after I revoked all the GitHub tokens for the integration.
If you added a Singularity Hub Badge to your repository, I've also
generated a newly linked one that you can use as follows (see the gist for the
markdown):

<script src="https://gist.github.com/vsoch/a4035049e5a8076d33bf0ebaead0f05b.js"></script>

For the complete details and other options for building containers, you should
read <a href="https://singularityhub.github.io/singularityhub-docs/2021/going-read-only/" target="_blank">the initial news post</a>.
If you are feeling nostalgic, take a look at the <a href="https://singularityhub.github.io/singularityhub-docs/lastday/" target="_blank">last day gallery</a>
that I've prepared in Singularity Hub's honor. 
If you have an issue or question that you want to post for the new archive, you can do so 
<a href="https://github.com/con/shub/issues" target="_blank">here</a>.
This post will continue to give Singularity Hub one last honor before it becomes a
distant memory.

## Background

### A Need for Reproducible Science

You can read the background story <a href="https://singularityhub.github.io/singularityhub-docs/docs/introduction#a-need-for-reproducible-science" target="_blank">here</a>,
or watch an interactive version <a href="https://vsoch.github.io/containers-story/" target="_blank">here</a>.
I started using containers (Docker, specifically) as a naive graduate student in early 2015, quickly fell in love,
and decided it would be my mission to bring containers to our HPC cluster at Stanford. It felt immensely important for scientific reproducibility -
or being able to preserve an analysis pipeline by some means (containers are a good start) to run again
and reproduce it. I built the original version of Singularity Hub, wrote a paper

```
Sochat V, Prybol CJ, Kurtzer GM (2017)
Enhancing reproducibility in scientific computing: Metrics and registry for Singularity containers.
PLoS ONE 12(11): e0188511. https://doi.org/10.1371/journal.pone.0188511
Encapsulation of Environments with Containers¶
```

and charged forward as an advocate and developer for all things containers.
This lasted a few years, until containers "were definitely at thing"  and then I stepped back.
While discussion of the change in the Singularity community itself from 2016 until now is out
of scope for this post, I will say that despite the changes, I still care about supporting the Singularity user base and 
maintain several <a href="https://singularityhub.github.io" target="_blank">Singularity-associated projects</a>.

### What happens in the future?

At the time that I designed Singularity Hub the thought that I likely wouldn't be 
able to maintain it forever loomed in my awareness, but I had hope that the company that grew out
of Singularity would soon build a service to replace it. They technically did, but unfortunately the
free tier was not suitable for what scientific developers would need. And there certainly wasn't
a business model for (most) academics paying for a service, so ultimately I would keep Singularity Hub
online much longer than I originally anticipated. A year and then two grew into five years, and in
that time I did whatever it took to keep the server and builders running. This meant several
refactors, and pursuring funding for the service. While my group
could pay small amounts every now and then, the burden of costs was not reasonable, so I ultimately
went to Google early on and asked for help. I suspect people have different views about Google,
but before you express any negative sentiment remember that at large companies there are people, 
and I can solidly state that the people who I worked with showed infinite kindness and support for this tiny effort. I am forever grateful to
Google for supporting Singularity Hub for all these years -- without them it never would
have happened. Thank you Google!!

<div style="margin:20px; padding-top:20px">
<img src="https://raw.githubusercontent.com/singularityhub/singularityhub-docs/master/assets/img/lastday/1Screenshot_2021-04-25%20singularity-hub(1).png">
</div>

At the beginning of this year, my time at Stanford was coming to a close. I had finished what I
set out to do, and it was time for me to move on. At this point, I reached out to the community
for help. At best someone could take over the service, and at worst it would simply go away entirely,
including all containers. Thankfully the <a href="https://github.com/con/" target="_blank">Center for Open Neuroscience</a>
and more specifically, <a href="https://github.com/yarikoptic" target="_blank">Yarikoptic</a> took the reins.
We had a simple plan to migrate all the containers and metadata from storage, and then serve
the same containers at an archive at Dartmouth. All previously built public containers before
the 19th of April would still be available to pull, ensuring reproducibility of those
pipelines from all those years. You can in fact now navigate to 
<a href="https://singularity-hub.org" target="_blank">singularity-hub.org</a> to see the new home!
I tried many times to convince Yarik that I should send him ice cream, but I was not successful.

## Is Reproducibility possible?

I've <a href="https://vsoch.github.io/2017/reproducible-impossible/" target="_blank">written about this before</a>, but 
after maintaining a service and having pretty good knowledge about scientific workflows and software, I'm
not convinced that reproducibility is much more than a pipe dream. Yes, I agree that if you use
the right technologies, have great documentation, and try to ensure your data and code is preserved over
time, the chances that your original analysis will work in 5 years are pretty good. The problem is when 
we scale out beyond our lifetimes. Have you seen all those GitHub accounts that belong to people
that have died because of old age? Probably not, because GitHub has only been around since 2011.
But do you ever wonder what happens to your code, and your various services you use to support it,
when you are no longer around? The answer is that you need people to continue supporting it. 

> This is where I will say that sustainability is less about doing the right thing, and more about survival of the valued. 

Your code _will_ endure if it continues to be valued. Even if technologies change, if your
analysis pipeline or service adds significant value to the community, people will find a way to keep it up
to date and running. If you mysteriously go away and leave a hugely useful project unmaintained, someone
will fork it and keep it alive. Yes, it's very likely the case that the awareness and branding that you create around your code will
have an impact. For example, you can make the greatest software known to man, but nobody will care
if they don't know about it. But let's face it. If software or an analysis pipeline
does not add value to the world, even if you got a shiny paper out of it, why should there be effort
to keep it alive? I used to be a reproducibility stickler and want to save all-the-things, but
now I'm more of a reproducibility evolutionist that expects software to grow, change, and die, and
wants to support an ecosystem around that.

For these reasons, when I create something these days, I take a needs-based development approach. 
Sure - when a piece of software is new and I think it could be useful, I spend some time getting
the word out. But once the word is out and there are crickets on the GitHub issue board? It's probably
not useful, and I should focus my time on other things. The reality of being a developer is that 99%
of what I do is probably not really useful. I'm okay with that, because the 1% can have a huge impact.
This is why after something is solidly released in a pretty good state, I only continue to work on it if users open issues and ask me to. 

## Was Singularity Hub Valuable?

Putting on my reproducibility evolutionist hat, I'm going to say that Singularity Hub was valuable for
those first few years when there weren't many other options. Although it was special to me and used by a few thousand, 
I'm then going to say that the environment changed so that it wasn't absolutely essential.
There are many different kinds of registries, tricks for building and storing containers, and even
new container technologies for HPC that, over time, brought down the overall value.
This isn't to say that it's not important to maintain containers that were previously built. In a way
this is a promise I had hoped to keep, and I'm immensely grateful to be able to do that.

## A Future Registry?

I have a few ideas for how we could continue to serve GitHub built and deployed
containers from the shub unique resource identifier, but will hold off on sharing
until I've had some time to think it over, and test. I do think that, other than
the Sylabs library and Docker Hub (or more generally OCI registries) there should
be another simple option.

## One Last Look

Here is a quick glance at the final state of Singularity Hub.
Note that containers, unless they were frozen, would get over-written with a new
build (a user pushing to GitHub) and this is how I managed to keep the number down.
My original design did not do this, and grew much larger much more quickly.

```python
# A container is associated with a sif binary
> Container.objects.count()
7202

# A collection of containers
> Collection.objects.count()
3901

# An owner of a collection
> User.objects.count()
6530

# A builder associated with a container
> Build.objects.count()
8208

# I'm surprised people went out of their way to star collections!
Star.objects.count()
> 373

# This is the number of collections that had recorded pulls in the last year.
> APIRequestCount.objects.count()
2868
```

Finally, just for the records that I have for the last few months, I can
count the number of requests to pull containers across all of Singularity Hub.

```
total requests 695,493
```

That's pretty good! The oldest container, because of the first refactor in 2017,
is only from 2017.

```python
> Container.objects.order_by('build_date')[0]
<Container: alaindomissy/rnashapes:tag2>

datetime.datetime(2017, 10, 15, 18, 24, 56, 188137, tzinfo=<UTC>)
```

There were surprisingly a handful of demos (documentation, asciinema, or other
content related to a container build) despite the feature being disabled pretty
early on:

```python
> Demo.objects.count()
29
```

And very not surprisingly, many labels and apps associated with containers!

```python
> Label.objects.count()
 18326

> App.objects.count()
1189
```

It would be fun to do a weekend project and parse those over. Finally, we can
look at the all time leaders for API requests (I'll truncate at N=500).

```python
miguelcarcamov/container_docker: 140186
ikaneshiro/singularityhub: 87991
singularityhub/busybox: 49156
vsoch/singularity-images: 49036
GodloveD/busybox: 48454
vsoch/hello-world: 26195
GodloveD/lolcow: 19897
tikk3r/lofar-grid-hpccloud: 14454
bouthilx/repro-hub: 14080
singularityhub/centos: 13144
vsoch/singularity-hello-world: 9764
singularityhub/ubuntu: 8392
bouthilx/sgd-space-hub: 8001
marcc-hpc/tensorflow: 7786
dominik-handler/AP_singu: 7246
gem-pasteur/Integron_Finder: 5757
aardk/jupyter-casa: 4320
dynverse/ti_tscan: 3182
nuitrcs/fenics: 3169
truatpasteurdotfr/singularity-alpine: 3034
dynverse/ti_mpath: 3006
ravi-0841/singularity-tensorflow-1.14: 2867
pegasus-isi/montage-workflow-v2: 2745
marcc-hpc/pytorch: 2479
NBISweden/K9-WGS-Pipeline: 2441
staeglis/HPOlib2: 2051
datalad/datalad-container: 1994
nickjer/singularity-rstudio: 1939
dynverse/ti_projected_paga: 1885
dynverse/ti_ouijaflow: 1880
UMMS-Biocore/singularitysc: 1863
dynverse/ti_waterfall: 1858
dynverse/ti_angle: 1851
dynverse/ti_scorpius: 1844
dynverse/ti_comp1: 1838
onuryukselen/singularity: 1824
dynverse/ti_forks: 1816
dynverse/ti_projected_tscan: 1814
dynverse/ti_embeddr: 1814
dynverse/ti_periodpc: 1814
dynverse/ti_monocle_ica: 1813
dynverse/ti_wanderlust: 1809
dynverse/ti_phenopath: 1806
truatpasteurdotfr/singularity-docker-miniconda3: 1558
nickjer/singularity-r: 1553
FCP-INDI/C-PAC: 1532
ISU-HPC/mysql: 1469
dynverse/ti_slicer: 1426
dynverse/ti_elpilinear: 1411
adam2392/deeplearning_hubs: 1328
singularityhub/hello-world: 1307
dynverse/ti_wishbone: 1296
dynverse/ti_fateid: 1256
Characterisation-Virtual-Laboratory/CharacterisationVL-Software: 1249
dynverse/dynwrap: 1248
brucemoran/Singularity: 1233
DavidEWarrenPhD/afnipype: 1188
onuryukselen/initialrun: 1163
as1986/own-singularity: 1161
dynverse/ti_projected_monocle: 1107
bballew/NGS_singularity_recipes: 1072
ReproNim/containers: 1012
TomHarrop/singularity-containers: 1006
cokelaer/graphviz4all: 957
UMMS-Biocore/initialrun: 874
myyoda/ohbm2018-training: 864
chrarnold/Singularity_images: 805
bsiranosian/bens_1337_workflows: 782
justinblaber/synb0_25iso_app: 767
dynverse/ti_mfa: 751
pegasus-isi/fedora-montage: 669
alfpark/linpack: 641
cottersci/DIRT2_Workflows: 641
linzhi2013/MitoZ: 613
lar-airpact/bluesky-framework: 589
apeltzer/EAGER-GUI: 589
datalad/datalad-extensions: 586
maxemil/PhyloMagnet: 564
elimoss/lathe: 562
mwiens91/test-error-containers: 555
ISU-HPC/ros: 551
mwanakijiji/lbti_altair_fizeau: 533
willgpaik/centos7_aci: 519
jekriske/lolcow: 517
tyson-swetnam/osgeo-singularity: 517
ltalirz/singularity-recipe-zeopp: 512
```

There is a much longer list that has just about as many lines as collections,
but we'll leave it at that for now. Thank you to the community for your excitement
about Singularity, and using Singularity Hub! I can't make any promises, but maybe
keep on the lookout for other ideas and developments in the next few months.
I certainly hope to contribute more to the world of research software than this
small amount of early work.
