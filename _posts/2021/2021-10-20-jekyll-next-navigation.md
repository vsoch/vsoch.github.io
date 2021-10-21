---
title: "Automatic Jekyll Navigation"
date: 2021-10-20 21:30:00
category: rse
---

One thing I'm quite lazy about is wanting to update navigation. There are several approaches I've taken in 
the past to handle this, the most labor intensive being maintaining several (possibly related) navigation
menus via YAML files or directly in Jekyll's ``_config.yaml``. For individual files that aren't posts
or part of a logic collection, this often means manually defining the ``permalink:`` attribute, which can
also get tiring. 

When I designed <a href="https://vsoch.github.io/docsy-jekyll/" target="_blank">Docsy Jekyll</a> (and note that by "design" I mean write the logic for the Jekyll site, the design itself is done by the authors
of  <a href="https://www.docsy.dev/" target="_blank">the original Docsy</a>) I did an intermediate approach -
I had a few upper levels of links "hard coded" in the sidebar (via YAML) and then for any content in ``_docs``, by
way of being a collection, they would general URLs that logically corresponded to their organization. For example:

```
_docs/
├── ci-cd
├── compilers
├── containers
│   ├── docker.md       (- /docs/containers/docker
│   ├── docker
│   │   └── getting-started.md  (- /docs/containers/docker/getting-started
│   ├── subpage         (- /docs/containers/subpage
│   └── singularity     (- /docs/containers/singularity
```

This was annoying, of course, because instead of doing this to define an "index.html" equivalent:

```
_docs/
├── ci-cd
├── compilers
├── containers
│   ├── docker
│   │   ├── index.md       (?? /docs/containers/docker/
│   │   └── getting-started.md  (- /docs/containers/docker/getting-started
```

I had to do what I showed above - a docker.md alongside the docker folder. But I could actually use a ``permalink`` to get around that if I wanted.
But I digress! With the organization above, I had a fairly auto-generating site, and although I had a few "summary" or top level pages to loop through all links, I still largely had to link from page to page. That was tiring.

## Automatic Generation of Direct Child Pages

It occurred to me that given the structure of the url, I could easily derive pages that were children of other pages,
and then at the bottom of each page, automatically provide navigation to any page on the next level. For example, if I have these pages:

```

/docs/
/docs/containers
/docs/containers/singularity
/docs/containers/docker
/docs/containers/docker/tutorial
/docs/ci
```

When I'm at the root, `docs`, I'd only want to see links to 

```

/docs/containers
/docs/ci
```
When I navigate then to `/docs/containers` I'd only want to see:

```

/docs/containers/singularity
/docs/containers/docker
```

You get it. This seems obvious in retrospect, but I don't see if often on Jekyll sites!
So the easy logic is that when we are looping through pages in docs, we do a comparison
to a potential "next page" and the current page. We check:

<ol class="custom-counter">
  <li>Is the contender page url included in the current url?</li>
  <li>Is the nesting of the contender page the current nesting + 1?</li>
</ol>

For the first point, you can easily just check if the contender page url contains the current page url.
E.g., "/docs/containers/docker" contains "/docs/containers" and therefore should be included.
And for the second, we basically do a bunch of splitting and counting of slashes.
In case this is useful for anyone else wanting similar functionality, here is what I came up with.


```html
{% raw %}
<h3>Read Next</h3>
{% assign page_url = page.url | replace: "index", "" | split: "/" | join: "/" %}

<!-- We compare lengths - the next level should be current +1.-->
{% assign current_level = page_url | split: "/" | size %}
{% assign next_level = current_level | plus: 1 %}

<div class="section-index">
  <hr class="panel-line"><div class="card-columns">{% for doc in site.docs %}
   {% assign doc_url = doc.url | replace: "index", "" %}
    {% unless doc.url == page.url %}
    {% assign comparison_count = doc_url | split: "/" | size %}
    {% if next_level == comparison_count %}{% if doc_url contains page_url %}
    <div class="card next-card">
    <h5><a href="{{ site.baseurl }}{{ doc.url }}">{{ doc.title }}</a></h5>
      <p>{{ doc.description }}</p>
    </div>
    {% endif %}{% endif %}{% endunless %}{% endfor %}<br>
</div>{% endraw %}
```

Mind you that how you render your pages is up to you - I have little cards that include titles and descriptions.
The result looks something like this:

<div style="padding:20px">
  <img src="{{ site.baseurl }}/assets/images/posts/rseng/example-1.png">
</div>

And the example we talked about:

<div style="padding:20px">
  <img src="{{ site.baseurl }}/assets/images/posts/rseng/example-2.png">
</div>

Just a tiny thing - but if this is useful to you, I'd like to help! Happy Jekyll-ing!
