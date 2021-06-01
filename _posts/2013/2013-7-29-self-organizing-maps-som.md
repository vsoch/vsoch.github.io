---
title: "Self Organizing Maps (SOM)"
date: 2013-7-29 19:24:25
tags:
  machine-learning
  self-organizing-map
  som
  unsupervised
---


The goal of the** Self Organizing Maps** (SOM) is to use unsupervised machine learning to represent complex data in a low (e.g, 2D) dimensional space.  They are actually types of artificial neural networks (ANNs), meaning that we are going to be talking about nodes, and a set of weights for each node, and our algorithm is going to find the optimal weights.  If you have ever seen the reference to a "Kohonen" map or network, this is talking about the same thing, and just giving credit to the guy that came up with them, Mr. [Teuvo Kohonen](http://en.wikipedia.org/wiki/Teuvo_Kohonen).

### How to Build a SOM

As with many algorithms, building a SOM involves training, and then mapping (or classifying a new input).  Training comes by way of [vector quantization](http://www.vbmis.com/learn/?p=506 "Vector Quantization").  You can imagine that we start with a random set of centroids, and at each iteration, we select a point and find the centroid that it is closest to, and move that centroid a tiny bit toward the point. And after many iterations, the grid does a good job of approximating the data.  An example (from wikipedia!) is shown below:

![](http://upload.wikimedia.org/wikipedia/commons/thumb/9/91/Somtraining.svg/500px-Somtraining.svg.png)

In the case of SOM, these "centroids" are called nodes or neurons, and with each node is an associated vector of weights.  This vector of weights is nothing more than the current vector of feature values for the centroid.  The simplest SOM algorithm starts with this vector initialized to be random, but there are better ways.  Generally, training works as follows:

1. <span style="line-height: 13px;">Initialize weights</span>
2. Prepare your points to feed to the network!

For each point {

1. Calculate the euclidean distance of the point to all nodes in the network.  The closest one is called the "Best Matching Unit" (BMU)
2. Adjust the weights of the BMU toward the input vector, as well as other points close in the SOM lattice ("close" as determined by some neighborhood function, a Gaussian function is a common choice)  This neighborhood function should shrink with time so the weights converge to local estimates.

}

You would need to do this for many points, of course.  At the end of your training, each node should be associated with some pattern in the data.  To classify a new point, simply calculate its Euclidean distance to all nodes in the space, and the closest one wins.   SOMs are cool because they are sort of like a non-linear form of PCA.  Another way of achieving this goal is by way of multidimensional scaling, which aims to represent observation vectors in a lower space, but preserve the distances between them.


