---
title: "Visualize Containers with Github Actions"
date: 2019-01-09 7:55:00
categories: rse
---

Container introspection is hard. When you have a container binary, or
a Dockerfile on Github, how do you see it? You might know a little
bit about the base operating system and have access to see some of the files
that are added in the repository itself. But largely, the container is a black
box that you need to execute or shell into to reveal its inner goodness.

> Can we add visualization as part of our continuous integration?

Can we make it easy to visualize the innermost wonderful guts of our containers,
and have this visualization update each time that we make changes, and live
alongside our version controlled code?

<div style="padding:20px">
<img src="https://vsoch.github.io/assets/images/posts/container-tree/containertree.png">
</div>

<a href="https://vsoch.github.io/containertree/" target="_blank">Yes, we can.</a>

## Github Actions for Visualization

I'm working on a <a href="https://www.github.com/singularityhub/container-tree">Container Tree</a> 
python module that will generate both data structures and visualizations for trees. 
I have various aspirations for this library, but for now, let's say that 
it can be used to take some container (e.g., [vanessa/salad](https://hub.docker.com/r/vanessa/salad))
and spit out a [d3.js](https://d3js.org/) visualization of its inner files.
So here is what I did:

<ol class="custom-counter">
 <li>Generated a simple Github Action <a href="https://github.com/vsoch/github-deploy" target="_blank">vsoch/github-deploy</a>) to deploy static files to Github Pages</li>
 <li>Created a Container Tree client to generate the trees from the command line.</li>
 <li>Put those two things together in <a href="https://github.com/vsoch/containertree" target="_blank">vsoch/containertree</a> to test it out!</li>
</ol>

Here is how you can deploy container trees from your Github repositories too!

### 1. Create a Workflow

Let's create our <a href="https://developer.github.com/actions/" target="_blank">Github Actions</a> workflow.
first. It will deploy a containertree to your Github pages from an existing Docker container.
Create a `.github/main.workflow` in your repository that looks like this:

```

workflow "Deploy ContainerTree Extraction" {
  on = "push"
  resolves = ["deploy"]
}

action "extract" {
  uses = "docker://singularityhub/container-tree"
  args = ["--quiet generate --output=/github/workspace vanessa/salad"]
}

action "list" {
  needs = ["extract"]
  uses = "actions/bin/sh@master"
  runs = "ls"
  args = ["/github/workspace"]
}

action "deploy" {
  needs = ["extract", "list"]
  uses = "vsoch/github-deploy@master"
  secrets = ["GITHUB_TOKEN"]
  args = ["index.html data.json"]
}

```

In the above, we are:

**Extract**

Using the SingularityHub ContainerTree container to extract static files to the github workspace
Note we are using an existing container "vanessa/salad.

**List**

Then we are listing the files for our own debugging.

**Deploy**

Finally, we are using the [vsoch/github-deploy](https://github.com/vsoch/github-deploy)
to deploy the static files back to Github Pages. The arguments for the container
are a single list of files in the Github Workspace (generated in the extract step)
that we want to deploy.

### 2. Push to Github

And seriously, then we push to Github master branch, and that's it.
<a href="https://vsoch.github.io/containertree/" target="_blank">There it is!</a>

When you deploy to Github pages for the first time, you
need to switch Github Pages back and forth to deploy from master and then back to the `gh-pages`
branch. There is a bug with Permissions if you deploy
to the branch without activating it (as an admin) from the repository first.

### 3. (Optionally) Add a Build

If you have a Dockerfile in your repository, then you can build and deploy it,
and then generate its tree for Github pages! Notice below we've added
steps to login, build, and push.

```

workflow "Deploy ContainerTree Extraction" {
  on = "push"
  resolves = ["deploy"]
}

action "login" {
  uses = "actions/docker/login@master"
  secrets = ["DOCKER_USERNAME", "DOCKER_PASSWORD"]
}

action "build" {
  uses = "actions/docker/cli@master"
  args = "build -t vanessa/salad ."
}

action "push" {
  needs = ["login", "build"]
  uses = "actions/docker/cli@master"
  args = "push vanessa/salad"
}

action "extract" {
  needs = ["login", "build", "push"]
  uses = "docker://singularityhub/container-tree"
  args = ["--quiet generate --output=/github/workspace vanessa/salad"]
}

action "list" {
  needs = ["extract"]
  uses = "actions/bin/sh@master"
  runs = "ls"
  args = ["/github/workspace"]
}

action "deploy" {
  needs = ["login", "extract", "list"]
  uses = "vsoch/github-deploy@master"
  secrets = ["GITHUB_TOKEN"]
  args = ["index.html data.json"]
}

```

We've added steps to:

**Login**

means logging into the docker daemon in case we want to push.
You need to add these credentials to your Github Secrets under the repository settings.

And then build and push do exactly that. The vanessa/salad that is referenced under
extract will use the container that we just pushed.

## The Power of Container-Diff

The driver of the tree visualization is exporting the filesystem, and we
do this by way of Google's [Container Diff](https://github.com/GoogleContainerTools/container-diff).
I love this tool, and will have much more fun to show you with it. For now, 
if you just want to generate the data.json for Container Diff (and roll
your own visualization) here is an example main.workflow to get you started:

```

workflow "Run container-diff isolated" {
  on = "push"
  resolves = ["list"]
}

action "Run container-diff" {
  uses = "vsoch/container-diff/actions@add/github-actions"
  args = ["analyze vanessa/salad --type=file --output=/github/workspace/data.json --json"]
}

action "list" {
  needs = ["Run container-diff"]
  uses = "actions/bin/sh@master"
  runs = "ls"
  args = ["/github/workspace"]
}

```

Note that the above for container-diff is currently 
[opened as a PR](https://github.com/GoogleContainerTools/container-diff/pull/286), so
you should soon be able to use the uri `GoogleContainerTools/container-diff@master`.

That's it! If you have any questions, please [open up an issue](https://www.github.com/vsoch/containertree)
