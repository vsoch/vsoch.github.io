---
title: "Jekyll, this is the Last Comma!"
date: 2019-01-28 7:12:00
categories: rse
---

This is a quick solution for a problem I've run into countless times when
I'm trying to loop through an (unspecified length) of static files for
a [Jekyll site](https://jekyllrb.com), and I'm rendering some listing into a JSON list.

## The Problem

The problem is the trailing comma. It needs to be there for items 1 through N-1. but
for item N, nope, you can't put a comma after the final item in the list. That isn't
valid json. For example, let's say that I'm looping through these items:

 - vanessa/greeting/README.md
 - vanessa/greeting/manifests/latest/README.md
 - vanessa/greeting/manifests/boogers/README.md
 - vanessa/goodbye/manifests/latest/README.md


<br>

And I'm only interested in the paths that start with `vanessa/greeting/manifests`. 
If I were just looping through a list, and including all items, I could do this:


```
{% raw %}
{% for item in site.pages %}
    {% if item.path contains "vanessa/greeting/manifests" %}
        {{ item.path }}
        {% if forloop.last %}{% else %},{% endif %}
    {% endif %}
{% endfor %}

{% endraw %}
```


Notice the {% raw %}`{% if forloop.last %}{% else %},{% endif %}`{% endraw %}? That ensures that the last
entry in the loop doesn't have a comma. Given that I can include all items in the list 
(meaning they all pass the if statement, or if I don't have an if statement at all:

```
{% raw %}
{% for item in site.pages %}
    {{ item.path }}
    {% if forloop.last %}{% else %},{% endif %}
{% endfor %}
{% endraw %}

```

It would render beautifully. In the context of rendering json, we might see:


```json

{
    "tags": [
       "vanessa/greeting/README.md",
       "vanessa/greeting/manifests/latest/README.md",
       "vanessa/greeting/manifests/boogers/README.md",
       "vanessa/goodbye/manifests/latest/README.md"
    ]
}

```

But wait a minute, given that the last item in 
the list (`vanessa/goodbye/manifests/latest/README.md`) doesn't match the if statement,
that means that we will ultimately render the actual last item as 
`vanessa/greeting/manifests/boogers/README.md`, and our list will end with a comma!


```json

{
    "tags": [
       "vanessa/greeting/manifests/latest/README.md",
       "vanessa/greeting/manifests/boogers/README.md",
    ]
}

```


The above rendering is all wrong, because the last item we loop through 
(the one with goodbye) isn't the last rendered, so the logic to
not add the comma to the last fails. We've already rendered N through N-1 and
we added the commas. So instead we get the monstrosity above.
It needs to be this (notice the last comma is removed):


```json

{
    "tags": [
       "vanessa/greeting/manifests/latest/README.md",
       "vanessa/greeting/manifests/boogers/README.md"
    ]
}

```

What I've tried before is just to accept that I can't control the last item, and instead
of checking for it, just add an empty one. Something like:


```
{% raw %}
{% for item in site.pages %}
    {% if item.path contains "vanessa/greeting/manifests" %}
        {{ item.path }},
    {% endif %}
{% endfor %}"" 
{% endraw %}
```

Notice the extra set of quotes on the end? That would render our list into something like:

```json

{
    "tags": [
       "vanessa/greeting/manifests/latest/README.md",
       "vanessa/greeting/manifests/boogers/README.md",
       ""
    ]
}

```

This is also valid json, but it's a crappy solution.  What happens when your client
parses the empty string in the list?

## The Hack

The hack is that I generate a string of (comma separated) items beforehand, remove
the last comma by appending some nonsense and them removing it with a comma, and then generate
the final list by splitting the string by a comma. It's fairly stupid and simple, but it works!
Here is the full example that I was working on for a recent project. The goal was to render this
endpoint:

```

$ curl https://singularityhub.github.io/container-storage/vanessa/greeting/tags/
{
  "name": "vanessa/greeting", 
  "tags": [
    "latest"
   ]
}

```

which without the hack, was showing up like this:

```

{
  "name": "vanessa/greeting", 
  "tags": [
    "latest",
   ]
}


```

I'll separate this out into lines so you can more easily read it.

```
{% raw %}
# Create an empty variable string variable, tags
{% assign tags = "" %}

# For each page in the site, filter to those with a particular variable path
# manifests -> vanessa/greeting/manifests
{% for item in site.pages %}
 {% if item.path contains manifests %}

  # When we find a match, parse out the tag name from the path
  {% assign name = item.path | remove_first: manifests | remove: "/README.md" %}

  # Add quotes around it, because we will be rendering json
  {% assign name = '"' | append: name | append: '"' %}

  # Update our tags variable by appending the new name to it
  {% assign tags = tags | append: name | append: "," %}

 {% endif %}
{% endfor %}

# Finally, append arbitrary nonsense so we can remove it with the trailing comma!
{% assign tags = tags | append: "-@" | remove: ",-@" %}
{% endraw %}
```

The idea above is that we can create a string of comma separated tags, and then
remove the last one by appending some nonesense and removing it from the string 
(along with the trailing comma). Finally, I used it like so to render the endpoint.

```
{% raw %}
 "tags": [
    {{ tags }}
   ]
}
{% endraw %}
```

You could also then split the list based on the delimiter (a comma) and loop through
it as you would before, but this time all the entries are meant to be used or rendered:

```
{% raw %}
{% assign taglist = tags | split: ', ' %}
{% for tag in tags %}
    {% tag %}
{% endfor %}
{% endraw %}
```

And the final compressed nonsense [is here](https://github.com/singularityhub/container-storage/blob/master/_layouts/tags.html).
You could modify this general strategy of parsing content into (some delimiter)
separated string, appending a special character to indicate the end, and then
removing the junk from the end based on that special character. Finally, you can split
based on the delimiter and have a nice list for looping through, or rendering. The use
case that I am doing this for is a static RESTful API, but I imagine that there 
are use cases beyond this. On the other hand, this might just be one of those problems that only I'll ever run into, that
keeps me up at night. Oh Liquid Front Matter, you are so weird.
