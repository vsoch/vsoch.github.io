---
title: "Organizational Static Container Registry"
date: 2019-02-01 7:05:00
---

To follow up on my <a href="">original post</a> about a basic <a href="https://www.github.com/singularityhub/registry-" target="_blank">static container registry</a>,
I've following up with another model that might be more of interest to groups that don't want to build, test, and deploy
all in one place. The <a href="https://www.github.com/singularityhub/registry-org" target="_blank">organizational registry</a>.
It <a href="https://singularityhub.github.io/registry-org/" target="_blank">looks exactly the same</a>:


<div style="padding:20px">
<a href="https://vsoch.github.io/assets/images/posts/sregistry/org.png"><img src="https://vsoch.github.io/assets/images/posts/sregistry/org.png"></a>
</div>


 but is serving containers from separate repositories from where the registry is hosted! Here is a modified workflow:

<ol class="custom-counter">
<li>other repositories such as <a href="https://www.github.com/singularityhub/centos" target="_blank">singularityhub/centos</a> serve and build container recipes</li>
<li>a pull request runs a continuous integration workflow to build and upload the container to storage</li>
<li>when step 2 is done, the workflow finishes by creating a new branch (named according to its namespace, so each repository always has a unique branch)</li>
<li>the branch push opens or updates a pull request on the repository via this <a href="https://www.github.com/vsoch/pull-request-action" target="_blank">GitHub Action</a></li>
</ol>

There are many benefits to the above! For example, the above model affords more specific permissions with respect to who
manages individual containers. The above also affords many different methods of builders! You can have
one container builder use a remote build service, and send containers to Google Storage, and perhaps
another builds and uses storage via Amazon Web Services. The above is a more modular workflow that 
doesn't place the burden of building on one single repository.

## The Organizational Static Registry

The [org registry](https://www.github.com/singularityhub/registry-org) that I put together is a modified basic registry
with the change that the registry repository itself doesn't do any building. It's a silly GitHub repository that only
knows how to deploy it's content to GitHub pages, and it relies on pull requests to it in order to update that content.


### Creating a Connected Repository

If you want details for how to set this up, I've updated the [documentation here](https://github.com/singularityhub/registry/wiki/deploy-container-storage).
It comes down to forking the repository, and then generating repositories for your containers
that have a continuous integration setup akin to <a href="https://www.github.com/singularityhub/centos" target="_blank">singularityhub/centos</a>
Specifically:

<ol class="custom-counter">
<li>Start with a template such as <a href="https://www.github.com/singularityhub/centos" target="_blank">singularityhub/centos</a>. This will build Singularity containers</li>
<li>Connect the repository to <a href="https://circleci.com/docs/2.0/getting-started/#setting-up-your-build-on-circleci" target="_blank">CircleCI</a></li>
<li>Create a <a href="https://github.com/singularityhub/registry/wiki/Github-Machine-User" target="_blank">Github Machine User</a></li>
<li>Proceed as you would to add containers (Singularity recipe files) in your repository.</li>
</ol>


### How Does the namespace Work?

Unlike the basic registry, the organizational registry has a namespace based on the GitHub repositories that submit containers to it! So if you are submitting a container from `singularityhub/ubuntu`, the container will be served from `https://singularityhub.github.io/singularityhub/ubuntu`, with manifests and tags under `https://singularityhub.github.io/singularityhub/ubuntu/manifests/<tag>`. This makes life much easier for the registry, because the namespaces aren't maintainer via
randomly generated folder hierarchies, but rather via the GitHub namespace.

### How do I create a tag?

Unlike the basic registry, the tags for your containers follow the Singularity Hub standard. The extension of the Singularity file maps to a tag. For example, `Singularity` will build the tag "latest" and `Singularity.pancakes` will build the tag `pancakes`. 
The [rules for interaction](https://github.com/singularityhub/registry/wiki/deploy-container-storage#interaction)
with the API to get a container or tag manifest are the same for both kinds of registries.


### Next Steps

The registry would then do any testing desired to ensure that the objects exist, content types are valid, etc. 
I'll add this testing when I have a more solid example with several build options. I'm optimistic that with
remote build services and completely GitHub actions driven workflows, we won't even need to think about
the complexity of communication between different continuous integration services. More to come!
