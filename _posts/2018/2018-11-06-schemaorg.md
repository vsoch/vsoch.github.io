---
title: "Container Metadata with Schema.org"
date: 2018-11-05 6:30:00
toc: false
---

Container discoverability is a problem. I should be able to do a search (somewhere, how about
Google?), and find what I'm looking for. There must be a webbing of metadata that can
span Github repositories, container registries, and pretty much any webby place where a
container might be found to help with this. I've had vision for how this could work
using already existing things, and working dilligently to exemplify it. First, let's 
talk about what I wanted to do.

<br>

# A Vision for Discoverability

I want to define a "Container," meaning the Image and build recipe / specification 
(insert your favorite word for a text file here) in schema.org so that we
can then discover and query the (currently) expansive and disorganized universe of 
containers. This comes down to:

 - [1. Container Definition in Schema.org](#1-container-definition-in-schemaorg)
 - [2. Programmatic interaction with schemas](#2-programmatic-interaction-with-schemas)
 - [3. An Example Implementation](#3-an-implementation)
 - [4. Deployment](#4-next-steps)

<br> 

The definition of a container (step 1) in schema.org means that we can programmatically (step 2)
tag them, have it done automatically for single container registries and repositories (step 3)
and then have these metadata embedded in html pages to be discovered by search, akin
to how [Google Datasets](https://developers.google.com/search/docs/guides/search-features) work.

<br>
<hr>

## 1. Container Definition in Schema.org

[Schema.org](https://www.schema.org) is an ontology, or description of entities and relationships between
them, that attemps to describe kinds of things in the world, literally from
type [Thing](https://schema.org/Thing) to type [Volcano](https://schema.org/Volcano). The value
isn't necessarily being able to define a list of attributes for any one thing, but for
being able to make inferences over the graph, and answer weird questions about how
types of <strong>thing1</strong> and <strong>thing2</strong> relate to one another. Thus, a container definition in schema.org
comes down to defining representations for Containers in this graph. I want to know how my
Container recipe (Dockerfile) relates to Volcanoes, for example. 
While imperfect, after [early discussion](https://github.com/schemaorg/schemaorg/issues/2059) 
with schema.org, I went to the OCI community for some hard core expertise, and I came up with an 
[early proposal](https://openschemas.github.io/spec-container/):

```

Thing > ContainerImage
Thing > CreativeWork > SoftwareSourceCode > ContainerRecipe

```

While the name "ContainerRecipe" is up for change with many 
[good ideas](https://github.com/openbases/extract-dockerfile#why-should-i-care) from the 
OCI list, the general idea and organization is presented. If you are interested in
rationale for this proposal, I summarize it [here](https://github.com/openschemas/specifications/pull/9).
If you want to jump back in on the OCI thread, you can do that [here](https://groups.google.com/a/opencontainers.org/forum/#!topic/dev/vEupyIGtvJs).

<br>
<hr>

## 2. Programmatic interaction with schemas

Great! We have a nasty looking yml or json-ld, but I'm a software developer. What am 
I going to do with that?  I will again present this as a list of use cases. People
in this industry / academic world seem to talk about these "use cases" a lot.

<br>

**What are we trying to do again?**

The high level goal is to make it easy to tag datasets, containers, and other software to
be accessible via Google Search as a [dataset](https://developers.google.com/search/docs/data-types/dataset)
(or similar as Google develops these search types) or programatically via an API. This means that:

<br>

**If I'm a researcher**

<ul>
<li>I can search Google to find datasets or software of interest based on schema.org organization</li>
<li>I can use the corresponding search API to find a subset of datasets / software for my research</li>
</ul>

<br>

**If I'm a developer**

<ul>
<li>I can develop tools for my users to find content of a particular type</li>
<li>I can provide users with recipes to guide them how to extract metadata that I need for my tool</li>
<li>I can validate what they provide me with</li>
<li>I can build software that understands the categorization and organization of a particular type</li>
</ul>

<br>

For the last points, you can imagine validating a dataset contribution, and then
using the known organization to move it from some local to a cloud storage. You can imagine
writing software that expects a particular set of metadata, and then being able to programmatically
validate if it's been provided. You can also imagine the simpler use case - just <strong>having</strong>
the metadata to drive search and interesting analyses about your `thing1` and `thing2` of interest.
For my production use case, I would add some simple template rendering for [Singularity Hub](https://www.singularity-hub.org) containers so that there was a json-ld object for search to find, provided with each container.

<br>

**How do we interact with the schemas?**

I [asked schema.org](https://github.com/schemaorg/schemaorg/issues/2061)
about a Python client, and the answer was something like "well use rdflib" and then
it was tagged with "Good Question." I wasn't asking a question, I really wanted
a solution. And I wanted something a little simpler, and something that wouldn't require me to have expertise 
beyond what a typical data scientist or research might have (ahem, Python)! I wrote a 
[schmeaorg module](https://openschemas.github.io/schemaorg/) to accomplish these goals, and
I hope that others interested in this kind of interaction with the specifications might
contribute to what I've started. Briefly, I'll show you how easy it is to interact with a definition,
and see [here](https://openschemas.github.io/schemaorg/#Usage), for detailed walk-through and more robust examples.

```python

from schemaorg.main import Schema
softwareCode = Schema("SoftwareSourceCode")
```

```

Specification base set to http://www.schema.org
Using Version 3.4
Found http://www.schema.org/SoftwareSourceCode
SoftwareSourceCode: found 101 properties 

```
Add some properties...

```python
sourceCode.add_property('description', 'A Dockerfile build recipe')
```

You can optionally validate it against a recipe for some set of required properties
you need (not shown here) and then save the dumped metadata into just json, or
a json-ld template.

```python

sourceCode.dump_json()

```
```python

from schemaorg.templates.google import make_dataset
dataset = make_dataset(sourceCode, "index.html")

```

This was pretty cool! Now I could interact with schemas. Done. Moving on.

<br>
<hr>


## 3. An Implementation

Ok, good, we have specifications, and we have a way to interact with them, now we need
to create some example extractors! As another reminder the <strong>input</strong> here should
be some container recipe (we will use a Dockerfile) and the <strong>output</strong> should
be an html page with embedded json-ld of metadata. I came up with a 
[Github repository](https://www.github.com/openbases/extractor-dockerfile)
of example extractors toward this goal. Here is a [quick jump](https://openbases.github.io/extract-dockerfile/ImageDefinition/) to see an ImageDefinition, or an extraction from a Dockerfile to describe it!

<div>
<img src="https://vsoch.github.io/assets/images/posts/schemaorg/template.png">
</div><br>

The template is pretty, but the important part is to look at the "View Source"

<div>
<img src="https://vsoch.github.io/assets/images/posts/schemaorg/source.png">
</div><br>

Now, if only the Google bots could index this, we could easily generate the metadata
for tooons of places! You can  look at any of the [subfolders](https://github.com/openbases/extract-dockerfile/tree/master/ImageDefinition) in the repository to see the
extract.py, the recipe.yml, and in the case of a custom specification, a specification.yml
file.

```

$ tree ImageDefinition/
ImageDefinition/
├── Dockerfile
├── extract.py
├── index.html
├── README.md
├── recipe.yml
└── specification.yml

```

This metadata would go into an index so that the container recipe, wherever it's being
searched, would have its metadata indexed by a search engine. Because a massive search
engine can do eons more for discoverability than any single website or registry. Help
us OOgly-one-canGoogley, you're our only hope!

<br>

**Where would this be run?**

We could best run this with a continuous integration step, meaning that metadata for
a container is extracted with each change to it. We could also run it at build time
for a container registry, or an institution or user could use the software locally for 
research.  If you already have a container registry, then you can just render some of your
metadata into the page.

<br>
<hr>


## 4. Next Steps

I hope you see the next steps! For each of these, I hope that you can weigh in or help.
There is only one of me. It gets lonely a lot. I don't have a team, I just have Github
issue boards and random lists of developers. Give a dinosaur some support, and friends!
 We can do the following:

**Harden the schema.org specification.**

I had a meeting scheduled in September for October, and it was cancelled and rescheduled for January. 
I was really sad about this for a while, and then it motivated me to keep trying. I hope
that some day we can do better. The issue that I now opened almost 2 months ago
is [here](https://github.com/schemaorg/schemaorg/issues/2059). Please jump in!

**Decide on a name for the recipe**

As I alluded to earlier, we could call a recipe a ContainerRecipe, an ImageDefinition, a BuildPlan,
or pretty much anything else! To the community, how would you like to decide? Is
a vote the easiest way? Okay [let's do that](https://goo.gl/forms/0cd56mojQosp74D62). It's orange
for Fall / Halloween / November!

**Extract en masse!"**

This is what I've been wanting to do from day 1! Given the definition and a database of say, Dockerfiles
(I have a [Github repository](https://github.com/vsoch/dockerfiles) handy and in mind!") We can do an extraction en masse, and then better engage with Google tooling (or create our own) to answer questions like "How do I develop
search around this?" And then boum, containers are discoverable, done.

## Questions for You

Next steps also include contributing to the schemaorg module, if this is of your interest. What
other kinds of templates or features do you want to see? Please [reach out](https://github.com/openschemas/schemaorg/issues) and let me know.

 - <strong>Google</strong> - I want to make container search happen. Tell me what I need to do. 
 - <strong>Schema.org</strong> - how can I help you to improve your software base so that we can really take advange of all these Things? 
 - <strong>All</strong> - what kinds of tools do you want to see around discoverable containers? Where do you want to extract metadata for your containers, and/or serve it?

