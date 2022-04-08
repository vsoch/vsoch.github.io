---
title: "Time Management"
date: 2022-04-07 12:30:00
---

I'm continually fascinated by how people are always so busy. 

> Oh my schedule is packed for the next two weeks, but in this hypothetical two weeks _after_ that I'm sure it will be better!

This is the thinking that I see common in academia, and heck, even in tech. Sometimes I feel empathy,
and other times I am suspicious - is this person always in a chronic state of being busy?
Or even worse - are they a prisoner to their schedule and eternally optimistic that in two weeks things will
really be different? Now that I'm older (and not much wiser, but maybe a little bit) I'm pretty sure it's all about choices.
Let me explain. This is a post on time management, if you couldn't tell. To be fair, <a href="https://cacm.acm.org/magazines/2021/5/252174-the-10-best-practices-for-remote-software-engineering/fulltext" target="_blank">I've written about this before</a> and this is a follow up post. 

## The Different Kinds of Days

First let's talk about the different kinds of days. Mind you, this is biased towards being a software engineer.
Obviously if you are a manager or some other kind of role your kinds may vary!

### Chunked High Focus

These are arguably my favorite kind of day! A "Chunked High Focus" day means you have huge blocks of time to focus,
and something you are so excited about you are eager to take advantage of that.
When I have a project I'm super excited for, so much that I feel on the border of giddy and want to blast music 
and get "all the stuff in my head" out into code and documentation, I have one of these days. These days might be 4-5 hours of programming.
a quick break, and then back to it before evening, quick pause for dinner, and then back to it!
This kind of day I wish I could say happens more on work projects, but more often these days it happens
on the weekend because personal projects are always more fun.

## Context Switching

Another kind of day is the one where you whiddle away at maybe 5-10 separate things over a day. This doesn't mean your
attention gets taken away by a meeting persay, but it might mean that you work on something for 30 minutes,
and while something is building / compiling / testing you work on something else, and while that is running you jump into a
third thing. I can usually hold the state of about three things at once in my head and move easily between them without needing
a lot of getting my brain back into a different state. By the end of this day you've actually accomplished quite a bit,
but it was scattered. To be clear, this is context switching between work, and not between work and meetings, which is a different
beast. After one of these days you'll realize the impact you had when you do this a few times and all of a sudden "big things" are finished.
How did that happen?

## Meetings and Recovery

Meetings heavy days are exactly that. Do you have six? Seven? Eight meetings? Did you even get a bathroom break?
This kind of day is likely linked to having a role that requires talking with people. It could mean you are a manager
or someone higher up in the organization responsible for a lot of people or things. Personally speaking, I have to try
and avoid this pattern because meeting are draining for me. I'm just not a social person, and it takes a lot of energy pretending to be one.
Thus I usually have two days a week when I try to bunch my meetings together, which is usually a group meeting,
a manager meeting, and then maybe a few scattered meetings. Since I anticipate not being productive 30 minutes before
and 30 minutes after there goes 2 hours of the day. I am extra nice to myself on these days because I just really hate
meetings. Self compassion, folks!


## What I do in a day

Okay, so now let's talk about a day that I might have. 
Since it's fresh in my mind, let's use yesterday as an example. Today was a bit different because I gave a long talk,
and that is something I only do 5-10 times a year, and preparing for that means taking it easy. I also released an episode of RSE Stories,
which means careful audio listening to write show notes, and that's also something I only do once a month. The rest of the day
was mostly fun programming.

But... yesterday was a typical work day that we can discuss! This day would fall into the "Context Switching" day because I was always
doing multiple things at once. By the end of the day I felt like I had covered some pretty good ground.
I woke up probably close to 11am (because hey, it happens sometimes) and began the day. I glanced at
my calendar the night before, so I knew I had one meeting later in the day. This meant that I could
work happily with little awareness of time until "some later point." To summarize what I accomplished 
in the hours between 11 and 11pm (with a break for dinner, and a few hours of "not work" work:

### Data Analysis Work

I talked to two colleagues to find data, transfer it, and understand the format. We had chat the night
before about our analysis plan, and this was the "get everything set up" phase of it. This meant finding
data, moving it to where I could inspect and work with it, and writing a new script to transform it,
and re-run the analysis with it. I re-ran the model to do a clustering and uploaded the scripts, documentation,
and results, and then pinged my colleague to take over for the next step. I don't usually do a ton of machine
learning or data analysis, but with the right people it can be really fun. I tend to enjoy the work that the
other party does not - the data preprocessing, setting up some pipeline, and automating things.

### Open Source Online ML

I've been working on a <a href="https://github.com/online-ml/river" target="_blank">River</a> pull request to 
refactor the nearest neighbors library, and the last state from a few
days ago had some nasty "un-pickleable result" error that I was too tired to deal with then. I decided to look at it,
and it was fairly easy to work on. I first created a testing example of pickling something to generate the same
error, and then learned there were two issues with my code. The first was defining a class within a class - it needed
to be global. The second was not having the class variable name match the `__name__`. When I could reproduce the
test failure, I could then push the change and the tests passed, hooray! And to put this work in context of the
first data analysis project, I have a custom solution for one of our models I'm hoping to exchange for this new work.

### Open Containers Reference Types WG

I haven't been able to attend the Open Containers Reference Types working group meetings, but I've been aware of what
is going on and looked at the current proposals. I had a vague idea for a proposal and wrote it up, and sent it to someone
for feedback. I have brought an idea to <a href="https://opencontainers.org/" target="_blank">OCI</a> before and 
ultimately felt very stupid and embarrassed so I might not submit this one. I figured I'd get feedback first.

### Singularity HPC Version Parsing

We are refactoring the version parsing of shpc to be custom for container tags, which in and of itself I can write an entire post on!
For today's work, we noticed that sometimes people have tags that are essentially git hashes, and we will want to avoid
these tags in our automated updates as they have no meaning in the context of numberical release tags. So I wrote a custom set of
filters for the shpc parser to look for strings of lowercase characters and numbers, and given no other types, to remove
the tag. In a testing set of ~290 containers it looked to do fairly well (all the commit hashes that were there previously
are no longer selected).

### Error Parsing

I started a new personal project last week that is essentially going to be a command line tool to wrap commands (or parse
logs after the fact) and find errors and prepare markdown / other formats to easily put into a GitHub issue. Today I finished
getting up to the end of the command, collecting the error code, and adding additional metadata to write into the markdown.
I got up into writing the markdown but then got lazy and distracted and worked on something else.

### Libabigail Automated Builds and Checks

I created two automated workflows for libabigail - one to build and release a container on push, pull request, or scheduled job,
and the other to run libabigail checks *on* the library libabigail. It was pretty cool because the developer I was working with
got interesting in containerization and took a shot at making a Fedora container, and he did a good job!

### CiteLang Parsing

I'm working on a software credit attribution system, and part of that is checking the quality of my dependency file parsing. Since this is hard
to do, I have a set of ~1500 repos running continuously, and catching an error at various points and then waiting in an interactive session.
This means if I find myself with free time or taking a break I can debug an issue and then let it keep running. I'm about 350 in so that's pretty good!
This project is actually two things - the library to do the analysis, and using the Research Software Encyclopedia as a database.
I'm pretty excited for what I could say about software. It's just a fun side project though!

### Talk Practicing

I gave a talk today, a 45 minute talk mind you, and that is a lot of preparation and angst. Yesterday I didn't practice a ton,
but I did lie on my bed for a few minutes and walk myself through the parts of it, and focus on parts that I wasn't super strong on
for my practice earlier in the week. My visual and auditory memory is very good so I can usually just lie there and even talk to myself
and practice a bunch of it without seeing the slides.

### Project Scoping

I had several private chats with other developers about cool projects. I'm not going to share details but they were fun!
I can share the projects that I'm dreaming about, which will come next in the queue likely after the talk is over, CiteLang,
and my current error parsing library. I want to extend my version parsing idea into it's own proper library, and make it easy for someone
to create their own processing / sorting / ordering pipeline for versions. Versions are hard, yo! I also want to check out what
the folks at Dagger.io are up to, because "DevOps operating system" and implemented in Go makes me feel giddy it's like my two favorite things!
We also have a ton of features in the queue to work on for shpc. After the automated updates we are thinking about symlinks and views,
and how to represent gpu metadata.

## Is that a lot?

So I don't know, is that a lot? Do I have any way to compare what I do to what anyone else does? Not really. 
But I will state that I feel chronically *not busy* so I must be doing something right. I rarely have doubt that I'll finish
something in time because I usually finish well in advance and move on to other things. Note that I said *feel* and not
am. That implies that it's a state of mind more than anything else, which I want to talk about next.

## How to Time Manage, Maybe?

Now that we have talked about what I might do in a day, you can decide if it's a good amount (or not), and if you decide the first,
you might be interested in some of the ideas I have around time management. If not, no worries.
I am of the opinion that a lot of time management is about choices, and state of mind, and let me explain what that means.
I started to observe people around me to see how they managed time, and I noticed a few things. 

### Turn off Notifications for Control

The first is notificaions and control. It's often the case that people are bombarded with them, and they feel the need to respond as quickly as possible and "pass the ball to the other person's court." People are attached to their email, or their phone, and the notifications bleed into everything. But here's the thing - the faster you throw a task back, the quicker the other person will throw it back to you. Also, if you are chronically trying to stay on top of notifications you are giving them control of you. My approach is to take off all notifications entirely. When I first did it I had a sense of lovely freedom. Of course if you are on call for a service you need to keep your pager or channel open, but most things can wait. 

When you take off notifications you are in control. You can look when you choose to look, and respond when you choose to respond. In practice this means that sometimes others might wait a handful of hours while I'm working. When my intense coding state dies down, then I might take a break and browse the chat channels. From the standpoint of the other person, unless someone is falling into a sinkhole, do you really think they want a response immediately? I would argue the opposite - they appreciate the small break of time between when they posted and when you respond. It's really a balance. 

I bring this up because when I looked at people around me, I saw that they were chronically trying to make everyone happy as quickly as possible, and it was stressing them out because of unexpected requests and never knowing if they would finish in a day. This is no way to live, folks. You are in control of your time and work and if someone tells you differently find a different group to work with.

> My advise here is to turn off your notifications, and choose to open your emails / chats and get to things when it works for you.

### Do Small Things for Mental Boosts

Okay so let's imagine we have a list of things to do. Actually, I can't assume that, but I will say I've been keeping my TODO list in a single
Google Document since 2007, so if history is really preserved I could re-create everything I've written down to do for the last 16 years. The way
I use my list is to write something down that I want to do or remember, and then I just delete it when I do it.

So what happens when you have, say, 3 small or quick things, and 3 large, important things? If you do the little things first you can "get them out of the way" and then get a nice mental boost for checking things off. However, if you do this every day you are (generally) never going to get to your large projects or ideas. What I do is take "big things" and break them into little pieces. Instead of "do large project" I might just write the very first step of that, perhaps "create skeleton and README for project." This way I can have my cake and eat it too - I am tackling the big projects in little pieces, getting a mental boost that I checked something off, and then I'll still probably do the list of little things. So in this light, the actual size of something has nothing to do with priority. You get to decide what size is a good bite for you to take, focus on that, and move on for the day.

> Priority doesn't have to be based on actual size, but how you create portions of work


### Don't do it if you don't feel like it.

This is my all time mantra. It's also a longer term thing. I never work on something that I don't want to be working on.
If there is a project I am being forced to do and I absolutely don't want to do it, there is a mismatch of interests and it needs to be discussed and figured out. This isn't a super common thing, but it does happen once in a while. Thankfully I've made life choices for over a decade that have directed me toward things I like, so I am generally someone that likes the work that I do. So my advice here is more longer term. 

> In your life, generally, lean towards things that you like and enjoy, and then find yourself doing them for your work!


### Use Patterns and Templates

If could be that I've just encountered a lot of similar design patterns, but I've found that when I've done something once, I can do it much faster
the next time because I can either start with a design that took me some time to figure out, or I know mistakes to avoid. This can also mean
explicit templates! For example, it probably took me a lot of Googling and figuring out to write my first Python package. I spent a few iterations
establishing preferences for structure, and after over a decade (and over 70 packages on pypi) I have a structure that I really like and I can
start with the skeleton and iterate quickly from there. Some of my Python modules are obvious derivations (and experiments on my part) to try out new ideas. But it's not just about re-use, it's about growing and changing and adapting your templates too. And sometimes you can try something new. Design can be fun too!

> Identify redundancy and patterns in your work, and re-use ideas, design, or assets.

### Minimize Scheduling Meetings

I don't know why people don't say "no" more to meetings. It might be that we have this chronic desire to make everyone happy. I decided
I'd rather make myself happy, and focus on the things that are most important to me. I have said this before in different contexts,
but it's okay to say yes, no, and not right now. It's also okay to say yes and then change your mind later and say "not anymore." For
the most part people aren't as aware of you being there or not being there as you think. And yeah, if you care about something?
You totally need to show up. But these "weekly or biweekly meetings" that you start to go to that don't seem like you are accomplishing anything?
I've been there. It doesn't feel like the best use of my time. If it's just an extra thing and not the best use of your time, you can decide to attend
less frequently, or completely step away. You can also engage with others and decide if there is a better way to run things. For a project you are a member of, it might make sense to talk to the leader of the meeting and discuss conditions for when it's important for you to be there. For example, I have a regular meeting that I ping someone the day before and let them know I don't have updates for that week. I'll also point out that open source operates like a well oiled machine (well, a lot of it) and there are typically not meetings.

The other thing I do for meetings is clumping. Instead of having a handful a day, I try to condense them into blocks of time on 1-2 days a week.
This means that I can be in a mental state to be social, and gussied up and ready, and I can have this be my mode of operation for a few blocks
of time in a week instead of scattered "all the time."

> Minimize meetings, schedule them in blocks on the same days, and if you cannot, try to make them more efficient or define criteria for you needing to be there.


### Don't Get Zoom Fatigue

One of the downsides of virtual or remote work is Zoom fatigue. It's a <a href="https://news.stanford.edu/2021/02/23/four-causes-zoom-fatigue-solutions/" target="_blank">real thing</a> and it impacts women more than men. The reason this is related to time management is because if you are exhausted it doesn't matter how much time you have - it deprecates to zero. Although the push to be on camera is embedded in the culture of an organization, if you are at an org that wants to "see all your happy faces" because "we value the face to face interaction" this is a time for you to step up and set clear limits for your ability to do that. Maybe you decide to go on camera for meetings later in the day, or some percentage of meetings. What you shouldn't do is nothing, and then force yourself into a Zoom fatigue. Also if you do nothing, how can an organization ever have change? Someone has to set the example. This isn't necessarily an issue for everyone, but it is for me.

> Identify what level of "on camera" virtual meetings tires you out and set limits for yourself.


### Do "The Day Before Checks"

I don't think this is essential, but I like to get a glimse of the next day the day before, which usually means looking at my calendar(s). Then I can easily go through most of the day without checking them again. I can also plan out my day in some general sense (OK, need to exercise by this time, and can use this chunk for working). I do that less often, but sometimes. This isn't essential, but for someone that gets stressed out by time, it's been my preference.

### Make Decisions Under Uncertainty

I've seen a lot of people close to me freeze under uncertainty. Perhaps they are starting a new project and they can't write a line of code
until they have absolute certainty about details. Or they are doing some data science work and feel that they need to understand every possible derivation
of an algorithm before choosing one. My advise here is not freeze. Of course there is a minimal amount of information you need to start something, but it's okay to start with maybe 60% certainty about something and change your mind as you go. I've actually found that I learn while exploring an idea, even if I wind up changing my mind. Is this maybe a form of learning by doing? If so, the only difference between learning by doing and passive learning is that in the second case you have nothing to show for it.

Another point here is that there is something to say about failing quickly. If you can quickly try something and determine that it's not a good option, this gets you one step closer to the desired outcome. Had you sat there in decision paralysis, you wouldn't have even gotten this far.

> Don't be afraid to jump in without certainty. Failure can be a good thing for progress.

### Have Self Compassion

Being really productive one day also means having self compassion for days that you cannot. For example, days where I need to give talks (like today!)
I take especially easy. I had a talk at 3:30pm so I planned to exercise around 1:30pm, take a nap at 2:30pm, and then casually get ready at 3:00pm. Thankfully I only need to do this 5-10 times a year, but it's a pretty demanding and social performance experience that I make sure I'm rested beforehand. You can't give a really great talk if you are tired and stressed.

> Be kind to yourself, because without you there is no work.

### Choose to Not Do It

This is a hard one to see, because typically when we put something down on our TODO list, or if someone suggests to do something, we need to do it right?
It's a skill in and of itself to decide that something *isn't* worth doing. For example, is it worth stressing yourself out to make a last minute paper deadline for some random conference you don't care about?  Is it worth starting a new project that is going to take a ton of time that you haven't identified a really strong use case or audience for? Sometimes when I used to go in the store to buy things (pre-pandemic) I would see something that I reactively wanted. Let's say if I were a teenager it might be a shirt at Target. I'd walk around the store with it for most of my shopping, and do a re-evaluation at the end. Did I really need it? Was it important to me, or was I just quickly drawn to it and reacted? In most of these cases I'd put the shirt back, because I truly didn't need a shirt. The same can be true for projects - you might get overly ambitious or excited, and it's not that you will never do it, but the time might not be now. What to do? Keep a separate little list of your ideas. I can promise that you'll have insights later and work on these projects. For example, a project I created in 2021 that is proving to be a useful tool is Singularity Registry HPC. I had this idea years earlier, but didn't see the audience. Early in that year when someone approached me about this kind of idea? I realized I had the audience, and I started the project. About a year later I'm so happy that I did!

This is also really good rationale for sharing your ideas with others. Many of us have lists of ideas and things we want to try, but are waiting until we get some evidence there is a signal out there for wanting it.

Finally, a point needs to be made here that sometimes you need to stand up for yourself, or more specifically what you think is right. If someone tells you to walk from the east to the west coast and you (being a seasoned human) know that we have these things called cars and planes, perhaps you should speak up and mention there is a better way? And that you will take "walk across the country" off of your TODO list? A lot of times if you have something that feels like busy work on your TODO list, question why it's there, and why it needs to be done. What will you (or someone else) gain from it?

### Find Your Flow State

Have you ever been in a flow state of work? It helps to have a lot of time, and for me I can quickly get into one with music. Once I turn on the music
and my editor is open, time flies by, and productivity seems to happen. I also like being surrounded by colored lights and having a music video playing in front of me along with the music for a bit of treadmill dancing. However, the environment for your flow state may not look like mine.
It could be you can achieve flow in a coffee shop, or even in complete quiet.

### Lounge Time

I think it's interesting that some of us work so much that we don't leave any time for thinking! Why do you think "shower thoughts" is a thing? It's because some people really don't relax and think until they are in the shower and then "aha!" the solution to that hard problem comes to light. This also happens to me during a good sleep or even a nap. So what I want to suggest here is to make sure to fit some "lounge time," whether that's laying on the bed staring at the ceiling, on a rug out an open window, or in a comfy chair with your eyes closed - make sure you get some time like this every day. It's just for you, to relax and let your mind wander. I can't tell you how many insights have come to me when I'm not working.


### Routine saves time

This might be my preference, but I find that (for other aspects of my day) when I follow a routine it's less to think about. For example, I don't need to plan outfits or know where to find clothing, I always keep them in the same place in the closet and grab the same ones. I have the same routine in the morning, and routine for dinner, and nightly routine. This kind of consistency gives me some stability if there is a lot of change in my work. Of course if your state catches on fire and the world starts to fall apart, even the best routine won't help you! But generally, routine is good to give you some comfort. But in a larger sense, if you have parts of your day that feel taxing, see if you can turn any of the pieces into a routine (that perhaps you can optimize?) so it is less so.

### Save Activation Energy

I often leave one tiny thing on my TODO list so I will be more eager to start work on it the next day. I call this "activation energy" or being able
to overcome the interia of say, a very comfortable bed. I'm not saying that you shouldn't sleep in if you need or want to, but that work is more fulfilling when you look forward to it, and often starting on the right foot makes you more productive.

### Put Yourself in Other's Shoes

This might not be a problem that other people have, but I often run out of things to do. Now, I might want more than anything to dive into a fun
personal project, but I'm certainly not being paid by my employer to do that. This is where I sometimes step outside of myself (metaphorically) and look
at the situation around me. What are other people working on? What is important for the project? I might look into something, start a small project, or
engage with people in Slack with a new idea that I think might be cool or useful. If it's a good day, you'll get a response and maybe some people
will be excited about your idea. But the key to this tip is:

> You can find insights when you try to take the perspective of others

### Make Choices to do things you like

This is a very long term one! The role that you pursue obviously has implications for time management. 
If you decide to be a manager, you are making a life choice about more meetings. You will have to meet with some number
of higher up committees and then your team members individually and each of those takes times. There is really no way to
get around that unless you derive some weird "hands off" management strategy nobody has ever heard of.
My life choice is to never go into management. I like freedom. You can't pay for temporal freedom. But if you
make the right choices you can get paid while you have it :)

So my advise here to always re-assess your life choices. If you want to try management or a higher interaction role? Go for it.
Don't be afraid to look at your daily routine a year later and decide if you like it. If you don't like it? Go back to what you were
doing before. You don't exist to please other people.

## TLDR

Do others have tricks for productivity and time management? Are these reasonable points or am I just a fast typer and thus programmer?
Could it actually be my level of focus and not any tricks? I don't use any special tools, and (at least in my head) I feel relaxed and lazy.
I want to recognize that I could just be biased in the sampling of roles that I've had over the years - perhaps it's just the case that I have selected easy jobs and I've never experienced a truly difficult one. It could also be that I am less social and would rather program on weekends than whatever a social person would do. But I don't know, I used to work in food service as a teenager and I was really good when things picked up. 
So I suspect there is some combination of focus, handling lots of tasks at once, and knowing what to do in the face of uncertainty. So here are my final advice points!

<ol class="custom-counter">
<li>Turn off all notifications (minus on-call ones) and respond on your own time.</li>
<li>Break big things into smaller things, and do smaller things for mental boosts</li>
<li>Move towards work that you like to do.</li>
<li>Recognize patterns in your work, create templates, and re-use!</li>
<li>Minimize meetings. Make the ones you have to go to better</li>
<li>Watch out for zoom (or other tech) fatigue and manage it</li>
<li>Learn to make decisions under uncertainty</li>
<li>Prioritize sleep! If you are well rested you will be more efficient.</li>
<li>Have days where you take it easy, especially after long or overly productive days</li>
<li>Question everything on your list. Don't do everything.</li>
<li>Take time to be a lounge lizard.</li>
<li>Find your flow state.</li>
<li>Turn taxing parts of your day into routines.</li>
<li>Leave fun things to start on the next day.</li>
<li>Get insights by taking the perspective of others.</li>
<li>Choose a role (engineer, manager) that matches your preferences for meetings.</li>
<li>If you don't like your work, find something else.</li>
<li>Take care of yourself, physically and mentally. Without you there is no work.</li>
<ol>

That's all! I hope some of these ideas might be useful to you.
