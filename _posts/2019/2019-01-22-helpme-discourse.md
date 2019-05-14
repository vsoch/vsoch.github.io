---
title: "HelpMe Discourse You're My Only Hope..."
date: 2019-01-22 6:05:00
categories: rse
---

In this one shot wonder, I give a quick rundown of the 
<a href="https://vsoch.github.io/helpme">HelpMe</a> command line client, 
for use with the recently upgraded <a href="https://neurostars.org">NeuroStars.org</a> Discourse board! This means that
you can post a question to Discourse without leaving your command line, including:

<ol class="custom-counter">
<li>A whitelisted environment</li>
<li>A terminal recording</li>
<li>A title and description of your issue</li>
</ol>

And all gets uploaded without needing to leave the command line, and
without you needing to worry about copy pasting or taking a screen shot.

## HelpMe Discourse!

And without further adieu... here is the unfortunate result of me 
struggle-bussing with video editing software:

<iframe width="760" height="515" src="https://www.youtube.com/embed/0t1n6mMzHo8" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>


## Install

If you want to install locally:

```bash

pip install helpme[discourse]

```

or on your cluster, where you are just a tiny, lacking permissions user:

```bash

pip install helpme[discourse] --user

```

or shell into a Docker container on your local machine to generate the token instead:

```bash

docker run -it --entrypoint bash vanessa/helpme

```

And remember, for the Docker container you need to save the discourse token that is generated in your (root's) home:

```bash

/root/.helpme/helpme.cfg -> $HOME/helpme.cfg

```

My computer was way low on memory so it pooped out in several spots, and I tried to either edit out or fill in with the missing words. Hey, I say
it's beautiful in its imperfection :) I'm too stubborn to do a take two so this is what we are left with :)

Enjoy!

For more details (help!), see the [repository](https://github.com/vsoch/helpme), and if you run into any issues please post an issue.
