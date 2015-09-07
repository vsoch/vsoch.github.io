---
title: "Image Registration"
date: 2013-6-27 18:15:10
tags:
  linear
  non-linear
  nonlinear
  registration
  rigid
---


When we talk about **registration,**** **we are talking about a transform of one image into another image's space by way of transforms.  What does this mean exactly? If each image is a matrix of numbers, the "transform" is another matrix that we can multiply our image-1 numbers by in order for it to line up nicely with image-2.  There are two kinds of registration: linear and non-linear, and the best way to explain the difference is with a putty metaphor.  Let's say that someone hands me a small box, and asks me to fit a series of Tetris pieces nicely into the bottom.  I create my Tetris pieces out of clay, bake them in the oven, and try to fit them into the box.  I can flip them, move them up, down, left, right, or rotate them.  This is akin to a **linear** or a **rigid registration.**  I can make a lot of movements, but I'm limited to translation, rotation, and flipping.

Frustrated that I can't get it to work, I decide to be sneaky.  I recreate my Tetris pieces out of clay, but I don't bake them this time.  I put them in the box in a formation that *almost* fits, and then I proceed to stretch one piece to double it's width, fold a straight piece into an L, and squeeze one piece to take up less space.  Ta-da!  Task accomplished!  This is an example of a **non-linear** **registration,** and if I were to write down the exact manipulations that I did, that would be equivalent to saving a translation matrix.**  **It's useful to save this matrix in the case that you want to apply your registration to other images.

### **When do I want linear vs non-linear registration?**

Generally, we only want non-linear registration if we need to warp the shape or size of our data.  For linear, we basically want to define an affine transformation matrix that maps one image to the other.  I wrote up this handout to explain this matrix:

<iframe class="pdf" frameborder="0" height="990" src="http://docs.google.com/viewer?url=http%3A%2F%2Fwww.vbmis.com%2Flearn%2Fwp-content%2Fuploads%2F2013%2F06%2FAffine_Registration.pdf&embedded=true" style="height:990px;width:100%px;border:0" width="100%"></iframe>

<div style="width:100%;height:990;text-align:center;background:#fff;color:#000;margin:0;border:0;padding:0">Unable to display PDF  
[Click here to download](http://www.vbmis.com/learn/wp-content/uploads/2013/06/Affine_Registration.pdf)</div>What is not explained in this handout is exactly how we solve for the matrix, A.  We use the idea of mutual information, or maximizing the probability of both images.  We want to use mutual information instead of something like least squares because with different modalities, the intensities may not be in the same scale.  A very good description of the method is included in this paper (bottom of page 4):

<iframe class="pdf" frameborder="0" height="990" src="http://docs.google.com/viewer?url=http%3A%2F%2Fwww.vbmis.com%2Flearn%2Fwp-content%2Fuploads%2F2013%2F06%2FMedical-image-registration-using-mutual-information.pdf&embedded=true" style="height:990px;width:100%px;border:0" width="100%"></iframe>

<div style="width:100%;height:990;text-align:center;background:#fff;color:#000;margin:0;border:0;padding:0">Unable to display PDF  
[Click here to download](http://www.vbmis.com/learn/wp-content/uploads/2013/06/Medical-image-registration-using-mutual-information.pdf)</div> 


