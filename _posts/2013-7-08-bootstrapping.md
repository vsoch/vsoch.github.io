---
title: "Bootstrapping"
date: 2013-7-08 21:05:57
tags:
  
---


**Bootstrapping** is another strategy (like cross validation) that we can use for validation or parameter estimation if there is not enough data.  The technique is simple: we basically do random sampling from the original dataset to generate a larger dataset that we can either estimate some population parameter from, or use to train a model.   I (think) that bootstrapping is most commonly used to estimate standard errors of predictions (as outlined below).

1. Sample N times randomly from our training dataset to make a "bootstrap" dataset
2. Estimate your model on the bootstrap dataset
3. Make predictions for the original training set

Repeat many times and average your results (accuracy, error, etc).  You could also do a modified version that estimates errors using the samples *not* included in the bootstrap dataset.  To do this you would simply need to keep track of who was picked each time, and then use a set difference function with that list and the original training set to get who was not included. (Matlab function is [setdiff](http://www.mathworks.com/help/simulink/slref/setdiff.html))


