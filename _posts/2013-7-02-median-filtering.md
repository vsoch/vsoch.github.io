---
title: "Median Filtering"
date: 2013-7-02 21:28:59
tags:
  filter
  filtering-2
  median-filter
  noise
  salt-and-pepper-noise
---


**Median filtering** is another filtering technique similar to [convolution](http://www.vbmis.com/learn/?p=70 "Convolution") in that we define a small window ( an nxn square smaller than our image) to move across it, and based on the pixels that fall within that window, we define a new pixel value in the filtered image.  For example,  here we have a window of size 3X3 that we will move across our image:

[![med1](http://www.vbmis.com/learn/wp-content/uploads/2013/07/med1.png)](http://www.vbmis.com/learn/wp-content/uploads/2013/07/med1.png)

In median filtering, it's a super simple algorithm.  We set the new image pixel to be the median value of the pixels that fall within our yellow window.  What does this mean for what the filter does?  It means that if we have outlier pixels (extremely high or low values that will make the image look speckled, often called **salt and pepper noise**), we get rid of those nicely.  For example. here is a before and after shot of an image with salt and pepper noise that has been median filtered:

[![med1](http://www.vbmis.com/learn/wp-content/uploads/2013/07/med11.png)](http://www.vbmis.com/learn/wp-content/uploads/2013/07/med11.png)

This is a huge improvement!  Hooray for simple algorithms that work well.

 


