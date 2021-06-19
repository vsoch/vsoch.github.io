---
title: "RFC Jekyll"
date: 2021-06-18 22:30:00
category: rse
---

As software engineers we often have to make choices between ideal states.
For example, modular development can better assign responsibility, and make
development more scoped and thus easier to do. But what are the drawbacks?
It could be that choosing a modular approach means that it's harder to bring
things together -- things such as documentation, or in some cases, even community.
But really I'm thinking about the first, because recently I've been crafting a plan
to better contribute to the <a href="https://github.com/opencontainers" target="_blank">Open Containers Specifications</a>.
We've assembled a group of talented container enthusiasts, and while we are discussing many 
<a href="https://supercontainers.github.io/containers-wg/" target="_blank">interesting ideas</a>,
during our discussion it keeps dawning on me that it's really hard to keep track of things.
What do I mean? Well, I keep hearing the same story:

> Is that part of the spec?
> Where does it say that?

The issue is that each single specification is stored in multiple markdown files, and you have to jump
between files and even repositories to find what you are looking for. This might be okay
if you know exactly where to look and have a strong understanding of the belonging of files
(e.g., knowing if a linked markdown is part of the spec or just a reference) but for a new 
contributor, it's akin to being lost in the markdown wilderness.

### RFC Jekyll

Early in our discussions, <a href="https://github.com/reidpr" target="_blank">@reidpr</a>
had a fantastic idea.

> I’d love consolidation of the standard into a single coherent document, e.g. RFC style.

I quickly <a href="https://github.com/supercontainers/containers-wg/issues/9" target="_blank">opened an issue</a>,
and by chance the topic of being able to share spec content was brought up at the next OCI meeting.
I <a href="https://hackmd.io/El8Dd2xrTlCaCG59ns5cwg#Notes1" target="_blank">brought up</a>
the idea and it wasn't rejected, so I got to work! This is thus the creation of the rfc-jekyll template.
When you arrive at the root, you can choose to view a specification:

<div style="margin:20px">
 <img src="https://raw.githubusercontent.com/vsoch/rfc-jekyll/main/assets/img/rfc-jekyll.png">
</div>

And then browsing to the specification shows content in the center, a left side navigation with
other files that are defined for the spec, and the right side is a dynamically generated
navigation.

<div style="margin:20px">
 <img src="https://raw.githubusercontent.com/vsoch/rfc-jekyll/main/assets/img/runtime-spec.png">
</div>

The content from the many different specs and files are retrieved across files and GitHub repositories
for a holistic, cohesive experience. I find this much easier to navigate than the spec markdown files 
on their own.

#### Design

I wanted to emulate the style of a modern <a href="https://www.rfc-editor.org/rfc/rfc8843.html" target="_blank">RFC memo</a>,
but rendered totally dynamically. I also wanted to add some nice features, like being able to click to quickly open
a link to edit the document, or open an issue. For the use case of Open Containers, I wanted to render content 
not only from the repository that served the template, but from multiple repositories across GitHub! For
the design that I am prototyping:

<ol class="custom-counter">
<li>You can combine many different resources across multiple repos to look like one holistic documentation base</li>
<li>Content is retrieved dynamically directly from the specs and you don't need to rebuild.</li>
<li>Every section of a spec page has a permalink, and the page has a direct link to edit on GitHub or open an issue.</li>
<li>Adding new pages comes down to adding metadata for the pages you want.</li>
</ol>

I won't go into details of the template, because if you are interested you can read about it
<a href="https://github.com/vsoch/rfc-jekyll" target="_blank">here</a> and see the preview
<a href="https://vsoch.github.io/rfc-jekyll" target="_blank">here</a>.

#### Questions for you!

Primarily I'm interested in feedback from the community for the following questions:

<ol class="custom-counter">
<li>Would it be useful to still render content from local files?</li>
<li>What kind of supplementary pages would be useful to go alongside specs (e.g., working groups, ideas, loose images?)</li>
<li>What other features would be useful to have?</li>
</ol>

And of course please <a href="https://github.com/vsoch/rfc-jekyll/issues">report any issues or bugs!</a>.
I made this is evenings over a few days, and I consider it early in development. 

### Summary

And that's all I got! I hope that you take a look and can give feedback to make it better.
I've made <a href="https://github.com/supercontainers/containers-wg/discussions/34" target="_blank">a GitHub discussion</a>
if you want a more formal discussion board other than issues.
