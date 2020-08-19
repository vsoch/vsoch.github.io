---
title: "The Open Source Heartbeat"
date: 2020-08-18 12:30:00
---

As a research software engineer, I want people to ask me for help. I'm hungry for it
in fact - collaborating on code gives me personal fulfillment that I'm useful, and needed.
I'd venture to say that most of us want to feel needed. There is an interesting relationship
to this need with open source development - when we find ourselves immersed in a community, we feel
needed. This is what I want to talk about today - how sharing open source contributions
can contribute to personal fulfillment, and grow community. You can read about [background](#background) 
in the first section, or skip over my reasons and just jump to the [opensource-heartbeat-action](#action).

<a id="background">
## A Service Oriented Group: A Problem 

As I've been setting up <a href="https://stanford-rc.github.io/rse-services" target="_blank">Research Software Engineering Services</a>
the core business model is to find people, labs, or other groups that might need help. I'm
especially eager because I don't have my own little development team in Research Computing,
and so finding others in the Stanford community that might need
help would mean having someone on (a temporary) team with the same goals and passions. It's actually
the same reason that I love open source - you find communities, demonstrate value, and can
be needed. But this also leads me to the current conundrum. 

> Nobody seems to ask for help.

And it's understandable - labs might look at the costs of services, and run away.
They might not even be able to afford the single graduate student they recently brought on.
What I want to shout from the roof-tops is that you don't need a huge project that warrants
paying for support! I want Research Software Engineering Services to help with smaller tasks 
that might be done in an hour or so. I want students and labs to share with me what they are trying to do, and see
if I have any feedback or offering to help. But the issue goes deeper than that.
Even if they could afford to pay, they still are likely to not ask for help.
It could be that maybe they don't know that they can. There definitely isn't any
training in graduate school that teaches you how to ask for help from some kind
of software engineering services. The typical thing to do is ask someone else in your
lab. Asking for help also shows vulnerability.  It's harder than you think.

## Maybe I can find them instead?

Well, if nobody is going to ask me for help, maybe we could do the inverse?
If I find open source projects at Stanford, I could then poke in on the various
issues and pull request boards and see if I can help.  This led me to a simple question:

> What open source work is happening at Stanford?

The fact that I couldn't quickly answer this question was troubling. Undoubtably it's
rampant. But this led me to my next idea - what if I could find Stanford GitHub users,
and then create an interface to show what's going on?

<a id="action">
## The Open Source Heartbeat

<div style="padding:20px">
    <img src="https://raw.githubusercontent.com/rseng/opensource-heartbeat-action/master/img/open-source-heartbeat.png">
</div>

This led me to creating the <a href="https://github.com/rseng/opensource-heartbeat-action" target="_blank">opensource-heartbeat-action</a>
repository. The idea is simple - you can start with a list of GitHub usernames (and/or organization names)
and then have a nightly job that parses events, and deploys an interface to show the most recent.
If you want the user set to update programatically based on a Query to the GitHub User Search API,
it also includes a script for programmatically finding users based on a query of interest. For example,
if I search for Stanford in the location I can be fairly sure to get a Stanford affiliate.
It's fairly easy to set up - you can add a simple yaml file in your GitHub Workflows folder, and have it
running nightly. If you want to quickly see it in action, see the Stanford <a href="https://stanford-rc.github.io/opensource-stanford/" target="_blank">open source heartbeat</a>. If you want to add your username to be included,
please <a href="https://github.com/stanford-rc/opensource-stanford/issues" target="_blank">open an issue</a>!
We want to proudly showcase open source work going on at Stanford.

### Interface

On the front page, you see the 100 most recent contributions, with filters for each contribution type. But
you can also browse a single type:

<div style="padding:20px">
    <img src="https://raw.githubusercontent.com/rseng/opensource-heartbeat-action/master/img/browse.png">
</div>


And you can also view a graph that break downs contribution types:

<div style="padding:20px">
    <img src="https://raw.githubusercontent.com/rseng/opensource-heartbeat-action/master/img/chart.png">
</div>

Selfishly, I would use this to find Stanford researchers, look at what they are working on, and then
ask them if I can be of any help. But you can also use it to generate a nice interface just for your
organization or username! Here is <a target="_blank" href="https://github.com/vsoch/opensource-heartbeat/blob/master/.github/workflows/generate-opensource-interface.yml">an example</a> that will run nightly just to update
my contributions. 

<div style="padding:20px">
    <img src="https://raw.githubusercontent.com/vsoch/opensource-heartbeat/master/img/heartbeat.png">
</div>


It's really up to you!

## So What?

I've created a simple tool to better showcase open source contributions, whether they be for you,
or your institution. Aside from my personal desire to answer the question "What the heck is going
on in open source at X," I want to point out that this kind of awareness can also grow community.
It can help to make a statement that an organization cares about open source development.
As an instition, it would also be nice to be known for more than <a href="https://en.wikipedia.org/wiki/Stanford_University" target="_blank">having lots of money</a>. In fact, we should be known for consistent and high quality contributions to open source.
