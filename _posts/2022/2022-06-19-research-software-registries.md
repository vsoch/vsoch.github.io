---
title: "Research Software Registries"
date: 2022-06-19 12:15:00
category: rse
---

This post spurred from some original thinking about <a target="_blank" href="https://rse-ops.github.io/proposals/proposals/drafts/research-software-registry/">research software registries</a>, and my recent discovery of the <a href="https://scicodes.net/" target="_blank">SciCodes Consortium</a>, which I'm excited to find (and a bit surprised I didn't earlier given my experience with research software and registries)! Since I've developed registries and been involved extensively in communities that develop standards and tooling for them, I've naturally been ruminating over ideas for several months, and hoping to find others that are motivated to think about similar things. This is the motivation of this post - to ruminate, share my thinking, and think together about ideas. You can read the content, or listen to the ideas below.

<iframe width="100%" height="166" scrolling="no" frameborder="no" allow="autoplay" src="https://w.soundcloud.com/player/?url=https%3A//api.soundcloud.com/tracks/1290489547&color=%23ff5500&auto_play=false&hide_related=false&show_comments=true&show_user=true&show_reposts=false&show_teaser=true"></iframe><div style="font-size: 10px; color: #cccccc;line-break: anywhere;word-break: normal;overflow: hidden;white-space: nowrap;text-overflow: ellipsis; font-family: Interstate,Lucida Grande,Lucida Sans Unicode,Lucida Sans,Garuda,Verdana,Tahoma,sans-serif;font-weight: 100;"><a href="https://soundcloud.com/vsoch" title="vsoch" target="_blank" style="color: #cccccc; text-decoration: none;">vsoch</a> · <a href="https://soundcloud.com/vsoch/research-software-registries" title="Research Software Registries" target="_blank" style="color: #cccccc; text-decoration: none;">Research Software Registries</a></div>

## Why do we want research software registries?

Research software registries have value when they are deployed for a specific context. However,
I'm not convinced that a research software registry, at the most basic form providing archives with DOIS and metadata, is a useful thing in and of itself. It's adding complexity and redundancy to an already cluttered ecosystem. The reason is because the source of truth of software is usually the source code in version control, e.g., the GitHub repository, which often already has support for features we need to enable easy citation (CITATION.cff), tagged releases, and programmatically accessible metadata. In this context, any kind of registry that provides another identifier and points to the first is providing redundant information. The only potential benefit is grouping and curation, which I would then argue should still point to the version control and/or a specific release as a source of truth.

I'm also not convinced that we have established an actual use case of "searching a registry for software." What happens in labs and communities is that you establish communities around the software, and then there are established workflows or slack communities or GitHub organizations to join around that. Most labs already have chosen languages, and even software pipelines that new members extend or work on. I would even go as far to say that for some (myself included) I don't find research software, but it finds me. It appears as a link in some social media or chat channel, and I click the link and then there are about 15 seconds during which I make a determination if the software can help me to solve a problem that I have, or if it looks easy, professional, and/or fun and I simply want to try it out. If the answer is "yes" then I add it to a list in a Google Document with other things to try out when I have time. If not, I close the lab and life moves on. But I want to point out that nowhere in this workflow do I explicitly go looking for software. The software often finds me, and then I keep a mental cache of "tools that I've seen" and go back to it when the use case arises.

So being able to answer this question about wanting research software registries is especially challenging because I'm not sure I've ever wanted one.
Unless there is a specific kind of context around a registry (e.g., search for a specific name in a package manager to use, or look for an already assembled workflow) I haven't been able to convince myself (yet) that I would find a use for one. I could be wrong about this, however, because as we know, people (myself included) are fairly bad at predicting the future, and perhaps there could be some future where "checking a research software registry" is a part of a daily workflow. I am skeptical because I think that a context is needed. Even if some central source of software ability truth was established, would it not be the case that a graduate student or researcher needs to go there with a use case or context in mind? I can't imagine just mindlessly browsing for the sake of browsing. It's akin to search engines - we are usually looking for something very specific. We don't search without a purpose. The question here then is, what is the purpose?

## Research Software Registries with a Purpose

A very good example of purpose comes down to workflows. This is the "I need to perform this specific function and I want to use what many others have done before me and not re-invent the wheel." The minimum example of a workflow registry would be a search interface that indexes pipelines that are perhaps stored in version control. And extended version of that includes being able to provide structured inputs, outputs, and arguments, so the registry can programmatically provide this information to tools. You can then also quickly see how changing this to be general inputs/outputs of software (and functions within) and entrypoints of containers can quickly become a more generalized registry for software that could be used by any workflow manager that knows how to consume its information. However, there is a fine line here, because when we talk about I/O we are going
squarely into workflow management territoty, and again in my opinion, we have to be careful about that scope. The closest thing that comes to mind for providing workflows as a service is something like <a href="https://openneuro.org/" target="_blank">openneuro</a> that has a beautiful idea of "Get your data into this standard format and we will serve it and provide other easy ways to analyze it." This kind of success story tells me that perhaps there is something to say for developing anything related to processing or pipelines in the context of a community. You can't create the perfect registry for every scientific discipline, or perhaps you can do a mediocre job at trying, but perhaps if you scope to a specific one you can do a very good job. I've found the same to be true with software - it's often better to do one or few things very well than more things kind of mediocre.

### A Provider of Identifiers?

I'm skeptical when I hear that people want to apply our traditional model of publication (e.g., having a DOI) to software. The reason isn't because I don't value means to support reproducibility (and knowing the exact version of something that was used) but rather that we already have means to tag specific versions of software, and means that fit into a well-established ecosystem: package managers, versions, and releases. To think that a single frozen version of software is "the correct unit to provide" I also disagree with. Software is a living, and changing entity, and when it truly does "freeze" and stops being worked on, unlike a DOI in the academic space, this is sort of its death. The correct entrypoint for a piece of software, in my opinion, is the current version on version control, from where you could decide to pin a particular release or install a particular version from a package manager. But to provide a single frozen DOI that is wrapping some other version / release of the software? It doesn't make sense to me. It's adding additional complexity that's not needed. So my opinion (as I've shared before) is that we should be thinking more about preserving specific timepoints in package managers, and not adding on an artificially created layer of "DOI" that seems (in my opinion) more of a reflection of our need to shove things into an academic framework we are comfortable with than anything else.

So (I hope) that the purpose of a research software registry would not just be to provide DOIs. That doesn't help me get my work done at the end of the day. All that said, I don't think there can be a singular answer for purpose. I think the purpose ultimately comes down to the institution (or community) and the specific goals of the registry. For this reason there is no one answer for what a registry should look like or provide, and it is (or will be) challenging to define attributes that "any registry should have." 

### What is my purpose?

<iframe width="560" height="315" src="https://www.youtube.com/embed/X7HmltUWXgs" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

_You cut butter_!

Just kidding :_) I've been ruminating on this idea for quite some time, and namely because I'm motivated to build a new kind of research software registry, but first I need to convince myself of a meaningful purpose. While I don't have my convincing answer yet (but I do have a sense of direction) the way I've been thinking about this is to provide a set of questions or use cases that seem plausible. It seems like most people are asking "What kind of information should we have in a registry" but I think this isn't exactly the question I'm interested in - I want to know:

> What do you want to do next with the software you find?

This is important because it's going to drive the context and purpose of the registry. Here are a few examples:

<ol class="custom-counter">
  <li><strong>I want to quickly try this out</strong> → a registry that can deploy a developer environment</li>
  <li><strong>I want to find if this is in a package manager</strong> → a reproducible install</li>
  <li><strong>I want to use this with a workflow manager</strong> → this is some kind of workflow hub</li>  
  <li><strong>I want to see inputs / outputs / entrypoints</strong> → support to workflow tools</li>  
  <li><strong>I want to install this on HPC</strong> → I want a module deployment or similar</li>  
  <li><strong>I want to cite this</strong> → use case akin to CITATION.cff</li>  
  <li><strong>I want to understand dependencies of an ecosystem</strong> → a registry deploying something akin to citelang</li>  
  <li><strong>I want to see all my options to do X</strong> → a domain or categorical registry</li>  
  <li><strong>I want to see new and noteworthy libraries</strong> → a registry with advanced filtering and ranking</li>  
  <li><strong>I want to see change over time</strong> → a registry with a layer of analysis tools</li>  
</ol>

Indeed many of the above contexts require additional information. For example, if we want to be able to ask what software is specifically used to perform X, we need a set of functions that are common to a domain, and then to annotate specific software (or even functions) that do it. If we want to then ask "Which of these is the best?" we need to then generate benchmarks to measure this functionality. E.g., how long does it take to run? What are the inputs and outputs and are they correct? What are resource needs? It would be an incredibly cool thing to be able to ask these questions, but an enormous amount of work for any particular scientific domain. As an example of thinking about functional needs, we might look to brain imaging, which is arguably a subfield of neuroinformatics. We might define custom processing functions like thresholding, registration, normalization, or creating regions of interest, tag specific functions that can do each, and then collect and share metrics about the degree to which easy is successful to do each. Arguably, if I wanted to do this I would create wrappers to workflow managers (akin to Snakemake Wrappers) that not only measure metrics, but make it easy for people to quickly use it in their work.

## It needs to be easy

Whether I'm thinking about being a user of a research software registry or a developer, it just needs to be easy. Here are some ideas around that.

### Re-inventing the wheel?

I come with the experience of deploying a custom container registry (Singularity Hub) years ago, and then being involved in standards committees (the Open Container Initiative) that develop generalized specifications that now drive the most common software (container) registries. I've also developed registry proxies that do interesting things, along with a Python OCI registry, and I'm the main developer for oras-py (ORAS == OCI Registry as Storage). So believe me when I say that in terms of storing blobs and metadata about them, I don't think we should re-invent the wheel. Any new registry I create is going to start with these standards. You might disagree, and that's OK. But I think people have thought long and hard about these things, and we are stronger for working together on them over always making our own new thing.

As a supplement to that, I want to point out one of the biggest challenges in our community. The majority of research software, I would argue, doesn't get used beyond the lab it's created for. Said lab might submit or include it in a paper, and then they get their publication and move on. This is reflective of many things, and I'll review them here. The first is our funding model - we maybe can fund working on a piece of software only up until the funding dries out, and then it becomes an abandoned repository, if it's made publicly available. The second is our incentive model - the academic community is focused on writing papers, so once you get there, you don't have reason to consider the long term impact of the software. The third is communication. It is actually much easier to throw together your own library than to have to search and then try contributing to someone else's.
I say this because I don't think the way that things are are necessarily the fault of anyone - we are all agents responding to incentives and resources available. 

But then on the flip side - these observations beg to ask what leads to software that is successful, on a community level? I think a few things can happen. Either someone puts time and energy into establishing community, period, meaning bringing together people that are working on common goals and explicitly asking "How can we do this together," or what I've seen with more commercial open source - having enough money or power that you can create strong branding and community just by way of having the funds for it.  I've talked about this a <a href="https://vsoch.github.io/2019/transparency/" target="_blank">few times before</a> and it's not necessarily bad, but it's unfair at best. Software that maybe would not be successful by its own merit rises to the top, and really great software that doesn't have those resources does not. That said, I've also seen sort of mediocre software get much better and earn its reputation, so I can't say it's a completely wrong dynamic.

### Is the answer Mooooar Metadata?

As we design the "perfect set of information" we want provided for any piece of software, we need to put people first.
We have to ask ourselves what are people willing to do, and generally people aren't wanting to spend inordinate amounts of extra time defining metadata or inputs/outputs for their custom scripts. This was a point also brought up by <a href="https://twitter.com/orchid00" target="_blank">Paula</a> in the SciCodes meeting and I am 100% behind it. If we require extensive metadata about software, it needs to be done in an automated fashion. In practice when I think of archives for software, I'm just not that motivated to provide more than the absolute minimum to click the "submit" button.

## Do people know what they want?

One of the hardest things about this kind of problem is that people don't often know what they want. 
And actually - I'd extend that to software in general. Think of common tools like git (version control) or containers.
Could most people have told you in advance about the designs for these tools? I suspect likely not.
This is often the game that software developers play - we imagine new ways of doing things that scratch an itch
or have a problem that we have, and then hand over our duct taped laden prototype to others and we're  like
hey, is this useful to you? And often the response in radio silence, but then sometimes it's a resounding, "WoW, yes!"
So I'm going to throw out this idea that people generally don't know what they want until they see it, touch it and try it.
This is also why I want to inspire you to take some time to think about your specific needs and motivation for wanting
(on a high level) to browse and interact with research software. What are the compelling reasons for this registry,
for you?

This is actually really fun to think about, because what even is a research software registry? 
Is it a place to find software to plug into workflows? Does it provide ABI or more general function signatures to help you plug into workflows? Does it provide a citation? A container? An interactive environment? Dependency graph? Something else? This is inded why this problem is so hard - there are so many ways to thinkabout this basic concept. And that's kind of what makes it fun too? But also what makes it hard. Personally speaking sinceI'm more interested in building things I find myself ruminating about details for a specific use case. And since I'm a developer and craving better support for developer environments, this tends to be where my brain goes. And have you noticed I haven't given
a direct answer for what is a research software registry? It's 1. because I don't know, and 2. because we are trying to define a registry for a kind of output that we don't even have an agreed upon definition for yet! So perhaps the definition will happen on the level of the deployment or institution? Anyway, I hope you take the opportunity to discuss with your peers, pets, and even yourself, to try and answer this question.

## Summary

To summarize, I'm spending a lot of time thinking about this, and less in an "I'm an academic that wants DOIs and metadata" and more in a "I am a software engineer that wants to build something that I actually find useful." Might I scratch itches along the way? Sure. And I do have some early ideas that I plan to hack on before sharing publicly. In the meantime, I do hope you are interested in some of these ideas and take time to write or introspect yourself.

And on a higher level, I really like this format of writing and speaking, where the speaking isn't formal enough to be a talk that you put together and practice for weeks (I put this all together in an afternoon) but it still is a media format that literally gives a voice.
