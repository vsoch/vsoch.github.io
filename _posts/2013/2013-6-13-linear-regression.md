---
title: "Linear Regression"
date: 2013-6-13 17:50:15
tags:
  linear
  machine-learning
  regression
  supervised
---


[What is Linear Regression?](#7)  
[What does a dataset look like?](#1)  
[How do we fit a model?](#2)  
[Batch Gradient Descent](#3)  
[Stochastic Gradient Descent](#4)  
[The Normal Equations](#5)  
[Summary](#6)

### What is Linear Regression?

Linear regression is modeling some linear relationship between a dependent variable, y, and an explanatory variable, x.  We call it a "regression" because our y variables are continuous.  If we were trying to predict a binary outcome we would call it **classification**, but more on that later.  When we have just one relationship this is called **simple linear regression**, and more than one is **multiple linear regression, **each relationship modeled by the equation:

 >> y = mx + b

With more than one explanatory variable, each coefficient is represented with beta (**b**) , and **e** is some error, or what cannot be explained by the model.

 >> y = b1x1 + b2x2 +...+ bnxn + e

This equation is commonly called our **hypothesis** for how the different predictors or features (x) predict the outcome (y), and we can rewrite the equation as "h as a function of x":

  >> h(x) = b1x1 + b2x2 +...+ bnxn + e

We like to use matrices to make computation more efficient, and so typically we write this as a XTB, where X is a vector of explanatory variables, and B is a vector of coefficients.  The errors are captured by a vector represented with the **e **term.  Note that this equation is just representing one outcome (y) with one set of features (x's).

You can imagine plotting one dependent (y) against one explanatory variable (x), and if there is truly a linear relationship, we might see something like this:

[![](http://upload.wikimedia.org/wikipedia/commons/thumb/3/3a/Linear_regression.svg/500px-Linear_regression.svg.png)](http://upload.wikimedia.org/wikipedia/commons/thumb/3/3a/Linear_regression.svg/500px-Linear_regression.svg.png)Simple linear regression with one independent variable

### What does a dataset look like?

The equation above models just one y and a set of x.  An entire dataset consists of many y variables each paired with a set of x's and an error term, and our goal is to find a set of betas (the coefficients) that best fit all of the data.  

### How do we fit a model?

We use the **least squares approach**.  Let's look at the picture above.  We can draw a line from each blue point to the red line.  This represents the distance (error) for each point, or in other words, how off it is from our model (the red line).  If we calculate all these distances, square each one to do away with possible negative, and then add them up, we get the **sum of the squared error**, also called the **residuals**.  This number represents how well our model fits the data.  If every blue point falls on the red line, this number is 0.  Larger numbers mean that our data does not fit the model as well.  This metric is going to allow us to figure out the best fit model for any set of points - we want to find the values of beta (the coefficients) that minimize this least squared error.  This equation that represents the goodness of fit of a model is called a **cost function**.  If we minimize the cost function, then we find the best model to fit the data.  


## Batch Gradient Descent

#### 1) Write an equation that represents the sum of the squared errors, the least squares cost function:

[![eq2](http://www.vbmis.com/learn/wp-content/uploads/2013/06/eq22-300x73.png)](http://www.vbmis.com/learn/wp-content/uploads/2013/06/eq22.png)

In this case, we are summing from 1 to m, where m is the number of cases we have in our dataset, each with one outcome variable (y) and a set of (x).  This equation represents exactly what we discussed above - h(x) is our model's prediction of the outcome based on the features, y(i) is the real outcome, and so h(x) is the difference between the actual and observed outcome, our error, which we square, and then sum up for all of our m data points.  This equation gives rise to the **ordinary least squares regression model.**

#### 2) Minimize the least squares cost function:

****To find the set of betas that best fit out data, we should aim to minimize the cost function.  We can do this with **batch gradient descent**, where we will randomly initialize our beta values, and then "take a step" in the steepest direction to find a minimum.  This means that we are interested in the rate of change of the function, so we are going to want to take the derivative.  We will basically take steps and update our beta values each time until we decide to stop taking steps.  If we took the derivative for just one training case, we would get the following update rule:

[![eq2](http://www.vbmis.com/learn/wp-content/uploads/2013/06/eq23-300x47.png)](http://www.vbmis.com/learn/wp-content/uploads/2013/06/eq23.png)

where **a** is alpha, the **learning rate, **or how big a step we want to take.  And this has a particular name that you will never remember, but I'll share anyway: the **Least Mean Squares **or **Widroff-Hoff **update rule.  Remember that the subtraction in the parentheses represents how far off our prediction is from the actual value.  If this value turns out to be small, that means that our parameters don't change so much.  If it's large, they do!  To extend this equation to batch gradient descent, we would do:

**Repeat until convergence, for every training example, j

[![eq2](http://www.vbmis.com/learn/wp-content/uploads/2013/06/eq24-300x39.png)](http://www.vbmis.com/learn/wp-content/uploads/2013/06/eq24.png)
 

Convergence might mean that the parameters stop changing, or a certain number of iterations have occurred, or some other logical criteria.  And wait a minute, isn't that a quadratic function? Yes! This means that we always converge to a global minima.  The final model is the coefficients that we converge to, woohoo we are done!



## **Stochastic Gradient Descent**

Guess what? We don't necessarily have to look at every training example before "taking a step."  What if we have a HUGE dataset, and looking at every training example is infeasible?  We can use stochastic gradient descent!  It's almost exactly the same, except we update J(x) after looking at each of the m training examples.  The new update equation becomes:

```
for i=1:m {

xj = xj + a (h(x)i) - y(x)i)^2 * xj

}
```

This will let us hop around the hypothesis space much faster, although we may never completely converge (although we are usually very close).


## The Normal Equations

Linear algebra gives me shivers, but it's worth mentioning that there is a much more efficient way to solve this problem: a closed form.  We can represent our data and unsolved regression coefficients in matrices, and then just solve a matrix form equation to find the values of our betas that minimize the least squared error.  While I'm sure you would enjoy me coughing through the linear algebra derivation, I'm just going to give it to you, because like I said... *shivers!*  Welcome to the 21st century when you can plug this equation into a computer (Matlab, anyone?) and not need to write it out on paper.

X = (XTX)^(-1)XTy

where X is our matrix of features (the transpose is like squaring it), y is the vector of observed outcomes (remember this is supervised learning so we have labels!)  If you want the lovely derivation, I suggest you take CS229 Machine Learning.  :)  You can plug that into Matlab and get the answer with one line, no looping needed!  That is pretty awesome.


## Summary

We've learned how to create a model using a dataset with outcomes (y), each associated with features (x) for which the relationship is linear.  All that we did is find the coefficients that minimize the sum of the squares,or the error.  However, before trying to fit any models, I can't stress enough the value of **looking at your data**.  You can use almost any software to plot y against different x, and if there is a linear relationship, you will see it!  You can also get a sense of if there are outliers in your data, and if another model might be a better fit.
