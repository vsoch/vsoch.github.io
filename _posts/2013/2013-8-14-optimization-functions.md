---
title: "Optimization Functions"
date: 2013-8-14 19:14:04
tags:
  
---


I wanted to compile a nice list of (general) optimization functions for different algorithms, mostly so I don't need to look them up one by one.  If an optimization method isn't appropriate, I'll summarize how you make a classification.  I will provide each function, as well as description, if appropriate:

### Linear Regression

With linear regression, we aim to minimize the sum of squared error between our data and a linear equation (a line, our model). Specifically, we want to find the parameters, theta, that minimize this function (this is "ordinary least squares":

[![eq1](http://www.vbmis.com/learn/wp-content/uploads/2013/06/eq11.png)](http://www.vbmis.com/learn/wp-content/uploads/2013/06/eq11.png)  
 We could do this with coordinate descent, however there is a closed form solution for this optimization:

![\hat{\beta}=(X^{T}X)^{-1}X^{T}y](http://l.wordpress.com/latex.php?latex=%5Chat%7B%5Cbeta%7D%3D%28X%5E%7BT%7DX%29%5E%7B-1%7DX%5E%7BT%7Dy&bg=FFFFFF&fg=470229&s=1 "\hat{\beta}=(X^{T}X)^{-1}X^{T}y")

The values of the optimal betas give us clues to how much of each feature, x, is used to determine the class.  The sign (+/-) of the beta value also hints at the relationship - a positive beta means that increasing the feature, x, increases our y, and a negative value means that they have an inverse relationship.  We can also assess if a beta is significant by calculating a p-value for how different it is from the null hypothesis (that the value == 0), i.e, think of a normal distribution of beta values, and if the value you obtained is in the tails (the .025 of values on the far left, or .025 of values to the far right) then it is significant, meaning that your beta value is unlikely to be due to chance.  Standard packages in R (lm) will automatically spit out these values for you.

### Ridge Regression

When we place the L2 penalty on our betas (a), the result is ridge regression, and we want to find the values of a that minimize the following equation (subject to the penalty):

[![ridge](http://www.vbmis.com/learn/wp-content/uploads/2013/08/ridge.png)](http://www.vbmis.com/learn/wp-content/uploads/2013/08/ridge.png)

Obviously as our fudge parameter, lambda, goes to zero, we just get ordinary least squares.  Also remember that if we use the L1 penalty instead, (the absolute value of the summed parameters) we get [lasso](http://en.wikipedia.org/wiki/Lasso_regression#Lasso_method), and if we are totally undecided about which one to use, we can use [elastic net](http://www.vbmis.com/learn/?p=372 "Elastic Net: Flexible Regularization for Linear Regression") and move our parameter alpha between 0 (ridge regression) and 1( lasso).  Broadly, I think of lasso, ridge regression, and elastic net as regularization strategies that can be used with standard regression.

### Locally Weighted Linear Regression

When we have data with a non-linear distribution, we can take a non-parametric approach and use locally weighted linear regression:

[![eq2](http://www.vbmis.com/learn/wp-content/uploads/2013/06/eq21.png)](http://www.vbmis.com/learn/wp-content/uploads/2013/06/eq21.png)

The equation is the same, except now we are multiplying by a vector of weights, w, that place high weight on the points closest to our training example.  This means that we are looking at local neighborhoods of our data, and building a model for each local neighborhood.  This is obviously computationally intensive, and does not give us a nice "final equation" for our model.  We have to keep the data around (akin to knn) to make a classification.

The weight function takes into account a tuning parameter (the "bandwidth") that specifies how big the step should be between neighborhoods.  If we choose to build a model at every data point (a small bandwidth), you can imagine that we would estimate our function very well, however there is probably some overfitting going on.  It would be better to increase the bandwidth to get an abstraction of the data, but not make it so big that we lose the general shape of our non-linear distribution (e.g., you can imagine if you choose the "neighborhood" to be the entire dataset, you are essentially just fitting a linear model to your data).

### Naive Bayes

Naive Bayes assumes independence of features, and allows us to figure out the probability of a particular class (y) given the features by looking at the probability of the features given the class:

[![eq2](http://www.vbmis.com/learn/wp-content/uploads/2013/06/eq28.png)](http://www.vbmis.com/learn/wp-content/uploads/2013/06/eq28.png)

We use our data to calculate the priors (the probability of a class being == 1, and the overall p(x), calculate this probability for each of our classes (0 and 1 in a simple example), and then just assign the class with the higher probability.

### SVM with regularization

We want to build our model by finding the non-zero parameters that form our supporting vectors.  We solve for our parameters by maximizing the following equation:

[![ridge](http://www.vbmis.com/learn/wp-content/uploads/2013/08/ridge1.png)](http://www.vbmis.com/learn/wp-content/uploads/2013/08/ridge1.png)

The above is the SVM optimization with regularization, meaning that we are additionally imposing an L1 penalty on our parameters (C is akin to lambda), and it simplifies to be exactly the same as without the regularization, but the parameters also have to be less than or equal to some C.  We can solve for the optimal parameters by way of the [SMO Algorithm](http://en.wikipedia.org/wiki/Sequential_minimal_optimization).

### Logistic Regression

Logistic regression models the probability that a class (our Y) belongs to one of two categories.  This is done by using the [sigmoid function](http://en.wikipedia.org/wiki/Sigmoid_function), which increases nicely between 0 and 1, giving us a nice probabilistic value.  This is our hypothesis (h(x)), and it's also called the "logistic function."  This is the log likelihood equation that we want to maximize, and we could do this similarly to linear regression with gradient descent (e.g., take the derivative of the function below with respect to the parameters, plug into the update rule, cycle through your training examples and update each one until convergence):

[![eq1](http://www.vbmis.com/learn/wp-content/uploads/2013/06/eq12.png)](http://www.vbmis.com/learn/wp-content/uploads/2013/06/eq12.png)

We could also use maximum likelihood estimation, meaning that we would model the P(Y|X,parameters), and then take the derivative with respect to the parameters, and then set the derivative equal to zero and solve.  You would want to check the second derivative to make sure that you have a maximum.  Either way we come out with optimal parameters, which we can plug back into the sigmoid function to make a prediction.

### Gaussian Discriminant Analysis (GDA,LDA,QDA)

GDA hypothesizes that we have some number of classes, and each is some form of a multivariate Gaussian distribution.  Our goal is to model the probability of each class, and then like with Naive Bayes, we assign the one for which the probability is larger.  The parameters that we need to find to define our distributions are a mean and covariance matrix.  GDA describes the technique, generally, and linear discriminant analysis says that we have a shared convariance matrix for all the classes, and quadratic discriminant analysis says that each class has its own.  We basically model each class with the GDA equation, and then take the derivative with respect to each parameter, and set it equal to zero to solve for the parameter (eg, the mean, the covariance matrix, and coeffcients).  Then we can make a prediction by plugging a set of features (X) into each equation, getting a P(X|Y=class) for each class, and then assigning the class with the largest probability.  Here are the final equations for each parameter after we took the derivative, set it == 0, and solved for the parameter:

[![Screenshot at 2013-06-27 13:35:32](http://www.vbmis.com/learn/wp-content/uploads/2013/06/Screenshot-at-2013-06-27-133532.png)](http://www.vbmis.com/learn/wp-content/uploads/2013/06/Screenshot-at-2013-06-27-133532.png)

### Independent Component Analysis (ICA)

With ICA we model our observed data as a matrix of weights multiplied by a matrix of "true" signals, which implies that the observed data is some linear combination of these original signals.   We assume independence of our signals, and so we model them with some function that "gets at" independence, e.g., kurtosis, entropy, or neg-entropy, and then we maximize this value.  We could also model the distribution of each component with sigmoid (increasing between 0 and 1), multiply to get the likelihood function, then take the log to get the log likelihood, and then take the derivative to get a stochastic gradient descent rule, and update the matrix of weights until convergence.  The equation for the log of the likelihood is as follows:

[![eq1](http://www.vbmis.com/learn/wp-content/uploads/2013/06/eq121.png)](http://www.vbmis.com/learn/wp-content/uploads/2013/06/eq121.png)

And then the update rule for stochastic gradient descent would be:

[![eq1](http://www.vbmis.com/learn/wp-content/uploads/2013/06/eq122.png)](http://www.vbmis.com/learn/wp-content/uploads/2013/06/eq122.png)

### Principal Component Analysis

With PCA we want to decompose our data based on maximizing the variance of our projections.  We model this by summing the distance from the origin to each point, and then dividing by the number of points (m) to get an average.  We then factor our distance calculation (L2 norm in the first equation), and we see that this simplifies to the principal eigenvector of the data multiplied by the covariance matrix (in parentheses, third term).  This means that PCA comes down to doing an eigenvalue decomposition (factorization) of the data.

[![eq1](http://www.vbmis.com/learn/wp-content/uploads/2013/07/eq18.png)](http://www.vbmis.com/learn/wp-content/uploads/2013/07/eq18.png)

and then once we solve for the eigenvalues (u), we project our data back onto them to get the new representation:

[![eq1](http://www.vbmis.com/learn/wp-content/uploads/2013/07/eq19.png)](http://www.vbmis.com/learn/wp-content/uploads/2013/07/eq19.png)

### Archetypal Analysis

We start with the same model as ICA, except we don't assume independence of signals, so we just model our data (X) as a linear combination (W) of some set of archetypes (H), so X = WH.  We also model the archetypes (H) as some linear combination (B) of the original data (X), so H = BX.  We then would obviously want X - WH to be equal to zero, and also by substituting in BX for H we get the equations that we want to minimize:

[![eq1](http://www.vbmis.com/learn/wp-content/uploads/2013/07/eq134.png)](http://www.vbmis.com/learn/wp-content/uploads/2013/07/eq134.png)

We would minimize this function in an alternating fashion.

### Non negative matrix factorization

Again, is the same basic model as ICA and Archetypal (above), however we model each resulting component with poisson, and then we can maximize the likelihood or minimize the the log of the likelihood:

[![eq1](http://www.vbmis.com/learn/wp-content/uploads/2013/07/eq130.png)](http://www.vbmis.com/learn/wp-content/uploads/2013/07/eq130.png)
