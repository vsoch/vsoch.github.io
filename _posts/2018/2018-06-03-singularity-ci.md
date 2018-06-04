---
title: "Building Singularity Containers on TravisCI"
date: 2018-06-03 6:46:00
toc: false
---

It's probably no surprise that you can build Singularity containers using 
<a href="https://en.wikipedia.org/wiki/Continuous_integration" target="_blank">continuous integration (CI).</a>
Actually, the main repository does testing with one service in particular, Travis CI, and
you can always see the testing going on <a href="https://travis-ci.org/singularityware/singularity/builds" target="_blank">here</a>. While Travis (and continuous integration generally) is used for testing,
a new focus has been on the idea of deployment, or basically:

> build (and test) my container and push it somewhere for me to use!

In an effort to always empower you, the user, to build, understand, and generally work with your containers, I am
always thinking of creative ways to put together open source tools and services to do cool things. Building, and
building with webhooks from Github, was always obvious (hint, this is how Singularity Hub works!) but when I 
first thought of this idea almost two years ago, it wasn't 
clear to me how the user could easily do it without the storage infrastructure. This is actually why I abandoned 
continuous integration services and just developed Singularity Hub around Github webhooks and handling the storage for you.
But arguably, this is a reasonable thing:

```bash
[container recipe in Github] --> [commit and push] --> [build on CI] --> [push to storage]
```

It was also challenging because every user and center has their own cloud provider of choice. That last step 
"push to storage" couldn't easily be one thing, and further, someone had to pay for it.

> there is no free dinosaur lunch!

Two years later, there is still no dinosaur lunch (and this is why the robots work so hard to maintain <a href="https://singularity-hub.org" target="_blank">Singularity Hub</a> for you!), but now that we have the 
<a href="https://singularityhub.github.io/sregistry-cli/clients">Singularity Global Client (sregistry)</a> 
clients, you can _easily_ build a container and then upload it to your endpoint of choice, just as you would on your local machine! This was a lot of programming that I hadn't done a few years ago. Derp-a-derp, when I realized that all the tools already existed to do this and I had to shove them together like halves of a peanut butter and jelly container, I was very happy :)

**TLDR** this isn't any new information, it's a (finally) <a href="https://www.github.com/singularityhub/singularity-ci" target="_blank">finished example</a> that shows 
<a href="https://travis-ci.org/singularityhub/singularity-ci/builds" target='_blank'>builds on Travis</a> to get you started to do this with your own Github repos. Fork the repo and look at the files to jump in, or keep reading to get step by step instructions. 

# Singularity-CI

[![Build Status](https://travis-ci.org/singularityhub/singularity-ci.svg?branch=master)](https://travis-ci.org/singularityhub/singularity-ci)

This is a simple example of how you can use Continuous Integration (Travis) to build your images! The cool part is that you have complete power to configure the build, and then to push to your storage endpoint of choice. When you are setting up a Singularity CI repo, you will generally do the following:

<ol class="custom-counter">
  <li>Fork and customize the <a href="https://www.github.com/singularityhub/singularity-ci">singularityhub/singularity-ci</a> repo</li>
  <li>Connect the repo to Travis-Ci</li>
  <li>If desired, add a command to push to a client, and define environment variables for your credentials</li>
</ol>

The remainder of this post will walk through using the Singularity CI repository. The details below are also written in the <a href="https://github.com/singularityhub/singularity-ci/blob/master/README.md" target="_blank">README.md</a> of the repo. Enjoy! Please reach out if you need help, have questions, or just want to try something weird and fun and want a dinosaur friend to collaborate with :)

## Getting Started

### 1. Fork this repository

You can clone and tweak, but it's easiest likely to get started with our example files and edit them as you need.

### 2. Get to Know Travis

We will be working with <a href="https://www.travis-ci.org" target="_blank">Travis CI</a>. You can see example builds for this <a href="https://travis-ci.org/singularityhub/singularity-ci/builds" target="_blank">repository here</a>.

 - Travis offers <a href="https://docs.travis-ci.com/user/cron-jobs/" target="_blank">cron jobs</a> so you could schedule builds at some frequency.
 - Travis also offers <a href="https://circleci.com/docs/2.0/gpu/" target="_blank">GPU Builders</a> if you want/need that sort of thing.
 - If you don't want to use the <a href="https://singularityhub.github.io/sregistry-cli" target="_blank">sregistry</a>
 to push to Google Storage, Drive, Globus, Dropbox, or your personal Singularity Registry, travis will upload your artifacts directly to your <a href="https://docs.travis-ci.com/user/uploading-artifacts/" target="_blank">Amazon S3 bucket</a>
 along with a <a href="https://docs.travis-ci.com/user/deployment" target="_blank">crapton</a> of other deployment methods.
 
### 3. Add your Recipe(s)

For the example here, we have a single recipe named "Singularity" that is provided as an input argument to the [build
script](build.sh). You could add another recipe, and then of course call the build to happen more than once. The build script will name the image based on the recipe, and you of course can change this up.

### 4. Configure Singularity

The basic steps to <a href="https://github.com/singularityhub/singularity-ci/blob/master/setup.sh" target="_blank">setup</a> the build are the following:

 - Install Singularity from master branch. You could of course change the lines in [setup.sh](setup.sh) to use a specific tagged release, an older version, or development version.
 - Install the sregistry client, if needed. The  <a href="https://singularityhub.github.io/sregistry-cli" target="_blank">sregistry client</a> allows you to issue a command like "sregistry push ..." to upload a finished image to one of your cloud / storage endpoints. By default, this won't happen, and you will just build an image using the CI.

### 5. Configure the Build

The basic steps for the <a href="https://github.com/singularityhub/singularity-ci/blob/master/build.sh" target="_blank">build.sh</a>  are the following:

**Recipe**

Running build.sh with no inputs will default to a recipe called "Singularity" in the base of the repository. You can provide an argument to point to a different recipe path, always relative to the base of your repository.

**Unique Resource Identifier**

If you want to define a particular unique resource identifier for a finished container (to be uploaded to your storage endpoint) you can do that with `--uri collection/container`. If you don't define one, a robot name will be generated.

**Client**

If you add "--cli" then this is telling the build script that you have defined the <a href="https://docs.travis-ci.com/user/environment-variables/#Defining-Variables-in-Repository-Settings">needed environment variables</a> for your <a href="https://singularityhub.github.io/sregistry-cli/clients" target="_blank">client of choice</a> and you want successful builds to be pushed to your storage endpoint. Valid clients include:

<ol class="custom-counter">
  <li>google-storage</li>
  <li>google-drive</li>
  <li>dropbox</li>
  <li>globus</li>
  <li>sregistry (Singularity Registry Server)</li>
</ol>

See the <a href="https://github.com/singularityhub/singularity-ci/blob/master/.travis.yml" target="_blank">.travis.yml</a> for examples of this build.sh command (commented out). If there is some cloud service that you'd like that is not provided, please 
<a href="https://www.github.com/singularityhub/sregistry-cli/issues" target="_blank">open an issue</a>.

### 6. Connect to CI

If you go to your <a href="https://travis-ci.org/profile" target="_blank">Travis Profile</a> you can usually select a Github organization (or user) and then the repository, and then click the toggle button to activate it to build on commit --> push.

That's it for the basic setup! At this point, you will have a continuous integration service that will build your container from a recipe each time that you push. The next step is figuring out where you want to put the finished image(s), and we will walk through this in more detail.

## Storage!

Once the image is built, where can you put it? An easy answer is to use the  <a href="https://singularityhub.github.io/sregistry-cli" target="_blank">Singularity Global Client</a> and choose <a href="https://singularityhub.github.io/sregistry-cli/clients" target="_blank">one of the many clients</a> to add a final step to push the image. This comes down to the following. The first step is already done for you in the example, so you just need to do `2.` and `3.`


<ol class="custom-counter">
  <li>installing `sregistry` to the builder with pip</li>
  <li>Saving the credentials that your client needs to your <a href="https://docs.travis-ci.com/user/environment-variables/#Defining-Variables-in-Repository-Settings">CI settings</a></li>
  <li>adding a line to your .travis.yml to do an sregistry push action to the endpoint of choice.</li>
</ol>

For the last point, we have provided some (commented out) examples to get you started. 

## Travis Provided Uploads

You don't even need to use sregistry to upload a container (or an artifact / result produced from running one via a cron job maybe?) to an endpoint of choice! There are a [crapton](https://docs.travis-ci.com/user/deployment) of places you can deploy to. If you can think of it, it's on this list. Here are a sampling of some that I've tried (and generally like):

**Surge.sh**

[Surge.sh](https://docs.travis-ci.com/user/deployment/surge/) gives you a little web address for free to upload content. This means that if your container runs an analysis and generates a web report, you can push it here. Each time you run it, you can push again and update your webby thing. Cool! Here is an [old example](http://containers-ftw.surge.sh/) of how I did this - the table you see was produced by a container and then the generated report uploaded to surge.

**Amazon S3**

[Amazon S3](https://docs.travis-ci.com/user/deployment/s3/) bread and butter of object storage. sregistry doesn't have a client for it (bad dinosaur!) so I'll direct you to Travis to help :)

**Github Pages**

[Github Pages](https://docs.travis-ci.com/user/deployment/pages/) I want to point you to github pages in the case that your container has documentation that should be pushed when built afresh.

## Advanced

Guess what, this setup is totally changeable by you, it's your build! This means you can do any of the following "advanced" options:

**Cron Jobs**

This setup can work as an analysis node as well! Try setting up a [cron job](https://docs.travis-ci.com/user/cron-jobs/) to build a container that processes some information feed, and you have a regularly scheduled task.

**GPU Builders**

try out one of the [GPU builders](https://circleci.com/docs/2.0/gpu/)

**Resource Optimization**

run builds in parallel and test different building environments. You could try building the "same" container across different machine types and see if you really do get the same thing :)

**Additional Testing**

You can also do other sanity checks like testing if the container runs as you would expect, etc.

## Contributing

I learn best from examples, and I suspect that others do too. If you have an example continuous integration recipe that you find interesting or useful, please <a href="https://www.github.com/singularityhub/singularity-ci/issues" target="_blank"> share it with me</a> so we can add it as an example to this repository, write about it for others to see, or some other idea that you have! The Container Tools robots have some other ideas up their sleeves for how this can be creatively used, so stay tuned!
