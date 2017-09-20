---
title: "Principal Component Analysis (PCA)"
date: 2013-7-03 19:00:55
tags:
  components
  dimensionality-reduction
  pca
  principal-component-analysis
---


### What is Principal Component Analysis?

**Principal Components Analysis (PCA) **is an algorithm most commonly used for dimensionality reduction that finds a one dimensional subspace that best approximates a dataset.  When you have data with many (possibly correlated) features, PCA finds the "principal component" that gets at the direction (think of a vector pointing in some direction) that the data approximately lies.  This is the "strongest" direction of the data, meaning that the vector is the major axis of variation, and when we project the data onto this vector, we maximize the variance of our data.  What does it mean to project data onto a vector?  It means that we would draw our vector, and map each data point to the closest spot on the vector where the two meet at a 90 degree angle (they are orthogonal), as illustrated in the graphic below:

[![eq1](http://www.vbmis.com/learn/wp-content/uploads/2013/07/eq17.png)](http://www.vbmis.com/learn/wp-content/uploads/2013/07/eq17.png)

Maximizing variance means that, when we look at the new points (the black dots), they have maximal spread.  You can imagine if we had drawn a line perpendicular to the one in the picture, the original points (they gray X's) would map onto it and be incredibly close together.  This wouldn't capture the true direction of the data as well as our original line, above.  We want to maintain as much variance as we can because we are likely using PCA as a pre-processing step to some machine learning algorithm, and if we were to take away the nice spread between points, we would be less successful to find differences between classes to build a classifier.

### How does it work?

Let's say that we have a dataset with m observations and n features to describe clowns.  Each observation, m, is one clown, and each features, n, is some personality metric, a phenotype, or a performance variable.  The first step is to make sure that all of our features are within the same space so that we can compare them.  For example, if the mean of a behavioral metric is 5 with variance .4, and the mean of a phenotype variable is 230 with variance 23, if we were to plot these variables in the same space, they would be very far apart.  So the first step is to normalize the means and variances all of our features  by doing the following:

#### Step 1: Normalize your Data

[![eq1](http://www.vbmis.com/learn/wp-content/uploads/2013/07/eq16.png)](http://www.vbmis.com/learn/wp-content/uploads/2013/07/eq16.png)

In step 1, we calculate the mean by summing the features and dividing by the number of features.  In step 2, we subtract this mean from each feature so that we essentially have mean 0.  In steps 3 and 4, we re-scale each observation to have unit variance.  Now if we were to plot a phenotype variable and a behavioral metric in the same space, they would be comparable.

#### Step 2: Maximize the Variance of the Projections

If you look at the picture above, and if you have taken linear algebra (I haven't, but I picked this up somewhere along the way), you will notice that the perpendicular line from the point to the projection is represented by xTu (x transpose u).  This means that, for any point (X) in the picture above, its projection onto the vector is xTu distance from the origin.  So in this problem, the unit vector (lets call this u) is the unknown that we want to find.  To maximize the variance for all projections, we would want to** **maximize the following:

[![eq1](http://www.vbmis.com/learn/wp-content/uploads/2013/07/eq18.png)](http://www.vbmis.com/learn/wp-content/uploads/2013/07/eq18.png)

The first term is summing the distance from the origin of each point, and we are squaring each distance because we don't want negative distances to cancel out positive ones.  This can be re-written as the second term by by multiplying xTu by xTu.  We then can factor the unit vectors out of the sum, and we are left with the principal eigenvector of the data, which is also just the covariance matrix (the stuff in the parentheses).  This is really neat, because it means that we can find this "maximum direction" just by solving for this principal eigenvector.  I think that can be done with Lagrange multiplier, but as long as you understand it, you can use something like the [eig function in Matlab](http://www.mathworks.com/help/matlab/ref/eig.html) to find any of the k top eigenvectors.

Once you have solved for these eigenvectors (u), you would then want to represent your data in this space, meaning projected onto these eigenvectors.  This y(i) would be the "dimensionally reduced" representation of your data, in k dimensions instead of the higher, original dimensionality:

[![eq1](http://www.vbmis.com/learn/wp-content/uploads/2013/07/eq19.png)](http://www.vbmis.com/learn/wp-content/uploads/2013/07/eq19.png)

And it is notable that these new k vectors are what we refer to as the first k **principal components**.

### Summary

With PCA, we can represent our dataset of clowns (originally described by many features) in a lower dimensional space.  You can think of this as simple dimensionality reduction, or noise reduction, or even compression.  Although we have a hard time ascribing a label to what the components represent or mean, in many cases this processing step leads to better performance of a classifier because it better represents some intrinsic "clowniness" that was hidden in the noise.  It is also desirable because the dimensionality reduction lets us better plot our dataset in a 2D space.  As humans that like to see things to understand them, this is a win :O)


