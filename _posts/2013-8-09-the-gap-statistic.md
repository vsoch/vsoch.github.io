---
title: "The Gap Statistic"
date: 2013-8-09 19:50:06
tags:
  gap
  gap-statistic
  k
  unsupervised-clustering
---


The gap statistic is a method for approximating the "correct" number of clusters, k, for an unsupervised clustering. We do this by assessing a metric of error (the within cluster sum of squares) with regard to our choice of k. We tend to see that error decreases steadily as our K increases:

[![img1](http://www.vbmis.com/learn/wp-content/uploads/2013/08/img1.png)](http://www.vbmis.com/learn/wp-content/uploads/2013/08/img1.png)

However, we reach a point where the error stops decreasing (the elbow in the picture above), and this is where we want to set our value of k as the "correct" number. While we could look at a plot and estimate the elbow, better is a formalized procedure to do this. This is the gap method proposed by the [awesome statistics folk at Stanford](http://www.stanford.edu/~hastie/Papers/gap.pdf), and it can be applied to any clustering algorithm with a suitable metric to represent the error.

### The idea behind the Gap Statistic

We have this graph that compares the error rate ([K-Means](http://www.vbmis.com/learn/?p=94 "K-Means Clustering") WCSS, for example) to the value of k. We can only get a sense of "how good" each error/k value pair is if we are able to compare to the expected error for the same k under a null reference distribution. In other words, if there was absolutely no signal in data with similar overall distribution and we clustered it with k clusters, what would be the expected error? We want to find the value of k for which the 'gap' between the expected error under a null distribution and our clustering is the largest. If the data has real, meaningful clusters, we would expect to see this error rate decrease more rapidly than its expected rate. This means that we want to maximize the following equation:

[![gap](http://www.vbmis.com/learn/wp-content/uploads/2013/08/gap.png)](http://www.vbmis.com/learn/wp-content/uploads/2013/08/gap.png)

The first term is the expected error under a null distribution, and the second is our particular clustering.  We take the log of both (I think) to standardize the comparison, allowing us to make comparisons between different data and clusterings.

### How do I choose a reference distribution?

[The paper](http://www.stanford.edu/~hastie/Papers/gap.pdf) behind this method suggests two strategies:

1. Generate the distribution uniformly over all observed values for each feature.
2. Use the same strategy as above, but applied to the singular value decomposition (svd) of your data, so your uniform distribution is generated from a source that gets at the general structure of your data.  You would have to first generate the distribution and then back transform to get the reference data.

and then nicely lays out the algorithm for the entire procedure:

1. Cluster your data over some range of k = 1 ... K
2. Generate B reference data sets using a or b above.
3. Cluster your references
4. Compute the gap statistic as follows:

[![gap](http://www.vbmis.com/learn/wp-content/uploads/2013/08/gap1.png)](http://www.vbmis.com/learn/wp-content/uploads/2013/08/gap1.png)

This is the same equation that we saw before, except that we are taking an average over our b reference distributions.  We then would want to calculate the average expected error for just the reference distributions, this is the "mean" (muuuu!) that of course is a metric to define the distribution. Let's call this l:

[![gap](http://www.vbmis.com/learn/wp-content/uploads/2013/08/gap2.png)](http://www.vbmis.com/learn/wp-content/uploads/2013/08/gap2.png)

And then of course we can plug our mean (muuuuu!) into the equation to calculate our standard deviation ("gets at" the spread of our reference data):

[![gap](http://www.vbmis.com/learn/wp-content/uploads/2013/08/gap3.png)](http://www.vbmis.com/learn/wp-content/uploads/2013/08/gap3.png) :

of course, now we need to remember that since this is simulated data, there is likely error.  We need to account for this error.  I don't quite understand the rationale behind this equation, but if you imagine you have some number of B reference distributions between 1 and infinity, we are essentially multiplying our standard deviation by a value between 1 and sqrt(2):

[![gap](http://www.vbmis.com/learn/wp-content/uploads/2013/08/gap5.png)](http://www.vbmis.com/learn/wp-content/uploads/2013/08/gap5.png)

thus making the variance just a little bit larger, because we probably underestimated it with our sampling?  Let's now choose our number of clusters, k, based on the Gap(k+1) having as much distance as possible from the gap at the previous value of k:

[![gap](http://www.vbmis.com/learn/wp-content/uploads/2013/08/gap6.png)](http://www.vbmis.com/learn/wp-content/uploads/2013/08/gap6.png)

The equation above is looking at two values of k, specifically "k" and "k+1."  We want to choose the value of k that maximizes our gap, adjusted for the expected variance (sk+1 from our null reference).  The reason that we are assessing subsequent pairs, k and k+1, is because we don't want to blindly look across all values of K, we want to choose the smallest one.  I don't have rationale behind this idea, but I'd say that for two pairs of k and k+1 for which the Gap statistic is equivalent, the pair of smaller values is probably more correct.  E.g., it seems more reasonable to say that we have 5 "correct" clusters than 25.  I'm not sure about this, however.   Here is an example, also from the paper, applied to K-Means clustering:

[![gap](http://www.vbmis.com/learn/wp-content/uploads/2013/08/gap7-785x346.png)](http://www.vbmis.com/learn/wp-content/uploads/2013/08/gap7.png)

The plot on the left shows the log of the expected error (E) from the reference distribution, compared to the observed data (O).  We can see that the difference between these two values (sort of) looks greatest at k=2.  The plot on the right shows the calculated Gap Statistic for this data, and we can see that it is indeed maximized when k=2.  The plots above are a good demonstration of what we see when there is real, meaningful clustering in our data.  What about when there isn't? We might see something like this:

[![gap](http://www.vbmis.com/learn/wp-content/uploads/2013/08/gap8.png)](http://www.vbmis.com/learn/wp-content/uploads/2013/08/gap8.png)

The plot on the right shows that the expected error is actually *less* than the observed error, and the corresponding Gap statistic on the right has all negative values.  This tells us that there is no value of K for which there is a good clustering.


