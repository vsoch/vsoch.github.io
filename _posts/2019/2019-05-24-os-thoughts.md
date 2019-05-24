---
title: "The Changing Open Source Landscape"
date: 2019-05-24 2:30:00
---

This is a discussion about the changing open source landscape, from the perspective
of an open source software engineer. For quick takeaways,
see the [overview below](#overview). You can also listen to an informal (shortened)
audio version via [SoundCloud](#soundcloud). I recommend reading first.

<br>
<hr>
<br>

When I was in graduate school, open source had clear definition for me. It meant
that code was provided openly under a particular kind of license, and the license
detailed to what degree it could be re-used with or without modification. It meant
transparency, and it usually meant good intentions, because there was an inherent
decision to encourage openness and sharing versus coveting the code for any selfish reason.
In academia, it coincided with a movement around open science, meaning having
transparency every step along the way.

I could break down different projects into two bins at that timepoint. There were established,
big projects like nginx, Linux, and redis, and there were smaller (lesser known)
projects like code released by an academic lab. For example, everything that I or my lab
created was smacked onto GitHub, and had an MIT license added by default.
I was really proud of that. When I encountered colleagues that didn't want to share simple
scripts, it seemed silly and out of practice. Everyone was afraid of scooping, but 
I was bluntly ruthless - I truly believed that if someone could do something better
than me, they should. I could move on to other things. But really,
I didn't see any issue with having replication in work - replication is
the fundamental basis of the scientific method.

Open source at this time seemed to revolve around licenses and control.
There was still some gray area between "big well known project" and "the code I wrote last
weekend to scrape Pokemon." They both might have the same license, but one felt more
established than the other. It had a presence online, branding, and a much larger community.
What was clear to me, however, was that we didn't have a chicken or the egg problem. For
these projects, the code and community came *before* the branding. The beautiful sites and
other community interactions resulted from a thriving community with a lot of people
excited about the project. 

So what happened? The gray area got bigger, or maybe it was just me that started
to notice shades of purple and blues. For much larger projects, I started to realize
association with business models, whether it be a nonprofit, LLC, or fully established corporation. 
It started to become a chicken or the egg problem, because I wasn't sure if branding
and online markers of success were created after a project took up, or pre-empively to
then help it take off. All through this party literally and figuratively at the Farm (Stanford)
the licenses (mostly) stayed the same. It's never really been about them.

## The growing gray

Let's zoom ahead to today - and now the grey area has expanded. We have GitHub projects
that have many qualities of (what used to be) small, selfless academic projects.
They grew organically and were primarily driven by community needs, and work was
done by community members. We also have many of the top repositories, whether that
be ranked based on stars or contributions, associated with corporate entities.
The corporate entities typically have rigorous release and rules for the community,
so the repos themselves are carefully put together with codes of conducts, tools
to assert agreement about licensing, and guides for contribution. The documentation
is flawless, and the logos are adorable. If you started with open source recently,
you probably don't think twice about big company names having GitHub organizations, but
even back in early graduate school, this wasn't a thing. This has me constantly
questioning - what does open source mean? Is it about a license? Is it something else?
What does it mean to be sustainable, and how can we quantify this change that seems
to be happening? "Open source" is a general term that
is thrown around that can refer to any kind of project along this spectrum.
So how then, do we actually define open source, is it even about the license, or
something deeper?

## Open source also describes a culture

It's about other things, but the strongest factor is culture. 
I've talked about this before - sustenance of a project not
only depends on having maintainers (people) and a code base on GitHub, is also
relies upon the contributors feeling good about what they are doing. The problem
today is that the term "open source" is thrown around casually, and it means
different things to different people. Let's step back.

There are two very different kinds of open source, and perhaps this is more 
representative of a stage of development than a tangible difference in the projects
themselves. There are 

<ol class="custom-counter">
<li>the organically grown, new and green small projects that don't have definition beyond a license and code base</li>
<li>the projects that, for one reason or another, are large enough to have some kind of business entity
directly behind them, or sponsors from the same entity. </li>
</ol>

<br>

There are several large, (still community driven) projects that I see falling into a category of their
own. For this discussion, what I'm primarily interested in is the new wave of open
source, meaning the corporate controlled projects, vs. the smaller community and
academic ones.

## The business of open source

If you didn't notice, open source is now a business. Here is the typical story
for a corporate open source model. First, a company has some awesome internal software.
They realize it's awesome, and that they would go much farther by opening it up
to the community. They likely assembled a team of developers just to maintain it,
and a company wide guide for "How to Do Open Source." There might be a marketing
department involved to help with branding, and a designer to make it appealing.
As soon as it's thrown out there and gets the attention of the world, the 
developers that follow the latest trends on social media start to take notice.
The repository gets used, starred, and contributed to. After some time, maybe there
is a conference. They give away stickers, overuse the work "rockstar," and everyone is made to feel
empowered, and like part of something bigger. This is the corporate model of open
source, and it's great, because it means we have come so far since the days of 
buying software in boxes at Staples. It's better for business to share code and
work together. 

> But, why shouldn't every project have a business model?

Couldn't it be the case that some smaller projects would appreciate help
on the code base, but don't operate the same as a business? Yes, this is suggesting
that they don't know how to deal with monetary contributions beyond putting them
into a bank account, and that every project doesn't necessarily fit with
a business model. 

> But what about sustainability?

Corporate open source tells us that we have to package projects alongside 
a business model. For example, the "open core" model says that
some level of the software is provided for free (the core) and then advanced
features or services are paid for [[1](https://sfosc.org/business-models/loose-open-core/)]. Some projects that were
from the original wave of "traditional" open source have (I think) felt taken 
advantage of, and as a result have resorted to doing things like having dual
licenses, or coming up with their own license all together. Again, there is this
coupling of licensing with the amount of control that an entity wants to maintain
over a code base. I'm uncomfortable with a lot of the current conversation not
because these models are bad, but because of square pegs and round holes.

> Why are we trying to fit everything into the same box?

Hold the phone, Shelly. Why does open source have to fit into a consumerist model, 
and why does it have to be marketed? Just because this new wave of projects are corporate
driven and have business plans, does this have to define open source?
I think the main issue here is that we're really dealing with two things.
This new wave of open source is really a subtype of corporate or commercial open 
source, and it's not to be confused with traditional, or non-corporate open source.
Selling an associated product or service is not evil. However, having an expectation that
"to be sustainable, there must be funding and a business model" is not something that feels
right to me. With open source projects that I care about, it's never felt like it's about monetary sustainability.
It feels more like selling an ideology. The software I care about I care about not to sell it like something on Amazon, 
but to sell a method for how a process can be done (containers built, monitoring tasks, continuous integration checks, etc.) 
When I am alone with my thoughts I am not excited by the external rewards of a project, or some
potential to make profit, but rather the interactions that I have with the community, and this
deep, vulnerable hope that I'm working on something [for the greater good](https://good-labs.github.io/greater-good-affirmation/).

> How does commercial open source hurt culture?

I can't speak for others, but I can speak for myself. Fitting open source into 
a business model is hard because it doesn't fit. As soon as a project tries to, 
it gets a little less fun. You aren't just there because you believe in it. 
The original excitement and disbelief that others value the project and contribute 
voluntarily is replaced by fear of project death and lack of sustainability.
You start to obsess over business models, and being on the bleeding edge of
the industry. You start to worry about competitors. You maybe spend a lot more
time trying to sell your project than actually working on it. The fun turns to stress, and obligation.
I would hypothesize that it's a lot easier for corporate open source, specifically
projects that were always associated with a company, to thrive because they never
had to transition from being totally free, to something that seems selfish.
Maybe we know and accept the idea of a company and making money, so we don't
feel betrayed because there is no 180 degree turn or change of mind about
the reason that the project exists.

> To the community, any initiative to make profit smells like greed

The problem is that as soon as a project takes on a business model, that's making a statement that 
the maintainers behind the project have changed their incentives. They are
are selfish. Their incentives can't be about being for the greater good, even if
they started that way. How then, can we have
sustainable open source software, something that has resources to stand the test of
time, without branding it as selfish?

I don't know the answer to that question, but I would guess that what makes
projects most (naturally) sustainable is having a focus of development for and by
the community. This means adding features that the community needs, and not
ones that are in the company's best interest. It means treating every user as a 
first class citizen, and not abandoning the community that was previously supported. It also means that you go out of your way to support users and developers of your project. You make sure they are inspired, having fun, and not overworked, stressed, and tired.

## How Developers Thrive

I'm an open source developer. I span academia and industry quite a bit, and I've
interacted with different communities. I understand them very little, in fact I'd
say many are very different but appear almost the same when slapped onto GitHub.
At the end of the day, I'm not someone that can get behind an aspiration for
cashing in, and being eaten by a bigger fish. My love for software development
is tightly coupled with an idealistic dreamer that likes to believe I'm working
for some greater good. The contributions that I make are done at my own
jurisdiction. My top incentives are not metrics of performance, but rather
how excited I am by something I'm working on, and how much fun I have to work on it.
I believe that the fundamental component, the magical feeling that we get from open source, isn't because of business models,
expensive conferences, or external incentives. It's the people. It's the culture.
It's having fun with your tribe and working on something that will survive because
it's great. I am free.

> What if this passion could be packaged and supported officially?

Now imagine that there is an actual career track for an open source
developer. There is some body with governance that hires them. Companies go to the body
and state projects they support. The developers are then paid to focus on those projects.
Or maybe companies themselves just hire open source developers, and pay them
to only work on open source. They don't need to do it on top of a full time job, or in their free time during
weekends and evenings. The developers are best matched to contribute to the projects that they care most about. 

> Should all open source projects be supported?

And now, an unpopular opinion. It goes without saying that if some projects can
stand the test of time because people care about them, others will not. Communities
dry up, and small groups of developers get tired. Many projects simply won't stand
the test of time, and in laymans terms, one would say they aren't sustainable. 
But is this a bad thing? I don't think so. The landscape of these projects is
one of survival of the fittest. It might not be a fair game given some unfair
advantage or growing to be well known, but that's the world that we live in - it's
not fair. I want to argue that a lot of projects should go away. If a project is useful
and valued, the community won't let it die. If it's not, or if the community isn't
healthy, it should be allowed to die.

## The Open Source Heartbeat

What can you do, as an individual? Close your eyes. Thinking about your projects,
and the people you work with, and take a snapshot of the feeling that you get. Are
you having fun? How often do you laugh, and smile, or work really hard on something
and feel something like triumph over challenge? How often are you inspired, and
how easy is it to share that with others? These are what I believe the true metrics
of a healthy open source project. It's the community spirit that gives a project
its heartbeat. You can put any project on life support and it will continue to breath,
but it's not the same thing.

What can you do, as an organization? I think it's okay for businesses to keep focusing
on these business models, but not to send the message that every project out there must
have one. You should encourage your employees to work on open source.
If you have employees that are passionate about a particular
project, well you have a match made in heaven. But what about the others? If you force
them to work on something they don't find inspiring, it could be the case that they learn
to like it, but more likely not. How about instead, let them be free? Give them time
to look around, and get excited about projects. Give them space to work on the ones that
they care about. Don't tell them that they have to, but show and encourage them that they can.
Open source projects that aren't company maintained come out of everywhere, and they
need help. Companies assume that the same units of contribution that would help a business
entity might help these projects. For some this is the case, but for many, they aren't
set up for that. What if instead of trying to shove these projects into corporate business
models, we placed value on the project themself, and set free an army of engineers to
be free, and work on a subset that are meaningful for their goals? 

## Overview

Let's quickly summarize. 

### Open source has subtypes

The first takehome point is that opensource is not one concept. There seem to be
subtypes of open source, the most prominent one this new kind of corporate open source,
and this does not mean that every project should try to fit into that mold.

### Sustainability does not mean consumerism

The next point is about sustainability. Corporate open source is arguably okay in that they can hire
an army of maintainers, and people to create branding for a project. But what about
the smaller, non corporate projects? We already stated that it's commonly not the best fit
to shove them into a business model. For these projects, I want to suggest that
sustainability comes from larger companies that have armies of engineers giving back.
If they've truly realized the value of open source, other than hosting their own projects,
they should build in protocol into their companies to practice a little tit for tat.

### Open source calls for new jobs

Imagine how the world could be different. Imagine if an open source software engineer
was a fully accredicted profession, where there was some governing body to manage
sponsors, and passionate disparate engineers worked as a team to make projects valued
by the community better. Imagine if contributing to open source was so valued that
it was built into every companies protocol. Imagine if the culture of open source didn't
create a divide of haves and have nots, where conferences were available and affordable
to all kinds of software engineers.

### Community is the heartbeat

And finally, let's not forget about community. Regardless of whether you are home grown or
corporate grown, if your community isn't strong, inspired, and people aren't having fun,
you're in trouble.


### SoundCloud

<iframe width="100%" height="166" scrolling="no" frameborder="no" allow="autoplay" src="https://w.soundcloud.com/player/?url=https%3A//api.soundcloud.com/tracks/626011320&color=%23ff5500&auto_play=false&hide_related=false&show_comments=true&show_user=true&show_reposts=false&show_teaser=true"></iframe>


