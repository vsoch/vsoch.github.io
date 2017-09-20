---
title: "Dual Regression to Compare Functional Brain Networks"
date: 2013-8-23 16:53:08
tags:
  dual-regression
  fmri
  functional-networks
  ica
---


I want to talk about a method that is quite popular with functional network analysis, namely to define functional networks for a group of people, and then go back and identify the same (unique) network for an individual.  This technique is called [dual regression](http://fsl.fmrib.ox.ac.uk/fsl/fslwiki/DualRegression), and if you want to do higher level analysis with this data, it's important to understand how it works, and the resulting spatial maps.  These beautiful pictures come by way of a poster from [Christian Beckmann](http://fsl.fmrib.ox.ac.uk/fsl/fslwiki/DualRegression?action=AttachFile&do=view&target=CB09.pdf), who has done quite a bit of work with FSL / Melodic / ICA.

### Define Group Networks

First, we use [independent component analysis](http://www.vbmis.com/learn/?p=88 "Independent Component Analysis (ICA)") to define group networks.  We do this the same way as we would for an individual network, except our "observed data" (X) that we decompose into a matrix of weights X spatial maps is actually many individuals' timeseries, stacked on top of one another:

[![fmri1](http://www.vbmis.com/learn/wp-content/uploads/2013/08/fmri1.png)](http://www.vbmis.com/learn/wp-content/uploads/2013/08/fmri1.png)

If you use FSL, this technique is called "multisession temporal concatenation."  I'm not a fan of using the GUI (especially for resting state because it doesn't have bandpass filtering, forces you to do some other filtering that isn't desired, forces doing individual ICA first (takes forever!), and also forces registration), so I typically use the [melodic utility](http://fsl.fmrib.ox.ac.uk/fsl/fslwiki/MELODIC) command line.  I'll do another post about the specific commands, etc.

Why wouldn't we just stop here? Because the group maps, by definition, lose meaningful detail on the level of the individual.  If you have group decomposition for two different groups you could identify equivalent networks with some template matching approach (or just visually) and then assess for differences, but at best that would be a very rough analysis.  This is where dual regression comes in.

### Dual Regression to Define Individual Components from Group Components

We start with a set of group components (the middle matrix), and our goal is to use these maps with each individual subject data (the first matrix) to define, first, timecourses, and then individual level spatial maps.  The picture below shows how this is done.  If X = group maps X timecourses,

[![fmri1](http://www.vbmis.com/learn/wp-content/uploads/2013/08/fmri11.png)](http://www.vbmis.com/learn/wp-content/uploads/2013/08/fmri11.png)

How does this make sense? Let's think about a simple case.  The value in row 1, column 1, of the first matrix (X) is produced by taking the first row of the middle matrix (G), and transposing it (the dot product) with the first column of the unknown matrix (I).  For example:

X11 = G11*I11 + G12*I21 + ... + G1n * In1

We know X11, and we know each of the G* values, so it becomes a simple case of solving for the "coefficients," I.  It's a linear equation.  We can extend this to the entire matrix, and we would want to solve for the matrix I in this equation:

X = G * I

I tried out a simple example of this in Matlab, and I just used the [linsolve](http://www.mathworks.com/help/matlab/ref/linsolve.html) function:

code

with a simply defined X and G, to produce a matrix I.  I then multipled G by I to affirm that I reproduced my X, and I did.  So, by doing this and solving for I, this matrix I represents the timecourses for an individual person relevant to the group spatial map.  In many implementations, we then normalize these timecourses to unit variance, so we can compare between them.  We can now use these individual timecourses to define the individual's spatial maps:

[![fmri1](http://www.vbmis.com/learn/wp-content/uploads/2013/08/fmri12.png)](http://www.vbmis.com/learn/wp-content/uploads/2013/08/fmri12.png)

Namely, we use the timecourses as temporal regressors in a General Linear Model (GLM) to come up with the spatial maps.  We can then do permutation testing to assess for differences between groups, or do some higher level analysis using the spatial maps and timecourses.

### Visualize Dual Regression Results

I wrote a script to create an incredibly simple web report visualization of the corrected and thresholded dual regression maps, one for each contrast.  You can see some [sample output here](http://www.vbmis.com/bmi/project/ndar/brainstemica/), and the [scripts are here](https://gist.github.com/vsoch/6323663).
