---
title: "Convolution"
date: 2013-7-02 21:08:30
tags:
  convolution
  filtering
  fspectial
---


I remember in my first image processing course, the instructors threw around the term **convolution **like flying [latkes in this video](http://www.youtube.com/watch?v=qSJCSR4MuhU).  It definitely happens a lot when you are new to a field that people (professors) make assumptions about the jargon of the students.  To counter that phenomena, I am going to tell you about convolution in this post.

**What is Convolution?**

Convolution is really just a fancy term for filtering an image.  The basic idea is that we choose some filter (we call this our **kernel****)**, a matrix of numbers smaller than the actual image, and we move through each pixel in the image and "apply" that filter.  As we apply the filter to each pixel, we output new pixel values that encompass an entirely new (filtered) image.  What does "applying" the filter mean?  To help illustrate this, I've stolen a few slides from one of my course instructors.

Here we have our kernel (the red box) and our input image (left) and output image (right)

[![c1](http://www.vbmis.com/learn/wp-content/uploads/2013/07/c1.png)](http://www.vbmis.com/learn/wp-content/uploads/2013/07/c1.png)

We place the kernel over the image, with the center of the kernel on the first pixel.  To calculate the value for our new image, we multiply each pixel in the kernel by the value underneath it, and sum all of those values.  The summed value goes in the same box of our new image (green).

[![c2](http://www.vbmis.com/learn/wp-content/uploads/2013/07/c2.png)](http://www.vbmis.com/learn/wp-content/uploads/2013/07/c2.png)

We then move the kernel across the image, and calculate our new values one at a time until we have gone across the entire image.  This process is what we call **convolution**.

[![c3](http://www.vbmis.com/learn/wp-content/uploads/2013/07/c3.png)](http://www.vbmis.com/learn/wp-content/uploads/2013/07/c3.png)

 

As you can see from the illustration above, when we are at the top, left, right, and bottom edges, our kernel is going to overlap into empty space.  For this reason, you will commonly need to pad your image with zeros.  You can do this manually in Matlab, or use the function [padarray](http://www.mathworks.com/help/images/ref/padarray.html).

As you might guess, the choice of your kernel (the filter, or matrix of numbers you move across the image) has implications for the kind of filter that results.  If you apply a Gaussian kernel (meaning that the matrix of numbers follows a Gaussian distribution) this will work to blur the image.  Matlab, in all of its awesomeness, has a function called[ fspecial](http://www.mathworks.com/help/images/ref/fspecial.html) that will let you create customized 2D filters, including Gaussian.

**What is the algorithm for convolution?**

It is pretty simple.  If you walk through the pseudo-code below, it is basically the process that I just explained:

[![conv1](http://www.vbmis.com/learn/wp-content/uploads/2013/07/conv1.png)](http://www.vbmis.com/learn/wp-content/uploads/2013/07/conv1.png)


