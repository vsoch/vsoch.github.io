---
title: "Introduction to Weka"
date: 2013-11-25 16:35:47
tags:
  classifier
  introduction
  machine-learning
  weka
---


I'm new to using Weka, so I thought that it would be useful to log my steps.

### Data Import

It's likely that you will need to export your from your statistical software of choice by formatting it in the [.arff file](http://www.cs.waikato.ac.nz/ml/weka/arff.html) standard.  I wrote a script that [exports from R](https://gist.github.com/vsoch/7633498), and could be easily tweaked.  When you start Weka, click on "Explorer" and "Open File" to import the .arff file.  If there is something wrong with your formatting, it will tell you.  Keep in mind that your data types (string, numeric, or nominal) will determine which kinds of analyses that you can do.  Missing values should be exported as question marks, ?.  When you import your data, Weka assumes that the last variable is your label of interest, so in my case this was a nominal variable with two classes, in the file, specified as:

`@attribute RXStr {0,1}`

You can also change this selection using the drop down menu above the graph visualization.  If you have a nominal variable selected, all of your features will be colored by these groups (eg, red and blue in the picture below).  Obviously, the list on the left are the attributes that you've loaded, and you can select each one by clicking on it, or using any of the buttons on top of the box.  Details for each feature are displayed on the right side of the GUI.

[![weka](http://www.vbmis.com/learn/wp-content/uploads/2013/11/weka-300x224.png)](http://www.vbmis.com/learn/wp-content/uploads/2013/11/weka.png)

If you click on "edit" in the top right, you can see all of your data, and even click a box to edit it.

[![weka](http://www.vbmis.com/learn/wp-content/uploads/2013/11/weka1-300x282.png)](http://www.vbmis.com/learn/wp-content/uploads/2013/11/weka1.png)

### **Data Preprocessing**

It's probably best to do normalization and other preprocessing before export, at least I don't like some black box GUI getting all handsy with my data!  However, if you haven't, you can click on "filters" above your features to see lots of options.  You can normalize, discretize, change variable types, the whole shabang!  I'm not a fan of this, but you can also [replaceMissingValues](http://weka.sourceforge.net/doc.dev/weka/filters/unsupervised/attribute/ReplaceMissingValues.html), if your algorithm of choice doesn't allow for them.  [Feature selection](http://weka.wikispaces.com/Performing+attribute+selection) is something else you might want to do, and while you have most power via the command line, you can use the GUI under "Select attributes" tab.  You can also choose a classifier of type "meta" that folds it into the algorithm.  I'm sure that there is a more elegant way of doing this, but after "selecting attributes" I right clicked on the result and saved my reduced set as a new data file to run analyses.

### **Classify (or Cluster)**

The classify tab is where the meat of Weka is.  Remember that classify = "we have a label that we want to predict (supervised)" and cluster means "unsupervised."  However, also note that Weka lets you validate an unsupervised clustering based on one of your variables.  On the top under "Choose" you can select your algorithm of choice, and the variable shown in the drop down menu is what you want to predict (normally it starts as your last variable imported).  An important note - the variable type that you have, and whether or not there are missing values, will determine which analyses you can do.  When your data doesn't fit an algorithm, it will be greyed out.  Note that the filtering is done based on ALL of the variables that are in your feature list, regardless of whether they are checked or not.  For example, I had a string uid that was preventing me from being able to run most of the algorithms, and only when I clicked "remove" did they become available for selection. Once you've made it beyond these fussy data import details, the rest is pretty intuitive - you select an analysis, whether you want cross validation or to use a training set, and then click "Start."

[![weka](http://www.vbmis.com/learn/wp-content/uploads/2013/11/weka2-300x170.png)](http://www.vbmis.com/learn/wp-content/uploads/2013/11/weka2.png)

### **Visualize**

The last useful tidbit is how to save and view your results.  If you right click on the analysis that you've just run in the list to the left, you can "save result buffer" and visualize (different visualizations depending on the algorithm).  You can also save the entire model, but I'm happy with the result buffer.  Also check out the "Visualize" tab, which will show pairwise plots of your variables (akin to ["pairs"](http://www.statmethods.net/graphs/scatterplot.html) in R).

### Throw Your Pancakes in the Air!

Once you get the hang of Weka, it is rather empowering to have so many powerful algorithms available at the click of a button!  And instant visualization!  For my first work at Stanford I coded an entire preprocessing / analysis and classifier / validation from scratch in Matlab, so this is, in two words, instant gratification!

### A Strategy?

One possible strategy (that seems glaringly obvious now that I've given Weka a go) is to use a GUI package like this to very quickly try out a bunch of methods on your data.  Then, once you get a sense of what your data looks like, and which classifiers might be a good fit, then you can go back to statistical powerhouse packages like R where you can really fine tune your analyses.  Also remember that Weka has [command line interface](http://weka.wikispaces.com/Primer) for more power in customization.  If you are a fan of python, also give [Orange a try](http://orange.biolab.si/).

