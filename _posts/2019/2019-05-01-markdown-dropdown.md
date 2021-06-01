---
title: "Markdown Details"
date: 2019-05-01 7:30:00
categories: rse
---

This is a quick post to share a highly useful trick for posting long
error logs or similar on GitHub issues or any spot with markdown. The amazing
discovery [comes by way](https://github.com/RunestoneInteractive/RunestoneServer/pull/1229#issuecomment-488315755) 
of my colleagues, [@yarikoptic](https://github.com/yarikoptic). Here is a 
[GitHub example](https://github.com/RunestoneInteractive/RunestoneServer/issues/1204#issue-407541603) out in the wild, again from my colleagues,
and here is a live example of what it looks like in this blog post:

<details>

This is top secret text! Or more likely, some really verbose error log that<br>
only a tiny fraction of us need to see. Inspect a container? Sure, why not!<br>

<pre><code>
$ singularity inspect salad_latest.sif
==labels==
org.label-schema.build-date: Thursday_11_April_2019_9:13:20_EDT
org.label-schema.schema-version: 1.0
org.label-schema.usage.singularity.deffile.bootstrap: docker
org.label-schema.usage.singularity.deffile.from: vanessa/salad
org.label-schema.usage.singularity.version: 3.1.0-rc2.1154.g479352901
</code></pre>
</details>

### Basic Example
What would the code look like to do this?

```html
<details>

This is top secret text! Or more likely, some really verbose error log that
only a tiny fraction of us need to see. Inspect a container? Sure, why not!

$ singularity inspect salad_latest.sif
==labels==
org.label-schema.build-date: Thursday_11_April_2019_9:13:20_EDT
org.label-schema.schema-version: 1.0
org.label-schema.usage.singularity.deffile.bootstrap: docker
org.label-schema.usage.singularity.deffile.from: vanessa/salad
org.label-schema.usage.singularity.version: 3.1.0-rc2.1154.g479352901

</details>
```

### Add a Title


You can add a title with the `<summary></summary>` set of tags.

```
<details>
  <summary>Error Log</summary>

   more...

</details>
```

### Open by Default

You can also make the dropdown box "open" by default.

```
<details open>
  <summary>Error Log</summary>

   YOU MUST READ THIS TEXT :X
   more...

</details>
```

### Formatting

Writing this into an html page, you have to include the contents of the details
box in paragraphs or with line breaks. However on GitHub, the lines of markdown
are formatted as such, and so you don't need these extra tags.
For example, you can add formatting for your code, of course.


## How do I remember this?

Just remember `<details></details>` and write code and content between these tags.
My colleague mentioned that it's good to have an empty line at the top, so if you run
into issues try that. [Here is a gist](https://gist.github.com/vsoch/1235f639d50d358a017abce651580435)
I put together so you can see both rendered and code examples.

## Why does this work?

Details isn't a markdown trick, or a GitHub (or similar) feature, it's
actually a full fledged [html tag](https://www.w3schools.com/tags/tag_details.asp)
that has almost full browser support (it doesn't work Internet Explorer / Edge).
The initial tag was added to the HTML 5.1 specification, and is cutely
referred to as "a disclosure box." Read more [about the details tag here](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/details),
and let's start seeing these handy boxes used in GitHub issues to clean up the threads,
and make them easier to navigate.
