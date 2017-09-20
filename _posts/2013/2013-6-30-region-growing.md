---
title: "Region Growing"
date: 2013-6-30 18:10:04
tags:
  region-growing
  segmentation
---


**Region Growing** is an algorithm for segmentation of regions in an image based on the idea that regions share some property that can be computationally measured.  It's one of those magical algorithms that is ridiculously simply, and powerful because the user can customize it so easily.  In what way?  We have complete freedom to choose the metric to distinguish our region(s) of interest, when we stop and start growing a region, and how we initialize the algorithm with some seed point.  For example, the most simple metric that could be used is the image intensity (the pixel value).  If we were to read the image below into Matlab:  
[![totoro](http://www.vbmis.com/learn/wp-content/uploads/2013/06/totoro.png)](http://www.vbmis.com/learn/wp-content/uploads/2013/06/totoro.png)

We could look at the matrix of gray values, and see that the pixels making up Totoro have a value close to 0 (meaning total absence) and his eyes are close to 1 (white).  Note that this is assuming that we are reading the image in **greyscale, **which gives images values in the range [0,1].  From this observation alone, we could use pixel intensity to separate Tototo from his background.  How do we do that?How does region growing work?We will start by choosing a criteria that defines our region, such as image intensity.  We could "hard code" a particular intensity in, (perhaps between 0 and .15 would work well?), however it is more reasonable to write a script that allows a user to select a pixel of interest from the image, and use that intensity to start region growing.  In a simple image like this one, you could specify the pixel intensity to be equal to that value.  In an image that isn't so clean cut, you could specify within some range of that value.  The important thing is that you have some boolean statement that represents your criteria.  We then start at our selected pixel of interest, and look at all of his neighbors to determine if they meet the criteria.  If they do, great! We add them to our region, and then we look at their neighbors.  We keep looking at neighbors until we run out, and everyone that passed the criteria is included in the final image.  More specifically, here is the general pseudo-code for region growing:  
[![region_growing](http://www.vbmis.com/learn/wp-content/uploads/2013/06/region_growing.png)](http://www.vbmis.com/learn/wp-content/uploads/2013/06/region_growing.png)

The criteria can be anything that you can dream up to measure in the image, and you can add additional constraints about the size or even shape of the region.  Applied to medical imaging, region growing works pretty well for large vessel segmentation, and even lung segmentation.  For example:  
[![region_growing_pic](http://www.vbmis.com/learn/wp-content/uploads/2013/06/region_growing_pic.png)](http://www.vbmis.com/learn/wp-content/uploads/2013/06/region_growing_pic.png)

This is the classic picture that comes to my mind when I think of region growing, and it's actually from a [Matlab region growing script](http://www.mathworks.com/matlabcentral/fileexchange/19084-region-growing) on the File Exchange.  You can see that the algorithm nicely segmented the right lung in this CT, however there are some holes that should probably be filled, and we haven't made any sort of delineation of the finer detail that you can see on the left side.


