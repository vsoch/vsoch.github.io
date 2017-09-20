---
title: "Modularity Optimization Algorithm of Newman"
date: 2013-7-29 17:11:05
tags:
  graph-theory
  modularity
---


When we create a network, we are concerned about how the components are broken into groups, and how those groups are connected.  This is relevant to graph theory, where the basic idea is to have entities in some system represented as nodes, and the relationships between them (some similarity metric) represented as connections between the nodes (called "edges").  The way that one of these graphs is built typically goes something like this:

1. For n observations, create an n x n similarity matrix S, where each box Sij represents the similarity between observation i and observation j
2. Threshold the matrix at some meaningful value so that boxes above the threshold become nodes of the graph, and boxes below the threshold go away

This is very simple, and how I'd probably do it.  And I'd probably choose a threshold so that each node has minimally one vertex, because we don't want any lonely nodes floating off by themselves.  But if we read more about graph theory, once we have some set of nodes and vertices, how do we define the groups?

 

### We define groups to maximize community structure

The idea of **community structure** says that there are groups of highly connected observations, and the connections between these groups are pretty sparse.  In the domain of neuroscience, this community structure would be coined a "**small world network**," relevant to a disorder like autism, as [it has been propose](http://arxiv.org/abs/1007.5471v1) [d](http://arxiv.org/abs/1007.5471v1) that the autistic brain is defined by these small world networks.

The concept of **modularity **is the number of connections (edges) falling within groups minus the expected number in an equivalent network with randomly placed edges.  This means that modularity can be positive or negative, and if it's negative, this hints at the graph having community structure, because there are relatively more edges.

This is pretty simple, but when I was thinking about graphs, I asked the question, "How do we know how to define groups?"  This post will discuss one simple method [proposed by Newman](http://www.ncbi.nlm.nih.gov/pmc/articles/PMC1482622/).

 

### Newman's Modularity Optimization Algorithm

Newman basically takes the [modularity matrix](http://en.wikipedia.org/wiki/Modularity_(networks)#Matrix_formulation), defined as:

![](http://www.ncbi.nlm.nih.gov/pmc/articles/PMC1482622/bin/zpq02306-2388-m03.jpg)

where Aij is the adjacency matrix, and each box has the number of connections between vertices i and j (in this case, this will be 0 or 1).  ki and kj are the degrees of the vertices, and m is the total number of nodes in the network.  The modularity, then, is the sum of all of these values for all pairs of vertices in the same group.  We can express this as:

![](http://www.ncbi.nlm.nih.gov/pmc/articles/PMC1482622/bin/zpq02306-2388-m02.jpg)

The 1/4m (the paper says) is conventional (to go along with previous definitions of modularity), the vector s is a vector of {-1 1} that says if a particular vertex belongs to group 1 or 2, and the matrix B is the modularity matrix we defined above.  Our goal is to maximize this modularity, Q, by choosing the appropriate division of the network, reflected by the vector s.

What Newman does is 1) compute the leading eigenvector (see paper for details),  and 2) divide the vertices into two groups according to the signs of the elements in this vector.  If all the values are positive, this means that there is no division of the network that results in community structure (we call the network **indivisible **in this case).  A larger value means that the vertex in question is a big contributor to the community structure (in other words, you can imagine a large value is spot in the middle of a big cluster, and if we moved it, we'd mess up the group pretty significantly), and a small (positive) value could be moved to a different group with less influence on the network.

What about if we have more than one group? (of course we do!) We apply this algorithm many times: i.e., break into the best two groups, and then break each group into two, and we continue until the signs of the eigenvectors are all positive, meaning that we do not improve community structure by continuing to break.

 

### Another method!

This Newman guy, he is full of ideas - the paper has another method!  We start by diving our vertices into two groups, and then we find the one vertex that, when moved to the other group, results in the biggest increase in modularity.  We then keep making moves with the constraint that no vertex is moved more than once.  When all have been moved, we then have an idea about how salient each one is to the community structure, and we can search around these intermediate states to find the greatest modularity.  We then have a new grouping, and we keep doing this until there is no improvement in modularity.

 

### A Caveat: High Modularity Doesn't Always Mean Having Strong Community Structure

Well, crap.  Why is this the case?  As our network gets really big, so does the number of possible divisions of that network. In this landscape, it is possible that there exists a division with high modularity and not strong community structure.  This only means that high modularity is necessary but not sufficient for evaluating community structure.  You might also want to use something like VOI, or [variation of information](http://en.wikipedia.org/wiki/Variation_of_information).  This basically means doing a random perturbation of your assignments, and then re-assessing the modularity.  The VOI is the difference between the first clustering and the perturbed one.  A graph with true community structure will have little change in VOI because any one vertex movement is not going to significantly alter the true structure.  A graph that has high modularity due to random chance will have a large change in VOI.  You can calculate this metric for different numbers of random changes in assignments and assess the change in the VOI.

 


