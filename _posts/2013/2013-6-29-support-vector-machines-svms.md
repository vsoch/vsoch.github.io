---
title: "Support Vector Machines (SVMs)"
date: 2013-6-29 18:45:05
tags:
  functional-margin
  geometric-margin
  kernel
  machine-learning
  supervised
  svm
---


**Support Vector Machines (SVMs) **are supervised machine learning classifiers based on the idea that if we plot our data in some n dimensional space, we can draw a **separating hyperplane** between the classes.  Based on this description alone, you will guess correctly that SVMs are appropriate for distinguishing two binary classes.  You might also guess that a metric that we will use to construct our model is calculating the distance of the points on either side of the hyperplane to the hyperplane itself.  For any set of datapoints with appropriate labels {-1,1}, our "best" hyperplane drawn to separate the points will maximize this distance.

### Parameters to Describe a SVM

We define our classifier with parameters w, and b:

[![eq1](http://www.vbmis.com/learn/wp-content/uploads/2013/06/eq16.png)](http://www.vbmis.com/learn/wp-content/uploads/2013/06/eq16.png)

If the stuff inside the parentheses (g(stuff)) is greater than or equal to zero, then we spit out a class of 1, and say that the class is -1 otherwise.

### The Functional Margin... gives us confidence in our SVM?

To define the **functional margin** of our classifier, we would look at all of the distances between each point and our separating hyperplane, and choose the smallest one.  For any one point (x,y), we define the functional margin as:

[![eq1](http://www.vbmis.com/learn/wp-content/uploads/2013/06/eq17.png)](http://www.vbmis.com/learn/wp-content/uploads/2013/06/eq17.png)

If our class label is 1, to be correct in our prediction we want this value to be a large positive number.  If our class label is -1, a correct prediction coincides with a large negative number.  However, do you see a problem with using the functional margin as a measure of confidence in how well our classifier predicts a class label?

### The *Geometric Margin* Gives Us Confidence in our SVM!

The problem with using the functional margin for evaluation is that if we were to change the scaling of our parameters w or  b, we would also make the output value much larger, or much smaller, but there is fact would be no change to the classifier itself.  What we need to do is somehow normalize this calculation, and this is where the geometric margin comes in.  The **geometric margin** is exactly the same as the functional, but we divide by the norm of the vectors w and b, so any change in scaling doesn't influence the resulting value.  And equivalently, the smallest geometric margin across all points is our final value.

[![eq1](http://www.vbmis.com/learn/wp-content/uploads/2013/06/eq18.png)](http://www.vbmis.com/learn/wp-content/uploads/2013/06/eq18.png)

### How do we build an optimal margin classifier?

Given that we have a metric that represents the goodness of a decision boundary for our classifier, you might have guessed correctly that we will try to maximize this boundary to build our classifier.  The problem is now set up as:

[![eq1](http://www.vbmis.com/learn/wp-content/uploads/2013/06/eq19.png)](http://www.vbmis.com/learn/wp-content/uploads/2013/06/eq19.png)

We are now faced with the problem that the functional margin divided by the norm of the vector w (the first line) is a non convex problem.  This means that it doesn't look like a nice parabola that we could crawl along and eventually end up at a nice maximum value.  To deal with this, we are going to take advantage of the fact that we can change the scaling of both w and b without influencing the final calculating of the geometric margin.  We are going to make it required that the functional margin (y hat) is equal to 1, and so since maximizing the above is equivalent to minimizing it's inverse, the new problem becomes:

[![eq1](http://www.vbmis.com/learn/wp-content/uploads/2013/06/eq110.png)](http://www.vbmis.com/learn/wp-content/uploads/2013/06/eq110.png)

the solution being... the **optimal margin classifier!  **This means that, for****any particular training example (m), we are subject to the following constraint (I just subtracted the 1 from the right side in the second line above)

[![eq1](http://www.vbmis.com/learn/wp-content/uploads/2013/06/eq111.png)](http://www.vbmis.com/learn/wp-content/uploads/2013/06/eq111.png)

Remember that our separating hyperplane is going to be defined by the closest points on either side to it.  This is where the name "support vector machine" comes from - these points are called the **support vectors**, because their functional margin is exactly equal to 1, or for the equation above, g(w) = 0.  These "support vectors" are illustrated in the image below.  Can you see that they are the only points to actually define the separating hyperplane?  Technically, we don't care so much about the rest of the points.

![The "support vectors" are where the functional margin is equal to 1, or g(w) = 0.  These are the points that ultimately determine our optimal separating hyperplane.](http://www.vbmis.com/learn/wp-content/uploads/2013/06/eq112.png)](http://www.vbmis.com/learn/wp-content/uploads/2013/06/eq112.png)The "support vectors" are where the functional margin is equal to 1, or g(w) = 0. These are the points that ultimately determine our optimal separating hyperplane.

In our optimization problem, we are only going to care about these three points.  Here is where it gets a little tricky, and I'll do my best to explain.  Honestly, I never understood this very well, and so I'll state it point blank, and if you want proofs, you can find them on your own.  When we have some optimization problem subject to constraints (as we do here), the [Lagrange Dual Function](http://en.wikipedia.org/wiki/Duality_%28optimization%29) gives lower bounds on the optimal value of the original function (insert hand waving here).  So to solve for our SVM, we construct a Lagrangian as follows:

[![eq1](http://www.vbmis.com/learn/wp-content/uploads/2013/06/eq113.png)](http://www.vbmis.com/learn/wp-content/uploads/2013/06/eq113.png)

and then we find the dual form of the problem by minimizing the above with respect to w and b, and remembering that alpha > 0  (Insert a ridiculous amount of hand waving here). We now have the dual optimization problem:

 

[![eq1](http://www.vbmis.com/learn/wp-content/uploads/2013/06/eq114.png)](http://www.vbmis.com/learn/wp-content/uploads/2013/06/eq114.png)

and the goal is to find the alphas that maximize the equation.  The x's in the bent parentheses represent a [**kernel**](http://en.wikipedia.org/wiki/Kernel_methods), which is ****a function that maps your data to a higher dimensional space, the idea being if the data aren't linearly separable, when we map them to an infinite dimensional space, they can be.

An example algorithm to solve the dual problem is called **Sequential Minimal Optimization (SMO).  **Broadly, this algorithm iterates through each training example (1 through m), and holds all parameters alpha except for the current training example constant, and the equation W alpha is optimized with respect to that training example parameter.  We keep going until convergence.  This method is called **coordinate ascent.**  For the SVM, we would do the following:

Going until Convergence {

1. Pick an alpha_x and alpha_y with some heuristic
2. Reoptimize W alpha with respect to those two, and all other parameters are held constant.

}

That is probably the limit of my understanding of SVMs.  I recommend reading [Matlab documentation](http://www.mathworks.com/help/stats/support-vector-machines-svm.html) if you want a more satisfactory explanation.  If you are using SVMs, it's pretty trivial to train and test with [Matlab](http://www.mathworks.com/help/stats/svmtrain.html) or [R](http://rss.acs.unt.edu/Rdoc/library/kernlab/html/ksvm.html) functions, and you would want to try different kernels to get a sense for which works best with your data.
