---
title: "Logistic Regression"
date: 2013-6-20 17:26:35
tags:
  logistic-regression
  machine-learning-2
  newtons-method
  perceptron
  supervised-2
---


Logistic Regression is a supervised learning method for predicting a discrete outcome (y) based on one or more features (x).  If you remember in linear regression we were trying to predict a **continuous** variable, and in logistic regression we are trying to predict a  **discrete** variable.  The problem moves from one of **prediction** to one of **classification**.

Let's start with a simple case where our y can only be 0 or 1, i.e., ![y = {0,1}](http://l.wordpress.com/latex.php?latex=y%20%3D%20%7B0%2C1%7D&bg=FFFFFF&fg=470229&s=1 "y = {0,1}").  If I had a dataset with labels of 0 and 1 and I was looking to build a classifier, I would want my classifier to output a value between 0 and 1 that I could then threshold.  A value of .5, for example, would be an obvious cutoff to indicate indifference between the two classes, however if I were building an ROC curve, I would vary my threshold between 0 and 1 to produce a nice curve that spans the tradeoff between calling everything 0, and calling everything 1.  With this goal, logistic regression chooses to model the hypothesis with a distribution that is nicely, monotonically increasing between 0 and 1.  This distribution is the sigmoid function!

![](http://upload.wikimedia.org/wikipedia/commons/b/b5/SigmoidFunction.png)

Guess what? This is also called the logistic function, and it is defined as follows:

[![eq4](http://www.vbmis.com/learn/wp-content/uploads/2013/06/eq4.png)](http://www.vbmis.com/learn/wp-content/uploads/2013/06/eq4.png)

We can plug in the vector of coefficients multiplied by our x(i) values (this result represents our "prediction") into this function to define our new hypothesis:

[![eq5](http://www.vbmis.com/learn/wp-content/uploads/2013/06/eq5.png)](http://www.vbmis.com/learn/wp-content/uploads/2013/06/eq5.png)

As before, our goal is to now find the parameters that maximize the likelihood of our data, and the likelihood is the probability of the outcomes (y) given the features (X), parameterized by theta.  We re-write that expression in terms of each parameter, specifically we model the overall likelihood as the product of all density functions, the pdfs, for each x(i).  We need to maximize this thing!

[![eq6](http://www.vbmis.com/learn/wp-content/uploads/2013/06/eq6.png)](http://www.vbmis.com/learn/wp-content/uploads/2013/06/eq6.png)

Well, crap.  What in the world is that?  In this case, we need to remember that we have a binary outcome, and so memories of the binomial distribution might be flying into our heads.  Since there are only two outcomes in our sample space, the probability of one outcome is simply 1 - (the other one).  In more concise terms:

[![eq7](http://www.vbmis.com/learn/wp-content/uploads/2013/06/eq7-300x76.png)](http://www.vbmis.com/learn/wp-content/uploads/2013/06/eq7.png)

Above we are defining the probability of y=1 given x as our hypothesis, and then the probability of 0 as... one minus that!   We can write this more compactly as:

[![eq8](http://www.vbmis.com/learn/wp-content/uploads/2013/06/eq8-300x38.png)](http://www.vbmis.com/learn/wp-content/uploads/2013/06/eq8.png)

Try plugging in y = 0 or y = 1 into that equation - you get exactly what we defined for the probabilities of y = 1, and y = 0 in the previous step.  Nice!  Now let's plug this into our Likelihood function:

[![eq9](http://www.vbmis.com/learn/wp-content/uploads/2013/06/eq9-300x66.png)](http://www.vbmis.com/learn/wp-content/uploads/2013/06/eq9.png)

and we need to maximize the above, which again is much easier if we take the log.  It simplifies to this (remember that when taking the log of an exponent, you can move it in front of the log):

[![eq1](http://www.vbmis.com/learn/wp-content/uploads/2013/06/eq12-300x46.png)](http://www.vbmis.com/learn/wp-content/uploads/2013/06/eq12.png)

Again, we want to maximize this log of the likelihood.  Let's take the derivative for just one training example to get our "update rule" if we were doing stochastic gradient descent:

[![eq2](http://www.vbmis.com/learn/wp-content/uploads/2013/06/eq25-300x51.png)](http://www.vbmis.com/learn/wp-content/uploads/2013/06/eq25.png)

 

:O It's exactly the same as the one from [linear regression](http://www.vbmis.com/learn/?p=100#4) (the LMS update rule), but rest assured this is not the same algorithm, because our hypothesis is the sigmoid function... definitely not linear!  So again, if we plug this into a loop and continue until convergence, that is how we find our optimal parameters.

 


## Newton's Method

Fig Newtons?

![](http://foodhistory.pbworks.com/f/1232767512/FigNewtonPackage.gif)

No, sorry... this is the person, Newton.  He came up with a method for finding the minimum of a function that basically finds tangents along a curve, and jumps to where the tangent = 0 to calculate the next tangent.  If you want more (graphical) information, [please consult our friend, wikipedia](https://en.wikipedia.org/wiki/Newton's_method).  There is a nice animation there.  Our update rule becomes:

[![eq2](http://www.vbmis.com/learn/wp-content/uploads/2013/06/eq27.png)](http://www.vbmis.com/learn/wp-content/uploads/2013/06/eq27.png)

If you want a closed form you will need the **Hessian, **or a matrix of second derivatives.  But let's be real, if you want to use this method, [just code it up](http://www.theresearchkitchen.com/archives/642)!   Things make more sense in code than scripty letters.

 


## The Perceptron Learning Algorithm

I should probably write a new post on this, but I want to note that if we change our ![g(z)](http://l.wordpress.com/latex.php?latex=g%28z%29&bg=FFFFFF&fg=470229&s=1 "g(z)") definition from the sigmoid function to:

[![eq2](http://www.vbmis.com/learn/wp-content/uploads/2013/06/eq26.png)](http://www.vbmis.com/learn/wp-content/uploads/2013/06/eq26.png)

and use the same update rule, we get the Perceptron Learning Algorithm.  I think that people used to think that this algorithm modeled how the brain works.  We obviously know that it's not quite that simple.


