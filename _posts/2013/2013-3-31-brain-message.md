---
title: "Brain Message 1.0 to Write Secret Messages into fMRI"
date: 2013-3-31 18:08:51
tags:
  fmri
  ica
  matlab
  melodic
---


Have you ever seen interesting shapes emerge as components when running independent component analysis (ICA) on resting BOLD functional MRI (fMRI) data? What comes to mind is the one time I swear that I saw the Koolaid Pitcher mascot, and V1 (visual cortex) commonly looks like a heart (some people do in fact have love on the brain!)

Inspired by these shapes, and wanting to add a bit of fun to [bmi260](http://bmi260.stanford.edu "Biomedical Imaging Analysis and Interpretation"), a course I am TAing this quarter, I decided it would be fun to do a decomposition of functional data and find surprise messages.


## What does Brain Message do?

I created a quick Matlab script to do exactly that. It takes as input a specified message, and an output file name, and outputs a nifti file for use with independent component analysis:

> dummy = BrainMessage('message','output.nii');

You will want to create the image using the command above, and then run ICA. I normally use [FSL’s melodic](http://fsl.fmrib.ox.ac.uk/fsl/fslwiki/MELODIC "FSL MELODIC"), however another good option is the[ GIFT toolbox](http://icatb.sourceforge.net/groupica.htm "GIFT Toolbox"), for those users who prefer Matlab and SPM. The script uses SPM to read and write images, and you can of course change these function calls to your preference. When running ICA, you can estimate the number of components or use your method of choice, however I will tell you that 46 should work best.

Here is an example letter:

[![K](http://www.vsoch.com/blog/wp-content/uploads/2013/03/K-300x300.png)](http://www.vsoch.com/blog/wp-content/uploads/2013/03/K.png)

 


## How does it work?

I basically start with a set of real component timecourses and spatial map distributions, and modify the spatial maps to take the shape of letter templates. The algorithm solves for the matrix W in the equation S = W X, where S is the observed signal, W is some matrix of weights, and X is the unmixed signal. Applied to fMRI, our matrix of weights consists of columns of timecourses, and the unmixed signal has rows of component spatial maps. I therefore went about this backwards, and multiplied rows of timecourses with edited spatial maps to come up with the observed data, S. In other words, for each letter, we multiply a column of Nx1 timepoints by a squished spatial map (a row of 1xV voxels) to result in a matrix of size NxV. I then decided to add in some real functional network spatial maps to make the data more realistic.


## Where do the templates come from?

These three sets of templates come zipped up with the script, and there are 46 of them, meaning that you are limited to creating messages 46 characters long. Why did I choose to do this? I wanted this data to be as “real” as possible as opposed to the other option of generating random timecourses and distributions. You could easily edit the script to make everything faux and remove this limit. Secondly, I wanted uncovering the letters to not be consistently easy. By using real data I would be sampling from components with varying strength, and so a resulting spatial map can come out weaker by chance, making seeing it more challenging.


## What can I change?

You can easily modify the script to generate fake timecourses, and not limit to messages of 46 characters. You can also create new templates (smiley faces, custom logos), or improve the code however you see fit. Have fun!

[Download Scripts](https://github.com/vsoch/BrainMessage "BrainMessage")


