---
title: "Visual: Should I use a linear model?"
date: 2013-8-21 19:24:08
tags:
  linear-model
  residual
  studentized-residual
---


I've read about this trick in two places, as a way to determine if the choice of a linear model for your data is a good one.  You can plot the residuals (the squared error terms) against each of the corresponding predicted values (the Y's), and if a linear fit is not good, you will see funky shapes!  For example, (another fantastic graphic from ESL with Applications in R):

[![eq1](http://www.vbmis.com/learn/wp-content/uploads/2013/08/eq17.png)](http://www.vbmis.com/learn/wp-content/uploads/2013/08/eq17.png)

The plot on the right shows that a linear model is not a good fit to the data, because there is a strong pattern that indicates non-linearity.  When we transform some of the variables (for example, squaring one of them), this pattern goes away (the image on the right).  Transforming your variables is another trick that we use to use linear regression to fit polynomial-looking data.  Very cool!  Plotting the residuals like this is also a good strategy to find outliers.  While an outlier may not change your model fit drastically, it can drastically change the R (squared) statistic, so you should keep watch!  In this case, we can also calculate the **studentized residuals, **which basically means dividing by the standard deviation, and then plotting that.  If there is a studentized residual greater then about 3, spidey sense says that it is probably an outlier.
