---
title: "Maximum Likelihood Estimation (MLE)"
date: 2013-6-17 21:30:00
tags:
  maximum-likelihood
  mle
  supervised-2
---


**Maximum Likelihood Estimation** is a technique that we use to estimate the parameters for some statistical model.  For example, let's say that we have a truckload of oatmeal raisin cookies, and we think that we can predict the number of raisins in each cookie based on features about the cookies, such as size, weight, etc.  Further, we think that the sizes and weights can all be modeled by the normal distribution.  To define our cookie model, we would need to know the parameters, the mean(s) and the variance(s), which means that we need to count the raisins in each cookie, measure them, weigh them, right?  That sure would take a long time!  But we have a group of hungry students, and each student is willing to count raisins, measure and weigh one cookie, ultimately producing these features for a sample of the cookie population.  Could that be enough information to at least guess the mean(s) and standard deviation(s) for the entire truckload?  Yup!

### What do we need to estimate parameters with MLE?

The big picture idea behind this method is that we are going to choose the parameters based on maximizing the likelihood of our sample data, based on the assumption that the number of raisins, height, weight, etc. is normally distributed.  Let's review what we need in order to make this work:

- <span style="line-height: 13px;">A **hypothesis** about the **distribution**.  Check! We think that our raisins and other features each are normally distributed, defined by a mean and standard deviation</span>
- **Sample data**.  Check!  Our hungry students gave us a nice list of counts and features for a sample of the cookies.
- A **likelihood function**: This is a function that takes, as input, a guess for the parameters of our model (the mean and standard deviation), our observed data, and plops out a value that represents the likelihood (probability) of the parameters given the data.  So a higher value means that our observed data is more likely, and we did a better job at guessing the parameters.  If you think back to your painful statistics courses, we model the probability of a distribution with the pdf, ([probability density function](http://en.wikipedia.org/wiki/Probability_density_function)).  This is fantastic, because if we just maximize this function then we can find the best parameters (the mean and standard deviation) to model our raisin cookies.  How do we do that?

### What are the steps to estimate parameters with MLE?

I am going to talk about this generally so that it could be applied to any problem for which we have the above components.  I will define:

- θ: our parameters, likely a vector
- X: our observed data matrix (vectors of features) clumped together, with a row = one observation
- y: out outcome variable (in this case, raisin counts, which I will call continuous since you can easily have 1/2 a raisin, etc.)

This is clearly a supervised machine learning method, because we have both an outcome variable (y) and our features (X).  We start with our likelihood function:

L(θ) = L(θ;X, ~y) = p(~y|X; θ)

Oh no, statistics and symbols! What does it mean!  We are saying that the Likelihood (L) of the parameters (θ) is a function of X and y, equal to the probability of y given X, parameterized by θ.  In this case, the "probability" is referring to the PDF (probability density function).  To extend this equation to encompass multiple features (each normally distributed) we would write:

[![eq1](http://www.vbmis.com/learn/wp-content/uploads/2013/06/eq1-300x109.png)](http://www.vbmis.com/learn/wp-content/uploads/2013/06/eq1.png)

 

 

 

 

I apologize for the image - writing complex equations in these posts is beyond the prowess of my current wordpress plugins.  This equation says that the likelihood of our parameters is obtained by multiplying, for each feature 1 through m, the probability of y given the feature x, still parameterized by θ.  Since we have said that our features are normally distributed, we plug in the function for the Gaussian PDF.  If you remember standard linear regression, the term in the numerator is the difference between the actual value and our predicted value (the error).  So, we now have the equation that we want to maximize!  Do you see any issues?

I see a major issue - multiplication makes this really hard to work with.  The trick that we are going to use is to take the log of the entire thing so that it becomes a sum.  And the log of the exponential function cancels out... do you see how this is getting more feasible?  We also use a lowercase, italisized script "l" to represent "the log of the likelihood" :

[![eq2](http://www.vbmis.com/learn/wp-content/uploads/2013/06/eq2-300x165.png)](http://www.vbmis.com/learn/wp-content/uploads/2013/06/eq2.png)

The first line says that we are defining that stuff on the left as the log of the Likelihood.  The second line is just writing "log" before the equation that we defined previously, the third line moves the log into the summation (note that when you take the log of things multiplied together, that simplifies to summing them).  We then distribute the log and simplify down to get a much more feasible equation to maximize, however we are going to take a step further.  If you look at the last line above, the first two terms do not depend on our variables of interest, so we can just look at the last term.

[![eq3](http://www.vbmis.com/learn/wp-content/uploads/2013/06/eq3.png)](http://www.vbmis.com/learn/wp-content/uploads/2013/06/eq3.png)

This is equivalent to the cost function that we saw with linear regression!  So we could solve for the parameters by maximizing or minimizing this function.  And does it make sense that you could apply this method to other distributions as well? You would start with their PDFs, take the log of the Likelihood, and then minimize to find the best parameters (and remember to do this we are interested in finding where the derivative of the function with respect to our parameters is zero, because this means the rate of change of the function is zero because we are at a maximum or a minimum point, where the slope is changing direction from positive to negative, or vice versa).  And of course you can get R or Matlab to do all of this for you.  Super cool, no?


