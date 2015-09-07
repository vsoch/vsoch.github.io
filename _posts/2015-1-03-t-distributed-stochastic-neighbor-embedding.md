---
title: "T-Distributed Stochastic Neighbor Embedding"
date: 2015-1-03 01:42:45
tags:
  big-data
  dimensionality-reduction
  kullback-leibler
  tsne
  unsupervised-2
---


### What do we want to do?

We want to visualize similarities in high dimensional data.

#### Why should we care?

We want to develop hypotheses about processes that generate our data, and discover interesting relationships. The visualization must match and preserve “important” relationships in the data without being too complex to be meaningless. Traditional methods like scatterplots or histograms only allow for the visualization of one or a few data variables at once.

#### Today

I want to learn about a [particular dimensionality reduction algorithm](http://lvdmaaten.github.io/publications/papers/JMLR_2014.pdf) that works very well with identifying patterns in large datasets, and integrates well into a visualization, t-SNE. I will talk about this algorithm in the context of brain maps.

 

### Two levels of relationships we can capture

We need to capture relationships on two levels - a "local" or "high" dimensional one, and a "low dimensional" one, most commonly referred to as a "low dimensional embedding."

#### Low-dimensional embedding:

For humans, distances between things are very intuitive to represent similarity Things that are closer together are more similar, and farther apart, more dissimilar. In this low dimensional embedding, we take advantage of this, and represent each highly complex brain map as perhaps a point on a flat plane, and it's similarity to other brain maps is "embedded" in the distances.

#### Local relationships (high dimensional similarity assessment)

This refers to some algorithm that is producing a more complex assessment of how two brain images are similar. We can use any distance metric of our choice (or something else) to come up with a computational score to rank the similarity of the two images. This relationship between two points, or two brain maps, is a “local relationship,” or the “gold standard” that we aim to preserve in the “low dimensional embedding.”

 

### Preserving local relationships in our embedding

Our challenge is to develop a low-dimensional embedding, a “reduction” of our data, that preserves the local relationships, which are the pairwise similarity assessments between each brain map point. This is challenging. Low dimensionality representations, by default, strip away this detail. However, there is a family of algorithms called "stochastic neighbor embedding" that aim to preserve these local relationships.

#### A distance matrix for each level

In machine learning, distance matrices are king. Each coordinate, I,j, represents a similarity between points I and j. In the context of our “low-dimensional embedding” and “local relationships” (gold standard), you can imagine having two distance matrices, each NxN, representing the pairwise similarities between points on these two levels. If we have done a really good job modeling our data in the reduced space, then the matrices should match.

#### Stochastic neighbor embedding

SNE is going to generate a distance matrix for each level, however we are not going to use a traditional distance metric. We are going to generate probability scores, where:for each pair of brain maps, a high score indicates that the two are very similar, and a low score, dissimilar. We are going to “learn” the “best” low-dimensional embedding by making the two matrices as similar as possible. This is the basis of the SNE approach.

- **Stochastic**: usually hints that probability is involved
- **Neighbor**: because we care about preserving the local relationships
- **Embedding**: because we are capturing the relationships in the reduction

 

### T-Distributed stochastic neighbor embedding

We are minimizing divergence between two distributions:

- a distribution that measures pairwise similarities of the input objects
- a distribution that measures pairwise similarities of the corresponding low-dimensional points in the embedding

We need to define joint probabilities that measure the pairwise similarity between two objects. This is called Pij.

 

[![image11](http://www.vbmis.com/learn/wp-content/uploads/2015/01/image11.png)](http://www.vbmis.com/learn/wp-content/uploads/2015/01/image11.png)

Here we are seeing the high dimensional space, and one of our brain maps (the red box), a point in the high dimensional space. We are going to measure similarities between points in such a way that we are only going to look at LOCAL similarities (we don't care about the blue circles off to the left). We are going to CENTER a Gaussian at the red box, and this makes sense in the context of the equation because the numerator is the equation for a modified Gaussian (student-T distribution), and xi, the red box, is the mean (center). Then we are going to measure the "density" of ALL the other points under the Gaussian – this is represented in the part of the equation where we are subtracting the xj points. We can imagine if the other points have the EXACT same densities (if xi == xj), then we are left with a value of 0. If the distributions are more different, then this resulting density will be larger. The BOTTOM part of the fraction just re-normalizes the distribution in the context of all points in the space.

 

#### Probabilities to represent “gold standard” similarities

This gives us a set of probabilities, Pij, that measure similarities between pairs of points pi - a probability distribution over pairs of points, where the probability of picking a pair of points is proportional to their similarity. If two points are close together in the high dimensional (gold standard) space, we are going to have a large value. Two points that are dissimilar will have pij that is very small.

**NOTE:** In practice we don't compute joint probabilities, but we compute conditional distributions (the top equation), and we only normalize over points that involve point xi (the denominator is different). We do this because it lets us set a different bandwidth, (the sigma guy) for each point, and we set it so the conditional distribution has a fixed “perplexity.

 

[![image2](http://www.vbmis.com/learn/wp-content/uploads/2015/01/image2.png)](http://www.vbmis.com/learn/wp-content/uploads/2015/01/image2.png)

 

#### Perplexity (sigma) is adaptive to density fluctuations in our space

We are scaling the bandwidth (width) of the Gaussian such that a certain number of points are falling in the mode. We do this because different parts of the space have different densities, so we can adapt to those different densities.

#### We combine conditional probabilities to estimate the joint

We then say the JOINT probabilities are just going to be the “symmetrized” version of the two conditionals (the bottom equation in the picture above) - taking an average to get the "final" similarities in the high dimensional space.  In summary, we now have a pairwise probability for each point in the high dimensional space.

 

### We do the same thing in the low dimensional embedding

Now we are looking at the low dimensional space - whatever will be the final reduction - and we want to learn the best layout of points in that map. Remember that distance will represent similarity. Again, the red box is the same object, but now it's in our low dimensional space. We center a kernel over our point, and then we measure the density of the other point (blue) under that distribution, and this gives us a probability Qij that gives us similarity of points in LOW dimensional space.

![image3](http://www.vbmis.com/learn/wp-content/uploads/2015/01/image3.png)

Remember!

- **Pij** : the high dimensional / actual / gold standard
- **Qij**: the reduction!

 

#### Pij should be the same as Qij!

We WANT the probabilities Qij (reduced) to reflect the probabilities Pij (high dimensional gold standard) as well as possible. If they are identical, then the structure of the maps are similar, and we have preserved structure in data. The way we measure the difference between the two is with Kullback Leibler Divergence, a standard or natural measure for the distance between two probability distributions:

 

![](http://upload.wikimedia.org/math/e/9/4/e942122df940271c8361f58c2c302ebe.png)

 

### Kullback Leibler Divergence will match our Pij and Qij

This is me reading the equation above.  The Kullback Leibler Divergence for distributions P and Q is calculated as follows: We sum over all pairs of points, Pij, times log Pij divided by Qij. We want to lay out these points in low dimensional space such that KL divergence is minimized.  So we do [some flavor of gradient descent](http://www.vbmis.com/learn/linear-regression/#3) until KL divergence is minimized.

 

#### Why KL Divergence?

Why does that preserve local structure? If we have two similar points, they will have large Pij value. If that is the case, then they also should have a large Qij value.  If they are exactly the same, then we take log of 1, and that is 0, and I don't think we can minimize much more than that ![:)](http://www.vbmis.com/learn/wp-includes/images/smilies/simple-smile.png)  Now imagine if this isn't the case - if we have a large Pij and a small Qij - in using KL divergence we will be dividing a huge number by a tiny one == huge number --> log of huge number approaches infinity --> the equation blows up (and remember we are trying to minimize it!  So KL is good because it tries to model large Pij (similar high dimensional points) by large Qij.

 

#### What kind of Gaussian are we using?

When we compute Pij, we don't use a Gaussian curve, we use student T-distribution with one degree of freedom. It's more heavy tailed than gaussian. The explanation is that, if we were to have three points in the shape of an L, the "local" distances between points (the red lines) would be preserved if we flatted out the L:

[![image4](http://www.vbmis.com/learn/wp-content/uploads/2015/01/image41.png)](http://www.vbmis.com/learn/wp-content/uploads/2015/01/image41.png) [![Image5](http://www.vbmis.com/learn/wp-content/uploads/2015/01/Image5.png)](http://www.vbmis.com/learn/wp-content/uploads/2015/01/Image5.png)

However, the points not connected (the two gray on the end, the "global" structure) - their distance gets increased. This happens a lot with high dimensional data sets. By using the student T with heavy tails, the points aren't modeled too far apart.  I didn't dig into this extensively, as I don't find the visualization above completely intuitive to illustrating this difference between the two distributions.

 

#### Gradient of KL interpretation

The gradient with respect to a point (how do we have to move a single point in the map) in order to get a lower KL divergence takes the form in picture. It consists of a spring between a pair of points (F and C):

[![spring](http://www.vbmis.com/learn/wp-content/uploads/2015/01/spring.png)](http://www.vbmis.com/learn/wp-content/uploads/2015/01/spring.png)

and the other term measures an exertion or compression of the spring:

[![compression](http://www.vbmis.com/learn/wp-content/uploads/2015/01/compression.png)](http://www.vbmis.com/learn/wp-content/uploads/2015/01/compression.png)

Eg, if Pij == Qij that term would be zero, meaning no force in the spring!  What the sum is doing is taking all forces that act on the point, and summing them up. All points exert a force on C, and we want to compute "resultant force" on C. This tells us HOW to move the point to get a lower KL divergence.

**LIMITATION:** We have to consider ALL pairwise interactions between points, need to sum in every gradient update. This is very limiting if we want to visualize datasets larger than 5000-10000 objects.

![gradient](http://www.vbmis.com/learn/wp-content/uploads/2015/01/gradient.png)

 

 

### Barnes-Hut Approximation addresses computational Limitation!

The intuition is that if we have a bunch of points (ABC) that are close together that all exert a force on points (I) relatively far away, the forces will be very similar. SO we could take the center of mass of the three points, and compute the interaction between that point and the other point (I) and multiply it by 3 to get an approximation. Boom! This method comes from astronomy, and results in an NlogN algorithm.

[![barnes2](http://www.vbmis.com/learn/wp-content/uploads/2015/01/barnes2.png)](http://www.vbmis.com/learn/wp-content/uploads/2015/01/barnes2.png)

In practice, the above is done with a "quadtree" - each node of tree corresponds to cell (eg, root is entire square map), and the children correspond to quadrants of the map. In each cell we store number of points in each cell, and the center of mass (blue circle).

[![quadtree](http://www.vbmis.com/learn/wp-content/uploads/2015/01/quadtree.png)](http://www.vbmis.com/learn/wp-content/uploads/2015/01/quadtree.png)

We build a full quad tree - meaning we proceed until each cell contains a single data point. We do depth first search on the tree to do the Barnes approximation. We start with point F (in red), because we are interested in computing the interactions with this point:

[![pointF](http://www.vbmis.com/learn/wp-content/uploads/2015/01/pointF.png)](http://www.vbmis.com/learn/wp-content/uploads/2015/01/pointF.png)

 

At every point in our DFS, we want to know if the cell is far enough away from our point (F), and small enough, so that the cell could be used as a summary for the interactions.  For example, below we are using the top left cell (the cluster to the left in the tree) - we calculate it's center of mass (the purple circle) and calculate the interaction with F, and then multiply by 3 to account for points A,B,C.  This is like a "summary" of the interaction of the three points on F.  We then do this for all the points.

[![faaa](http://www.vbmis.com/learn/wp-content/uploads/2015/01/faaa.png)](http://www.vbmis.com/learn/wp-content/uploads/2015/01/faaa.png)

 

 

### Extension to Brain Imaging Map Comparison?

This algorithm extends to [multiple maps](http://homepage.tudelft.nl/19j49/multiplemaps/Multiple_maps_t-SNE/Multiple_maps_t-SNE.html), and so I think it would be nicely extended to brain imaging to reflect different features (eg regional relationships) in our brain maps.

 

 

Credit for this content goes to [Laurens van der Maaten](http://lvdmaaten.github.io/), who is doing some incredibly awesome work that spans machine learning and visualization!


