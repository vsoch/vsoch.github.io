---
title: "K-Nearest Neighbor Clustering (KNN)"
date: 2013-6-13 20:11:55
tags:
  clustering
  knn
  machine-learning
  supervised
---


**K nearest neighbor** (KNN) clustering is a supervised machine learning method that predicts a class label based on looking at other labels from the dataset that are most similar.  In a nutshell, the only things that you need for KNN are:

- A dataset with N features for M observations, each observation having a class label and associated set of features
- some equation that determines the similarity between any two observations

### 1) Decide on a distance (similarity) metric to assess how similar any given observation is to another one

When we talk about a distance metric, this means that larger values = less similar.  When we talk about a similarity metric, this means that larger values = more similar.  In this case we will use a distance metric, namely the Euclidean distance.  If we have two vectors, x1 and x2, we want to subtract them from one another, square them, then take the square root:

![\sqrt (sum) (x1-x2)^2](http://l.wordpress.com/latex.php?latex=%5Csqrt%20%28sum%29%20%28x1-x2%29%5E2&bg=FFFFFF&fg=470229&s=1 "\sqrt (sum) (x1-x2)^2")

x1 and x2 being vectors implies that for each matching feature in x1 and x2 we are subtracting, squaring, and then adding them all up and taking the square root.  If you want to work with matrices, simply take the square root of the dot product

![\sqrt (x1-x2)T(x1-x2)](http://l.wordpress.com/latex.php?latex=%5Csqrt%20%28x1-x2%29T%28x1-x2%29&bg=FFFFFF&fg=470229&s=1 "\sqrt (x1-x2)T(x1-x2)")

### 2) Construct a distance matrix, where a coordinate (i,j) corresponds to the similarity/distance between observation i and observation j

To prepare for training, we should calculate all of our distances in advance.  This means creating a matrix of size m x m, and looping through every combination of observations, calculating this Euclidian distance and putting it in the matrix in the correct coordinate, (i,J).  This means that the value at (i,j) will be equivalent to the value at (j,i), and if i = j, since we are calculating the distance of an observation to itself, the matrix should equal 0.

### 3) Set a value of K

The value of K is the number of similar neighbors that we want to look at to determine our class label.  We basically will look at the class labels of the K nearest neighbors of some novel set of features, our X, and then ascribe the label that occurs most often, the idea being that similar things have similar features.  It makes sense, right?  It's a good idea to set an odd value for K so that you always have a majority class label.  How do you determine this value?  It can be based on some domain knowledge, or commonly we try a range of values and choose the one that works best.

### 4) How do we "train" the model?

KNN is different from something like regression in that we don't have to determine some optimal set of parameters.  We can't determine some parameters and throw the data away - our model is the data itself!  This is called a **non-parametric **model.  With this in mind, when we are "training" a KNN model, we are basically interested in getting some metric of accuracy for a particular dataset with labels.  The simplest and most obvious solution is to calculate accuracy as the number that we got right over the total.  So we essentially want to iterate through each observation, find the K nearest neighbors based on Euclidian distance, look at their labels to determine a class for the current observation, save the class to a vector of predicted observations, and then compare the predicted to the actual observations to calculate accuracy.

### 4) How do we evaluate the model?

In the case of KNN, we can't really say anything about finding a "significant" result.  Instead, it is customary to assess specificity, sensitivity, and generally, all the ROC curve metrics (area under the curve, etc.).  You would want to compare the performance of your model to the current gold standard.  An accuracy of .80 may seem not so great, but if the current gold standard produces something along the lines of .70, you have made marginal improvement!

### K-Nearest Neighbors in High Dimensions

Unfortunately, KNN falls prey to the curse of dimensionality.  It's ok to have lots of observations, but in the case of many features, KNN can fail in high dimensions because it becomes difficult to gather K observations close to a target point xo.
