---
title: 'Sparse K-Means Clustering "Sparcl"'
date: 2013-7-24 18:07:52
tags:
  bcss
  clustering
  gap-statistic
  k-means
  machine-learning
  sparse
  unsupervised
  wcss
---


[Tibshirani and Witten](http://www.ncbi.nlm.nih.gov/pmc/articles/PMC2930825/) introduced a variation of [K-Means](http://www.vbmis.com/learn/?p=94 "K-Means Clustering") clustering called "Sparcl."  What gives it this name?  It is a method of sparse clustering that clusters with an adaptively chosen set of features, by way of the lasso penalty.  This method works *best* when we have more features than data points, however it can be used in the case when data points > features as well.  The paper talks about the application of Sparcl to both K-Means and Hierarchical Clustering, however we will review it based on just K-Means.  We will start with doing what the paper does, which is reviewing previous work in sparse clustering. **Previous Work in Sparse Clustering**

- **Dimensionality Reduction Algorithms: **
- Use PCA to reduce the dimensionality of your data, and cluster the reduced data
- Use Non-Negative Matrix factorization, and cluster the resulting component matrix

What are the problems with the dimensionality reduction proposals above?  They don't allow for sparse features, and we cannot be sure that our signal of interest is in the resulting decomposition.  Why?  The components with the largest eigenvalues do not necessarily do the best to distinguish classes.  Let's talk about other ideas.

- **Model-based clustering framework: **
- Model the rows of the data, X, as independent multivariate observations from a mixture model with K components, and fit with the EM model.  The picture below  shows this approach:

[![eq1](http://www.vbmis.com/learn/wp-content/uploads/2013/07/eq118.png)](http://www.vbmis.com/learn/wp-content/uploads/2013/07/eq118.png)

The function, fk is a is Gaussian density, and it is parameterized by its mean and covariance matrix.  We iterate from 1 to K in the inside loop, one for each Gaussian, and the outside loop from 1 to n is going through each of our data objects.  Fitting with EM means fitting by [expectation maximization](http://www.vbmis.com/learn/?p=345 "Expectation Maximization (EM) Algorithm").  The problem with this algorithm for this application is in the case when our number of features (p) is much bigger than our number of observations (n).  In this case, we can't estimate the p x p covariance matrix.  There are ways around this (see paper), however they involve using dimensionality reduction, and the resulting components, in being combinations of all features, do not allow for sparsity.  Poozle.  Is there another way we can use model-based clustering? Yes.

- <span style="line-height: 13px;">Use model-based clustering (above), except instead of maximizing the log likelihood, maximize the log likelihood *subject to a penalty* that will enforce sparsity.  What does that look like?</span>

[![eq1](http://www.vbmis.com/learn/wp-content/uploads/2013/07/eq119.png)](http://www.vbmis.com/learn/wp-content/uploads/2013/07/eq119.png)

Above, you will see the same equation as before except... oh hello, [L1 penalty](http://www.vbmis.com/learn/?p=43 "LASSO: Regularization for Linear Regression")!  The last double summation above is basically summing up the means for each feature (j) across all Gaussians (k).  The parameter out front, lambda, is a fudge factor that gives us some control over the penalty.  When lambda is really big, this means that we are penalizing more, and so some of the Gaussian means will be exactly equal to zero.  When this is the case for some feature, j, over all Gaussians, K, this means that we don't include the feature in the clustering.  This is what makes it sparse.    It isn't clear in the paper why this approach isn't sufficient, but let's move into their proposed "Sparcl."

### Sparse Clustering, Sparcl

Let's start simply, and generally.  Unsupervised clustering problems are trying to solve the following problem:

[![eq1](http://www.vbmis.com/learn/wp-content/uploads/2013/07/eq120.png)](http://www.vbmis.com/learn/wp-content/uploads/2013/07/eq120.png)

Xj denotes some feature, j, and so the function is "some function" that involves only the j-th feature.  We are trying to maximize our parameters for this function.  For example, for K-Means, this function is the between cluster sum of squares for feature j.  The paper proposes sparse clustering as the solution to the following problem:

[![eq1](http://www.vbmis.com/learn/wp-content/uploads/2013/07/eq121.png)](http://www.vbmis.com/learn/wp-content/uploads/2013/07/eq121.png)

The function, f, is the between cluster sum of squares, j is still an index for a particular feature, and wj is the weight for that feature.  We can say a few things about the equation above:

- <span style="line-height: 13px;">If all of our weights are equal, the function above reduces to the first (without the subject to addition) and we are using all features weighted equally.</span>
- s is again a tuning parameter.  When it is small, this means that we are more stringent, and more of our weights will be set to zero.
- The L2 norm, which means that we square each weight, sum the squares, and then take the square route of that, is important as well, because without it, at most one weight would be set to zero.
- The value of the weights, as usual, is reflective of how meaningful a particular feature, j, is to the sparse clustering.  A large weight means that the feature is important, while a small one means the opposite.  A weight of zero means that we don't use it at all.  Dear statistics, thank you for making at least *one* thing like this intuitive!
- Lastly, the last term in the "subject to" says that we can't have all of our weights equal to zero, in which case we have no selected features at all!

**How do we solve the equation above?**  We first hold our weights, w fixed, and optimize with respect to the parameter.  We then hold our parameters fixed, and optimize w.  The paper notes that when we hold the parameters fixed and optimize w, the problem can be rewritten as:

[![eq1](http://www.vbmis.com/learn/wp-content/uploads/2013/07/eq122.png)](http://www.vbmis.com/learn/wp-content/uploads/2013/07/eq122.png)

For the above, the "subject to" parameters are equivalent, and since our parameters are fixed, we are just multiplying the weights by a, where a is a function of X and the fixed parameter.  The paper notes that this can be solved with soft-threholding, something that I need to read up on.  It is [detailed in the paper](http://www.ncbi.nlm.nih.gov/pmc/articles/PMC2930825/#!po=3.19149) if you are interested.  Now let's talk about this approach specifically applied to K-Means.

### Sparse K-Means Clustering (Sparckl?) :)

This is going to be a good method for three reason:

1. the criteria takes on a simple form
2. easily optimized
3. the tuning parameter controls the number of features in the clustering.

Let's first talk about standard K-Means.  For standard K-Means, our goal is to minimize the within cluster sum of squares (WCSS). This means that, for each cluster centroid, we look at the points currently assigned to that cluster, square each one, and add them up.  If this value is small, our cluster is tight and awesome.  The equation below is saying exactly this:  on the inside we calculate the distance between each cluster centroid and each member across all features j, and then we make sure to divide by the number of members in the cluster (nk) to normalize for differences in cluster sizes.  We then add up the summed distances for each cluster, K, to get a "final" total distance.

[![eq1](http://www.vbmis.com/learn/wp-content/uploads/2013/07/eq123.png)](http://www.vbmis.com/learn/wp-content/uploads/2013/07/eq123.png)

We want to minimize this total distance to yield the "tightest" clusters, i.e., the clusters that have their points closest to their centroids.  The equation above uses all features, j, and so there is not sparsity.  Before we add a penalty and weights, let's talk about the between cluster sum of squares, BCSS.

[![eq1](http://www.vbmis.com/learn/wp-content/uploads/2013/07/eq124.png)](http://www.vbmis.com/learn/wp-content/uploads/2013/07/eq124.png)

The term on the right is exactly what we had before, the within cluster sum of squares for all clusters K.  However, what we are trying to get at is the *between *cluster sum of squares, meaning that we want to minimize the distance between all the points in a cluster and all the other points *not *in the cluster.  So the equation above, in the first term that does not take a cluster k into account, is basically saying "ok, let's imagine that we don't have any clusters, and just calculate the pairwise distance for all of our observation, n, and then get an average.   We can then subtract the within cluster sum of squares, leaving only the distances for the pairs of points from different clusters.  The *between* cluster sum of squared distances.  And we do this for all of our features, p.  Maximizing the between cluster sum of squares (above, meaning that points in different clusters are far apart) is equivalent to minimizing the within cluster sum of squares.

Now, let's add weights and penalty terms!  The paper notes that if we were to add these parameters to the equation that just specifies the WCSS, since each element of the weighted sum is negative (see that big negative sign in front of the WCSS equation?) this would mean that all of our weights would be zero. Fail!  Instead, let's add the weights and penalty terms to the BCSS equation:

 

### **The Sparse K-Means Clustering Criterion**

[![eq1](http://www.vbmis.com/learn/wp-content/uploads/2013/07/eq125.png)](http://www.vbmis.com/learn/wp-content/uploads/2013/07/eq125.png)

Holy crap, that looks ugly.  But it's really not as scary as we think - all that we've done is taken the BCSS equation from above, and appended a weight (w) to the front for each feature, j.  As before, we can say some things about this criterion:

- When the weights are all equal, we are back to basic BCSS
- The smaller s, the more sparse the solution

Intuitively, we are assigning a weight to each feature, j, based on the increase in BCSS that the feature can contribute.  Why does this make sense? If BCSS is greater, we would want our weight to be larger to result in a larger value.  If BCSS is smaller, we don't get so much out of the feature, and since we are constrained in our values for w, we choose a smaller w and (hopefully) other features will be more meaningful.

 

### **How to use the criterion to solve for the optimal weights**

1. <span style="line-height: 13px;">Initialize each weight equal to 1/sqrt(p)</span>
2. Iterate until convergence {

Forget about the first term in the BCSS equation, and just think of standard K-Means.  Our first step is to minimize the WCSS for our current (fixed) weights:

[![eq1](http://www.vbmis.com/learn/wp-content/uploads/2013/07/eq126.png)](http://www.vbmis.com/learn/wp-content/uploads/2013/07/eq126.png)

This is how we are going to come up with our cluster assignments and centroids - we want points getting matched to their closest centroid, and on each iteration we re-define the cluster centroids based on the assigned points.  Yes, this is standard K-Means, out of the box!

When we finish with the above, we have defined our centroids, cluster member indices, and this selection has resulted in a minimum WCSS distance.  We now hold these cluster assignments fixed (C1 to Ck), and can look at the left side of the BCSS equation.  As was stated previously, we want to maximize this, and we are going to use something called "soft thresholding."  Again, see the paper, I will try to discuss soft thresholding in another post.  This results in a new set of weights.  We then define a stopping criterion (below), and keep iterating through these two steps until this stopping criterion is reached:

[![eq1](http://www.vbmis.com/learn/wp-content/uploads/2013/07/eq127.png)](http://www.vbmis.com/learn/wp-content/uploads/2013/07/eq127.png)

wr refers to the set of weights obtained at some iteration r, so we are stopping when the change in these weights from one iteration to the next is tiny.  Yes, this is convergence.

}

### Further Comments

- Convergence is usually achieved in 5 to 10 iterations
- The criterion is not convex, so we aren't guaranteed to converge to the global optimum
- We still have to choose our value of K
- To calculate the value of s, we can evaluate the objective using a subset of values of s, and use something akin to a gap statistic:

[![eq1](http://www.vbmis.com/learn/wp-content/uploads/2013/07/eq128.png)](http://www.vbmis.com/learn/wp-content/uploads/2013/07/eq128.png)

where O(s) is the objective evaluated at the value of S, and each B is a permuted subset of our data.  We want to permute our data so that our features are uncorrelated.  We choose the value of s with the largest gap statistic.

 


