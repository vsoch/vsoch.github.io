---
title: "Exploring Raw Functional MRI"
date: 2013-8-31 21:09:43
tags:
  aal
  fmri
  functional-mri
  mri
  region
---


I'm curious if using a mean timecourse to represent a region is a good idea or not.  What I did is, for a functional timeseries with 140 timepoints, I wrote a script to mask the data for a region of interest, and then for the voxels within each region, plot all of the normalized individual timecourses (blue) and compare against the mean timecourse (in red).  These are essentially Z values, meaning that we have subtracted the mean and divided by the standard deviation.

**1) Does a mean timecourse do a good job to represent a large region?**

Here we have the collection of timecourses for the first region of the AAL atlas, the Precentral gyrus, on the left.  The precentral gyrus is home to motor cortex:

[![mean_func](http://www.vbmis.com/learn/wp-content/uploads/2013/08/mean_func-785x318.png)](http://www.vbmis.com/learn/wp-content/uploads/2013/08/mean_func.png)

Schmogley!  I suppose you could argue that the mean timecourse gets at the "general" shape, but this just seems like a bad idea.  Although to be fair, this is a rather large region.  You are looking at just about 12,000 voxels.

**2) Does a mean timecourse do a good job to represent a small(er) region?**

Let's try a smaller region, like the right amygdala.  This is about 1000 voxels:

[![mean_func_amyg](http://www.vbmis.com/learn/wp-content/uploads/2013/08/mean_func_amyg-785x350.png)](http://www.vbmis.com/learn/wp-content/uploads/2013/08/mean_func_amyg.png)

It's slightly better looking, but I'm still thinking that this isn't a great idea.

**3) Assessing timecourse similarity**

Let's assess this properly and calculate a distance matrix  The indices of this matrix will represent the similarity between timecourse i and j, so when i==j, we would see a distance of 0 meaning that they are exactly the same.  The larger the value gets, the more different.  So we should see values of 0 along the diagonal (when i==j)) and I'd also suspect that neighboring voxels are firing together:

[![distance_matrix](http://www.vbmis.com/learn/wp-content/uploads/2013/08/distance_matrix-785x467.png)](http://www.vbmis.com/learn/wp-content/uploads/2013/08/distance_matrix.png)

What we see here is that there are most definitely voxels that share a similar timecourse (blue), and then there are a small number of voxels that are different.  I'd like to think that this is because of actual biological differences, but I'm also thinking that it's likely to be noise.  The amygdala is situated rather low in the head, and it tends to be victim of what we call signal dropout.  Namely, that it's possible to lose signal in some of the timepoints.  Or be subject to noise.

**4) Clustering Distance Matrix to find "the right" groups?**

I have a good idea... let's try clustering this distance matrix, and then looking at the timeseries for each of the clusters.  This is pretty easy, because the x and y labels correspond to the voxel index.  From the above I'd guess three clusters, but let's do a dendrogram first to see if this is a good idea.

[![dendrogram](http://www.vbmis.com/learn/wp-content/uploads/2013/08/dendrogram.png)](http://www.vbmis.com/learn/wp-content/uploads/2013/08/dendrogram.png)

Yes, I think so.  Let's try 3 clusters, and plot the timeseries for each of our three.

**5) Mean timecourses for clustered groups of voxels**

I decided to try for three clusters, and then six.  While there is slight improvement in the mean representing the group, it still looks kind of bad to me.

[![func_timecourses_3_cluster](http://www.vbmis.com/learn/wp-content/uploads/2013/08/func_timecourses_3_cluster-785x584.png)](http://www.vbmis.com/learn/wp-content/uploads/2013/08/func_timecourses_3_cluster.png)

and six groups...

[![func_timecourses_6_cluster](http://www.vbmis.com/learn/wp-content/uploads/2013/08/func_timecourses_6_cluster-785x369.png)](http://www.vbmis.com/learn/wp-content/uploads/2013/08/func_timecourses_6_cluster.png)

If these plots looked better, my next step would have been to assess the spatial location of the voxels.  But I'm not convinced that these groups are very good.  And here we have a conundrum!  On the one hand, we want to use more abstract (regional) features, because if we really do look at the data on the level of every single voxel, that is prime to overfitting our data.  We aren't going to find interesting patterns that way that could be extended beyond our training set.  On the other hand, if we zoom out too much, it's just a mess.

**6) We can't make assumptions about similar function based on spatial location**

In this exploration I've shown an important idea.  We can't make strong assumptions about function based on spatial location.  Yes, it's probably true that neighboring voxels share similar timecourses (reminds me of [a nice quote from NBIO 206](http://en.wikipedia.org/wiki/Hebbian_theory)) but we would be silly to assess for similar firing within one brain region.  It's likely that if we zoom out our distance matrix, there would be voxels in other parts of the brain with more similar timecourses to specific voxels in the amygdala than other voxels within the amygdala.  This is exactly why many approaches calculate whole brain voxelwise similarity metrics, and then threshold the matrix (keeping only the strongest connections) to create a graph.  This graph represents a connectivity matrix, and "gets at" what the buzz word "the human connectome" represents (on the functional side of things, note that you can also look at a structural connectome, representing areas that have physical neuron highways between them).  Since this would be a huge matrix, this is why researchers either set "seed" points (voxels they have reason to believe are the best or most important), or use a mean timecourse to represent some larger set of voxels before creating this graph of connections.

**7) So how can I make more "abstract" features for functional data?**

This is why, for functional data, I prefer methods like [ICA](http://www.vbmis.com/learn/?p=88 "Independent Component Analysis (ICA)") that can decompose the brain into some set of N independent signals, and their timecourses, not making any pre-conceived assumptions about spatial location of voxels (other than assuming independence).  Since I'd like to transform my functional data into some set of meaningful features to combine with my structural data and predict things like disorder type (probably won't be good models) or behavioral traits (a better idea), I need to think about how I want to do this.  I don't think that I expected to learn from this simple investigation that it would be a good idea to extract features about the signal of mean timecourses, so this introduces opportunity for creative thinking.  But I kind of want to work on something else for now, so I'll save that for another time!
