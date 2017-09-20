---
title: "Meyer Watershed Segmentation"
date: 2013-7-02 21:56:10
tags:
  meyer-watershed
  segmentation
---


Imagine that the pixel intensities of an image form a landscape, with lower values (closer to zero, corresponding to black) forming valleys, and higher values (closer to 1, white) forming mountains.  Our image isn't an image, in fact, it is a beautiful landscape!  **Meyer Watershed** segmentation is a segmentation algorithm that treats our image like a landscape, and segments it by finding the very bottom of the valleys (the basins, or the watersheds - has anyone actually ever seen a real watershed?) and filling them up.  When we fill up these basins without allowing for any overlap, each unique basin becomes an image region, and so we have segmented the image.

**How does the algorithm work?**

Here we have our image, which remember, we are thinking about like a landscape.  This image is a good choice because it looks like an actual landscape:

[![wat1](http://www.vbmis.com/learn/wp-content/uploads/2013/07/wat1.gif)](http://www.vbmis.com/learn/wp-content/uploads/2013/07/wat1.gif)

Most images that have color aren't going to work well off the bat, because there are three color channels.  What we want is to have the image in grayscale (with one color channel) and then we we would want to look at the gradient, or the change in the values.  The gradient (derivative) is going to tell us the "steepness" of our landscape.  We will get something that is high value along the edges (white), and low values where it is black.  For example, here is the gradient to describe the image above:

[![wat2](http://www.vbmis.com/learn/wp-content/uploads/2013/07/wat2.gif)](http://www.vbmis.com/learn/wp-content/uploads/2013/07/wat2.gif)

As stated previously, we are interested in finding the local minimum values of this image, which correspond to the bottom of the basins.  The darker values (closer to 0) correspond to the minima, and so from looking at this image, we would guess that there is a local minima within each white circle, as well as one or two around the outside.  We are then going to fill each basin until we reach the top of the basin.  Specifically, here is the algorithm:

<div>1. Choose starting markers (bin bottoms)
2. Insert neighboring pixels of each marked area into a priority queue
3. The pixel with the highest priority level is extracted from the priority queue. If the neighbors of the extracted pixel that have already been labeled all have the same label, then the pixel is labeled with their label. All non-marked neighbors that are not yet in the priority queue are put into the priority queue.
4. Redo step 3 until the priority queue is empty

</div>Non labeled pixels are water shed lines.

Generally, watershed tends to over-segment things.  However, it's a good starting point for segmentation, because you can over-segment an image to create "superpixels" and then use another algorithm to intelligently group the superpixels into larger regions.

As a fun example. here is an example of a Meyer Watershed segmentation from a class section that I was TA for.  Each colored blob corresponds to a different region.  I didn't work very hard to optimize anything, however you will generally observe that images with more well defined edges (the basin edges corresponding to values closer to 1 in the gradient image) are well defined (such as the stripes on a shirt, or glasses):

[![watershed](http://www.vbmis.com/learn/wp-content/uploads/2013/07/watershed.jpg)](http://www.vbmis.com/learn/wp-content/uploads/2013/07/watershed.jpg)

[Matlab has a watershed function](http://www.mathworks.com/help/images/examples/marker-controlled-watershed-segmentation.html), although for the images above I used a different script.


