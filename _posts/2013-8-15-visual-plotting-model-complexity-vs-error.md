---
title: "Visual: Plotting Model Complexity vs. Error"
date: 2013-8-15 17:34:22
tags:
  bias
  complexity
  error
  knn
  variance
  visual
---


I recently purchased the new [Elements of Statistical Learning (with Applications in R)](http://www.amazon.com/Introduction-Statistical-Learning-Applications-Statistics/dp/1461471370) by Witten, Hastie, Tibshirani, and James, and am completely taken with the beautiful plots in this book.  Of course I won't redistribute my copy, and I'm not sure if I'm allowed to do this, but I want to write short "Visual" posts that show and explain a plot.  I'm a very visual learner, so these have been very helpful for me.

### Plotting Model Complexity vs Error - KNN

When we talk about the complexity of a model, we might be getting at the number of indicator variables (our x's) used to build the model, such as with linear regression.  A higher number == more complex model, and the complexity of the model has a lot to say about generalizability error, or how well our model performs when extended to other data.  We reviewed the idea of the mean squared error being represented as a sum of squared [bias and variance](http://www.vbmis.com/learn/?p=127 "Bias and Variance Tradeoff"), and generally when a model is very complex (low bias and high variance) this could lead to overfitting (high test error, low training error), represented by this plot:

[![800px-Overfitting](http://www.vbmis.com/learn/wp-content/uploads/2013/06/800px-Overfitting-785x578.png)](http://www.vbmis.com/learn/wp-content/uploads/2013/06/800px-Overfitting.png)

Error is on y, and complexity on x.  When we go past the "sweet spot" we are overfitting  because test error starts to go up as training goes down.  It wasn't completely clear to me how I could think about model complexity with regard to knn, until I found this beautiful plot:

[![knn_error](http://www.vbmis.com/learn/wp-content/uploads/2013/08/knn_error1.png)](http://www.vbmis.com/learn/wp-content/uploads/2013/08/knn_error1.png)

Why of course! We model the complexity of KNN with 1/K.  This means that when K=1 (far right side), our model is going to perform very well on training data (blue line), and not so well with different test data (orange line).  We are overfitting, and likely have low error due to bias and high error due to variance.  On the other hand, when K is very large (left side of plot), we don't do well in either case.  You can imagine the extreme case when K = size of data, we just have a "majority rules" classifier that assigns the majority class to everyone.  This means that we have high error due to bias (a bad model!) and low error due to variance (because when we change our data, the predictions don't change much.)


