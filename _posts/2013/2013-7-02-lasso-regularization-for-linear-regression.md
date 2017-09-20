---
title: "LASSO: Regularization for Linear Regression"
date: 2013-7-02 19:40:29
tags:
  l1
  l1-norm
  lambda
  lasso
  linear-regression
  ridge-regression
---


From the [mind of the master](http://www-stat.stanford.edu/~tibs/lasso.html), we can define lasso as follows:

"The Lasso is a shrinkage and selection method for linear regression. It minimizes the usual sum of squared errors, with a bound on the sum of the absolute values of the coefficients. It has connections to soft-thresholding of wavelet coefficients, forward stagewise regression, and boosting methods."

Let's talk about what this actually means.

**What is linear regression, and why would I use it?**

****Linear regression in the most basic sense is finding a linear equation (a line) that best goes through a set of points.  When I say "best goes through a set of points," I mean that the line is positioned in the way that it is closest to every point.  We find this line by minimizing the sum of squared distances to it.  For a detailed review of linear regression, see [this earlier post](http://www.vbmis.com/learn/?p=100 "Linear Regression").

**What problems might I face with standard linear regression?**

Linear regression aims to minimize this sum of squared distances for every feature x to predict our outcome y.  What if we have features that aren't relevant to what we are trying to predict?  This is a case when we need the help of a **regularization technique**, which does the following:

- reduces the number of predictors in the model
- reduces redundant predictors
- identifies the most important predictors

Do these things sound familiar?  This is essentially **feature selection, **however unlike the [standard approaches](http://www.vbmis.com/learn/?p=334 "Feature Selection") that I discussed previously, these methods are built into the model.  After we use a regularization technique, we are likely to result with a better model, meaning that our estimates for the parameters yield lower errors than if using least squares alone.

**How does LASSO work?**

****Like with ridge regression, we are going to introduce a penalty term to our optimization function that will constrain the size of the coefficients.  We are going to set as many of the coefficients to zero as we can, and this is why it is called "the lasso" (think of an old Western movie with a guy on a horse with a lasso trying to capture the best chickens out of a bunch.  Same thing right?).  In the equation below, you will recognize the first chunk as the least squares minimization algorithm.  The second chunk is the penalty term:

![](http://www.mathworks.com/help/stats/eqn1302545443.png)

**What do all these variables mean?**

- N is the number of observations (training data)
- yi is our response variable for observation i
- xi is the feature vector (of length p) at observation i.
- λ is a nonnegative regularization parameter, "a fudge factor," also known as a value of Lambda (more on this later)
- The β's are the coefficients we aim to optimize, all scalars.  You will notice that we are taking the absolute value of these betas.  This is called the [L1 norm](http://en.wikipedia.org/wiki/Norm_(mathematics)#Taxicab_norm_or_Manhattan_norm), or the Manhattan distance.  Whenever you hear someone talk about L1/L2/L-something norms, they are just talking about different ways of calculating distances.  From looking at the equation above, we know that the LASSO uses the L1 norm.

**Lambda is a fudge factor... what?**

Lambda is a variable that you must choose that generally controls the number of features to "zero out."  As λ increases, the number of nonzero components of β decreases, so choosing a larger value of Lambda will result in fewer features because we are penalizing more.  It's common to choose an optimal value of Lambda by way of [cross validation](http://www.vbmis.com/learn/?p=125 "Cross Validation") - meaning that you run your model with several different values, and choose the one that works best.

### **How do I use LASSO?**

Thanks to the amazing statistics department at Stanford, LASSO is available in both [Matlab](http://www.mathworks.com/help/stats/lasso.html) and [R](http://cran.r-project.org/web/packages/glmnet/index.html), specifically for R in a package called glmnet that also does elastic net and logistic regression.  These packages are nice because they will allow you to easily create cross validated models.  I have great appreciation for this, because when I used the [original glmnet package](http://www-stat.stanford.edu/~tibs/glmnet-matlab/) for Matlab a few years back, I had to do my own cross validation.

### ****Summary

In a nutshell, with lasso we can do both **variable selection **and **shrinkage**.  Using the L1 norms is pretty computationally efficient because the solution is convex, and it brings to light something that I read about called **"The Bet on Sparsity Principle*:" **

*"Assume that the underlying truth is sparse and use an ℓ1 penalty to try to recover it. If you’re right, you will do well. If you’re wrong— the underlying truth is not sparse—, then no method can do well."*

[Bickel, Buhlmann, Candes, Donoho, Johnstone,Yu ...*Elements of Statistical Learning]

In other words, it's probably more likely that a small set of variables best explain the outcome.  And if that isn't the case, you would be out of luck with developing a good method to predict your outcome from the features anyway!


