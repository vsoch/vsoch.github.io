---
title: "Gaussian Discriminant Analysis (GDA)"
date: 2013-6-27 20:50:01
tags:
  gaussian-discriminant-analysis
  gda
  lda
  linear-discriminant-analysis
  multivariate-normal-distribution
  qda
  quadratic-discriminant-analysis
---


**Gaussian Discriminant Analysis (GDA) **is another **generative learning algorithm**  that models p(x|y) as a **multivariate normal distribution**.  This means that:

[![Screenshot at 2013-06-27 13:10:39](http://www.vbmis.com/learn/wp-content/uploads/2013/06/Screenshot-at-2013-06-27-131039-300x143.png)](http://www.vbmis.com/learn/wp-content/uploads/2013/06/Screenshot-at-2013-06-27-131039.png)

The cursive N symbol is used to represent this particular distribution, which represents a nasty looking density equation that is parameterized by:

- μ0 and μ1: mean vectors
- Σ: the covariance matrix
- φ: what we vary to get different distributions

### **Covariance**

This is a two by two matrix, and for a standard normal distribution with zero mean, we have the identity matrix.  As the covariance gets larger (e.g., if we multiply it by a factor > 1), it spreads out and squashes down.  As covariance gets smaller (multiply by something less than 1), the distribution gets taller and thinner.  If we increase the off-diagonal entry in the covariance matrix, we skew the distribution along the line y=x.  If we decrease the off-diagonal entry, we skew the distribution in the opposite direction.

[![Screenshot at 2013-06-27 13:16:00 (copy)](http://www.vbmis.com/learn/wp-content/uploads/2013/06/Screenshot-at-2013-06-27-131600-copy.png)](http://www.vbmis.com/learn/wp-content/uploads/2013/06/Screenshot-at-2013-06-27-131600-copy.png)

### **Mean**

### [![Screenshot at 2013-06-27 13:16:00](http://www.vbmis.com/learn/wp-content/uploads/2013/06/Screenshot-at-2013-06-27-131600-300x66.png)](http://www.vbmis.com/learn/wp-content/uploads/2013/06/Screenshot-at-2013-06-27-131600.png)

In contrast, varying the mean actually translates (moves) the entire distribution.  Again, with the mean as the identity matrix, we have the mean at the origin, and a change to that corresponds to moving that number of units in each direction, if you can imagine sliding around the distribution in the image below:

![](https://upload.wikimedia.org/wikipedia/commons/8/8e/MultivariateNormal.png)

### Writing Out the Distributions

Ok, brace yourself, here comes the ugly probability distributions! Keep in mind that the symbols are just numbers, please don't be scared.  You will recognize the first as Bernoulli, and the second and third are the probability density functions for the multivariate Gaussian:

[![Screenshot at 2013-06-27 13:30:33](http://www.vbmis.com/learn/wp-content/uploads/2013/06/Screenshot-at-2013-06-27-133033.png)](http://www.vbmis.com/learn/wp-content/uploads/2013/06/Screenshot-at-2013-06-27-133033.png)

And as we have been doing, we now want to choose the parameters with maximum likelihood estimation.  In the case of multiple parameters in our function, we want to maximize the likelihood  with respect to each of the parameters:

[![Screenshot at 2013-06-27 13:35:32](http://www.vbmis.com/learn/wp-content/uploads/2013/06/Screenshot-at-2013-06-27-133532.png)](http://www.vbmis.com/learn/wp-content/uploads/2013/06/Screenshot-at-2013-06-27-133532.png)

 

You can do different kinds of [discriminant analysis in Matlab](http://www.mathworks.com/help/stats/discriminant-analysis.html) and [also in R](http://www.statmethods.net/advstats/discriminant.html).  Note that **Linear Discriminant Analysis (LDA)** assumes a shared covariance matrix, while **Quadratic Discriminant Analysis****(QDA)** does not.

### When to use GDA?

- if p(x|y) is multivariate Gaussian (with shared Σ), then p(y|x) follows a logistic function, however the converse is **not **true!
- GDA makes stronger modeling assumptions than logistic regression, so we would expect it to do better *if* our modeling assumptions are correct.
- Logistic regression makes weaker assumptions about our data, which means that it is more robust, so if we are wrong about our data being Gaussian, it will do better.

 

 

 


