---
title: "Building Singularity Containers on GitLab-CI"
date: 2018-11-18 1:42:00
toc: false
---

Today I'm happy to announce a Thanksgiving special treat for Singularity and GitLab users!

<div>
<img src="https://vsoch.github.io/assets/images/posts/gitlab/sregistry-gitlab.png">
</div><br>

The robots and I have listened to your requests for a GitLab CI template, and had
a fun weekend exploring using GitLab for the first time. We are very excited
about what we've found, for example, did you know that GitLab can easily connect
to a [Kubernetes cluster](https://docs.gitlab.com/ee/user/project/clusters/)? 
I encourage you to explore it's [various projects](https://docs.gitlab.com/ee/user/project/), 
if you are new like me. Today we will focus on one feature, the <strong>Continuous Integration</strong>
or <strong>Continuous Deployment</strong>, often referred to as CI/CI. GitLab has its own Continuous Integration service built in, which means that you can (from a single repository):

 - build a container using the built in continuous integration
 - store it as an artifact
 - retrieve the artifact for use!

<br>

For the first step, I've added a new GitLab template to the [singularityhub/singularity-ci](https://github.com/singularityhub/singularity-ci) repository. The template itself is served on GitLab as
[singularityhub/gitlab-ci](https://gitlab.com/singularityhub/gitlab-ci/). You can find
a complete tutorial for using the template in the README there, or continue reading for 
a quick rundown. But this wasn't good enough, because it didn't seem easy enough to
retrieve the artifacts. So in addition to the template, I've added a [GitLab endpoint](https://singularityhub.github.io/sregistry-cli/client-gitlab) to the Singularity Registry Client too. Yes, I was very busy this weekend! However the inspiration comes from [@tamasgal](https://github.com/tamasgal), who [posted an issue](https://github.com/singularityhub/singularity-ci/issues/6) that he wanted it. And you know what Shrek says about Github issues...

<div>
<img src="https://vsoch.github.io/assets/images/posts/gitlab/issue-away.png">
</div><br>

I will again note that you don't need to use the client to retrieve the artifacts, and 
you don't even need to use the artifacts as your primary deployment spot. GitLab CI, along with
other [other builders](https://github.com/singularityhub/singularity-ci) are
excellent choices for maintaining version controlled, reproducible builds. Once the build is
done, you are free to deploy it to your heart's content. Today we will cover the following set of steps:

<ol class="custom-counter">
 <li>We will <strong>build</strong> a container recipe from a GitLab repository</li>
 <li>The container is saved as an <strong>artifact</strong>.</li>
 <li>We will <strong>pull</strong> the artifact using the Singularity Registry Client</li>
</ol>

It seems fairly simple when you think about it, but in the above we have both version control for
the recipes, an external build service, and programmatic access. It's also free. If you are a scrappy
developer like me, it's time to celebrate and make some pancakes.

<br>


# Getting Started

## 1. Fork the repository

Your best bet is to start with start with our [provided template](https://gitlab.com/singularityhub/gitlab-ci/)
and tweak it.

## 2. A Little About GitLab

GitLab is a resource for version control, meaning that akin to Github, it is a remote host for 
git repositories for you to collaborate with your friends. Aside from a different user interface, 
many of the goals that you want to achieve with  Github can be done with GitLab. 
A big difference, however, is that GitLab has its own "in house"
build service. For this service, we have an configuration file akin to a .travis.yml or .circleci/config.yml,
it's called a .gitlab-ci.yml. The sections are also similar - to me they look like a Travis-CI version
1.0 configuration. Here is an example to look at:

```yaml

before_script:
  - apt-get update -qq && apt-get install -y wget
  - wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh
  - /bin/bash Miniconda3-latest-Linux-x86_64.sh -b -p $HOME/conda
  - export PATH=$HOME/conda/bin:$PATH
  - $HOME/conda/bin/pip install sregistry[all]
  - chmod u+x .gitlabci/*.sh
  - /bin/bash .gitlabci/setup.sh

build:
  script:
     - /bin/bash .gitlabci/build.sh Singularity
     - mkdir -p build && cp *.simg build
     - mkdir -p build && cp Singularity* build

  # Save artifacts to a folder called "build"
  artifacts:
      paths:
        - build/Singularity.simg
        - build/Singularity


```

In fact, the example above is (a shorter version) of what is provided in the template repository.
In the "before_script" section we prepare the instance by installing Singularity and Python,
and then the job name "build" handles running a script (build.sh) that performs the build.
We then move artifacts and recipes into a folder (also called "build") where they are saved as 
artifacts in the last section of the job.

**What does this mean for you?**

It means that you just need to start with the template, add your build recipe(s), 
modify the configuration file above if you want to add additional builds or change
the functionality, and then push to GitLab. Examples for building tags and using
other deployments (other than artifacts) are provided with the repository. Let's
continue walking through some of these steps.

## 3. Recipe Naming Convention

We use the [same convention](https://github.com/singularityhub/singularityhub.github.io/wiki/Build-A-Container#naming-recipes) that is done for Singularity Hub, because it's important that the tag metadata
is represented with the file that builds the container. Specifically, a file
called "Singularity" builds the tag "latest" and any derivation of "Singularity.lego" builds
the tag "lego." For the example here, we have a single recipe named "Singularity" that is provided as an input argument to the build script, and so if you add another recipe you would want to add the line to build it:

```bash

  script:
     - /bin/bash .gitlabci/build.sh Singularity
     - /bin/bash .gitlabci/build.sh Singularity.lego

```

## 4. Configure Singularity

If you look in the [setup.sh](https://gitlab.com/singularityhub/gitlab-ci/blob/master/.gitlabci/setup.sh) file of the template, you can see the basic steps used to install Singularity. I am still installing a vault version because I don't see any huge benefit with switching to GoLang (yet?), however you are free to edit this file if you want a different version of Singularity. Note that we also install the Singularity Registry client, in the case that you choose
to push to one of it's endpoints (not required).

## 5. Configure the Build

Next, edit your <a href="https://gitlab.com/singularityhub/gitlab-ci/blob/master/.gitlab-ci.yml" target="_blank">.gitlab-ci.yml</a> file to fit your needs. I've provided robust notes in the file itself to help you out! If you intend to build a recipe named "Singularity" in the base of the repository, you don't need to change this at all.
If you have any questions, please  <a href="https://gitlab.com/singularityhub/gitlab-ci/issues" target="_blank">open an issue</a>.


## 6. Connect to CI

Haha, just kidding! The cool thing about GitLab is that it sort of already is connected. The most you would need to do
here is turn on or configure your "runners," meaning the instances that do the build. For gitlab.com this was already
set to go for me. For the Stanford GitLab instance, we didn't have any runners configured but would need to choose them. I chose the first option for this example since using Gitlab.com is the more likely of the two cases for you. 

That's it for the basic setup! At this point, you will have a continuous integration service that will build your container from a recipe each time that you push. The next step is figuring out where you want to put the finished image(s), and we will walk through this in more detail.

## 7. Build Away, Merrill!

Once you commit and push, and given that your runner is set up, you will have 
a builder (runner) doing his thing! [Here is an example](https://gitlab.com/singularityhub/gitlab-ci/-/jobs/122546034),
also shown below (I realize it's likely you don't have permission to see this url).

<div>
<img src="https://vsoch.github.io/assets/images/posts/gitlab/gitlab-runner.png">
</div><br>

It's quite a nice interface! Unlike other services I've used, the UI puts the controls on the right
side so that they are accessible no matter where I'm scrolling in the build log. I can also very
easily browse to see the artifacts, as if they were in a filesystem:

<div>
<img src="https://vsoch.github.io/assets/images/posts/gitlab/artifacts.png">
</div><br>

Note in the above that we are in the "build" folder.


## 8 Pull artifacts

I'm really excited to also provide you a client for pulling the artifacts! For full details,
please see the [sregistry client](https://singularityhub.github.io/sregistry-cli/client-gitlab) 
documentation. I'll quickly show you how it works here! You can query for job ids based
on the GItLab repository name. Note that you would need to [create a token](https://docs.gitlab.com/ee/user/profile/personal_access_tokens.html) and export it first.

```bash
export SREGISTRY_GITLAB_TOKEN=xxxxxxxxxxxxxxx
```

There are multiple ways to activate gitlab as the client:

```bash

export SREGISTRY_CLIENT=gitlab                # sets as default for a terminal session
sregistry backend activate gitlab             # sets as default in your configuration
SREGISTRY_CLIENT=gitlab sregistry ...         # just use for one command

```

The query command looks like this:

```bash

$ sregistry search singularityhub/gitlab-ci
[client|gitlab] [database|sqlite:////home/vanessa/.singularity/sregistry.db]
Artifact Browsers (you will need path and job id for pull)
1  job_id	browser
2  122546034	https://gitlab.com/singularityhub/gitlab-ci/-/jobs/122546034/artifacts/browse/build
3  122093393	https://gitlab.com/singularityhub/gitlab-ci/-/jobs/122093393/artifacts/browse/build
4  122059246	https://gitlab.com/singularityhub/gitlab-ci/-/jobs/122059246/artifacts/browse/build

```

The GitLab API doesn't support returning the artifact file names ([yet](https://gitlab.com/gitlab-org/gitlab-ce/issues/51515)) so in the meantime you can browse to the URLs above, each associated with the job identifier,
to find the artifact of choice. In the future if users are finding the query returns too many, we can
also just return some subset. Finally, when we see in the interface a "Singularity.simg" file (meaning
tag latest) and want to pull it, we can do that like this:

```bash

$ sregistry pull 122059246,singularityhub/gitlab-ci
[client|gitlab] [database|sqlite:////home/vanessa/.singularity/sregistry.db]
Looking for artifact build/Singularity.simg for job name build, 122059246
https://gitlab.com/singularityhub/gitlab-ci/-/jobs/122059246/artifacts/raw/build/Singularity.simg
Progress |===================================| 100.0% 
[container][new] 122059246,singularityhub/gitlab-ci-latest
Success! /home/vanessa/.singularity/shub/122059246,singularityhub-gitlab-ci-latest.simg

```

Then you got it!

```bash

$ sregistry images | grep gitlab
7  November 19, 2018	   [gitlab]	122059246,singularityhub/gitlab-ci:latest@ccfbb8f2a0f....

```

The (truncated) hash at the end is the container file hash, which we calculate on
pull of the container. you can then run it:

```bash

$ singularity run $(sregistry get 122059246,singularityhub/gitlab-ci)
Polo !

```

and are overtaken with a sudden sadness that this container has been lying dormant,
waiting to respond to the call of some "Marco!" emit long ago. We just freed his little
container spirit!

<br>

# Contributing

Thanks for stopping by! Please poke if you have a question or would like to request a feature.
I encourage you to test and give feedback on the [ceph storage](https://github.com/singularityhub/sregistry-cli/pull/161)
integration, because the ultimate goal with this integration will be to develop a means for Singularity Registry
Client endpoints (e.g., Google Cloud Storage, AWS, Ceph) to plug nicely into [Singularity Registry Server](https://www.github.com/singularityhub/sregistry). It is important as to provide both reproducible
and flexible options for an institution to build and deploy their containers.

<br>

# Resources
 
 - [singularityhub/gitlab-ci/](https://gitlab.com/singularityhub/gitlab-ci/) GitLab template
 - [singularityhub/singularity-ci](https://github.com/singularityhub/singularity-ci) all singularity-ci examples
 - [GitLab endpoint](https://singularityhub.github.io/sregistry-cli/client-gitlab) for retrieving artifacts using Singularity Registry Client.
