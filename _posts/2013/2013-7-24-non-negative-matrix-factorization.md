---
title: "Non-Negative Matrix Factorization"
date: 2013-7-24 19:13:27
tags:
  machine-learning
  non-negative-matrix-factorization
  unsupervised
---


**Non-negative matrix factorization (nnmf)** is an unsupervised machine learning method for (you predicted it, strictly *positive*) data!  The goal of nnmf, of course, is dimensionality reduction.  We start with a dataset, X (size N x p), and want to decompose it into a matrix of weights W (size N x r) multiplied by some matrix of components H (size r x p), the idea being that these components are a reduced representation of our original data.  We want the value of WH to do a good job approximating our original data:

[![eq1](http://www.vbmis.com/learn/wp-content/uploads/2013/07/eq129.png)](http://www.vbmis.com/learn/wp-content/uploads/2013/07/eq129.png)

Does this look familiar? It is incredibly similar to one of my favorite unsupervised learning algorithms, [independent component analysis](http://www.vbmis.com/learn/?p=88 "Independent Component Analysis (ICA)"), for which we equivalently decompose a data matrix, X, into a matrix of weights (A) multiplied by a matrix of components, the "true" signal (s).  The primary difference between these two algorithms is that ICA solves for the components based on the assumption of independence of the components.  In ICA, we are trying to maximize the non-gaussianity of our components (to maximize independence), and this is done, for example, by way of minimizing or maximizing kurtosis, which "gets at" independence,  because the kurtosis of a normal distribution is zero.  I will save discussion of different ways to solve for the weights of ICA for another post.  For now, just know that nnmf does *not* assume independence of the components.  This gives me a huge sigh of relief, because I never liked this assumption so much, even if it worked well.  The second salient difference from ICA is that, since our data is all positive, our resulting matrix of weights is also positive.

### Why am I excited about nnmf?

I have been exploring using ICA not for dimensionality reduction, but for definition of subgroups.  Broadly, I want to look at the mixing matrix as a matrix of weights telling us for any particular observation (a row) the relative contribution of that observation (one of the weights in that row) to each component.  In the case of ICA, you can see how this might not be an intuitive strategy, because we can have negative weights in the mixing matrix.  It makes sense that a weight of zero indicates no contribution, but what about a negative weight?  To prepare the data, the means are subtracted, and so a negative weight does not correspond to somehow being opposite of a positive one, it just indicates being less than one.  That's kind of confusing.  How do I interpret these negative weights?  nnmf, it seems, is more fit for this sort of interpretation because all the weights are positive.  In this light, nnmf can be thought of as a "soft clustering," with each weight representing the membership of that observation to the component in question.  That's super cool!  The data that I'm working with happens to be non-negative (because it represents volumes of different matter types), however nnmf would generally be fantastic for many types of imaging analysis, because color values are not negative.  Anyway, the goal of nnmf is to come up with this matrix of weights, W, and the associated components, H.  How do we do this?  First, a review of our assumptions:

### NNMF Assumptions

- <span style="line-height: 13px;">As we already stated, the data, X, is all positive</span>
- We still need to choose a value for r, the number of components.  As is true with ICA, r must be less than or equal to the max(N,p) (number of observations, number of features)

### Solving for W and H

We want to maximize the following equation:

[![eq1](http://www.vbmis.com/learn/wp-content/uploads/2013/07/eq130.png)](http://www.vbmis.com/learn/wp-content/uploads/2013/07/eq130.png)

This is derived from a [poisson distribution](http://en.wikipedia.org/wiki/Poisson_distribution) with mean (WH)ij.  If you look at the pdf (ok, wikipedia calls it a pmf, that's fair) for poisson, you will get a sense that the e term goes away when we take its log, and we are left with just the negative lambda parameter (in this case, the negative mean, defined above), and the value of k must be equal to 1, explaining the first term being just the log of the mean.  We then of course multiply each of our xij by the pdf/pmf, and multiply over all features and observations, to get the likelihood.  However, we don't see a product above because this is a log likelihood, meaning that we've taken the log of both sides.  As a reminder, we do this because it transforms the product into a nice sum, and so if any one of our values is zero, that doesn't mess up the entire calculation.

### How does it compare to other dimensionality reduction methods?

Here is where it gets cool, and I must note that I'm taking these pictures from The Elements of Statistical Learning, v.10.  NNMF was compared to standard [principal component analysis](http://www.vbmis.com/learn/?p=86 "Principal Component Analysis (PCA)"), and [vector quantization](http://www.vbmis.com/learn/?p=506 "Vector Quantization") (comparable to K-means) using a large database of picture's of people's faces.  Each method "learned" a set of 49 "basis" images (shown below), and the cool part is that the basis images of NNMF turn out to be parts of faces:

[![eq1](http://www.vbmis.com/learn/wp-content/uploads/2013/07/eq131.png)](http://www.vbmis.com/learn/wp-content/uploads/2013/07/eq131.png)

(from ESLv.10!)

Red indicates negative values, and black positive.  The big matrices on the left are the components, while the middle matrix represents the weights, and when you multiply them you get a reconstructed representation of the original data.

### Problems with NNMF - the solution is not unique

Ah, so it's not perfect.  The biggest problem is that the decomposition may not be unique.  The vectors that we choose to project our data onto can be anywhere between the coordinate axes and the points, and so we are biased based on our starting values.  Thank you, page 556 of ESL for illustrating this point in the case of two dimensional data:

[![eq1](http://www.vbmis.com/learn/wp-content/uploads/2013/07/eq132.png)](http://www.vbmis.com/learn/wp-content/uploads/2013/07/eq132.png)

### Problems with NNMF - we still need to choose a value for r

In the simplified explanation above, we start with a chosen value of r.  As with ICA, there are approaches (such as FastICA) that can be used to approximate the dimensionality, and I bet that we can do something similar for NNMF.  I need to think about this, and do more reading.


