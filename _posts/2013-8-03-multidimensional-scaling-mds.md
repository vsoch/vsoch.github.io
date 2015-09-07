---
title: "Multidimensional Scaling (MDS)"
date: 2013-8-03 00:46:01
tags:
  dimensionality-reduction
  mds
  multidimensional-scaling
---


**Multidimensional scaling (MDS)** is a way to reduce the dimensionality of data to visualize it.  We basically want to project our (likely highly dimensional) data into a lower dimensional space and preserve the distances between points.  The first time that I learned about MDS was by way of STATS 202 with John Taylor, although to be honest, I got through the class by watching [old lectures by David Mease](http://www.youtube.com/watch?v=zRsMEl6PHhM) on youtube.  Thank goodness for youtube!

If we have some highly complex data that we project into some lower N dimensions, we will assign each point from our data a coordinate in this lower dimensional space, and the idea is that these N dimensional coordinates are ordered based on their ability to capture variance in the data.  Since we can only visualize things in 2D, this is why it is common to assess your MDS based on plotting the first and second dimension of the output.   It's not that the remaining N-2 axis don't capture meaningful information, however they capture progressively less information.

If you look at the output of an MDS algorithm, which will be points in 2D or 3D space, the distances represent similarity. So very close points = very similar, and points farther away from one another = less similar.  MDS can also be useful for assessing correlation matrices, since a correlation is just another metric of similarity between two things.

### How does MDS Work?

Let's implement very simple MDS so that we (and when I say we, I mean I!) know what is going on.  The input to the MDS algorithm is our proximity matrix.  There are  two kinds of classical MDS that we could use:

- Classical (metric) MDS is for data that has metric properties, like actual distances from a map or calculated from a vector
- Nonmetric MDS is for more ordinal data (such as human-provided similarity ratings) for which we can say a 1 is more similar than a 2, but there is no defined (metric) distance between the values of 1 and 2.

For this post, we will walk through the algorithm for classical MDS, with metric data of course!  I'm going to use one of Matlab's random datasets that is called "cities" and is made up of different ratings for a large set of US cities.

code

Here are our cities, with MDS applied, closer dots  = more similar cities, as assessed by ratings pertaining to climate, housing, health, crime, transportation, education, arts. recreation, and economics.

[![mds_example](http://www.vbmis.com/learn/wp-content/uploads/2013/08/mds_example.png)](http://www.vbmis.com/learn/wp-content/uploads/2013/08/mds_example.png)

This isn't the greatest example, because showing the labels wouldn't give you much insight into if the method works.  (Better would have been to use a dataset of actual distances then projected into 2d, oh well!) The end of the script does format and display labels, however the picture doesn't show them, because they didn't add much.  For more details (and a better example that uses simple cities distances) [see here](http://homepages.uni-tuebingen.de/florian.wickelmaier/pubs/Wickelmaier2003SQRU.pdf).

Remember that this is an incredibly simple form of MDS.  See page 589 of [Elements of Statistical Learning](http://www-stat.stanford.edu/~tibs/ElemStatLearn/) for more.

 


