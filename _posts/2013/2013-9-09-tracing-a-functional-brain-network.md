---
title: "Tracing a Functional Brain Network"
date: 2013-9-09 22:30:22
tags:
  betweenness
  centrality
  closeness
  degree
  fmri
  graph-theory
---


I'm reading about different ways to understand and process functional data, and so methods from graph theory serve as good candidates.  I'm excited about these methods simply because I've never tried them out before.


## Creating the Graph

### Assess Correlations between points and threshold to create a graph

We are starting with a graph, meaning that we have accessed the connectivity (correlation or some similarity metric) between all pairwise voxels in a brain, and then applied a threshold to leave only the more highly connected voxels.  If a connection between two voxels falls below the threshold, the "edge" is broken, and if the value is above the threshold, we maintain the edge. To explore these different kinds of connectivity, let's again work with actual functional data.  First, let's read in the data and flatten it into a 2D matrix (Yes, I am modifying the path and files names for the example):

code

At this point I would want to make a correlation matrix like this:

code

but of course I ran out of memory!  I then queried my friend Google for some data structure in Matlab for sparse matrices, and found it, the function "[sparse](http://www.mathworks.com/help/matlab/ref/sparse.html)" of course!  Instead of creating the entire correlation matrix and *then *thresholding, what we can do is find the indices for correlations already above some threshold, and then plop these values into a sparse matrix.  This "sparse" function takes as input a vector of indices and a vector of values, and you create the matrix in one call.   So, we need to create these two vectors, and just hope that there aren't enough values to have memory issues:

code

Seems like a good idea, right?  Don't do it!  The above will run for days, if it even finishes at all.  Here is where I ran into a conundrum.  How have other people done this?  Is it really impossible to create a voxelwise graph for one person's brain?  I first explored tricks in Matlab to use matrix operations to efficiently calculate my values (think arrayfun, matfun, etc.)  This didn't work.  I then learned about a function called [bigcor in R](http://rmazing.wordpress.com/2013/02/22/bigcor-large-correlation-matrices-in-r/) from a colleague, and exported my data to try that out.  Even my data was too big for it, and I had to split it up into a tiny piece (20,000 / 520,000 voxels) and then it took quite some time to work on the piece.

### A function for sparse matrices in Matlab? Not yet.

If the best that I could do was a piecewise function in R, then I figured that I might as well write my own function in Matlab.  I knew that I would just need to break the data into pieces, calculate the correlation matrix for the piece, and then save indices relevant to the original data size with the corresponding correlation value.  And I would probably want to save results as I went to not run out of memory with long lists of indices on top of the original data and correlation matrix.  I'm squoozy to admit that I spent most of a weekend on said function.  I'm not sharing it here because, while it technically works, the run-time is just not feasible, and so after spending the time, I decided that I needed to pursue a more clever method for defining a local brain network.

### Introducing, Mr. Voxel!

This exploration began with just one voxel.  If I am going to create a method for tracing some functional network, I need to have a basic understanding of how one voxel is connected to the rest of the brain.  Introducing, Mr. Voxel, who is seeded in the right amygdala.  My first question was, how does Mr. Voxel function with all the voxels in the rest of the brain, and his neighboring voxels?

[![ramycorr](http://www.vbmis.com/learn/wp-content/uploads/2013/09/ramycorr-785x310.png)](http://www.vbmis.com/learn/wp-content/uploads/2013/09/ramycorr.png)

The plot to the left shows correlations between Mr. Voxel and the other 510,340 voxels in the brain.  The plot to the right shows correlations between Mr. Voxel and his neighbors, defined by also being in the right amydala region of the AAL atlas.  It seems logical that neighboring voxels would have more similar timecourses than far away ones.  However my next question was, where are the most highly correlated voxels located?  I chose a threshold of .5 because .55 / .6 seemed to be the tipping point, when we jumped from 16 and 22 voxels, respectively, up to 162.  Here is the breakdown for the top 162 voxels:

code

and the distribution of the correlation values themselves:

[![topcorrs](http://www.vbmis.com/learn/wp-content/uploads/2013/09/topcorrs.png)](http://www.vbmis.com/learn/wp-content/uploads/2013/09/topcorrs.png)

But we can do better!  Let's take a look at the spatial map for these voxels:

[![threshpt6](http://www.vbmis.com/learn/wp-content/uploads/2013/09/threshpt6.png)](http://www.vbmis.com/learn/wp-content/uploads/2013/09/threshpt6.png)

I'm quite happy with this result.  I would want to see the most highly connected voxels being the neighboring ones in the amygdala, and then some friends in frontal cortex and hippocampus.  Now what?

### A function to generate the graph of a local network

What I really had wanted to do was generate a simple network so that I could test different graph metrics, and so I decided that it would make sense to start at a seed voxel, and trace a network around the brain, adding voxels to some queue that are above some threshold to expand the network.   Since this could get unwieldy rather quickly, I decided that my stopping conditions would be either an empty queue (unlikely!), or visiting all 116 unique regions of the AAL atlas.  For each iteration, I would take the top value off of the queue, find the most highly correlated voxels, and save them to my network.  I would then only add voxels to the queue that came from novel regions.  I know that this is a biased approach for whatever regional voxel gets lucky enough to be added first, and even more biased based on what I choose for an initial seed.  For this early testing I'm content with that.  I will later think about more sophisticated methods for adding and choosing voxels off of the queue.  Whatever strategy that I choose, there probably isn't a right answer, and what is important is only to be consistent with the method between people.

### Queue Popping Method Development

First, let's look at the growth of the queue.  The plot below shows the number of voxels in the queue at each iteration:

[![queue_growth](http://www.vbmis.com/learn/wp-content/uploads/2013/09/queue_growth.png)](http://www.vbmis.com/learn/wp-content/uploads/2013/09/queue_growth.png)

Based on only going through 158 iterations and visiting 101 AAL regions in those iterations, I realized that most of my queue wasn't even going to be used.  I need to rethink my queue popping strategy.  Now let's take a look at the breakdown of the old queue.  Out of a final total of 15120 contenders, there are in fact only 5665 unique values, and they are spread across the entire AAL atlas:

[![voxelsinq](http://www.vbmis.com/learn/wp-content/uploads/2013/09/voxelsinq.png)](http://www.vbmis.com/learn/wp-content/uploads/2013/09/voxelsinq.png)

We could either limit the voxels that we put on the queue to begin with, or we could develop a strategy that takes this distribution, *and* the regions that we've already visited, into account.  On the one hand, we want to visit a region that has more representation first, but we don't want to keep visiting the same popular regions in the network over and over again.  Stepping back and thinking about this, I would want to do something similar to what  is done in vector quantization.  I want a vector of sensitivity values that bias our choice toward regions that haven't been selected, and I also want to take into account the number of voxels that are in the queue for that region.  I modified the script to take these two things into account, and used it to generate my first local network!  Keep in mind that this network is an **undirected graph** because we can't say if a connection between voxels i and j is from i to j, or j to i.  I finished with a list of links, and a list of values to describe those links (the weights).  I then (finally) used Matlab's sparse function to create the adjacency matrix for my graph:

code

The above is saying to create a sparse matrix with x values from links(:,1), y values from links(:,2), fill them in with ones because there is one link between each set of nodes, and make it a square matrix sized as the original number of voxels (that Matlab could not handle as a non-sparse matrix).  After this adjacency matrix was created (albeit in like, two seconds!), I used the "spy" function to look at the indices of this beast matrix that are included in the graph.  This definitely isn't everyone, but it's a good sampling across the entire matrix, and I'm pretty happy that I was able to pull this off.  The stripes of emptiness are more likely to be area outside of the brain than "missed" voxels.  Remember that this isn't the graph itself, just the indices of the members, and the correlation threshold is .55, which could easily be increased.

[![sparse_matrix](http://www.vbmis.com/learn/wp-content/uploads/2013/09/sparse_matrix-785x526.png)](http://www.vbmis.com/learn/wp-content/uploads/2013/09/sparse_matrix.png)

Trying to visualize these voxels, spatially, in Matlab is not a good idea.  Instead, let's write the included voxel coordinates to file, and overlay on an anatomical image:

[![includedvox](http://www.vbmis.com/learn/wp-content/uploads/2013/09/includedvox.png)](http://www.vbmis.com/learn/wp-content/uploads/2013/09/includedvox.png)

My instincts were correct that I got most of the brain, and for a first go at this, I am pretty pleased!  The running time wasn't ridiculous, and we get coverage of most of the brain's gray matter.  In fact, I think that it's even too much, and I'm going to up the threshold.  [For my next post](http://www.vbmis.com/learn/?p=702), I will increase the threshold to a much higher value (.9?) and see if I can visualize this network as a graph.  My goal is to get a sense if using this kind of graphing software for visualization makes sense for functional MRI data.
