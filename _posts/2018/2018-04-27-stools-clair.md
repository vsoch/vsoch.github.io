---
title: "Continuous Vulnerability Testing"
date: 2018-04-27 6:00:00
toc: false
---

I've been putting off for some time working on an integration that will combine
Singularity with vulnerability scanning, specifically 
<a href="https://github.com/singularityhub/sregistry/issues/14" target="_blank"> discussed for Singularity Registry Server </a>) where <a href="https://github.com/dctrud" target="_blank">one of my colleagues</a> 
that I've enjoyed working with immensely in the past (and have a lot of respect for!) got us started,
and the issue got side-tracked with adding a general plugin framework to the registry. This particular Clair 
integration *for the registry* isn't ready yet (the <a href="https://github.com/singularityhub/sregistry/pull/113" target="_blank">Globus integration</a> Pull Request in in the queue first, needing review!) but in the meantime I created
a small docker-compose application, <a href="https://github.com/singularityhub/stools" target="_blank">stools</a> or "Singularity Tools" and an example usage with 
<a href="https://travis-ci.org" target="_blank">Travis CI</a> to bring *true* continuous vulnerability scanning for a
container recipe in Github *or* a container served by Docker Hub or Singularity Hub! In this post I'll walk through
how to set this up.

## Too long didn't read

<ol class="custom-counter">
  <li><a href="https://github.com/singularityhub/stools" target="_blank">stools</a> builds a Docker container that can run ClairOS checks for a Singularity container</li>
  <li>With Travis you can perform vulnerability scanning on every push, or at a scheduled interval</li>
  <li>The checks can be for one or more recipes, or containers already existing on Docker or Singularity Hub</li>
</ol>
<br>

Awesome! Here it is in action. I recorded this after not sleeping an entire night, so apologies for my sleepy dinosaur typing:

<script src="https://asciinema.org/a/178712.js" id="asciicast-178712" async></script>

If you want to skip the prose, 

<ol class="custom-counter">
<li>go straight to the <a href="https://github.com/singularityhub/stools-clair" target="_blank">example Travis code</a></li>
<li>contribute to the development of stools at <a href="https://github.com/singularityhub/stools" target="_blank">singularityhub/stools</a></li>
<li>or see the example testing <a href="https://travis-ci.org/singularityhub/stools-clair" target="_blank">on Travis</a></li>
</ol>
More information is provided below.


# Singularity Tools for Continuous Integration
["stools"](https://www.github.com/singularityhub/stools) means "Singularity Tools for Continuous Integration." It's a tongue-in-cheek name, because I'm well aware of what it sounds like, and in fact we would **hope** that tools like this can help you to clear that stuff out from your containers :). 

<div style="padding-top:10px; padding-bottom:20px">
   <img src="/assets/images/posts/stools-clair/stools.gif" width="50%" style="margin:auto; display:block">
</div>


## How does it work?
Singularity doesn't do much here, we simply export a container to a `.tar.gz` and then present it as a layer to be analyzed by <a href="https://github.com/coreos/clair" target="_blank">Clair OS</a>. 
We use <a href="https://github.com/arminc/clair-local-scan" target="_blank">arminc/clair-local-scan</a> 
base that will grab a daily update of security vulnerabilities. The container used in the `.travis.yml` should actually be updated with the most recent vulnerabilities. How? @arminc has set up his continuous integration to be triggered by a cron job, so that it happens on a regular basis. This means that his CI setup triggers a build on Docker Hub, and my Docker Hub repository is also configured to trigger at this same time! Specifically, <a href="https://github.com/singularityhub/stools/blob/master/Dockerfile" target="_blank">my repository</a> 
builds a container that uses the `clair-local-scan` as a base, installs production Singularity, and then the package served in the repo called <a href="https://pypi.org/project/stools/" target="_blank">stools</a>. How does the updating work without me needing to do much? I found a section in settings called "Build Triggers" and was able to add the 
<a href="https://hub.docker.com/r/arminc/clair-local-scan/" target="_blank">arminc/clair-local-scan</a> Docker Hub repository:

<div style="padding-top:10px; padding-bottom:20px">
   <img src="/assets/images/posts/stools-clair/links.png" style="margin:auto; display:block">
</div>

Which means his hard work to rebuild the `clair-local-scan` with updated vulnerabilities will also build an updated `vanessa/stools-clair`, which is then pulled via the docker-compose when your continuous integration runs. Again, very cool! This is like, Matrix level continuous integration!

## Instructions

<ol class="custom-counter">
<li>Add the <a href="https://github.com/singularityhub/stools-clair/blob/master/.travis.yml" target="_blank">.travis.yml</a> file to your Github repository with one or more Singularity recipes</li>
<li>Ensure your recipe location(s) are specified correctly (see below) depending on if you want to build or pull.</li>
<li>Connect your repository to Travis (<a href="https://docs.travis-ci.com/user/getting-started/" target="_blank">instructions</a>), and optionally set up a cron job for continuous vulnerability testing.</li>
</ol>

The `.travis.yml` file is going to retrieve the docker-compose.yml (a configuration to run Docker containers) from the <a href="https://github.com/singularityhub/stools" target="_blank">stools repo</a>, start the needed containers `clair-db` and `clair-scanner`, and then issue commands to `clair-scanner` to build or pull, and then run the scan with the installed utility `sclair`. I like this name too, it **almost** sounds like some derivation of "eclair" nomnomnom. The entire file looks like this:

```yaml

sudo: required

language: ruby

services:
  - docker

before_install:
  - wget https://raw.githubusercontent.com/singularityhub/stools/master/docker-compose.yml

script:

  # Bring up necessary containers defined in docker-compose retrieved above
  - docker-compose up -d clair-db
  - docker-compose up -d clair-scanner
  - sleep 3

  # Perform the build from your Singularity file, we are at the base of the repo
  - docker exec -it clair-scanner singularity build container.simg Singularity

  # Run sclair in the container to perform the scan
  - docker exec -it clair-scanner sclair container.simg
```

There are many ways you can customize this simple file for your continuous vulnerability scanning! Let's discuss them next.

### Set up cron jobs

<a href="https://en.wikipedia.org/wiki/Cron" target="_blank">Cron</a> is a linux based scheduler that let's you tell your computer "perform this task at this particular interval." On Travis, they added a 
<a href="https://docs.travis-ci.com/user/cron-jobs/" target="_blank">cron scheduler</a> some time
ago that I was excited to use, but didn't have a strong use case at the time. What it means is that we can have our continuous integration (the instructions defined in the `travis.yml`) to run at some frequency. How to do that?

<ol class="custom-counter">
<li>Navigate to the project settings page, usually at **https://travis-ci.org/[organization]/[repo]/settings**</li>
<li>Under "Cron Jobs" select the branch and interval that you want the checks to run, and then click "Add"</li>
</ol>

And again, that's it!


### Change the recipe file
If you have a Singularity recipe in the base of your repository, you should not need to change the `.travis.yml` example file. If you want to change it to include one or more recipes in different locations, then you will want to change this line:

```yaml

# Perform the build from your Singularity file, we are at the base of the repo
- docker exec -it clair-scanner singularity build container.simg Singularity
```

Where is says `Singularity` you might change it to `path/in/repo/Singularity`. 


### Add another recipe file
You aren't limited to the number of containers you can build and test! You can build more than one, and test the resulting containers, like this:

```yaml

 - docker exec -it clair-scanner singularity build container1.simg Singularity
 - docker exec -it clair-scanner singularity build container2.simg Singularity.two
 - docker exec -it clair-scanner sclair container1.simg container2.simg
```

In the example above, we are building two containers, each from a different Singularity file in the repository. Singularity is installed in the `clair-scanner` Docker image, so we are free to use it.

### Pull a container
If you don't want to build here, you can use Continuous Integration just for vulnerability scanning of containers built elsewhere. Let's say we have a
repository with just a travis file, we can actually use it to test all of our Docker images (converted to Singularity) or
containers hosted on Singularity Hub. That might look like this:

```yaml

 - docker exec -it clair-scanner singularity pull --name vsoch-hello-world.simg shub://vsoch/hello-world
 - docker exec -it clair-scanner singularity pull --name ubuntu.simg docker://ubuntu:16.04
 - docker exec -it clair-scanner sclair vsoch-hello-world.simg ubuntu.simg
```

In the example above, we are pulling the first container from Singularity Hub and the second from Docker Hub, and testing
them both for vulnerabilities, again with the executable `sclair` in the container `clair-scanner` (It is named in the docker-compose.yml file).


### Rename the Output
You might also change the name of the output image (container.simg). Why? Imagine that you are using Travis to
build, test, and then upon success, to upload to some container storage.  Check out different ways you can <a href="https://docs.travis-ci.com/user/deployment" target="_blank">deploy from Travis</a>, for example.


# Feedback Wanted!
Or do something else entirely different! I've provided a very slim usage example that just spits out a report to the console during testing. Let's talk now about what we might do next. I won't proactively do these things until you <a href="https://www.twitter.com/vsoch" target="_blank">poke me</a>, so please do that! Here are some questions to get you started:

<ol class="custom-counter">
<li>Under what conditions might we want a build to fail testing?</li>
<li>Would you like a CirciCI example? Artifacts?</li>
<li>Is it worth having some kind of message sent back to Github (would require additional permissions)?</li>
<li>Circle has support for artifacts. How might you want results presented?</li>
</ol>

Notably, the application produces reports in json that are printed as text on the screen. The json means that we can easily plug them into a nice rendered web interface, and given <a href="https://circleci.com/docs/2.0/artifacts/" target="_blank">artifacts</a> on CircleCI, we could get a nice web report for each run. Would you like to see this? What kind of reports would be meaningful to you? How do you intend or want to respond to the reports?

Please [let me know](https://www.github.com/singularityhub/stools/issues) your feedback!
