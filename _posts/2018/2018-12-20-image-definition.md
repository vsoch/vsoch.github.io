---
title: "The Ultimate Dockerfile Extraction"
date: 2018-12-20 7:39:00
toc: false
---

Before we go into details, here is what I am going to talk about in this post:

<ol class="custom-counter">
 <li><strong>Container-diff</strong> is HPC Friendly. It affords doing a scaled analysis of Dockerfiles.</li>
 <li><strong>ImageDefinition</strong> is my proposal to schema.org to describe a Dockerfile. I made a bunch.</li>
 <li>I made <strong>Github Actions</strong> to extract metadata for your Dockerfiles and Datasets in Github repositories</li>
</ol>

Let's get started!

<br>
<hr>
<br>

# Container-diff is HPC Friendly

When I first wanted to use Google's <a href="https://github.com/GoogleContainerTools/container-diff" target="_blank">container-diff</a>
 at scale, I realized that it wasn't suited for a cluster environment. 
Why? Because <strong>1.</strong> I couldn't control the cache, and it would default to my home that would subsequently fill 
up almost immediately and then lock me out from logging in again. Then <strong>2.</strong> There wasn't an 
option to save to file, and I couldn't come up with a (reasonably simple) solution to pipe the output 
from a node. Sure, I could come up with a hack, but it wasn't the best and right way to address the issue.

To solve these problems, despite being super noobish with GoLang, I did two pull requests (now merged into master, [1](https://github.com/GoogleContainerTools/container-diff/pull/274) and [2](https://github.com/GoogleContainerTools/container-diff/pull/279)) to add the ability to customize the cache and save output to a file. In a nutshell, I added command line options for an `--output` and `--cache-dir` and a few tests. The release with these features hasn't yet been done yet at the time of writing of this post, so if you are interested in testing you would need to build from the master branch. I also want to give a "Thank you from the Vanessasaurus!" to <a href="https://github.com/nkubala" target="_blank">@nkubala</a> because contributing was really fun. This is the best way to run open source software.

## Analysis of Dockerfiles

Let's cut to the chase. I filtered down the original 120K to 60K that had Python (pip) packages, and then
did a small visualization of a subset that would be reasonable to work with on my local machine. In a nutshell,
there is beautiful structure:

<div>
<img src="/assets/images/posts/schemaorg/clustering.png" style="float:left" title="Dinosaur Dockerfiles">
</div><br><br>


If you want to see the entire analysis, the 
<a href="https://github.com/openschemas/dockerfiles/blob/master/container-analysis.ipynb" target="_blank">notebook is available</a>.
The take away message that I want you to have is that containers are the new unit that we operate in. We don't understand their 
guts. With tools like container-diff, and with data structures like an `ImageDefinition` defined by schema.org, we can
have all this metadata splot out statically in HTML for search giants like Google to parse. We might actually be able
to parse and organize this massive landscape. How do you do that? Let me show you how to start.

## How do we label a Dockerfile?

For each Dockerfile, I used <a href="https://openschemas.github.io/schemaorg/" target="_blank">schemaorg</a>
Python to define an extractor, and used the extractor to generate an html page (with embedded metadata). 
If you remember the early work thinking about <a href="https://vsoch.github.io/2018/schemaorg/" target="_blank">
a container definition</a> and then <a href="https://vsoch.github.io/2018/datasets/" target="_blank"> doing an actual extraction</a>
this was leading up to the extraction done here - we finally labeled each Dockerfile as an `ImageDefinition`.

<br><br>
<hr>
<br>

# The ImageDefinition

This jumps to our next question. We needed an entity in schema.org to define a build specification / container recipe 
or definition like a Dockerfile. This is the `ImageDefinition`.

## What is an ImageDefinition?

An ImageDefinition is my favorite proposed term for what we might call a container recipe,
the "Dockerfile." It is essentially a <a href="https://schema.org/SoftwareSourceCode" target='_blank'>
SoftwareSourceCode</a> that has some extra fields to describe containers. I've been trying to engage various
communities (Schemaorg and OCI) for a few months to take interest (imagine if Google Search could
define and index these data structures! That alone would be huge incentive for others to add the
metadata to their Github repos and other webby places). 

To make it easy for you to extract ImageDefinitions and Datasets for your software and respositories,
I've created a repository of [extractors](https://github.com/openschemas/extractors). 
Each subfolder there will extract a schema.org entity of a particular type, and create a static
html file (or a json structure) to describe your dataset or Dockerfile. [Here is a random example](https://openschemas.github.io/dockerfiles/data/b/b1015223/creating-a-simple-web-app/ImageDefinition.html) from the GIthub pages for that repository for a container Dockerfile
that provides both Apt and Pip packages, extracted thanks to Container-diff, and parsed
into that metadata thanks to schamaorg Python.


<br><br>
<hr>
<br>

# Github Actions

But I wanted to make it easier. How about instead of tweaking Python and bash code,
you had a way to just generate the metadata for your Github repos? This can be helped with Github
actions! 

## How do I set up Github Actions?

It comes down to adding a file in your repository that looks like `.github/main.workflow` that then
gets run via Github's internal Continuous Integreation service called [Actions](https://help.github.com/articles/about-github-actions/).


## What goes in the main workflow?
Here are recipes and examples to show you each of the demos for ImageDefinition and Dataset, respectively.


### Extract a Dataset

[zenodo-ml](https://vsoch.github.io/zenodo-ml/) describes the [vsoch/zenodo-ml](https://github.com/vsoch/zenodo-ml) repository, with a bunch of Github code snippets from Zenodo records and their metadata. This is a <strong>Dataset</strong> and you can see it's valid based on the Google Metadata Testing tool:

<div>
<img src="/assets/images/posts/schemaorg/valid-dataset.png" style="float:left" title="Dinosaur Dataset">
</div><br><br>


Here is a snapshot of the site that is validated. You can see the metadata there, and it's also provided
in a script tag for the robots to find.

<div>
<img src="/assets/images/posts/schemaorg/zenodo-ml.png" style="float:left" title="Dinosaur Dataset">
</div><br><br>


The main workflow looks like this:

```yaml

workflow "Deploy Dataset Schema" {
  on = "push"
  resolves = ["Extract Dataset Schema"]
}

action "list" {
  uses = "actions/bin/sh@master"
  runs = "ls"
  args = ["/github/workspace"]
}

action "Extract Dataset Schema" {
  needs = ["list"]
  uses = "docker://openschemas/extractors:Dataset"
  secrets = ["GITHUB_TOKEN"]
  env = {
    DATASET_THUMBNAIL = "https://vsoch.github.io/datasets/assets/img/avocado.png"
    DATASET_ABOUT = "Images and metadata from ~10K Github repositories. A Dinosaur Dataset. See https://vsoch.github.io/2018/extension-counts/"
    DATASET_DESCRIPTION = "Data is compressed with squashfs and includes python3 pickled images and metadata dictionaries. "
  }
  args = ["extract", "--name", "zenodo-ml", "--contact", "@vsoch", "--version", "1.0.0", "--deploy"]
}

```

In the first block we define the name of the workflow, and we say that it happens on a "push." In the second block,
we just list the contents of the Github workspace. This is a sanity check to make sure that we have files there.
In the third block, we do the extraction! You'll notice that I am using the Docker container 
[openschemas/extractors:Dataset](https://cloud.docker.com/u/openschemas/repository/docker/openschemas/extractors)
and that several environment variables are used to define metadata, along with command line arguments under args.
I'm not giving extensive details here because I've written up how to write this recipe in detail
in the [README](https://github.com/openschemas/extractors/tree/master/Dataset) associated with the action.
The last step also deploys to Github pages, but only given that we are on master branch.

### Extract an ImageDefinition

As an example of an `ImageDefinition`, I chose my [vsoch/salad](https://www.github.com/vsoch/salad) repository
that builds a silly container. You can see it's `ImageDefinition` [here](https://vsoch.github.io/salad/).
It's also generated via a Github Action. The main workflow looks like this:

```yaml

workflow "Deploy ImageDefinition Schema" {
  on = "push"
  resolves = ["Extract ImageDefinition Schema"]
}

action "build" {
  uses = "actions/docker/cli@master"
  args = "build -t vanessa/salad ."
}

action "list" {
  needs = ["build"]
  uses = "actions/bin/sh@master"
  runs = "ls"
  args = ["/github/workspace"]
}

action "Extract ImageDefinition Schema" {
  needs = ["build", "list"]
  uses = "docker://openschemas/extractors:ImageDefinition"
  secrets = ["GITHUB_TOKEN"]
  env = {
    IMAGE_THUMBNAIL = "https://vsoch.github.io/datasets/assets/img/avocado.png"
    IMAGE_ABOUT = "Generate ascii art for a fork or spoon, along with a pun."
    IMAGE_DESCRIPTION = "alpine base with GoLang and PUNS."
  }
  args = ["extract", "--name", "vanessa/salad", "--contact", "@vsoch", "--filename", "/github/workspace/Dockerfile", "--deploy"]
}

```

The only difference from the above (primarily) is that we build our `vanessa/salad` container first,
and then run the extraction.

### Github Bugs

There are some bugs you should know about if setting this up! When you first deploy to Github
pages, the permissions are wrong so that it will <strong>look</strong> like your site is
rendering Github pages, but you will get a 404. The only fix is to (in your settings)
switch to master branch, and then back to Github Pages. The same thing unfortunately
happens on updates - you will notice the Github Action runs successfully, but then that
the page isn't updated. If you go back to settings you will see the issue:

<div>
<img src="/assets/images/posts/schemaorg/error.png" style="float:left" title="Dinosaur Dataset">
</div><br><br>

And again the fix is to switch back and forth from master back to Github pages.

# Summary

I've been working a long time on this, and I'm happy to have created something that
could be useful. What can you do to actively start exposing the metadata for your Datasets
and Containers? Here are some suggestions:

 - Use the [extractors](https://github.com/openschemas/extractors) locally or via Github actions.
 - Do a [better job than me](https://github.com/openschemas/dockerfiles) to analyze all those Dockerfiles!
 - Use <a href="https://github.com/GoogleContainerTools/container-diff" target="_blank">container-diff</a> to do your own analysis
 - Analyze software via code in Github repositories with the [zenodo-ml](https://github.com/vsoch/zenodo-ml) dataset.

Dinosaur out.
