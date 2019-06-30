---
title: "Jekyll Search Content"
date: 2019-06-30 9:40:00
---

There are several good ways that you can make a jekyll site searchable. In
the past I've used <a href="https://lunrjs.com/" target="_blank">Lunr.js</a>,
(example <a href="https://github.com/USRSE/usrse.github.io/blob/master/pages/search.html" target="_blank">here</a>) or previously, <a href="https://github.com/christian-fei/Simple-Jekyll-Search" target="_blank">
Simple Jekyll Search</a>. These are good options, but their success and function totally depends on how
you parse the text content that will drive the search. For example, for the <a href="https://us-rse.org" target="_blank">USRSE</a> site, I thought I had stumbled on a fairly good solution:

```
{% raw %}{{ post.content | strip_html | replace_regex: "[\s/\n]+"," " | strip | jsonify }}{% endraw %}
```

It could serve to have a `strip_newlines` tag, but the above does work well on
GitHub pages in that the search works. But what has been bothering me? The
fact that if you pass it into a Json object, it looks like this:

<div style="padding:20px">
<a href="https://vsoch.github.io/assets/images/posts/jekyll-search/nonsense.png"><img src="https://vsoch.github.io/assets/images/posts/jekyll-search/nonsense.png"></a>
</div>

It's totally gross. Depending on how you implement the search (with some kind of a preview?) the 
user might see this cruft appear in their search result.

## A Better Solution?

I stumbled on a much cleaner solution this morning when I was looking for some
easy way to use regular expressions or the replace filter. We can actually use the Jekyll
<a href="https://jekyllrb.com/docs/liquid/filters/#options-for-the-slugify-filter" target="_blank">slugify</a> filter to do the work for us! It's technically supposed to turn some stringy thing
into a unique resource identifier, usually without spaces, but we can also use it
to clean up html and illegal characters. So here is what I tried instead:

```
{% raw %}{{ post.content | strip_html | strip_newlines | slugify: 'ascii' | replace: '-',' ' }}{% endraw %}
```

And it worked like a charm! Look how much cleaner the result is:

<div style="padding:20px">
<a href="https://vsoch.github.io/assets/images/posts/jekyll-search/slugified.png"><img src="https://vsoch.github.io/assets/images/posts/jekyll-search/slugified.png"></a>
</div>

It's almost working as a tokenizer, so the words are left without anything else. 
It's also typically the case that the user searches with lowercase, so I'm
not worried about that.

I wanted to get this online because it's definitely something I'll lose or forget
about, and then want a place to look it up. And very likely someone else is
also running into this issue, and will be thankful to find it.

> And on Sunday, it was a day of pancakes. And boy, it was great!
