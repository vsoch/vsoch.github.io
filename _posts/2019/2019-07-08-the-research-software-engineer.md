---
title: "The Story of the Research Software Engineer"
date: 2019-07-09 13:20:00
categories: rse
---

Have you heard of an RSE? It means Research Software Engineer. You might
need us for help with reproducible and sustainable research, but guess what?
We need you too. This post tells the story of the Research Software Engineer.
If you prefer, you can also have the story told to you:

<iframe width="560" height="315" src="https://www.youtube.com/embed/trAfA9VWLTQ" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

Either way, see the [Resources](#Resources) at the end of the post for useful links
if you want to learn more, or connect with the community of Research
Software Engineers.

<br>

# The Research Software Engineer

Once upon a time, there was a little hammer that could. She was surrounded
by others in the university cup that were in training to be scholars.
And my oh my she would watch them go! They would have the most interesting,
the most compelling burning questions about the world. And then they would summon
up a protocol to use the most fundamental tools of science and statistics to
answer it. These students were sharp. But for the little hammer that could,
she was only left to feel lacking. To her, everything looked like a nail. 
She didn't dream of finding answers, but rather building the databases 
and software that she imagined in her head. She was not scholarly, or 
sharp, she was consistent, hard working, organized,
and detail oriented. While the scholarly pupils would go off to become
academics or accredited data scientists, there was no path for her. 
But it was ironic, because the things that she cared about were so badly
needed for research practices to be reproducible, and for software
to be sustainable. If she made it through her field of study at all, what would become of her? 

This is the story of the research software engineer. While it's not the typical
story for every research software engineer, it highlights the fact that
a career track historically was not well established for someone 
that wanted to work on research software, data engineering, or other
engineering practices supporting research, but didn't necessarily want to be a traditional
researcher. This is the plot that unfolds in our story today.

## A Little Background

Research is becoming increasingly more about having skills and expertise
that go well beyond a particular domain of knowledge. To be a research scientist
in this day and age, not only do you need this domain expertise, but you
also need to know some statistics, you need to be academic enough to know
how to ask and answer scientific questions, and you also need some kind of
dataset or method to do so. But expertise and data is not enough. With the increasing
demand for using computational resources and scientific programming,
practices from software engineering have become standard practice in research today.

> But isn't it a little much to ask a researcher to do it all? 

In 2012 in the UK, the term "Research Software Engineering" started to be used to
describe this specific application of software engineering to research.
In 2014 a Research Software Engineer association was created 
with a focus around reusability, and reproducibility of research software.
Not surprisingly, this was also around the same time as the reproducibility crisis
came about in Psychology.

Since that time, there have been similar groups established in many other countries -
Australia, Canada, Nordic Countries, New Zealand, and finally the United States. 
But here's the thing - even without this official organization, 
research software engineering has been around for a long time.
It's really that now we're finally fighting to make the profession a career
track proper.


<br>

# What is an RSE?

RSE stands for "Research Software Engineer," and it broadly refers to
a software engineer that specializes in research software. This spans a wide
gamut. Some RSEs are more researchers that do programming, and others are 
trained software engineers that work on research problems. If you identify
as an RSE, regardless of where you fall on this spectrum, you are likely
bringing practices from software development like version control, continuous
integration, and data provenance into workflows to support sustainable software
for research.

## Where do I find RSEs?

So where do we find these RSEs anyway? The answer is that you might need to go
looking for them. RSEs are like marshmallows hiding in a box of gold mined Lucky Charms. 
They are like mushrooms in the forest. You might not see them unless you
proactively go out looking. But maybe you are lucky, and
your institution has an official group of RSEs with a manager and campus
presence. In that case, you don't have to look very far. 
But even if your institution doesn't have any kind of official 
RSE community, you will still find RSEs scattered
about the research community. Who are they? They are lab research associates, 
postdocs, staff, and sometimes even graduate students. They can be found at universities, academic institutions,
national labs, and even companies. Sometimes larger labs can afford to hire staff to exclusively
work on tools, and research computing groups play a role in helping their users
to write code.

## What are the types of RSEs?

As mentioned previously, an RSE can range from a researcher that does a lot of
programming, to a software engineer that works in research. While no single RSE
is likely to fall within one subtype, one RSE is likely to have one or more
facets, discussed next.

### Research Software Manager

An RSE Manager is typically the lead of a group of RSEs, with a role that might
be similar to a product manager in a company, or the head of a lab. This individual
usually has expertise in software development, and is a leader not just for the
work of the group, but the individuals in it. An institution would be very lucky
to have one or more RSE Managers, and it reflects well on the institution
itself. It suggests knowing the importance of software engineering practices for sustainable research,
and having acted on this knowledge.

### Domain Developer

It's likely that many RSEs sitting within labs started with or developed
domain knowledge. For example, a researcher developing software for neuroimaging
analysis is likely to be familiar with data formats and software for brain mapping.
The domain developer might sit in a specific department or lab, and work
exclusively on developing and maintaining software for the domain. Usually input,
goals, and feedback would come from the group that the developer serves.

### Researcher

A part of being an RSE might include conducting actual research. It could be
with respect to a domain of science, but it also might be research about
software engineering, open source development, or general practices of
conducting research to begin with.


### Generalist Programmer

In contrast to the domain developer, a generalist programmer might assist researchers
with good software development practices without having expertise about
a specific domain. For example, a statistical programmer might hold office hours
and assist researchers from departments across a university. This role can
be viewed as a service, where the programmer has expertise in his or
her practice, and researchers come to him or her to get support.

### Open Source Developer

While a generalist programmer helps researchers with code they are writing, an open source
RSE moves up one level to work on open source software that is valuable for their
user base. The open source RSE might solicit feedback from users, or 
use some other method to derive what software is valued, and what improvements
are needed.

### Generalist Developer

The genealist developer is by far the most challenging subtype of RSE, as it 
 sometimes requires intuition about what doesn't exist (but might) to 
improve research sustainability across groups. A generalist developer 
does not provide a service for researchers like the generalist programmer, 
but instead works on general software that intuitively could directly or 
indirectly help researchers. For example, developing new software that targets metadata provenance or
creation of reproducible artifacts might not be tied to an existing open source
project, and is less likely to be written into a grant and requested by a lab.
However, it would likely benefit researchers across domains, and perhaps they won't know
it until the software is available to them.

For all of the above, the margins are not set in stone. For example, you might
have an open source generalist developer that primarily works
on developing open source software for research, but also holds office hours
once a week to support researchers, and develops novel tools in spare time.


## What's the issue?

The issue is funding, of course. Despite the fact that
practices from software engineering are essential for reproducible research,
many institutions do not fund official RSE groups. Software as a service
is undefined, and folded into other departments and service groups.

> So what has resulted from that?

An institution that doesn't prioritize support for research software either requires
researchers to take on extra training to learn it, or to procure funding for a
(likely temporary) position to work on it. Larger labs might have more success
because they can hire more permanent engineering teams, however they still struggle
to attract talented engineers away from the equivalent (higher paying) roles in
industry.

> Why aren't there more RSE groups?

Historically, the awareness isn't there. Various groups that might hire software engineers
perhaps need to recover their salaries from grants, funding from other principle
investigators, or other monetary sources in a lab. At most institutions in the
United States, the responsibility of realizing the need for this expertise, 
hiring, and then sustaining a position has been the burden of individual labs
and small groups. Anyone that needed help with software might have been forced
to find training on their own, ask for help from support staff or other trainees in their lab, 
or go to general IT support to ask for help. Notably, IT support and other
groups like research computing support, libraries, and statistical help desks 
are not necessarily set up to help with longer term software projects, or
detailed work for software that might include setting up version control, testing,
and writing code itself. 

> What do we need?

In an ideal world, an institution would have a fully funded layer of research 
software engineers, where, for example, a graduate student that wanted help 
with development of an open source library could go. The graduate student wouldn't
be forced to learn on his or her own, or responsible for the longevity of a
lab's software. 

> Why is it bad that we don't have RSEs?

The results of this missing layer are dire. We don't have established standards for ensuring that
the software, methods, and data that supports a publication are reproducible. We
cannot ensure that code will be maintained. Further, anyone that is interested
in these areas of work must roll their own solution for finding and funding a
position. 

> What's so bad about that?

Okay, so let's say that we do that - it remains the burden of the interested
individual or group to roll their own solution. Is there a career track, or 
promise for future growth of the profession? Is there a community within the
instutiion to which the RSE feels a sense of belonging? The answer is no,
and what suffers is long term, sustainable research. 

## How can I help?

Any vision starts with awareness. You can express the need to your colleagues,
and others at your institution. If you are able, you can set aside funding in your
grants to hire an RSE. When you do, you can share and exemplify the work done 
to stress the importance to the larger community. The awareness must reach up
to the highest level of an institution to put policy in place that can
guarantee support for research software.

> Can I start a community of RSEs at my institution?

There isn't a one size fits all solution for any community, but here I'd like to make some
suggestions. Keep in mind that my perspective is not one of a manager, but 
one of the worker fish that wants to find other RSE fish.
If your institution doesn't have an RSE group, then you should
first start by joining communication channels of the country wide group.
For example, both the US and UK RSE groups have a Slack, email lists, and Twitter
handles (see [resources](#resources)). Just getting involved can help you to feel less
alone in your craft, and to start to foster relationships with other RSEs.
They might have a GitHub organization that you can join and then work on
developing a portal or group page for your specific community.

In the case that your institution has an established way to create groups of like minded
individuals, you can take advantage of that to find other RSEs that are also
hiding amongst the labs. For example, at my institution, we have something 
called "Communities of Practice."  This means that it was was possible for me
to create a definition for the group, and link to the larger community resources.
By the way, if you are someone at Stanford that works on research software,
please <a href="https://cop.stanford.edu/community/research-software-engineers" target="_blank">check it out!</a>

## A Future with Research Software Engineers

Can you imagine a future where the little hammer that could would have realized her
love for software engineering, and her desire to work in research, and then have
a clear career track and future presented to her? This is the future that we need to 
work toward - not just for reproducible science, but for the hearts and minds of all the
little hammers, nails, and other builders out there that have yet to grow.

<br>

# Resources

 - [The Research Software Engineers Association](https://rse.ac.uk/)
 - [The US Research Software Engineering Community](https://us-rse.org/)
 - [USRSE on GitHub](https://www.github.com/usrse/)
 - [US RSE Community Starter Pack](https://us-rse.org/starter-pack/#/)
 - [Stanford Research Software Engineer Community of Practice](https://cop.stanford.edu/community/research-software-engineers)

