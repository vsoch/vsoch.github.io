---
title: "covcheck_free.m Release!"
date: 2011-2-25 12:53:44
tags:
  
---


I have recently updated my coverage checking script to allow for more flexibility in selecting raw mask image files. As a reminder, [here is the original](http://vsoch.com/blog/2010/07/coverage-check-cov_check-m-alpha-release/ "Coverage Check (cov_check.m) Alpha Release!") version.

While this original solution worked well with the pipelines established in my lab, I realized that, long term, the script was not flexible enough to account for changes in directory hierarchy or task lists. Thus, I have modified it so that instead of selecting an experiment and a task and having a hard coded spot to create the output folder, the new version allows the user to select his or her own location to create the output folder, as well as a custom list of mask image paths. This means that we aren’t limited to any particular experiment, task, and could even run a session with data from multiple different experiments.

I am content with these changes for now, however I am aware that this script still requires the BIAC tools to function correctly, as well as some SPM functions. In the long run I would like to develop a stand alone application for checking coverage, given that the user has only a set of images to check coverage for, and a desired mask!

**Overall Changes**

- User no longer has to select experiment, task, number of subjects, or list of subjects. A simple input of mask image paths is asked for instead.
- Output files no longer print subject IDs, but these paths, which it is assumed contain the subject IDs. Granted that the list of paths is likely prepared in advance or takes time to select, this means that it can be saved somewhere for an incredibly easy copy paste to run the same coverage check.
- The script only includes support for .img/.hdr files, as I am not comfortable enabling other formats without lots of testing!

[covcheck_free](https://gist.github.com/vsoch/8247677)


