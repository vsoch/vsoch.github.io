---
title: "Independent Component Analysis (ICA)"
date: 2013-6-15 19:58:34
tags:
  ica
  independent-component-analysis
  maximum-liklihood
  mla
---


I'm sure that you've heard of the cocktail party problem. The simplest version of the problem posits that you have two people talking in a room with two microphones, each recording a mixed signal of the two voices. The challenge is to take these mixed recordings, and use some computational magic to separate the signals into person 1 and person 2. This is a job for independent components analysis, or ICA.  ICA is only related to PCA in that we start with more complex data and the algorithm finds a more simplified version.  While PCA is based on finding the main "directions" of the data that maximize variance, ICA is based on figuring out a matrix of weights that, when multiplied with independent sources, results in the observed (mixed) data.

Below, I have a PDF handout that explains ICA with monkeys and looms of colorful strings.  I'll also write about it here, giving you two resources for reference!

### What variables are we working with?

To set up the ICA problem, let's say we have:

- x: some observed temporal data (let's say, with N timepoints), each of M observations having a mix of our independent signals.  x is an N by M matrix.
- s: the original independent signals we want to uncover.  s is an N x M matrix.
- A: the "mixing matrix," or a matrix of numbers that, when multiplied with our original data (s), results in the observed data (x). This means that A is an N by N matrix. Specifically,

x=As

### What do the matrices look like?

To illustrate this in the context of some data, here is a visualization of the matrices relevant to functional MRI, which is a 4D dataset consisting of many 3D brain images over time.  Our first matrix takes each 3D image and breaks it into a vector of voxels, or cubes that represent the smallest resolution of the data.  Each 3D image is now represented as a vector of numbers, each number corresponding to a location in space.  We then stack these vectors on top of one another to make the first matrix.  Since the 3D images are acquired from time 0 to N, this means that our first matrix has time in rows, and space across columns.

[![eq1](http://www.vbmis.com/learn/wp-content/uploads/2013/06/eq118.png)](http://www.vbmis.com/learn/wp-content/uploads/2013/06/eq118.png)

The matrix on the far end represents the independent signals, and so each row corresponds to an independent signals, and in the context of using fMRI data, if we take an entire row and re-organize it into a 3D image, we would have a spatial map in the brain.  Let's continue!

### How do we solve for A?

We want to find the matrix in the middle, the mixing matrix.  We can shuffle around some terms and re-write x = A*s as s = A-1*x, or in words, the independent signals are equal to the inverse of the mixing matrix (called the **unmixing matrix**) multiplied by the observed data.  Now let's walk through the ICA algorithm.  We start by modeling the joint distribution (pdf) for all of our independent signals:

[![eq1](http://www.vbmis.com/learn/wp-content/uploads/2013/06/eq119.png)](http://www.vbmis.com/learn/wp-content/uploads/2013/06/eq119.png)

In the above, we are assuming that our training examples are independent of one another.  Well, oh dear, we know in the case of temporal data this likely isn't the case!  With enough training examples (e.g., timepoints), we will actually still be OK, however if we choose to optimize our final function with some iteration through our training examples (e.g., stochastic gradient descent), then it would help to shuffle the order.  Moving on!

Since we already talked about that x (our observed data) = A*s = A-1*s, let's plug this into our distribution above.  We know that s = some vector of weights applied to the observed data, and let's call our un-mixing matrix (A inverse), W.

[![eq1](http://www.vbmis.com/learn/wp-content/uploads/2013/06/eq120.png)](http://www.vbmis.com/learn/wp-content/uploads/2013/06/eq120.png)

we now need to choose a [cumulative distribution function (cdf)](http://en.wikipedia.org/wiki/Cumulative_distribution_function) that represents the density for each independent signal.  We need a CDF that increases monotonically from 0 to 1, so we choose good old sigmoid, which looks like this:

![](http://upload.wikimedia.org/wikipedia/commons/thumb/b/b5/SigmoidFunction.png/400px-SigmoidFunction.png)

Now we should re-shift our focus to the problem above as one of maximum likelihood.  We want to maximize the log likelihood parameterized by our mixing matrix W:

[![eq1](http://www.vbmis.com/learn/wp-content/uploads/2013/06/eq121.png)](http://www.vbmis.com/learn/wp-content/uploads/2013/06/eq121.png)

Remember that the cursive l represents the log likelihood.  The function g represents our Sigmoid, so g prime represents the derivative of Sigmoid, which gets at the rate of change, or the area under the curve (e.g, density).  By taking the log of both sides our product symbol (the capital pi) has transformed into a summation, and we have distributed the log on the right side into the summation.  We are summing over n weights (the number of independent components) for each of m observations.  We are trying to find the weights that maximize this equation.

### Solving for W with stochastic gradient ascent

We can solve the equation above with stochastic gradient ascent, meaning that our update rule for W on each iteration (iterating through the cases, i) is:

[![eq1](http://www.vbmis.com/learn/wp-content/uploads/2013/06/eq122.png)](http://www.vbmis.com/learn/wp-content/uploads/2013/06/eq122.png)

the variable in front of the parentheses is what we will call a **learning rate**, or basically, how big we take a step toward our optimized value after each iteration.  When this algorithm converges, we will have solved for the matrix W, which is just the inverse of A.

### Finally, solve for A

When we have our matrix, A inverse (W), we can "recover" the independent signals simply by calculating:

![s(i) = Wx(i)](http://l.wordpress.com/latex.php?latex=s%28i%29%20%3D%20Wx%28i%29&bg=FFFFFF&fg=470229&s=1 "s(i) = Wx(i)")

Awesome!

 

### <span style="font-size: 1.17em;">Some caveats of ICA:</span>

There is more detail in the PDF, however here I will briefly cover some caveats:

- There is no way to recover any original permutation of the data (e.g., order), however in the case of simply identifying different people or brain network, this largely does not matter.
- We also cannot recover the scaling of the original sources.
- The data must be non-Gaussian
- We are modeling each independent signal with sigmoid because it's reasonable, and we don't have a clue about the real distribution of the data.  If you *do* have a clue, you should modify the algorithm to use this distribution.

 

### Summary

ICA is most definitely a cool method for finding independent signals in mixed temporal data. The data might be audio files with mixtures of voices, brain images with a mixture of functional networks and noise, or financial data with common trends over time.  If you would like a (save-able) rundown of ICA, as explained with monkeys and looms of colorful strings, please see the PDF below.

<iframe class="pdf" frameborder="0" height="990" src="http://docs.google.com/viewer?url=http%3A%2F%2Fwww.vbmis.com%2Flearn%2Fwp-content%2Fuploads%2F2013%2F06%2FIndependent_Component_Analysis.pdf&embedded=true" style="height:990px;width:100%px;border:0" width="100%"></iframe>

<div style="width:100%;height:990;text-align:center;background:#fff;color:#000;margin:0;border:0;padding:0">Unable to display PDF  
[Click here to download](http://www.vbmis.com/learn/wp-content/uploads/2013/06/Independent_Component_Analysis.pdf)</div>
