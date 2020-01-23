---
title: "The Disney FairyTale Bias"
date: 2020-01-22 5:47:00
category: rse
---

<style>
.center {
  display: block;
  margin-left: auto;
  margin-right: auto;
  width: 50%;
}
</style>

<iframe width="100%" height="300" scrolling="no" frameborder="no" allow="autoplay" src="https://w.soundcloud.com/player/?url=https%3A//api.soundcloud.com/tracks/747892882&color=%23ff5500&auto_play=false&hide_related=false&show_comments=true&show_user=true&show_reposts=false&show_teaser=true&visual=true"></iframe>

It's well known that a <a href="https://en.wikipedia.org/wiki/Framing_effect_(psychology)" target="_blank">frame of reference</a> can bias your thinking. For example, an expensive wine in
the context of a <strong>very</strong> expensive wine looks like a better deal. An idea presented
in a positive context is more readily accepted than one presented in a negative light.
While I won't get into details about the many <a href="https://www.psychologytoday.com/us/blog/maybe-its-just-me/201005/tunnel-vision-in-the-criminal-justice-system" target="_blank">cognitive biases</a>
that we undergo with every breath of every day, I've been thinking about a particular kind of bias
that influences research software.


## The Disney Fairytale Bias

Research Software is subject to the disney fairytale bias, or a frame of reference bias that is experienced by the creators of research software to not fully value or acknowledge the full life cycle of software. Let's break this down into components.

### Frame of Reference

When I say "frame of reference" I'm referring to your expectations about the world, but specifically,
how your culture, life experience, and social norms influence your perception of time and order.
Easy examples are the concept of a work week being 5 days, a romance starting with a first date and ending happily ever when the courtship ends in a wedding, or a trip to the supermarket starting
with grabbing a cart, and ending with checkout. None of these temporal expectations are wrong,
however they point our attention to the events that happen within the span of a well known
"start" and an "end," after which some other experience is happening.

### Lifecycle

A true lifecycle is the actual period of time from birth to death of a thing, whether it
be a living entity or a real or tangible object in the world. In the case that a entity lifecycle
overlaps completely with an individual's frame of reference, then there is no Disney Fairytale bias,
because the entire start to finish is seen. However, in the case that we are biased
to only appreciate or value a subset of the lifecycle (the frame of reference) then we 
experience the bias. 

## Examples
Now you should understand enough to dive into specific examples! We will start with
the context from where the name derives, and finish with the topic for this post - research
software. For each of these examples, take note of what the true lifecycle is, and
what frame of reference we are biased to see. For each, you can imagine looking at
an entire scene or story, and then putting a paper tower tube up to your eye and having
tunnel vision.

### The Disney Fairytale
In a Disney movie, the plot proceeds very predictably.

<ol class="custom-counter">
    <li>we are introduced to a main character, typically an underdog that has some under-appreciated value or attribute.</li>
    <li>the character interacts with a conflict, usually involving one or more evil entities to eventually overcome the conflict.</li>
    <li>the ending ceremony is some kind of wedding or message to signal the conflict resolution.</li> 
    <li>the underlooked value is appreciated fully, and the main character (with some love interest) live happily ever after.</li>
</ol>

<br>

<strong>The End.</strong>

> Wait, is that the end?

I hope you see the issue here. We've watched a movie about fictional characters, and
due to this repeated theme of living happily ever after at the end of the courtship,
we don't think beyond that. We don't typically think about how the newly happy couple
might spend the holidays, resolve conflict together, have children, or grow old together.
Since these are well known parts of a lifecycle, we aren't being exposed to the whole
picture. This colors our own expectations about romance, because we are influenced
by the media that produces these stories, and we consequently place higher
attention on the courtship through marriage phase. Everything after that, although
it is real and alive, doesn't tend to show up in the movies.

### The Disney Fairytale Bias for Academic Software

Guess what - academia is no different! When you think of the entire
lifecycle of a research problem, it starts perhaps with the first person that ever asked
the question. The story then progresses with inquiry, synthesis, and conclusions.
With each new scientist that gets interested, the question is tested in
a different way or context, a publication is written, and our accumulated knowledge
about the research problem accumulates. The story might have a definitive start,
but if you think about it, there isn't really an ending. Knowledge is continually
changing and growing, and perhaps only when our entire species is completely gone
might be consider this an end. But on the other hand, maybe another life form
would then find our knowledge, understand it, and pick up where we left off?

The example goes a bit far, but I hope that you are anticipating what I'm about
to say. The real lifecycle of a research question is infinitely long. And in fact,
we might more realistically say that the lifecycle of an inquiry by a specific scientist
starts when the question is asked, and ends when the outputs of that scientist
(papers, data, and software) are no longer needed or used. Yes, this is a much
more realistic scope of interest, because we have to take the selfish interests
of the scientist into account. In this context, the true ending of the story
is not about the publication, but rather the lifecycle of the data and research software.
This is where the Disney Fairytale Bias hits the academic - because his or her end
of story is commonly the publication. Let's walk through these stages:


<ol class="custom-counter">
    <li>We start with a main character, an academic student, staff, or faculty at an academic institution</li>
    <li>the character interacts with a scientific problem, involving many challenges to solve</li>
    <li>the ending ceremony is the acceptance of the publication, the person or group is successful and...</li>
</ol>

<br>

<strong>The End</strong>

Oh no! We're here again. The academic moves on to the next thing, but here we still
have software and data to support. It's primarily pushes for reproducibility and mandates
by publishers that first encouraged academics to act more reproducibly, and now
it's becoming more a cultural thing - you might even be looked down upon if you don't
take measures for reproducibility of your work. But does this really change the academic
story, or incentive, when you think about it? I don't think so - the push to further
one's career is still about publication. When a publication is successful, you need
to start working on the next to survive (and likely you have many in the kettle).

In summary, the lifecycle of an academic's work is really the full span from the
start of asking a research question through the longer term support and data of software,
but due to incentives for success in the field, the frame of reference typically ends 
at publication.

## What about Industry?

This might be a point of discussion, but I find the frame of reference for typical academic
software development to be very different than industry software development.
Although both might have a similar staring point to address a specific problem, the academic story
ends with a publication, while the industry story includes details for the longevity of the software,
and minimally, criteria for choosing to keep supporting or abandoning it. It's not
that industry cares about scientific reproducibility per say, but they care about providing
a product that will result in profits. In industry,
the software has life beyond one initial use case or analysis, because something that is useful
to the community and brings in profits is obviously valuable to sustain. The average
scientist developing software most likely cares about it for his or her own use, and
then isn't as incentivized to keep it going. This isn't globally true, but my gut says
that it's generally true. In industry there are even 
[business models](https://sfosc.org/docs/business-models/) for how to commercialize open source. 
The business model for closed source commercial software is of course more obvious - the users must purchase it to use it.

## Why should I care?

Here is why I think this general concept is important to think about. In all of our lives,
well beyond writing papers or code for software, our perspective of an event, and 
what instances of time are indicative of a "start" or "stop" are biased. And it means
big things not just for what we pay attention to, but also how we experience time,
and form expectations around life experience. So, if you want to be a generally
more introspective person, or are just interested to think about behavior more deeply,
you might start to question these tiny events. 

So how do you even go about doing this? I like to think about it like a game. You
can take any moment in time and just stop. Ask yourself, What am I doing? Do I place
a label on this thing that I'm doing now - is it a small event? A larger event?
What other people are involved here? Then once you've identified that thing,
think about what your expectations are for it. Think about what you might define
the start and end to be, and how that might bias your perceptions. Once
you've done that, think about what it would mean if you or the people around
you thought about a different start or a different end to be the "right" start,
or the right end. Would it change your expectations of the experience or the 
experience itself? I find this to be a really fun thing to do because you can do
it at any point of any day, and it really gives you pause to stop and think about
some of these biases or expectations that we have that are so familiar to us that
we entirely stopped thinking about them.

You'll start seeing this Disney Fairytale Bias
in almost any kind of event, interaction, or definition that involves cultural norms, 
people, and expectations. I happened to think of research software because it's something
near and dear to me, but there are many other examples to parse over. More importantly,
once you identify that you have a Disney Fairtale frame of reference bias, try to think of
if you should consider changing your perspective, and how you might go about it. 

For me, I realized that to some extent, the success of research software is dependent
on being able to change this frame of reference for the average researcher.
If a researcher is going to take some time to think about what steps will be taken
for archive of their data or sustainability of their software, this requires
changing their basic story to have a later ending. It comes down to a shuffling
around of incentives to put higher value on the future potential for the software
to further the science, and in turn, still support the reputation of the researcher.
In other words, I've realized that in order to improve research software sustainability,
I need to understand how it fits into the story of a current researcher, and what
I need to do to extend that story. Writing this post is just a start. I hope
that you'll join me in thinking about these stories, and how they can be used to
influence people, and consequently, the world.

<br>
