---
title: "Functional Brain Network Visualization"
date: 2013-9-11 17:37:52
tags:
  brain
  connectivity
  fmri
  graph
---


Now that we have (finally) come up with a correlation matrix to describe the relationship of voxels across the brain, let's explore some simple methods from graph theory.  To make this analysis somewhat more simple, I've thresholded my brain network to only include the most highly connected regions, those with correlation values greater than .9.  Here is a visualization of the voxel pairs that we will use in the sparse correlation matrix:

[![pt9](http://www.vbmis.com/learn/wp-content/uploads/2013/09/pt9.png)](http://www.vbmis.com/learn/wp-content/uploads/2013/09/pt9.png)

It most definitely is the case that most of these voxels appear to be neighbors, however that will make it more interesting to find the links that are in different regions.  Here is the corresponding spatial map for this level of threshold:

[![includedvoxpt9](http://www.vbmis.com/learn/wp-content/uploads/2013/09/includedvoxpt9.png)](http://www.vbmis.com/learn/wp-content/uploads/2013/09/includedvoxpt9.png)

I was first curious about the distribution of voxels in each region, and so I returned to the AAL atlas to get a count.  Out of 9671 voxels, the left precuneus dominates, but it's not as crazy large as the chart makes it out to be, only 657 voxels.  To give this some perspective, the amygdala, which is a rather small area, is about 242 voxels.  The precuneus is a region posterior to somatosensory cortex, and anterior to occipital lobe (yes, this makes it a part of the parietal lobe) associated with visuospatial processing, consciousness, and episodic memory.

[![voxelcounts](http://www.vbmis.com/learn/wp-content/uploads/2013/09/voxelcounts-785x298.png)](http://www.vbmis.com/learn/wp-content/uploads/2013/09/voxelcounts.png)

At this point I started looking into functions that Matlab has to work with graphs, and hit another road block.  They really aren't suited for data of this size.  Actually, this dataset doesn't seem unrealistically large to me in context of genetic network analysis.  It was clear that I would need different software, and so my first test was [Cytoscape](http://www.cytoscape.org/).  I exported my nodes, exported the labels for the regions, as well as the edges (weights) between them.  Granted that I know nothing about this program I don't have any prowess in using is, but I was able to color nodes by region, and adjust edges based on the weight value.  Largely, having every voxel as a node was just too much:

[![network](http://www.vbmis.com/learn/wp-content/uploads/2013/09/network-785x417.png)](http://www.vbmis.com/learn/wp-content/uploads/2013/09/network.png)

The most that I could learn from this "visualization" was that if I viewed my data based on the region attribute, I could see that there were local (regional) networks, and then inter-regional ones.  Another downfall was that the software interpreted the ordering of my edges as directional, which isn't the case.  However, I'm not quite ready to give up!  I want a visualization that is more humanly interpretable.  I decided to go back to the raw data and calculate, for each region, the average intra-regional correlation, and the average inter-regional correlations (the average pairwise correlations to all other regions).  I wanted one node per region, and I wanted the size of the node to represent the intra-regional connectivity, and the edges to represent the inter-regional connectivity.

[![gr4](http://www.vbmis.com/learn/wp-content/uploads/2013/09/gr41.jpg)](http://www.vbmis.com/learn/wp-content/uploads/2013/09/gr41.jpg)

There we go!  The "organic layout" graph above represents connectivity between 116 distinct brain regions, with the size of the node representing the intra-regional connectivity, and the thickness of the edge the inter-regional connectivity.  The lack of huge variance in the node and edge sizes is due to the fact that the values are thresholded at .9 and above to begin with.  The red edges represent connections between the right and left amygdala and other brain areas.  This was definitely fun - me using Cytoscape is akin to a monkey wandering around an outlet mall looking for the candy dispenser that has the banana candy in it.  I learned that this software is probably best for higher level representations of networks, and it doesn't do too well for very large data, so I might come back to it only if I have that kind of representation in my research.  If you look at the spatial map above, this just wasn't that much data in the scope of the entire brain!  All in all, I met my goal, and so I'm happy with that visualization, for now.
