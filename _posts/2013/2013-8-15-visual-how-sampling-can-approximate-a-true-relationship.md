---
title: "Visual: How Sampling can Approximate a True Relationship"
date: 2013-8-15 17:48:02
tags:
  central-limit-theorum
  error
  law-of-large-numbers
  least-squares
---


We know from central limit theorem and the law of large numbers that when we take a bunch of random samples from some unknown distribution, and then look at the distribution of sample means, as our number of samples goes to infinity the distribution look normal, and the mean of this normal distribution approaches the expected value of the "true" mean of the distribution. My favorite explanation of this phenomenon comes from [Sal Khan at the Khan Academy](https://www.khanacademy.org/math/probability/statistics-inferential/sampling_distribution/v/central-limit-theorem), and I just stumbled on a nice plot that shows how the same idea is true with regard to linear regression.

How Sampling can Approximate a True Relationship: Linear Regression

This plot is from ESL with Applications in R.  The plot on the left shows our data, with the red line representing the "true" linear relationship (for the entire population), and the blue line representing an approximation made with a sample by way of minimizing the sum of squared errors.  We can see that, although the two lines aren't exact, the estimation using the sample isn't so far off.

[![sample_mean](http://www.vbmis.com/learn/wp-content/uploads/2013/08/sample_mean-785x440.png)](http://www.vbmis.com/learn/wp-content/uploads/2013/08/sample_mean.png)

The plot on the right again shows our population "true" relationship (red), and the sample estimate (dark blue), however now we have added a bunch of estimates from many random samples (the light blue lines).  Here is the super cool part - we can see that if we take an average of these random sample lines, we come quite close to the true relationship, the red line!  I (think) this is a good example of something akin to central limit theorum applied to a learning algorithm.


