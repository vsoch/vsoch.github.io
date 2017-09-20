---
title: "Interactive Timeseries Visualization"
date: 2011-1-09 11:39:22
tags:
  data
  matlab
  timeseries
  visualization
---


I am working on a mini project that, simply put, will be a webpage that visualizes BOLD timeseries for a particular task and contrast. The goal is to have these average group timeseries created and uploaded automatically so that there is always updated, live data to play with in the browser. I put together a rough mock up, which I’m excited to share! Here are the rough steps that I mentally sketched out to make this possible for one of our tasks.

**1. Script extracts and organizes data**: Matlab is data master, so matlab was my choice for collected the data. I wrote up a [quick script](https://gist.github.com/vsoch/8247814) that goes through folders for each subject where we store timeseries matrices, and based on the names and embedded data, creates a master matrix of mean values for each contrast of interest. To step back a bit, these individual subject matrices are made when we run our PPI (Psychophysiological Interactions) pipeline, which, as part of the analysis, will produce a timeseries of values for a particular contrast / mask. We are currently using anatomically and functionally defined masks, so the area that the values are extracted from would be based on significant activation for an entire group, and an anatomical mask like the amygdala. Anyway, this script jumps around the various folders, figures out the masks and contrasts that we have data for, and creates a mean timeseries for each. It’s a harmless little scripty because it just loads data matrices and reads them, and then writes the extensive data to a .csv file for the next step.

**2. Get data into web: **This next step I did manually for my mock up, but this would be incredibly easy to have done automatically, if that is what we choose. The web interface that I threw together is based on the Google Charts / Gapminder API, and the data is fed in live from a Google Spreadsheet. I can also code it to find a .csv file on a server somewhere, and read that data. I will decide on which one to utilize based on how often I would want this data updated, how it would be updated, and the level of security I want for the data. For the purposes of my mock up, I just imported the .csv into a google doc manually. But obviously there are very easy ways to get the data somewhere automatically! At the end of the day I can create a simple little batch script that checks for the data connection, produces the organized data matrix, formats it into a .csv, connects to somewhere to plop it, and that place that it gets plopped gets queried by the interactive chart. So awesome!

**3. Allow for customization: **This last step is something that I haven’t delved into yet because I’d like to talk with my lab mates about how we want this to look, and whether we want it to be more static (with a manual update maybe each time we have a datafreeze) or happen automatically, on a nightly basis, for example. I could make this a part of our site, and have a nice little interface that lets the user select the Task, the number of subjects, and I’m thinking that it would be cool to also have gender and genotype as variables, but this would make the entire task a little more challenging, because that information isn’t easily “grabbable” from anywhere. And I’m not sure about what we are allowed to show… I need to do a multitude of checks before I start to work on anything more official.

I figure that it would be cool to have something like this to show to a class, or anyone who is interested in what the lab is working on. For now, [here is the mock up](http://vsoch.com/LONG/Chart/longseries.html). I hope that you enjoy playing with this as much as I enjoyed making it!


