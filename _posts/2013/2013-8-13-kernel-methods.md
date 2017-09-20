---
title: "Kernel Methods"
date: 2013-8-13 18:30:14
tags:
  kernel
  rbf
  svm
---


Kernel methods, most commonly described in relation to [support vector machines](http://www.vbmis.com/learn/?p=312 "Support Vector Machines (SVMs)"), allow us to transform our data into a higher dimensional space to assist with the goal of the learning algorithm.  Specifically for SVMs, we are looking to define the support vectors based on maximizing the geometric margin, or the distance between the dividing line and the support vectors.  What this come down to is minimizing a set of weights subject to constraints that some are positive, and some negative, and the ones that turn out to be greater than zero indicates a functional margin == 1, and they form the support vectors.  Abstractly, we are finding the line to draw through our data (or some transformation of it, thanks to the kernel) so we can draw a line through the two classes.

Kernel methods aren't just useful for SVMs.  We can also use them with linear discriminant analysis, principal component analysis, ridge regression, and other types of clustering.  For this post, I'd like to outline some popular choices of kernels.

### How do I know if a function can be a Kernel?

If you have some function, it must satisfy two conditions to be a kernel:

1. The kernel matrix (an mxm matrix for which each value has your Kernek, K(xi,xj) defined at each slot ij) must be symmetric.
2. It must also be positive semi-definite (K >= 0)

These conditions were figured out by Mercer, and detailed in [Mercer's theorem](http://en.wikipedia.org/wiki/Mercer's_theorem).

### Types of Kernels

It's not clear to me what the best way to choose a kernel is.  From reading, it seems that many people choose the radial basis kernel, and if left on my own, I would probably just try them all, and choose the one with the lowest cross validated error.  [Graph kernels](http://en.wikipedia.org/wiki/Graph_kernel) calculate cross products for two graphs.  [String kernels](http://en.wikipedia.org/wiki/String_kernel) are used with strings.  Popular choices for imaging are [radial basis](http://en.wikipedia.org/wiki/Radial_basis_function_kernel) and [Fisher kernels](http://en.wikipedia.org/wiki/Fisher_kernel), but there are many other types, and you will have to read about the best types for your particular application.  Here are a few additional notes:

### Choosing a Kernel

In being like a dot product, a Kernel is essentially a similarity function.  For example, think of  euclidean distance, for which you calculate by taking the square route of the dot product.  A small value means that some two vectors are close together, and a large value means that they are not.  So, if a Kernel is like a dot product, it should result in small values when applied to similar objects, and large values when applied to different objects.

#### RBF Kernel (Gaussian)

The radial basis kernel is a good default choice when you've established that you have some non-linear model.  I also read that it's a good choice for image classification because it selects solutions that are smooth.

#### Linear kernels

I read that they typically are much faster than radial based ones.

#### Polynomial kernel

A better choice for text classification problems, commonly with the exponent = 2.

 


