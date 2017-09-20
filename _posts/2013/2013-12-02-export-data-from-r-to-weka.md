---
title: "Export Data from R to Weka"
date: 2013-12-02 18:56:31
tags:
  export
  r
  weka
---


This will be a quick post - I wanted to share an [updated script to export a data frame from R to Weka](https://gist.github.com/vsoch/7633498).  The older version was poorly designed to take in two different data matrices (one for numerical, the other for demographic), and I realized how silly this was in retrospect.  The user would want to hand the function one data frame with everything!  The old link from my previous post will work, however I wanted to clarify a few things:

- Data is a matrix of size n by m, with m features defining n data objects.
- Row names and column names are used for data and feature labels, respectively.
- All variables are assumed to be numeric, with the exception of the row names (the "uid" variable), which is a string.
- Missing values, currently set as -9999 and NA, are recoded as "?" Change this section (line 28) to fit your data.
- If you have a nominal outcome variable (eg, you want to color your data by a label in Weka) change the variable type as follows:

> @attribute groupVar {1,2}

with {1,2} corresponding to the set of options for the variable (these can also be strings).  You then want to select this variable in the dropdown next to "visualize all"

- More information on the .arff import format [is available here](http://www.cs.waikato.ac.nz/ml/weka/arff.html).
- Edit the script to your liking, it's pretty simple :O)

code

I am liking R a lot more than Matlab these days, oh dear!


