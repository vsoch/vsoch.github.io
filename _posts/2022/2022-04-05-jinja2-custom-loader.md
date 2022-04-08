---
title: "Jinja2: Have your string and filesystem loader too?"
date: 2022-04-05 12:30:00
---

The other day I wanted to have my cake and eat it too! If you aren't familiar with 
<a href="https://jinja.palletsprojects.com/en/3.1.x/" target="_blank">Jinja2</a>
templates in Python, it's a syntax for rendering texty things. For example, if I have some
list of fruits in Python named "fruits" I can provide them to a Jinja2 template to (perhaps) render
them into an html list. That might look like this:

```bash
{% raw %}<ul>{% for fruit in fruits %}<li>{{ fruit }}</li>{% endfor %}</ul>{% endraw %}
```

Pretty cool right? If you've ever done anything with Jekyll or Django, you'll see a similar
syntax. Technically Jekyll uses <a href="https://shopify.github.io/liquid/basics/introduction/" target="_blank">liquid syntax</a>,
but they are similar. Now given that you are using jinja2 in Python, there are a few different
ways that you can provide content to load.

## Jinja2 Rendering

The first is arguably the most simple, and works well for quick snippets that don't
reference other snippets (more on that later) that you just want to quickly render.
Let's say we have "fruits.html" for the above, and then a list of fruits in Python.
We might do:

```bash

from jinja2 import Template

fruits = ["apple", "orange", "banana"]
with open("fruits.html", "r") as fd:
    template = Template(fd.read())

rendered = template.render(fruits=fruits)
```

Pretty simple right? We read in the file as text, pass it to `jinja2.Template` and the result will be 
something like:

```html
<ul><li>apple</li><li>orange</li><li>banana</li></ul>
```

or rendered as html:

<ul><li>apple</li><li>orange</li><li>banana</li></ul>

<br>

So now let's pretend you have a bit of a more complex template. Instead of hard coding the list
into your file, you instead have a second template, list.html, that expects a listing of things.
Here is list.html:

```html
{% raw %}<ul>{% for item in listing %}<li>{{ item }}</li>{% endfor %}</ul>{% endraw %}
```

And then in another template, we "include" it like this:


```html
{% raw %}{% with listing = fruits %}{% include "listing.html" %}{% endwith %}{% endraw %}
```

If we use the same jinja2.Template strategy as before, we are going to get an error message.

```
File <template>:1, in top-level template code()

TypeError: no loader for this environment specified
```

What this error message is saying is:

> I don't know how to include that referenced snippet because you've given me no context.

In Jinja2 terms, a loader is a setup for loading files, typically from the environment or filesystem.
So the solution is to provide it that context. Let's say we have a directory called "templates" in the
same directory as the file that uses it. We would instead do:

```python

from jinja2 import Environment, FileSystemLoader
import os

here = os.path.dirname(os.path.abspath(__file__))

# Allow includes from this directory OR providing strings
template_dir = os.path.join(here, "templates")

env = Environment(loader=FileSystemLoader(template_dir))
```

And then typically in example you see the person asking to load a template from file:

```python
template = env.get_template("fruits.html")
```

But the case I ran into was a bit different - I needed to do some custom parsing of a template from an already loaded
string, but then still have the filesystem loader because my template had "includes" and
would raise that error shown above. Do not fear - there is a way to do that!

```python
{% raw %}template = env.from_string('{% with listing = fruits %}{% include "listing.html" %}{% endwith %}'){% endraw %}
```

and that's it! The reason I wanted to write this post is because I didn't at first find that solution
so readily - I tried making a custom class, and eventually read the source code of Jinja2 more carefully
(because it didn't make sense they wouldn't make it easy) and then found that additional function.
I hope I might have saved you some time!
