---
title: "Bayesian MAP Estimate"
date: 2013-6-30 16:39:33
tags:
  bayesian
  machine-learning
  map
  map-estimate
  regularization
---


The **MAP **estimate (maximum a posteriori) estimate is another way to estimate the optimal parameters for a supervised prediction problem.  As a reminder, when we had some training set with features x and labels, y, were using maximum likelihood to find the optimal value of θ:

[![eq1](http://www.vbmis.com/learn/wp-content/uploads/2013/06/eq116.png)](http://www.vbmis.com/learn/wp-content/uploads/2013/06/eq116.png)

What we didn't talk about is how this model makes assumptions about our parameters, θ.  We were making a **frequentist **assumption that these parameters were just constant numbers that we didn't know.  There is actually another field of thought from **Bayesian** statistics (these guys *love* probability) that would look at the problem a different way.  With this exact same data, a Bayesian view would think of θ as being a *random variable* pulled from a distribution, p(θ), and the value(s) that were pulled are unknown.  We *could* model this posterior distribution by taking an integral over θ, but this would be incredibly hard, and it usually can't be done in closed form.  Instead, we will use what is called the **MAP estimate** to approximate the posterior distribution with a single point estimate.  This estimate for θ is given by:

[![eq1](http://www.vbmis.com/learn/wp-content/uploads/2013/06/eq117.png)](http://www.vbmis.com/learn/wp-content/uploads/2013/06/eq117.png)

It's actually exactly the same as maximum likelihood except we have p(θ) (our prior beliefs about the distribution of θ) added to the end.

 


