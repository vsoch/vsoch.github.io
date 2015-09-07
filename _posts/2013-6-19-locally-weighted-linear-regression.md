---
title: "Locally Weighted Linear Regression"
date: 2013-6-19 16:46:03
tags:
  bandwidth
  local-linear-regression
  tau
  weight
---


Let's say that we have some relationship between our outcome variable (y) and one or more predictors (x) that isn't cleanly linear, quadratic, or even cubic.  Let's say that this relationship looks like a squiggle of pasta, and we might keep adding features to get a more squiggley curve, but then we run the risk of overfitting to this particular dataset.  How do we make predictions about values in this case?

We want to use **locally weighted linear regression**, which is a non-parametric regression method that is sort of like the love child of [linear regression](http://www.vbmis.com/learn/?p=100 "Linear Regression") and k nearest neighbor clustering.  **Non-parametric** means that we can't just derive an equation and throw away the data.  The model depends on the data in that whenever we want to classify a new point, we do so based on the most similar points in our dataset.  You can think of locally weighted linear regression as equivalent to linear regression, except when we minimize our least squares cost function to solve for our parameters, we give more weight to points in our dataset that are similar to the point we are trying to predict.  How does it work?

As a reminder, in linear regression we want to minimize the least squares cost function:

[![eq1](http://www.vbmis.com/learn/wp-content/uploads/2013/06/eq11.png)](http://www.vbmis.com/learn/wp-content/uploads/2013/06/eq11.png)

With locally weighted regression, it is exactly the same, except we have a vector of weights:

[![eq2](http://www.vbmis.com/learn/wp-content/uploads/2013/06/eq21.png)](http://www.vbmis.com/learn/wp-content/uploads/2013/06/eq21.png)

And we generally define the weights to be the distance of each point to our current x(i):

[![eq3](http://www.vbmis.com/learn/wp-content/uploads/2013/06/eq31.png)](http://www.vbmis.com/learn/wp-content/uploads/2013/06/eq31.png)

Incorporating this w(i) means that θ is chosen giving a higher weight to the errors on training examples close to our current x(i).  The "tau" symbol is the **bandwidth**, which you can think of as a parameter to fiddle with that controls the distance from the query point to define "close" neighbors.

 


