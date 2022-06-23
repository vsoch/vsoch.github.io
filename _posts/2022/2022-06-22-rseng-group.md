---
title: "So You Want to Start an Research Software Engineering Group?"
date: 2022-06-22 21:30:00
category: rse
---

Recently <a href="https://twitter.com/us_rse/status/1539752850489851908" target="_blank">US-RSE</a> put out a call for case studies,
and this peaked my interest because I've made an effort to put together <a href="https://rseng.github.io/starter-pack/#/" target="_blank">community resources</a> before (perhaps ahead of its time, June 2019) and now having single-handedly tried to start a Research Software Engineering Group
at my institution (and failing) a few years ago, I think I learned some valuable lessons that I will attempt to summarize here. I think it's one thing to talk or introspect about it, or to be thrown into an organization already with the power and/or resources to start a group, but for me, I was largely a random person, and didn't have any substantial power or resources to get started. So I *hope* you are starting off better than this, but if not (or either way) here are some valuable lessons.


## Presence is Important

Here is the advice that you aren't going to hear in a typical guide, and advice that some very successful leaders may not be aware of because it goes under awareness. Presence is important. And maybe it's not just important, it's essential. When you are first starting out and, for example, trying to go around and gather up supporting faculty and funding, the fact that you are there, as a person with a smile and handshake, is probably one of the most important things. You see, this is how trust is established. You meet a new faculty, you have an interaction and tell them what you are imaginging - and they can see your passion and motivation, and then you follow up, again reliably showing up when you said you would. 

> You are not just a name, an idea, or a faceless university service - you are a *person* there to help them. They can start to see you as part of their team. 

I am able to have this perspective because I've existed on both sides of this coin - as a sort of faceless service provider, and as a community member, and trust me when I say the latter goes a lot further for growing a good reputation and establishing trust. It's only when you establish this level of interaction, I believe, that you can grow something from nothing. So in the beginning it's important to have a consistent and enduring presence. Engage. It means you show up to meetings where you might have a voice, stand in front of classes to briefly mention the new group and encourage students to stop by if interested, and to find every possible venue to give a talk or mention. This was my greatest weakness at Stanford because (at the time) I was fully remote. I would never be more than a digital image on a screen, and I certainly could never become a part of the campus or a department community or culture. As much as I love being remote, I miss being part of a campus immensely. I'd like to imagine someday after COVID is over living again near one and being a part of a local RSEng group. It's fun having friends, y'all!

## Commit to being a Manager

My greatest challenge in trying to create an RSEng initiative at Stanford was that I could not commit to becoming a manager, and I certainly couldn't force a manager in my already over-burdened group (Research Computing) to take on such a role, with a hugely ominous task ahead of them. You see, when you are starting a group you need to be loud. You need to layout an idea for funding (which will depend on where you choose for your group to sit, and what level of interaction they have with researchers), a very clear direction for pursuring it, and be relentless about scheduling meetings and talking with people that could support you. This is where I practically failed before I started, because I knew that I needed to do this, but I absolutely didn't want to. I pursued doing it "the non-manager way" because frankly, I didn't want to be a manager. I wanted someone else to do that work, and I wanted to focus on developing software.b I gave several talks about Research Software Engineering (and got amazing applause, even remotely!) so I could tell that people were excited about it, but I needed to do more than that. The most success I was able to achieve was setting up a "one woman service" for which I made it possible for people to submit requests for help, I'd follow up with a 1-1 consulting discussion and then support plan, and then in some small number of cases we'd start work. It was an official service, meaning part of the larger Stanford catalog that researchers could browse, and I was proud to have been able to work with folks in financing and IT to achieve that. Over the small life of the service I brought in maybe close to 200K (not to myself personally but to my group) which was more influenced by longer, 6-9 month projects than small a-la-carte ones. So you see:

> without committing to be a manager you can create a quasi-successful consulting business. But it ends when you leave.

And that is exactly what happened. As soon as I left Stanford, Research Software Engineering Services went away. There was no foundation to continue it, nor was there a person to do it.


## Avoid the Service Mindset

Right away, since I was sitting in Research Computing, a very service oriented group, the model that was most obvious to use was one of providing a service. This meant coming up with a table of project sizes and rates (everything from a-la-carte to paying for chunks of my time for some number of months) and it also meant that the prices were dictated by the financial team at Stanford. This was also a failure before it started, because the hourly rate (as compared to what I know are researcher and lab salaries) was ridiculous. I knew I would not want to pay that much, and I also knew that the service would be biased to select for larger, more well-funded labs, and completely make it an impossible feat to help the smaller labs (which ironically probably needed it more). The 50% additional fee on top of the base cost for external collaborations made that totally impossible too. My confirmation was affirmed when, after about a year, my clients primarily included a large tech company external to Stanford, labs from the School of Medicine, and one large and fairly powerful biology lab that had the funding to pay for my time. And in that time I had maybe ~3 attempts at people external to Stanford wanting to pay for some of my time, but when they heard the price it was a quick no. What made absolutely no sense to me is how the institution could put up such strong barriers to not only helping their own researchers, but fostering external collaboration? So the lesson here is:

> When you identify early on barriers to helping people, within or outside your institution, start tackling them first, because they will come back to haunt you.

The other point about a service mindset is that it's a dangerous thing to do, culturally. The people you are helping will always treat you like a ticketing system, and tend to not be grateful when you get things right, but be extremely angry when not (a case of when a lab member deleted some data of an app that I developed comes to mind). It doesn't even necessarily have to be your fault, but if you didn't put in a protection to prevent it from happening, maybe it was. But this is why I'll dissuade you from choosing an impersonal, service-oriented architecture. I think the most successful efforts will indeed have planning and structure for how to get funding, but will do so in a way that says "I'm not providing you a service - I'm part of your team." Ideas that come to mind are having a pool of faculty to support work, and the contract is done annually perhaps so it's a one time, formal and "sign on the line" sort of deal, and the rest of the year is you (the manager) and the research software engineer(s) interacting, having fun, and truly being a part of the lab. 

> I believe the most successful RSEng will not be perceived as services, but as essential parts of the community.

## Listen to what is needed

Coming at this as a software engineer, I sometimes fall prey to developing what I believe to be needed, and I don't put in the work to really understand the problems that a group is facing. This is related to presence, because part of being present is listening deeply. Is the lab in need of help for HPC basics? Optimization? Making an entirely new service or application? Keeping up to date with managing data? The individual story that you hear is going to drive your next step, and how you decide to help the lab. If you have a team of RSEng, it is going to drive how you advise them to provide help, or what to work on. Often, you might find yourself in an initial interest meeting, and if you hear a hint of something they are having trouble with? Take a few minutes in your free time to brainstorm around it, and write up a plan. Share it with them, and explain this is the kind of things we could try if you were a part of their team. If the ideas are exciting to them, they will want to support you and find a way.

## Change is Slow

Organizations don't change quickly. I think perhaps if I had stayed at Stanford and continued fighting (and addressing some of the points above) I could have made a mark - for example the Sustainability Institute was started shortly after I left, and they were interested in some of the same things that I was - I could see having a conversation with them that would lead to collaboration and growth. But the salient point is that I didn't stay. I had been at Stanford for ~5 years and I couldn't deal with the stress of worrying about my funding and (sort of) chronically feeling alone. So the lesson here is:

> If you choose to start a group, commit to working on it at least 3-5 years.

And when things don't seem like they are going your way, remind yourself of this timeline, and pace of change.

## What did I do well?

Believe it or not, I did a few things well!

### Documentation and Organization

One of them was creating organization for my service. This meant templates for new support templates and keeping track of hours (if necessary) and keeping very detailed documentation about work I did along the way. I suspect if you are starting a larger team, you will want a scaled strategy for doing this - making it easy to manage each of your RSEng time, meeting with them to stay on track, and having templates and material for slides, etc.

### Branding

As it is important for software, branding is important for your new group. Ask yourself where someone will go looking for help, whether it's a particular Google search, a university page, a bulletin board, or word of mouth. Make sure you hit all of those spots. You should have a professional website that offers resources, templates, and clearly lays out what your team has to offer. The RSE Services site isn't up anymore, but I've transformed it into a general <a href="https://rseng.github.io/" target="_blank">rseng</a> site to give you a sense of what some simple jekyll, markdown and GitHub pages can produce! And in fact way back (2019) I even made <a href="https://rseng.github.io/community-template/" target="_blank">a community template</a> that was based on our original site design that can get you started. I'd also recommend checking out my collection of <a href="https://rseng.github.io/docs/resources/documentation" target="_blank">documentation templates</a>. Do you need something you don't see? Ping me and I can help make it!

Also in terms of branding, make sure you have small (more fun) assets like a logo, maybe stickers or other swag for your team, communicated (strongly) your vision, and you make yourself accessible (email, phone, and inquiry form) in several ways. It should be easy and obvious to ask a question to get help.

### Fun Initiatives!

In my short time leading RSE Services, I also started the RSE Stories Podcast, gave several talks (you can find them under the work section of my site - "Research Software Engineering"), and even pain-stakingly went through the entire staff listing at Stanford to find titles that "smelled like" research software engineering. I was planning an "RSE Day" when I"d fly in and have a bunch of talks, fun community events, and kick off of this initiative, and had invited the Stanford cohort to the US-RSE slack and created an email list. Unfortunately because of COVID that never happened, and that was the point when I didn't see a logical next step. But I bring this up because I think it was a great idea - plan to have fun events, talks, even a half day of fun just to educate people about your cause!

## Summary

So that's what I learned, as a tiny dinosaur with a vision trying to change things in a big way, but falling short because
I didn't try for long enough or hard enough, and I ultimately chose my own job security (and sleeping well at night)
over everything else. I hope you forgive me for this, but at the end of the day I really did try my best, and was able to do
quite a bit from nothing, but it wasn't enough to have a long term impact. I am also optimistic that I've directly and indirectly
helped pave the way for a lot of research software engineering initiative, and if you are to take a similar journey today you
will more likely have success. Good luck, and most importantly, hava fun!
