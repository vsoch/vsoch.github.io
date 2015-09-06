---
title: "MRlog to create text log of nifti brain images"
date: 2011-9-23 15:40:11
tags:
  
---


Gone are the days of having messy, disorganized directories of neuroimaging files! Or, in my case, needing to process 800 datasets, for which each subject has three runs, and not knowing which one has the correct number of timepoints!

This python script takes in a top directory (to search all directories underneath) for nifti (.nii or .nii.gz) files, and then uses fsl or the MRtools module to read header data and output a list of images with paths and important information.

- [MRlog](http://vsoch.com/wiki/doku.php?id=ica_:mrlog "MRlog"): Details, usage, and the scripts
- [Github](https://github.com/vsoch/ica-/blob/master/MRlog.py): Straight to the script!

 


