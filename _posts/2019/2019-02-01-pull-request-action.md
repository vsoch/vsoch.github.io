---
title: "Open Pull Requests on Branch Updates"
date: 2019-02-01 4:20:00
---

I've recently been thinking about how we can use GitHub actions (possibly combined
with other continuous integration services) to perform more complex workflows.
As a quick example, let's say that we have some central GitHub repository that hosts
a static registry. It could be any kind of central registry, but for this example
let's say that it is a collection of <a href="https://www.github.com/singularityhub/registry-org/" target="_blank">container manifests</a>.
For those not familiar with containers, this basically means a shared metadata bucket for a bunch
of objects that are maintained and built elsewhere (in other GitHub repositories). 
I could have some awful workflow of requiring a manual update, but does anyone really want
to do that? Instead, would it be possible to have the central registry updated whenever
a container repository is updated? Let's imagine a workflow that looks like this:

<ol class="custom-counter">
<li>A container build definition is stored in a repository, such as <a href="https://www.github.com/singularityhub/centos" target="_blank">singularityhub/centos</a></li>
<li>A pull request to the repository, along with triggering a build, generates manifests to update the central registry.</li>
<li>When the continuous integration passes and the container is deployed, a pull request with the updated metadata is automatically submit.</li>
</ol>

The way that the last step might work is an indirect route. What I decided to do was have the metadata
added to a branch of the central registry, and then create a GitHub action that would automatically
create a pull request for any update to a branch that isn't master.  
This probably sounds complicated, but it can be summarized as:

> open a pull request when I push to a branch

This is entirely possible, and in fact I put together this workflow this afternoon!

## Pull Request from Branch Action

I've put together the [pull-request-action](https://github.com/vsoch/pull-request-action) action
that serves one purpose - when a branch (that you have specified) is pushed to or updated,
it will open a pull request for it. That's it! Here is what to add to your .github/main.workflow
file:

```

workflow "Create Pull Request" {
  on = "push"
  resolves = "Create New Pull Request"
}

action "Create New Pull Request" {
  uses = "vsoch/pull-request-action@master"
  secrets = [
    "GITHUB_TOKEN"
  ]
  env = {
    BRANCH_PREFIX = "update/"
    PULL_REQUEST_BRANCH = "master"
  }
}

```

The <strong>PULL_REQUEST_BRANCH</strong> should be the branch that you are
targeting for the pull request. The <strong>BRANCH_PREFIX</strong> should
be some prefix that you want to always open a pull request when it's pushed.
For example, you can create a namespace like "automated-pr/" that is saved
for these automatic triggers. For the file above, it says that the GitHub action
should open a pull request to the master branch whenever a branch is pushed to
that starts with "update/." If the pull request is already open, no action is taken.
For example, here is the pull request that is opened for the 
[registry use case](https://github.com/singularityhub/registry/wiki/deploy-container-storage#organizational) outlined
above:

<div style="padding:20px">
<a href="https://vsoch.github.io/assets/images/posts/sregistry/robot-update.png"><img src="https://vsoch.github.io/assets/images/posts/sregistry/robot-update.png"></a>
</div>


This is a cool GitHub action because it's very developer friendly - the ways that
you can use a simple trigger to create pull requests from branch is really only
limited by your own creativity. It's also great if you like having robot friends.
I strangely still get joy whenever my robot updates his pull request when a container's
tests pass :)

I'll be writing more about the Organizational static registry soon, and in the meantime, 
please share ideas for how this could be useful for you! 
