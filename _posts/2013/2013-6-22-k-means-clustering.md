---
title: "K-Means Clustering"
date: 2013-6-22 18:41:23
tags:
  clustering
  k-means
  kmeans
  machine-learning-2
  unsupervised-2
---


**K-Means clustering** is a bread and butter method of unsupervised clustering in machine learning, and I love it because it's so intuiitive, and possibly because I learned about it in one of my favorite classes at Stanford, [BMI 214 with Russ Altman](http://bmi214.stanford.edu/) my first year.  How does it work?

### **When would I want to use K-Means?**

We use K-means when we want to uncover classes in a large, unlabeled dataset defined by a set of features.  For example, let's say that a lemur invades your pantry, and mixes all of your cereals into one giant mess.  While some people like their cereal as a pot-potpourri, you are horrified, and want nothing more than a bowl with one kind of morsel floating around.  Let's also say that you have a machine that is able to scan a piece of cereal, and extract features that describe the size, shape, ingredients, etc.  You realize that if you can extract features for a sample of your cereal and define groups based on those features, you can then use your classifier with the machine to automatically extract features and classify the rest of the cereal.  Thank goodness, because having to manually go through each piece would be terribly time consuming.  This is, of course, an **unsupervised** problem because we have no idea about the class labels, and **non-parametric** because the model is based on the data itself.  We have to keep our sample features around to classify a new piece of cereal, unlike a method like linear regression where we can optimize our parameters and then throw the training data away.

### **What is the basic algorithm?**

****We start with a matrix of features for our data.  Let's say we have a sample of m cereal pieces, each with n features, and so we have an n X m matrix.  We want to:

1.  Randomly initialize k centroids, which should be in our N-dimensional feature space.  We can also randomly select k training samples
2. For each training sample, calculate the distance to each centroid, and assign it to the closest one
3. After each iteration through the training samples, re-calculate the centroid based on averaging the training points assigned to it
4. Repeat 2 and 3 until convergence - meaning that assignments stop changing, a certain number of iterations goes by, or some other criteria

You probably have many questions.  How do we decide on a value of K? What about the distance metric? Are we going to find an optimal solution?  You should definitely run K-means a few times, because the outcome can somewhat be determined by the initial centroids, and so you could converge to a local optima.

### **How do we choose our parameters?**

First, you have to define your value of K, or how many clusters you believe there to be.  This can be feasible if you have some domain knowledge about your problem (for example, I may know that I would typically keep 7-9 cereals in my cabinet, so I would want to try K = {7,8,9]) or it can be more challenging if you haven't a clue.  What is most commonly done is **[cross validation](http://www.vbmis.com/learn/?p=125 "Cross Validation") **to find an optimal K, or basically creating a model for a set of Ks, and then choosing the one that works best.  "What works best" is defined by one of several common evaluation metrics for k-means clustering that get at the "goodness" of your clusters.  For your distance metric, the most obvious distance metric to use is the Euclidian Distance, however you could use any metric that you like.  Here are some common [distance metrics](http://www.mathworks.com/help/stats/classification-using-nearest-neighbors.html#bsfjytu-1), by courtesy of Matlab.

[]()

### **How do I evaluate my clusters?**

Generally, there are two broad buckets of cluster evaluation: internal and external evaluation.  **Internal evaluation **methods are specific to one clustering, while **external evaluation** methods try to compare across clusterings.  A good clustering means that members of the same cluster are more similar to one another than to some member(s) of another cluster.  We can assess this by comparing the distance of each point to its cluster centroid versus other cluster centroids.  A good "tight" clustering has a small within cluster sum of squares, and a large between-cluster sum of squares.  There is a nice visualization called a [Silhouette Plot](http://en.wikipedia.org/wiki/Silhouette_(clustering)) that calculates a score between -1 and 1 for the clustering, which could help you choose a good value of K.  Lastly, Tibshirani's [Gap Statistic](http://stat.ethz.ch/R-manual/R-devel/library/cluster/html/clusGap.html) provides another nice visualization to help evaluate a set of clusterings.

#### **What are some derivations?**

If you are doing an analysis for which "soft" cluster assignment is appropriate (think of the margins as being fuzzy and allowing for a point to belong to more than one class) then you will want to read about Fuzzy C-Means clustering.  If you restrict your centroids to actual points this is called k-medoids, or to medians (k-medians).  There are also smarter ways to choose your initial centroids, such as the [K-means++](http://en.wikipedia.org/wiki/K-means_algorithm) algorithm.

### **What are some drawbacks to this approach?**

We are making a big assumption about our clusters - that they are spherical blobs, and they are the same size.  Other interesting patterns in the data that are not of this shape or equivalent size won't be captured by this algorithm.  At the end of the day, each cluster is represented by a single mean vector (of our features).  If we want to classify a new point into a cluster, we calculate the distance of that point to all of our mean vectors, and assign it to the closest one.


