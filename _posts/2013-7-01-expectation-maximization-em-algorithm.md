---
title: "Expectation Maximization (EM) Algorithm"
date: 2013-7-01 16:27:35
tags:
  e-step
  em
  expectation-maximization
  latent-variable
  m-step
  machine-learning-2
  unsupervised-2
---


Let's talk about jelly beans.  Specifically, imagine that you took a bag of every single brand of jelly bean in the world (meaning different colors, sizes, and ingredients) and dumped them into a bin.  Your bin now has some k classes of jelly bean, and being very proud of your work, you seal the bin in a space capsule along with the k empty bags and launch it into orbit.

Two hundred years later, an alien species discovers your space capsule, and postulates that the beans originated in the k bags.  Being an inquisitive species, they want to re-organize the beans back into the k bags, however there is one problem.  The aliens are unable to taste, and so they cannot say anything about the flavors of the beans, and they are color blind, so the beans appear to them to be different shades of grey.

Here we have an **unsupervised** machine learning problem (due to not knowing any labels) for which we have observed features, x (size, texture, and anything the aliens can measure), and unobserved features, z (color and taste).  We call these unobserved features, z, **latent** or **hidden variables**.  If we could observe this data, it would be an easy problem to solve, because we would use maximum likelihood to solve for θ that maximize the log probability logP(x,z;θ).  However, since we don't know z, we can't do this.  We assume that our unobserved features, z, can be modeled with multinomial distributions, and we want to build a probabilistic model that can still do parameter selection in the presence of this missing data.  This might sound like Gaussian discriminant analysis, however the main difference is that we are using a different covariance matrix for each Gaussian, and we are modeling not with Bernoulli distributions, but with multinomial.  More on this later.  To build this probabilistic model we need expectation maximization.

### What is Expectation Maximization?

Expectation Maximization is a two step unsupervised machine learning algorithm that iteratively uses the data to makes guesses about the latent variables, z, and then uses these guesses to estimate the parameters.  We jump back and forth between guessing z and re-estimating the parameters until convergence. Specifically, we:

Repeat until convergence {

1. compute probabilities for each possible completion of the missing data using the current parameters, θ.  This is the **E-step**
2. We use the probabilities above to create a weighted training set consisting of all possible completions of the data.
3. We then use maximum likelihood estimation to get new parameter estimates.  This is the **M-step**.

}

If you think about it, this is like [maximum likelihood](http://www.vbmis.com/learn/?p=194 "Maximum Likelihood Estimation (MLE)") or [MAP estimation](http://www.vbmis.com/learn/?p=339 "Bayesian MAP Estimate") in the case of missing information.

### How does it work?

To explain the above in math, let's pretend for a second that we can observe the missing data, z.  We would model the log likelihood of our data given the class:

[![eq1](http://www.vbmis.com/learn/wp-content/uploads/2013/07/eq1.png)](http://www.vbmis.com/learn/wp-content/uploads/2013/07/eq1.png)

We would want to find a formula for each of the optimal parameters (the parameters, theta, mean, and covariance matrix) by taking the derivative with respect to each one.  As a reminder, the derivative of a function gets at the rate of change, so where the derivative is equal to zero, this is where we have a maximum.  This would be equivalent to the ****M-step:

[![eq1](http://www.vbmis.com/learn/wp-content/uploads/2013/07/eq11.png)](http://www.vbmis.com/learn/wp-content/uploads/2013/07/eq11.png)

But do you see why we cannot do this? We don't know anything about the class distribution, z.  Was it a jelly belly distribution, Jolly Rancher, or a Brachs?  This is why we have to guess the distribution of z, and the pretend that we are correct to update the parameters.  Let's re-write the above in context of the E and M step:

Until convergence...  {

**E-step: **for each i,j, set

[![eq1](http://www.vbmis.com/learn/wp-content/uploads/2013/07/eq12.png)](http://www.vbmis.com/learn/wp-content/uploads/2013/07/eq12.png) [![eq1](http://www.vbmis.com/learn/wp-content/uploads/2013/07/eq14.png)](http://www.vbmis.com/learn/wp-content/uploads/2013/07/eq14.png)

this is basically evaluating the density of a Gaussian with a particular mean and covariance at x(i), and the resulting weights that we get represent our current guesses for the values z(i).

**M-step: **update the parameters with the new weights

[![eq1](http://www.vbmis.com/learn/wp-content/uploads/2013/07/eq15.png)](http://www.vbmis.com/learn/wp-content/uploads/2013/07/eq15.png)

}

Note that the main difference between these parameters and what we had before (when we knew z) is that instead of an indicator variable, we have the weights.  The indicator variables before told us exactly which Gaussian (which jelly bean bag) each data point (jelly bean) originated from.  Now, we aren't so sure, so we have weights that reflect our belief for each jelly bean.

### Isn't this like K-Means Clustering?

A little bit, because the weights represent "soft" cluster assignments as opposed to hard assignments found with k-means.  And similarly to k-means, we are subject to local optima, so it's best to run it a few times.

 

 

 

}  
  


