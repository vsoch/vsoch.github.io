---
title: "Levels of a Research Software Engineering Group"
date: 2021-10-14 21:30:00
category: rse
---

Today we celebrate the first <a href="https://society-rse.org/international-rse-day-14th-october-2021/" target="_blank">International RSE Day</a>,
and I attended the <a href="https://us-rse.org/events/2021/2021-10-intnl-rse-day/" target="_blank">US-RSE events</a>. It was a lovely
little conference because it was mixed with presentations followed by discussion, and these kinds of discussion are both interesting
and can help foster collaboration between groups. Shout out to Blake Joyce that did a great job hosting!
Ian Cosden talked about creating his Research Software Engineering group at Princeton, and it quickly made me realize something.

> We are an iceberg.

I don't mean that we are going to be downing ships anytime soon, but I realized that there are different levels of
Research Software Engineers, where "level" can generally be thought of as the distance between the work
and the ultimate customer, the researcher. I came up with these three levels:

<ol class="custom-counter">
  <li><strong>Level 1: Research Software Engineer (Domain)</strong>: interacting directly with researchers</li>
  <li><strong>Level 2: Research Software Engineer (Generalist)</strong>: working on core tools for research</li>
  <li><strong>Level 3: Research Software Engineer (Researcher)</strong>: doing research for research software</li>
</ol>

Level 1 works directly with researchers, and by the time you get to Level 3 interaction can be rare.
Let's unwrap each of these levels a bit.  You can see the summary graphic below, and keep reading
below to get more details.

<div style="padding:20px">
  <img src="{{ site.baseurl }}/assets/images/posts/rseng/levels.png">
</div>

You can also get the source ascii <a href="https://gist.github.com/vsoch/5fdf0e067b229bdb2c794f878575de5b" target="_blank">in this gist</a>.

## Level 1: Research Software Engineer (Domain)

I believe that most RSEng fall into Level 1, and are working directly with researchers
on analysis pipelines, workflows, and other domain-oriented work aimed toward a publication.
This can mean that you are in a RSEng group proper, or working as an RSEng directly embedded within
a lab. You work directly with researchers, and your job is to understand their needs, meet them
where they are at, and help them achieve their goals. Software can be an end result of this collaboration,
but it doesn't have to be.. Along the way you might instill best practices
and routines for sustainability and reproducibility. This group is closest to researchers, and communication
with them is a given. This level of RSEng needs to be the interface between traditional academic
groups and software engineering best practices.

## Level 2: Research Software Engineer (Generalist)

Who originally designed the workflow managers, container technologies, or more generally,
the core software that researchers use? While many tools do arise from traditional academia meeting
a need (e.g., the Snakemake workflow manager came out of the biology community), there often
are RSEng that work on more generalist technologies. As an example, when I was at Stanford
I found every chance that I could to work on the original Singularity container technology.
There was no associated group or even funding source, but I knew it was important across domains.
It goes without saying that funding these generalist projects is much more challenging, at least
historically. Many groups with RSEng are not able to write grants, and those that can need
to find generalist grants that match what they want to do. This is also a challenging area
of work because it sometimes requires intoducing new practices or ideas into established workflows.
So although it is slightly further away from working directly with a research group, I still
think there is a lot of interaction with the research and RSEng community, because you have to
present your software and convince others to use it. I would even go as far to say that the
Generalists are more heavily interacting with open source communities for languages, workflow or
package managers, standards, or other core technologies.

## Level 3: Research Software Engineer (Research)

Level 3 encompasses research _for_ software engineering. The work in this level can
be very Computer Science heavy, but need not be. For example, for any core technology,
there might be an accepted way of doing something. This group of RSEng are trying to innovate,
or come up with new models or strategies for doing things that can then be implemented in core
software. This level is interesting because it brings up a different take on the term
"Research Software Engineer" - instead of someone doing software engineering for research,
they are doing research for software engineering. I talked about this a bit in an 
<a href="https://vsoch.github.io//2021/national-lab-vs-academia/#the-software-innovation-mindset" target="_blank">earlier post I wrote this year</a>.
This level of RSEng is arguably the furthest away from researchers, and the work
they do will trickle back down. For example, in my current role I'm working on developing
new models for assessing ABI (application binary interface) compatibility. If this effort is successful, the model could
be used in both package managers and containers to assess compatibility of say, a dependency
with an environment, or a container with the host. The work is fulfilling and different than anything
I every imagined doing, including doing binary analysis and more systems level stuff.
I can very easily get lost in the fun of working on very technical things and forget about the underlying drive to make life
overall better for anyone that installs software or uses containers. Thus, I'd say that Level
3 RSEng need a nice bonk in the head every once in a while to remind them of why
they are doing what they are doing in the first place!

## Examples

Let's take common needs of researchers and represent the work that might be done on each level.

| Research Need | Level 1  | Level 2 | Level 3 | 
|---------------|----------|---------|---------|
| Running a service | Setting up an application on Kubernetes on behalf of the researchers | Developing the application itself | Developing Kubernetes and internals |
| Install software | Teach and help researchers to use a package manager | Contributing to packages or the package manager software | Developing a new model for a package manager solver |
| Reproducibiity | Teach and help to containerize a workflow | Develop a container technology | Design a new metadata format for container registries with an emphasis on security |
| Run a workflow | Teach and help researchers to extend their code into pipelines | Develop a workflow manager technology | Design a new algorithm for parsing a DAG |
| Process data | Help researchers with data processing scripts | Write and maintain a library of general processing pipelines for a domain | Invent a new data format |

Do you see how the levels might work together? Level 1 (alongside the researchers) needs to communicate with Level 2 (the generalist builders) that there is a new need that isn't satisfied by current software. Level 2 might then report to Level 3 (the researchers of research software) that the tool isn't good enough, or is not supported in a way it could be. These levels work intimately together, and in fact within one person,
I can imagine we jump between them depending on the day! For example, early in my career as a researcher I was exclusvely in
Level 1. I wrote code to solve problems in science. When I joined a graduate school lab that also provided databases and software, I easily jumped into Level 2. For many of us, Level 2 is the first taste at open source, or what it means to be a maintainer. I would say I operated in Level 2 as a generalist developer for the start of my RSEng career at Stanford. In my new role I'm now fairly new to Level 3, and to be frank I'm sometimes
terrible at it because I never loved research. But the trick I've found is to take abstract problems and formulate them into concrete goals for
myself, and then I learn a lot along the way, and those small exercises and discoveries are fulfilling. 
Would I want to operate in Level 3 all of the time? Definitely not, because my
joy is derived from the pleasure of just building things and programming (Level 2) and feeling like those things
help researchers.

So if you step back, what levels do you operate on? Are there dimensions that I'm missing?
What do you think?
