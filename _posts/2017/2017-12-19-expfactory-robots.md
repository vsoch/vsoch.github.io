---
title: "The Experiment Factory Robots"
date: 2017-12-19 1:25:00
---

I recently have been on a mission to eradicate all dust
(and associated mites) from my dinosaur cave, and procured a robot vaccuum. Very quickly
Pusheena-Vaccuum (this is his name) was decorated with Christmas ribbons, a daily schedule, and 
a small Christmas Pusheen to ride on top and manage the entire thing. Pusheenavacuum was highly
useful for unexpected use cases like annihilation of dust mites from my mattress:

![/assets/images/posts/expfactory-robots/vac.jpg](/assets/images/posts/expfactory-robots/vac.jpg)


But you can also see that Pusheen and the vacuum don't always get along. The apartment is unbelievably clean, and although this makes me very happy, I realize that I've defined a new 21st century "old lady" type, and especially one for socially inept, allergy prone unfortunate-to-exist-in-the-first-place individuals like myself. We won't become old cat ladies, or even old fishermen. We will exist in solitude with primarily robot friendships. I'm not particularly talented at designing real robots (and I place this into the hands of Google and other companies that have the most resources to sell me these things), but
I thought I could at least pretend. Here is my contribution to the robot world, the start of robots for web based experiments.

## The Experiment Factory Robots
If you go back to the <a href="https://www.ncbi.nlm.nih.gov/pmc/articles/PMC4844768/" target="_blank">original paper</a>, I had implemented a robot to run during Continuous Integration (testing)
that did a simple job of sniffing the browser, and based on a well known data structure provided by the experiment
software, would issue commands (think key presses and responses) to move to the next trial. It worked well for a small number of experiments, and many times caught simple javascript and runtime bugs that otherwise weren't being tested by a human. But after a year or two, and after I had (sadly) departed from my lab, the old structure of the experiment factory that had <a href="https://www.github.com/expfactory/expfactory-experiments" target="_blank">many experiments in one repository</a> meant that testing took hours (a few of the experiments range from 20-30 minutes!). This was obviously not ideal, and likely frustrating if a researcher just wanted to get it merged for use. The robot was disabled because of that. Of course, this made me a bit sad, but (with the <a href="https://vsoch.github.io/2017/expfactory-beta/" target="_blank">same spirit</a> of bringing back the Experiment Factory in an improved version), and after befriending my Pusheena-vaccuum, I decided that I would give the robots another go! Here they are in action:

{% include asciicast.html source='expfactory-robots-12-19-2017.json' title='The Experiment Factory Robots' author='vsochat@stanford.edu' %}

and what you can't see from the terminal is the browser opening up on its own, and running through the task without my intervention, and closing the browser.

<br>

![/assets/images/posts/expfactory-robots/chrome.png](/assets/images/posts/expfactory-robots/chrome.png)

If you want to just dive in, pull and use the Singularity image:

```
singularity pull --name expfactory-robots shub://expfactory/expfactory-robots
./expfactory-robots --help
```

For the official docs, see <a href="https://expfactory.github.io/integrations#expfactory-robots" target="_blank">here</a>, or go <a href="https://github.com/expfactory/expfactory-robots" target="_blank">straight to the code</a>. Stay tuned for a few more really cool integrations coming soon to make it easier to interactively generate and run experiments.
