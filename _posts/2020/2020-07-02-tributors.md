---
title: "Tributors: pay tribute to your contributors!"
date: 2020-07-02 12:30:00
---

I want to share with you a work in progress project that I'm having quite a bit of fun with, 
<a href="https://con.github.io/tributors" target="_blank">Tributors!</a> Earlier this week, 
<a href="https://github.com/yarikoptic" target="_blank">@yarikoptic</a> opened
<a href="https://github.com/con/tributors/issues/1" target="_blank">an issue</a>
to request some kind of tool to convert between an <a href="https://allcontributors.org/docs/en/emoji-key" target="_blank">all-contributors</a> 
metadata file (.all-contributorsrc) and a <a href="https://zenodo.org" target="_blank">Zenodo</a> metadata file (a .zenodo.json). 
Since I get overly excited easily about programming projects, I jumped on the opportunity, and decided
to make a more modular, robust solution that would allow sharing of metadata
between multiple providers. The result is Tributors!

![Tributors](https://raw.githubusercontent.com/con/tributors/master/docs/assets/img/logo.png)

## What is tributors?

<a href="https://con.github.io/tributors" target="_blank">Tributors</a> is a Python library and GitHub action that helps you to pay tribute to your
contributors. Tribute interacts with several well-known repository metadata files:

<ul class="custom-counter">
 <li><a href="https://github.com/all-contributors" target="_blank">All Contributors</a>: 👉️ <a href="https://con.github.io/tributors/docs/parsers/allcontrib" target="_blank">docs</a></li>
 <li><a href="https://zenodo.org" target="_blank">Zenodo</a>: 👉️ <a href="https://con.github.io/tributors/docs/parsers/zenodo" target="_blank">docs</a></li>
 <li><a href="https://codemeta.github.io" target="_blank">CodeMeta</a>: 👉️ <a href="https://con.github.io/tributors/docs/parsers/codemeta" target="_blank">docs</a></li>
</ul>


Each of the services above allows you to generate some kind of metadata file
that has one or more repository contributors. This file typically needs to be
generated and updated manually, and this is where tributors comes in to help!
Tributors will allow you to programatically create and update these files.
By way of using a shared cache, a <a href="https://con.github.io/tributors/docs/tributors" target="_blank">.tributors</a> 
file that can store common identifiers, it becomes easy to update several of these metadata files at once.
You can set criteria such as a threshold for contributions to add a contributor,
export an Orcid ID token to ensure that you have Orcid Ids where needed,
or (in the future) use an interactive mode to make decisions as you go. For example,
I was able to quickly generate a <a href="https://github.com/usrse/usrse.github.io#contributors" target="_blank">Contributors</a>
section via using tributors to automatically find everyone via the GitHub API. Then we can
run the All Contributors client (more on this below) to update the README.md:

<div style="padding:20px">
<img src="https://raw.githubusercontent.com/vsoch/vsoch.github.io/master/assets/images/posts/tributors/contributors.png">
</div>

It's awesome, right! Individuals can then update their contribution types, and
a GitHub Action will run automatically to update the rendering in the README.md.

## How does it work?

Tributors uses the GitHub API, Orcid API, and Zenodo API to update your contributor
files. You can use it locally, via a Docker container, or GitHub Workflow.  I'll
briefly go through a "quick start" below, but you should check out the more robust
<a href="https://con.github.io/tributors/docs/getting-started" target="_blank">
getting started guide</a> if you really want to try it out.


### Local Usage

#### 1. Install

You can install the library locally:

```bash
pip install tributors
```

#### 2. Environment

and then export various API tokens that you might want.
For example, if you need orcid ids in your metadata, for a first time go you
should export an id and secret to interact with the Orcid API. It'a also recommended
to export a GitHub token to increase your API limit:

```bash
export ORCID_ID=APP-XXXXXXX
export ORCID_SECRET=12345678910111213141516171819202122
export GITHUB_TOKEN=XXXXXXXXXXXXXXX
```

Once you generate an orcid token, it will be written to a temporary file,
and you can read the file and export the variable for later discovery (and you'll
no longer need the ID and secret):

```bash
export ORCID_TOKEN=XXXXXXXXXXXXXXXXXXXXXXXX
```

#### 3. Update

If you are then sitting in a repository with one or more contribution files
(.zenodo.json, codemeta.json, or .all-contributorsrc) you can use the auto-detect
update (not specifying a particular contributor parser):

```bash
$ tributors update
```

or update a specific one:

```bash

$ tributors update allcontrib
$ tributors update zenodo
$ tributors update codemeta

```

#### 4. Init

And if you don't have any files yet, you can also create initial files:

```bash

$ tributors init allcontrib
$ tributors init zenodo

```

This is pretty useful for Zenodo, which doesn't have an easy generator for
the .zenodo.json. For all-contributors, if you don't want to install node,
this is also a nice way to generate and update one. 


### Docker Usage

You can also use the GitHub action container, [con/tributors](https://quay.io/repository/con/tributors?tab=tags) 
on Quay.io, to quickly get a container that has tributors installed, along with the allcontributors client.
You can shell inside, ensuring that the entrypoint is changed to bash, and also 
bind your repository to somewhere in the container (not `/code`).

```bash
$ docker run -it --entrypoint bash -v $PWD/:/data quay.io/con/tributors
```

In the container, tributors is already installed and on the path:

```bash

$ which tributors
/usr/local/bin/tributors

```

The all contributors client is also on the path (and this might be
the reason you want to use a container, because this install required npm/node).

```bash

$ which cli.js
/code/node_modules/all-contributors-cli/dist/cli.js

```

You'll notice that the present working directory is the `/github/workspace`,
and we do this so the container runs easily for a GitHub action (where the 
code for the user is found here). So you'd want to change directory to your
repository, and then use tributors, and update your README.

```bash

cd /data
# tributors update
cli.js generate

```

For more details on init, update, the GitHub action, or docker usage, see the 
<a href="https://con.github.io/tributors/docs/getting-started" target="_blank">
getting started guide</a>
 
### GitHub Workflow

If you want to have tributors run on it's own and also use the allcontributors client
to update your README.md, you can define a basic GitHub Workflow step that looks something
like this:

```yaml

- name: Update Tributors
  # Important! Update to release https://github.com/con/tributors
  uses: con/tributors@master
  env:
    GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}

```

The above would use all the defaults, meaning that the parser is unset (and
we auto-detect contributor files in the repository). You can see more examples
in the [examples](https://github.com/con/tributors/blob/master/examples/) folder,
or complete documentation on the GitHub Action [here](https://con.github.io/tributors/docs/getting-started#github-workflows).

## How do I contribute?

The library is very new, so I expect a lot of feature requests or bugs otherwise!
Please take it for a spin, and <a href="https://github.com/con/tributors" target="_blank">report</a> all that you like, dislike, and find.
Thanks!
