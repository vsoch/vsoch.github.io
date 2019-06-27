---
title: "Singularity Registry Server + Google Cloud Build"
date: 2019-06-27 5:35:00
---

<iframe width="100%" height="166" scrolling="no" frameborder="no" allow="autoplay" src="https://w.soundcloud.com/player/?url=https%3A//api.soundcloud.com/tracks/643096293%3Fsecret_token%3Ds-QzN7o&color=%23ff5500&auto_play=false&hide_related=false&show_comments=true&show_user=true&show_reposts=false&show_teaser=true"></iframe>

I'm excited to announce today a 
<a href="https://github.com/singularityhub/sregistry/releases/tag/v1.1.0rc1" target="_blank">release candidate</a>  for the Singularity Registry Server with Google Build. What does this mean? It's a completely open source
version of Singularity Hub that you can deploy on your own, meaning that you:

<ol class="custom-counter">
   <li>Add one or more recipes to a GitHub repository</li>
   <li>Connect the repository to your Singularity Registry Server</li>
   <li>Pushes to your repository use webhooks to trigger builds</li>
   <li>The builds happen via <a href="https://cloud.google.com/cloud-build/docs/" target="_blank">Google Cloud Build</a></li>
   <li>Finished containers are served from <a href="https://cloud.google.com/storage/" target="_blank">Google Storage</a></li>
</ol>

This happens by way of the Google Build <a href="https://singularityhub.github.io/sregistry-cli/client-google-build" target="_blank">integration</a> provided by the Singularity Registry
client, which, by the way, will let you run these same builds from your command line,
either providing a local recipe and context, or a GitHub repository to use.

## What do you think?

If you are interested in the complete setup documentation (that will be rendered
in the web interface when the pull request is merged) see 
<a href="https://github.com/singularityhub/sregistry/tree/add/builders/docs/pages/plugins/google_build" target="_blank">here</a> for the markdown, and <a href="https://github.com/singularityhub/sregistry/issues/207"
target="_blank">this issue</a> for a rendered version. If you don't care about the details and want to play? You can do that too!

<a href="https://www.containers.page" target="_blank"><span style="font-size:20pt;color:tomato">Try it out!</span></a><br>

and then leave feedback and report other issues <a href="https://github.com/singularityhub/sregistry/issues/207" target="_blank">here</a>. The preview will be open until the end of next week for you to test. 
For those interested, a (poorly done, really terrible, I really should try harder on
these things) video is included below.

<iframe width="560" height="315" src="https://www.youtube.com/embed/HgZRt0_n_FU" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

Additionally, I'm interested in your feedback to the following questions:

### Should Singularity Hub be Migrated?

Specifically, should Singularity Hub be migrated to this? Sylabs has never provided
me with a secure build branch for Singularity beyond 2.5.1, so I've been unable to 
update the Singularity Hub builders. This means that it's forever frozen at that 
version. With Google Cloud build, we could use any (or the latest) version of 
Singularity without issue. I had hoped that Sylabs
would step up to provide the same service to build from a version controlled
repository and put Singularity Hub out of business, but I haven't seen this yet.
