---
title: "notes-jekyll"
date: 2020-11-28 12:30:00
---

Efficient work is arguably the result of process. When we can identify patterns of how we think, solve problems,
or create software, we can more easily attach to those threads to make it faster the next time around.

> But what happens if we don't have a routine?

As someone who is heavily routine based, when I don't have one to match my task at hand, I freeze.
It's not a "deer in headlights" sort of freeze, it's more of a careful refactoring of the routines that I
know well, and figuring out what is missing, and needs to be developed. We cannot move on to a step 2 
without a mental organization plan to decide on step 1.

This happened to me recently when I decided that I wanted to take notes. I had the base structure
of the content I wanted to understand set up - a folder of papers (PDFs) alongside a list of references (BibTex).
As I started to read them, I had an almost compulsive desire to start organizing information. I logically
started to take notes, first in an email to myself, and then a standard Google Doc. But how would I easily
link these notes to the papers? How could I quote a specific paper? And more importantly, how could I
easily collaborate with others and render the entire thing into an interface that is easy to search and
explore? I couldn't continue, because there was too much in my head that needed to be properly organized
and made beautiful, and I didn't know how to do it.

> I want to write it down, and for it to be pretty.

I'm a fairly simple creature. I want things to be organized, and I want them to be pretty.
I want some future me to discover an old set of notes and have a holistic picture of
what past me was thinking.

## Notes-Jekyll

Looking for organization and beauty, I created the project <a href="https://vsoch.github.io/notes-jekyll/" target="_blank">notes-jekyll</a>.
My goals were the following:

<ol class="custom-counter">
  <li>Have BibTex references rendered automatically on the site</li>
  <li>Be able to insert citations into Markdown anywhere I like</li>
  <li>Be able to click from a reference a link to read the PDF, or see details</li>
  <li>Search across and categorize all my content</li>
</ol>

While I spent some time looking at many partially free or paid-for PDF annotation tools,
I decided that annotating a PDF directly would set me up for a more challenging future
to figure out how to extract the annotations. At best, it might be ideal for someone else
to print the PDF with my notes and read on, I don't know, an airplane? 
I also considered LaTeX, but some people don't like it. I decided to opt for
the simplest solution, and one that I'm already doing. I enjoy writing in Markdown, and it's
the bread and butter of GitHub pages, so it just made most sense. For the remainder of
this post I will review how notes-jekyll works.

### How does it work?

#### Overview

This is a Jekyll template optimized for taking notes in Markdown to render into an
organized interface. This means that you can:

<ol class="custom-counter">
<li>Add references to `references.bib` and papers to the `papers` folder.</li>
<li>Create pages with notes and automatically render and cite references on any page.</li>
<li> Push to the main branch and trigger a build for GitHub pages</li>
<li>Search or otherwise interact with the interface</li>
</ol>

Since we use a plugin that is not supported on GitHub pages, this means that
the template comes with a <a href="https://github.com/vsoch/notes-jekyll/blob/main/.github/workflows/build.yml" target="_blank">GitHub Action</a> 
to build and deploy the site after merge into main (or your branch of choice).
I also assume that you might not want to install all the ruby/jekyll dependencies,
and provide a <a href="https://github.com/vsoch/notes-jekyll/blob/main/Dockerfile" target="_blank">Dockerfile</a>
to build and render the site for you. All you need is a text editor, and the interface
running on localhost updates with changes.

#### Home

We can assume that if you are navigating to the front page, as a note taker you might
quickly want to see your references and open a PDF, and as a reader you might want to see
posts available, or how to get started. This led to the home page that you see below:

<br>
<a target="_blank" href="https://vsoch.github.io/notes-jekyll/">
<img src="https://raw.githubusercontent.com/vsoch/vsoch.github.io/master/assets/images/posts/notes-jekyll/home.png">
</a>
<br>

Above, we see that references are front and center, and each links directly to a PDF. Our
rendered notes are top and center, albeit we don't have too many pages becaues this is a dummy
"Lorem Ipsum" site.

#### Collaboration

By way of serving references and notes on GitHub pages, this makes it possible
to collaborate on taking notes, or creating a space of knowledge for your project
or group. The Jekyll <a href="https://jekyllrb.com/docs/posts/" target="_blank">posts</a> map 
to notes pages, meaning that you can create a page for each topic, and then easily cite and reference pages in each.
Posts were chosen to allow for sorting based on date, however you could also easily
implement them as a Jekyll <a href="https://jekyllrb.com/docs/collections/" target="_blank">collection</a>.
Tags and categories are also useful to group knowledge. For example, I would use tags to indicate authors,
working groups, or other developer relevant metadata. I would use categories for higher level topics
about what I'm discussing (e.g., <a href="https://vsoch.github.io/notes-jekyll/registration" target="_blank">registration</a> in the example post).

<br>
<a target="_blank" href="https://vsoch.github.io/notes-jekyll/registration">
<img src="https://raw.githubusercontent.com/vsoch/vsoch.github.io/master/assets/images/posts/notes-jekyll/registration.png">
</a>
<br>

#### References

It was important to me that the user be able to just edit / interact with a BibTex references
file and folder of papers and not care about the interface or notes. For this reason, I designed
the site around that idea - the rationale being some of your colleagues might just want to 
add and/or read papers. But for those that do want to take notes, it comes down to writing
Markdown files under `_posts`, which will render into a page of notes. Any reference
that you add to your references file will automatically render on the home page,
and can be easily read from here or referenced in any page. How does that work?
Well, let's say I have this reference in my `references.bib` file:

```bibtex
@article{metz2011nonrigid,
	author = {Metz, CT and Klein, Stefan and Schaap, et al.},
	journal = {Medical image analysis},
	keywords = {groupwise registration},
	number = {2},
	pages = {238--249},
	publisher = {Elsevier},
	title = {Nonrigid registration of dynamic medical imaging data using...},
	volume = {15},
	year = {2011}
}
```

I could cite it in any Markdown page doing the following:

```
{% raw %}{% cite metz2011nonrigid %}{% endraw %}
```

I could also reference a particular set of pages or lines:

```
{% raw %}{% cite metz2011nonrigid --locator 23-5 %}{% endraw %}
```

Or quote text, verbatim. 

```
{% raw %}{% quote metz2011nonrigid %}
Lorem ipsum dolor sit amet, consectetur adipisicing elit,
sed do eiusmod tempor.

Lorem ipsum dolor sit amet, consectetur adipisicing.
{% endquote %}{% endraw %}
```

And then I could include the references that I've cited at the bottom like this:

```
{% raw %}{% bibliography --cited %}{% endraw %}
```

You can remove the `--cited` to include all references, regardless of being mentioned or
not. The output might look like this - we can see a few references in the last section!
All references link to a reference in the bibliography at the end:

<br>
<a target="_blank" href="https://vsoch.github.io/notes-jekyll/registration">
<img src="https://raw.githubusercontent.com/vsoch/vsoch.github.io/master/assets/images/posts/notes-jekyll/references.png">
</a>
<br>

Each of which has a link to the PDF in my papers folder!

<br>
<a target="_blank" href="https://vsoch.github.io/notes-jekyll/papers/strand2017concept.pdf">
<img src="https://raw.githubusercontent.com/vsoch/vsoch.github.io/master/assets/images/posts/notes-jekyll/pdf.png">
</a>
<br>

Likely we could spruce up the paper details page a bit too - right now it just shows
basic metadata and the original BibTex reference.

<br>
<a target="_blank" href="https://vsoch.github.io/paper-details/strand2017concept.html">
<img src="https://raw.githubusercontent.com/vsoch/vsoch.github.io/master/assets/images/posts/notes-jekyll/details.png">
</a>
<br>

#### Features

There are a lot of ways to easily customize the notes pages depending on the
<a href="https://jekyllrb.com/docs/front-matter/" target="_blank">Front matter</a>.
For example, we can define categories, tags, if we want to enable MathJax in the
page (to render equations), add a Table of Contents (toc) in the left sidebar,
or even render an interactive datacamp code editor:

```yaml
---
title: How to write notes
categories: [about]
tags: [jekyll]
datacamp: 1
maths: 1
toc: 1
---
{% raw %}
{% cite keyToReference %}

{% quote metz2011nonrigid %}
This is an example of a cited quote.
Lorem ipsum dolor sit amet, consectetur adipisicing elit,
sed do eiusmod tempor.

Lorem ipsum dolor sit amet, consectetur adipisicing.
{% endquote %}

<hr>

{% bibliography --cited %}
{% endraw %}
```

I recommend reading the <a href="https://vsoch.github.io/notes-jekyll/how-to-write-notes" target="_blank">How to write notes</a>
page for the list of many examples for different formatting.


## Overview

I now have a plan for taking project specific, version controlled notes, where
I can easily assemble an army of references, make citations in Markdown, and then
render to a beautiful interface. The possible benefits of this strategy are:

<ul class="custom-counter">
  <li>Collaborative note-taking (via version control)</li>
  <li>Linking note references to the original PDFs</li>
  <li>Easily transferring notes to a paper when ready</li>
  <li>Having a nice interface to explore!</li>
</ul>

To go back to the original conundrum, I now have a strategy for being able
taking notes that are organized and pretty. Of course this is subject to change -
I expect some things to work well, and others not, and I'll adjust based on that.
If you have any questions or want to request a feature, please don't hesitate
to [open an issue](https://github.com/vsoch/notes-jekyll/issues), or browse the
[repository](https://github.com/vsoch/notes-jekyll). 
