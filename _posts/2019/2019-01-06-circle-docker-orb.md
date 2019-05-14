---
title: "CircleCI Docker Build with Programmatic Tag"
date: 2019-01-06 5:15:00
categories: rse
---

I'm starting to get the hang of using CircleCI Orbs as recipe templates
for my continuous integration. If you want to publish a container to Docker
Hub, I want to quickly share how I used the [docker-publish](https://circleci.com/orbs/registry/orb/circleci/docker-publish) Orb and some customization to achieve the following:

<ul class="custom-counter">
  <li>Build the container on pull requests, but don't push to Docker Hub</li>
  <li>Build *and* depoy to Docker Hub on merge to only master branch</li>
  <li>Programmatically generate a tag from the software version.</li>
</ul>


This is a fairly simple setup. We want to test our build when someone issues 
a pull request (along with any other testing blocks you might have) and then
we want to build and deploy when everything looks okay and the same pull
request is merged to master. If you aren't familiar with CircleCI, continuous
integration, or Orbs, then you should first 
[read the Orbs Documentation](https://circleci.com/docs/2.0/orb-intro/).

In the following sections we will talk about the content of the `.circleci/config.yml`
file that serves as a recipe for our testing, and is triggered to run when there 
is a pull request or other commit into the Github repository for our code.
Let's break the content of this file down into two blocks - the first 
will be pre-merge, and the second post-merge.


## Build on Pull Request

The first block here will build the container, and preview the tag based on querying the software inside. Notice that we also start with the configuration file version (2.1) and
a section that indicates the unique resources identifier of the Orb itself.

```yaml

version: 2.1

orbs:
  # https://circleci.com/orbs/registry/orb/circleci/docker-publish
  docker-publish: circleci/docker-publish@0.1.3

```

How did I find that URI, circleci/docker-publish@0.1.3? 
You can start at the [Orb Registry](https://circleci.com/orbs/registry/)
and then click on the Orb you are interested in. The top of the page will include
the most up to date version. Be careful of copy pasting the example code - the
version is a dummy "1.0.0" that will spit out an error when you try to use it.
And next we define our workflow blocks!

```yaml

workflows:

  # This workflow will be run on all branches but master (to test)
  build_without_publishing_job:
    jobs:
      - docker-publish/publish:
          image: singularityhub/sif
          deploy: false
          tag: latest
          filters:
            branches:
              ignore: master
          after_build:
            - run:
                name: Preview Docker Tag for Build
                command: |
                   DOCKER_TAG=$(docker run singularityhub/sif:latest --version)
                   echo "Version for Docker tag is ${DOCKER_TAG}"

```

Let's look quickly at the content of the above block. Our workflow 
"build_without_publishing_job" will do exactly that. We are using the docker-publish/publish
Orb, and within it defining variables for the image, tag, and a branch filter to say
"build on all branches except for master" (meaning pull requests). We set deploy
to false because we do not want to push to Docker Hub. The key here to generate
the custom tag is the "after_build" block. Notice that I'm adding a pipe (|) to
command so I can easliy write multiple lines. Those lines are running the container
to derive the version of the software inside, and showing that to the user
via an echo. You can run anything you want here to derive your tag, or run
additional tests. If you are interested, [here is the run](https://circleci.com/gh/singularityhub/sif/19) above.


## Deploy on Merge

Given that the above looks good, we would now want to deploy our image when the
pull request branch is merged into master. This second block is the same, 
but deploy is set to True (This is the default) and we add a "docker tag" command.

```yaml

  # This workflow will deploy images on merge to master only
  docker_with_lifecycle:
    jobs:
      - docker-publish/publish:
          image: singularityhub/sif
          tag: latest
          filters:
            branches:
             only: master
          after_build:
            - run:
                name: Publish Docker Tag with SIF Python Version
                command: |
                   DOCKER_TAG=$(docker run singularityhub/sif:latest --version)
                   echo "Version for Docker tag is ${DOCKER_TAG}"
                   docker tag singularityhub/sif:latest singularityhub/sif:${DOCKER_TAG}

```

Let's again talk about the sections. The workflow "docker_with_lifecycle" is using
the same step called "docker-publish/publish," but we've removed the boolean
to set deploy to false so this one will push the containers to Docker hub. This
time, instead of ignoring master we are running for <strong>only</strong> master.
Finally, the last run block is the same, except we are additionally tagging the "latest"
container with the tag we derive from the software in the container.

Since deploy is set to true by default, after the container is tagged both containers 
will be pushed because the push references the more general namespace "singularityhub/sif."
If you are interested in seeing the run, [here it is](https://circleci.com/gh/singularityhub/sif/22).
And here are the [containers on Docker Hub](https://cloud.docker.com/u/singularityhub/repository/registry-1.docker.io/singularityhub/sif). 

If you want to contribute to the published Orbs, it's all open source! Check
out the [repository here](https://github.com/CircleCI-Public/circleci-orbs).
