---
title: "The Flux Operator"
date: 2024-03-21 10:00:00
---

I am immensely proud to announce today that our paper on the [Flux Operator](https://doi.org/10.12688/f1000research.147989.1) is published in F1000 Research. This work represents my first taste of Kubernetes (at the end of 2022) and the start of work in a space of converged computing projects that I really enjoy. To tell you a bit of the story, I started engaging with the Flux Framework team on Slack, and was invited to several meetings (a converged computing one included) and had an opportunity to develop an operator in Go. I had never used Kubernetes meanintfully (let alone developed for it) but I jumped on the opportunity, and in the span of a weekend had plowed through some early learning to [create my first operator](https://vsoch.github.io/2022/kubernetes-lolcow-operator/) and then (after another weekend) come back with the first draft of the Flux Operator. This was also my first engagement with the [Batch working group](https://groups.google.com/a/kubernetes.io/g/wg-batch/c/u3eIlyo4F3g/m/c80n9gwrBAAJ), where I met Aldo (and in retrospect, Tim Hockin too) and Aldo's closing message:

> Looking forward to collaborating!

Was a foreshadow of things to come. It was an immensely fulfilling year, one of the best of my life to that point, because this work led to two talks at Kubecon, first for [Kubecon EU in Amsterdam](https://kccnceu2023.sched.com/event/1HyaG/enabling-hpc-and-ml-workloads-with-the-latest-kubernetes-job-features-michal-wozniak-google-vanessa-sochat-lawrence-livermore-national-laboratory) and then [Americas](https://kccncna2023.sched.com/event/1R2oD) for the same year. This particular collaborator with Google, namely with Aldo, Antonio, Abdullah, was especially important for our communities, as it represented two traditionally disparate communities, cloud and HPC, working together. The publication linked above is the full representation of that successful effort.

I don't particular love the academic expectation to write papers or not have a successful career, but I do like to write, and writing primarily technical software articles that discuss design thinking and forward thinking for the future is something that I greatly enjoy. I'll also note that all of the problems and issues with the operator that were mentioned have long since been addressed. This was a pleasure to write, and I hope you enjoy reading it. 