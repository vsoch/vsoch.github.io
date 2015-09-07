---
title: "Elastic Net: Flexible Regularization for Linear Regression"
date: 2013-7-02 20:28:36
tags:
  elastic-net
  lasso
  regularization
  ridge-regression
---


As a reminder, a **regularization technique** applied to linear regression helps us to select the most relevant features, x, to predict an outcome y.  For now, see my post about [LASSO](http://www.vbmis.com/learn/?p=43 "LASSO: Regularization for Linear Regression") for more details about regularization.  Both LASSO and elastic net, broadly, are good for cases when you have lots of features, and you want to set a lot of their coefficients to zero when building the model.  How do they compare?  I'm not the best to ask about this, but I read that when you have lots of correlated features, elastic net can outperform LASSO.

### What is elastic net?

**Elastic net **is what I am calling a "flexible" regularization technique because it lets you play around with a second fudge parameter, alpha, to fluctuate between **ridge regression **and linear regression with **LASSO** that uses the L1 norm.  If ridge regression and lasso regularization smooshed together and had a baby, it would be elastic net.  How does this work?  Here is the optimization problem for elastic net:

![](http://www.mathworks.com/help/stats/eqn1302546361.png)

where:

![](http://www.mathworks.com/help/stats/eqn1302546395.png)

As before, you will recognize the first term in the first equation as the least squares optimization technique, and the second is an additional **penalty term** that is defined in the second equation.  This penalty term aims to make the resulting "chosen" features sparse, meaning that we set as many of the coefficients (betas) to zero as possible.  The cool thing, however, is that we have this new term, alpha, that let's the elastic net fluctuate between LASSO (when alpha = 1) and ridge regression (when alpha = 0).  And yes, alpha is defined in the range of [0,1].

### How does elastic net relate to LASSO and Ridge Regression?

Take a look at the equation above, and try plugging in 1 for alpha.  The second penalty term gets a multiplier of 0, and so it largely goes away, leaving the exact same equation with the L1 norm that is, by definition, the LASSO regularization technique:

![](http://www.mathworks.com/help/stats/eqn1302545443.png)

How cool is that?!  Now try setting alpha = 0.  We get a standard ridge regression, which (I believe) is exactly the same thing, but using the L2 instead of the L1 norm.  In general, Lasso outperforms ridge regression when there are a good set of sizable effect (over many small effects).  The good news is that you largely don't need to decide - just optimize elastic net.

### How do I use elastic net?

Now that we have *two* fudge factors / parameters to set (Lambda AND alpha), you might be panicking about the best way to go about figuring out what to do.  There are likely more elegant methods, but in the past what I've done is a grid search for alpha within a cross validation to find Lambda.  This means that, for each value of Lambda that I am testing, I calculate the error of the model for alpha from 0 to 1 in increments of .01.  I then choose the value of alpha with the lowest error for that particular Lambda.  Generally what happens is that you will get a sense of a neighborhood of alpha that works best for your data (in my experience with my data the values tend to be smaller, erring more toward ridge regression), and then you don't have to run something so computationally intensive every time.

In terms of packages that you can use for elastic net, again you would want the glmnet package in [R](http://cran.r-project.org/web/packages/glmnet/index.html), and actually, elastic net comes via the [lasso function in Matlab](http://www.mathworks.com/help/stats/lasso.html) as well, you just specify the alpha parameter to not be equal to 1.


