---
title: "Agentic Orchestration of an HPC Workload in Cloud"
date: 2025-11-21 09:00:00
---

One of the most satisfying and learning-rich pieces of work from this year is represented in this white paper, "Agentic Orchestration of HPC Applications: A study using Google Gemini in Cloud."

<embed src="{{ site.baseurl }}/assets/posts/agentic-orchestration-hpc-workloads-cloud-sochat-milroy.pdf" type="application/pdf" width="100%" height="600px" />

First, I'll provide a little bit of back-story. We were using simple models to convert JSON job specifications or batch jobs between formats. 
I had a sense that the agents (specifically, Gemini) could do much more, and dove in. At first I was not sure the agent could successfully build a Docker container. It did. 
And then I was not sure about deployment and optimization in Kubernetes. That worked! Of course, there was a lot of nuanced detail with respect to how the orchestration
was done, and how me (the human) interacted with the agents as a team. The learning from this early work is represented in this white paper.

In summary, we used an agentic team (with Google's Gemini) to build, deploy, optimize, and run scaling studies for HPC applications in Kubernetes. 
Work is underway (and most of the software done) to do similar experiments using AutoGen, LangChain, and a more formalized state machine design with Model Context Protocol (MCP).
This work is immensely exciting because we have more ideas for extending agents to scheduling, topology, and job design. 
We released this as a white paper since we wanted to extend it before any kind of journal submission, and (for me) I care more about sharing the work than getting it into some high-end venue.
