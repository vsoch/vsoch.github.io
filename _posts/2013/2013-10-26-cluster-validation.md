---
title: "Cluster Validation"
date: 2013-10-26 21:32:30
tags:
  biological
  clustering
  clvalid
  internal
  r
  stability
  validation
---


Unsupervised clustering can be tough in situations when we just don't know "the right number" of clusters.  In toy examples we can sometimes use domain knowledge to push us toward the right answer, but what happens when you really haven't a clue?  Forget about the number of clusters, how about when I don't know the algorithm to use?  We've talked about using metrics like the [Gap Statistic](http://www.vbmis.com/learn/?p=574), and [sparse K-Means](http://www.vbmis.com/learn/?p=454) that looks at the within cluster sum of squares for optimization.  These are pretty good.  However, I wanted more.  That's when I found a package for R called [clValid](http://cran.r-project.org/web/packages/clValid/vignettes/clValid.pdf).

Now that I'm post Quals, I can happily delve into work that is a little more applied than theoretical (thank figs!).  First let's talk generally about different kinds of evaluation metrics, and then let's try them with some data.  The kinds of evaluation metrics that we will use fall into three categories: internal, stability, and biological.  Actually, stability is a kind of internal, so I'll talk about it as a subset of internal.

 


## What is internal validation?

Internal validation is the introverted validation method.  We figure out how good the clustering is based on intrinsic properties that don't go outside of our particular dataset, like compactness, distance between clusters, and how well connected they are.  For example:

- **Stability validation**:  is like a game of Jenga.  We remove features one at a time from our clustering, and see how it holds up.  For each time that we remove a feature, we look at the average distance between means, the average proportion of non overlap, the Figure of Merit, and the average distance.  For all four of these metrics, we iteratively remove features, and dock points when there is huge change.  A value of 0 would be ideal, meaning that our clustering was stable.  For details, see the link to the clValid documentation above.

- **Connectivity:** A good cluster should be close to its other cluster members.  That makes sense, right? If there is someone closed to me placed in another cluster, that's probably not a good clustering.  If there is someone very far from me placed in the same cluster, that doesn't sound great either.  So, intutively think of connectivity as a number between 0 and infinity that "gets at" how well connected a cluster is.  Specifically, if we have N mysterious lemurs, and are assessing L neighbors, the connectivity is:

[![conn](http://www.vbmis.com/learn/wp-content/uploads/2013/10/conn.png)](http://www.vbmis.com/learn/wp-content/uploads/2013/10/conn.png)

meaning that, for each lemur, we look at its distance to each of it's L neighbors.  For one lemur, i, and his jth nearest neighbor, the stuff in the parentheses is 0 if i and j are in the same cluster, and 1/j otherwise.  In the case that we have a perfect clustering, all nearest neighbors are in the same cluster, and we add up a bunch of zeros.  In the case that nearest neighbors are in different clusters, we add subsequent 1/j, and get some non zero value.  So if you were implementing this, you would basically calculate pairwise distances for all lemurs, N, then iterate through each point, find the closest L lemurs, and come up with a sum that depends on how many of those neighbors are in the same cluster.  Then you add up these sums for all N lemurs, and get the total connectivity value.  0 means awesome, larger numbers mean *sadface*.

- **Compactness:  ** Within my cluster family, I should be pretty similar to my siblings.  This means that the variance of whatever features define me shouldn't be very large.  On the other hand, it should be much different from an invidual in a different cluster family.
- **Separation: ** There should be lots of distance between clusters, whether you look at the distance between centroids, or the distance from the most outside points.
- **The Dunn Index: ** Since separation decreases as we add more clusters and compactness increases, we have the Dunn Index to nicely combine these two.  The Dunn Index holds to the idea that "a team is only as strong as its weakest member," and for each cluster, finds the smallest distance to a neighbor cluster, and divides by the greatest distance between any two points in the same cluster.   This value is different from compactness and silhouette because we want to maximize it.  We would want to see a huge distance from other clusters (the numerator) and a tiny tiny distance between the maximum points in the same cluster (the denominator).
- **Silhouette Width: ** is another nice metric that combines compactness and separation.   Each of our N lemur's can get a number between 1 (good) and -1 (bad) that represents how well clustered it is.  Specifically, for a point i, we can calculate the average distance it is from its same cluster siblings (ai), and its average distance from all points in the nearest (but different) cluster (bi):

[![conn](http://www.vbmis.com/learn/wp-content/uploads/2013/10/conn1.png)](http://www.vbmis.com/learn/wp-content/uploads/2013/10/conn1.png)

We subtract the average sibling distance from the average foreigner distance, and then divide by whichever value is larger (just to scale it).  In the case that are clustering is perfect, this would mean that the average distance from point i to all its neighbors is zero.  We would then subtract zero from some positive distance value, divide by that same value, and get a result S(i) = 1.  In the equally unlikely and extreme case that our clustering is awful and in fact the average neighboring distance is zero and our siblings have some positive distance, then we wind up subtracting a positive value from zero, dividing by the same positive distance value, and the result is S(i) = -1.  Again, values close to 1 are good, close to -1, not so much.

 


## What is biological validation?

Is my clustering meaningful, biologically?  In the world of informatics, the best example is with microarray data, or anything to do with genes and gene expression.  If we cluster some data based on expression values, we might then use the Gene Ontology (GO) to see if the grouped values (based on similar expression) all fall within some common biological pathway.  For neuroimaging analysis, I can't say that I have much use for GO.  However, if some day the Allen Brain Atlas has a better sample size for gene expression in the human brain, I might.  For now, let's say that we have some set of labels for our data that has biological meaning (a type of cell? a type of person? something along those lines.)  Here are common methods for biological validation:

- **Biological Homogeneity Index (BHI)**: how homogenous are our clusters?  Let's say that we have C clusters, and B classes of biological meaning:

[![conn](http://www.vbmis.com/learn/wp-content/uploads/2013/10/conn3.png)](http://www.vbmis.com/learn/wp-content/uploads/2013/10/conn3.png)

To calculate the Biological Homogenity Index, the result of which will be a value between 0 [no biological meaning] and 1 [homogenous!], we take each cluster (C), and then look at pairwise genes, i and j, within each cluster.  Let's move from right to left.  The summation on the right is comparing each gene i to each gene j in the same cluster.  The "I" means that we have an indiator function.  This function spits out a 1 in the case that the two genes share any functional class (not necessarily class K), and a 0 if they don't.  We sum up all of those values, to be multiplied by the summation on the left.  This first summation calculates a value, nk, which is the total number of genes in that cluster that are annotated with B , for some class K.  Intuitively, you can see that if nk==1, or nk==0, the first term is zero, and the BHI is zero as well.  So you would do the above calculation for each of your B classes, and large BHI scores for some class B means that your clustering is annotated in a biologically meaningful way!

- **Biological Stability Index (BSI)**:  Be weary of anything with an acronym that starts with "BS!"  Just kidding.  This is a combined stability and biological validator.  We would want to see data objects with similar biological annotation be consistent in their clustering if we iteratively remove data.   See the documentation linked at the top on page 8 for details.   A value of 1 means that we have stable clusters, and a value of 0 means we do not.

 


## And the algorithms?

I've gone over unsupervised algorithms in other posts, so here I will just list what the clValid package offers:

- UPGMA: This is agglomerative [hierarchical clustering](http://www.vbmis.com/learn/?p=98 "Hierarchical Clustering"), bread and butter.
- [K-Means](http://www.vbmis.com/learn/?p=94 "K-Means Clustering")! Also bread and butter
- Diana and SOTA: also hierarchical clustering, but divisive (meaning instead of starting with points and merging, we start with a massive blob and split it)
- PAM "Partitioning around medioids" is basically K-means with distance metrics other than Euclidean.  It's sister package Clara runs PAM in a bootstrappy sort of way on subsets of data.
- Fanny: Fuzzy clustering!
- SOM: [self organizing maps! ](http://www.vbmis.com/learn/?p=510 "Self Organizing Maps (SOM)")
- Model Based: fit your data to some statistical distribution using the [EM (expectation maximization) algorithm](http://www.vbmis.com/learn/?p=345 "Expectation Maximization (EM) Algorithm").
- SOTA: self organizing trees.

 


## clValid Application - Internal Metrics

Now it's time to have fun and use this package!  I won't give you the specifics of my data other than I'm looking at structural metrics to describe brains, and I want to use unsupervised clustering to group similar brains.  If you want to use any of my simple scripts, you can source my R Cloud gist as follows:

```
source('http://tinyurl.com/vanessaR')
```

First let's normalize our data, then look at k-means and hierarchical clustering for a good range of cluster values:

```
# Normalize data
x = as.matrix(normalize(area.lh))
```

library('clValid')
clusty &amp;amp;amp;amp;amp;amp;amp;amp;lt;- clValid(x, 2:20, clMethods=c("hierarchical","kmeans","pam"),validation="internal",neighbSize=50)
summary(clusty)
plot(clusty)
```

clValid gives us each metric for each clustering, and then reports the optimal values.  I ran this for different numbers of clusters, and consistently saw 2 as being the most prevalent, except for when using k-means:

[![conn](http://www.vbmis.com/learn/wp-content/uploads/2013/10/conn2.png)](http://www.vbmis.com/learn/wp-content/uploads/2013/10/conn2.png)

I tried increasing the number of clusters to 20+, and tended to see the metrics drop.  Let's take a look at 2 to 50 clusters:

#### Connectivity

Remember, this should be minimized.

[![internal_validation](http://www.vbmis.com/learn/wp-content/uploads/2013/10/internal_validation.png)](http://www.vbmis.com/learn/wp-content/uploads/2013/10/internal_validation.png)

#### Dunn

This should be maximized!

[![dunn](http://www.vbmis.com/learn/wp-content/uploads/2013/10/dunn.png)](http://www.vbmis.com/learn/wp-content/uploads/2013/10/dunn.png)

#### Silhouette

Maximized! (up to 1)

[![silhouette](http://www.vbmis.com/learn/wp-content/uploads/2013/10/silhouette.png)](http://www.vbmis.com/learn/wp-content/uploads/2013/10/silhouette.png)

So what are some issues here?  It looks like the data is somewhat "clustery" when we define two groups.  However, a main is feature selection.  I haven't done any at all :).  Just for curiosities sake, let's look at the dendrogram before moving on to testing stability metrics:

[![morph](http://www.vbmis.com/learn/wp-content/uploads/2013/10/morph.png)](http://www.vbmis.com/learn/wp-content/uploads/2013/10/morph.png)

It certainly makes sense that we see the best metrics for two clusters.  The numbers correspond to a biological label, and now we would want to see if there is a clustering that better separates these labels.  It's hard to tell from the picture - my best guess is that it looks kind of random.  Let's first look briefly at stability metrics.


## clValid Application - Stability Metrics


```
# Now validate stability
clusty &amp;amp;amp;amp;amp;amp;amp;amp;lt;- clValid(x, 2:6, clMethods=c("hierarchical","kmeans","pam"),validation="stability")
optimalScores(clusty)
```


[![conn](http://www.vbmis.com/learn/wp-content/uploads/2013/10/conn4.png)](http://www.vbmis.com/learn/wp-content/uploads/2013/10/conn4.png)

Remember, we are validating a clustering based on how much it changes when we remove data.  This took quite a bit of time to run, so I only evaluated between 2 and 6 clusters.  I would guess that kmeans would show "consistent improvement" with larger values of K (of course if we assigned each point to its own cluster we'd have perfect clustering, right?) and for hierarchical, as the tree above shows, our best clustering is a low value around 2 or 3.  Let's try some biological validation.  This is actually what I need to figure out how to do for my research!

 


## clValid Application - Biological Metrics

What I really want is actually to evaluate clustering based on biology.  I have separate labels that describe these brains, and I would want to see that it's more likely to find similar labels in a cluster than not.  I really should do feature selection first, but I'll give this a go now just to figure out how to do it.  Note that, to simplify things, I just used two annotations to distinguish two different classes, and the annotation variable (rx.bin) is a list, which the function converts into a matrix format.

```
# Validate biologically - first create two labels based on Rx

rx.bin = rx.filt
rx.bin[which(rx.bin %in% c(0,1))] = 1
rx.bin[which(rx.bin %in% c(2,3,4,5))] = 0

# Now stick the binary labels onto our data
annot &amp;amp;amp;amp;lt;- tapply(rownames(x.filt),rx.bin, c)
bio &amp;amp;amp;amp;lt;- clValid(x.filt, 2:20, clMethods=c("hierarchical","kmeans","pam"),validation="biological", annotation=annot)
optimalScores(bio)
```

And as you see above, we can use the optimalScores() method instead of summary() to see the best of the bunch:

[![conn](http://www.vbmis.com/learn/wp-content/uploads/2013/10/conn5.png)](http://www.vbmis.com/learn/wp-content/uploads/2013/10/conn5.png)

Remember that, for each of these, the result is a value between 0 and 1, with 1 indicating more biologically homogenous (BHI) and more stable (BSI).  This says that, based on our labels, there isn't that much homogeneity, which we could have guessed from looking at the tree.  But it's not so terrible - I tried running this with a random shuffling of the labels, and got values pitifully close to zero.

 


## Summary

Firstly, learning this stuff is awesome.  I have a gut feeling that there is signal in this data, and it's on me to refine that signal.  What I haven't revealed is that this data is only a small sample of the number of morphometry metrics that I have derived, and the labels are sort of bad as well (I could go on a rant about this particular set of labels, but I won't :)).  Further, we have done absolutely no feature selection!  However, armed with the knowledge of how to evaluate these kinds of clustering, I can now dig deeper into my data - first doing feature selection across a much larger set of metrics, and then trying biological validation using many different sets of labels.  Most of my labels are more akin to expression values than binary objects, so I'll need to think about how to best represent them for this goal.  I have some other work to do today, so I'll leave this for next time.  Until then, stick a fork in me, I'm Dunn! :)
