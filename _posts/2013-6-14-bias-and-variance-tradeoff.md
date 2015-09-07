---
title: "Bias and Variance Tradeoff"
date: 2013-6-14 22:06:44
tags:
  bias
  empirical-risk-minimization
  generalization-error
  sample-complexity
  tradeoff
  variance
---


When we talk about bias vs. variance tradeoff, we are venturing into the field of **learning theory** that broadly thinks about how to best match particular data to a method, and how to improve performance of a model by understanding the strengths and weaknesses of the methods.

### How well does a model fit the data?

When we train a model, meaning an algorithm that predicts some outcome, **y, **with features **x,** we would be interested to know if our model can be used on similar data, however data that it wasn't initially trained on.  This extendability of a  model is called it's **generalizability**.  Ok, I possibly made up that word - more formally:

- the **generalization error** is the expected error of a hypothesis on data not from the training set.  The **bias** of a model is its expected generalization error.
- When a model fits its data too well, we call this this **overfitting. **A model that is overfit to a particular dataset is said to have high variance, and this is a component of (adds to) generalization error.
- When a model does not fit the data well enough, we call this **underfitting.  **

This is a little bit like Goldie Locks and the three bears.  Overfitting and underfiiting are two extremes, and somewhere in the middle, the porridge tastes just right, or we find a model that fits the training data pretty well and can also be extended to data that it has not seen.  This leads to the bias and variance tradeoff:

### Bias and Variance Tradeoff

To understand the tradeoff between bias and variance, it's best to start by looking at the mean squared error (MSE):

[![eq1](http://www.vbmis.com/learn/wp-content/uploads/2013/06/eq126.png)](http://www.vbmis.com/learn/wp-content/uploads/2013/06/eq126.png)

The expected mean squared error of our algorithm (subtracting predictions from actual value, squaring), can be broken down into:

1. The variance of the model
2. The squared bias of the model
3. The variance of the error term

Intuitively, to get low error, we need low bias and low variance.  The **bias** component of the error "gets at" **error that is the result of our model choice**.  If we have chosen too simple a model and we don't capture some pattern, the bias is high, and we are under-fitting.  The **variance** component of the error is about the data, and "gets at" the amount that the error might change if we used a different test set.  Thus, high variance means that if we tested on another dataset, we might get much higher error, and so our model is possibly over-fitting to our training data.  Both of these components get at a models generalization error, which could be high due to high variance and/or high bias.

### How do we quantify generalization error?

We quantify the generalizability (not a word!) of a model with the **training error, **or **empir****ical error,** which is the fraction of the samples that the model in question misclassifies.  The **generalization error** is the probability that a new sample is misclassified by our model.

### Empirical Risk Minimization: We can use generalization error to build a model!

Just like we found the best parameters in linear regression by minimizing the sum of squared distances (the residuals, error, etc.) we can tackle the problem of finding optimal parameters for a model by simply minimizing the training error.  This process of finding parameters by minimizing the training error is called **empirical risk minimization**.  The size of the sample, **m** that is required for our model to get a particular level of performance is called the algorithm's **sample complexity.**

### Bias and Variance Tradeoff Relation to MSE

We can see from the above that since neither variance nor bias can be negative, if we decrease one and hold error constant, the error must go up.  This is the bias / variance tradeoff, and it says that when bias is low (we have small prediction error), variance is high (it doesn't extend as well to different data), and vice versa.

### What does overfitting look like?

The best example of overfitting comes by way of an illustration:

[![800px-Overfitting](http://www.vbmis.com/learn/wp-content/uploads/2013/06/800px-Overfitting.png)](http://www.vbmis.com/learn/wp-content/uploads/2013/06/800px-Overfitting.png)

We are plotting model complexity on the x axis, (e.g., the number of predictors in a linear regression), and the error on the y axis. The <span style="color: #0000ff;">blue line</span> represents our training data, and the <span style="color: #ff0000;">red line</span> represents our testing data. **For training**, we see that as we add more predictors, our model improves.  However, what we are actually doing is fitting the model to noise in the data.   It means that the model performs really well to predict our training set, and does terribly with the test set, which is why there is such a huge distance between the two lines on the right side of the chart.  **For testing**, we see the error decrease down to a certain point, and then it starts to grow. The area after this "sweet spot" where test error starts to increase is what we call overfitting.  It's sort of akin to the real world practice of **fitting people with mouth guards**:

**Underfitting: **(in other words, not using *enough* information, and having a model that is too simple all together):  In this scenario, you create a mouth guard out of two strips of plastic in a general half circle shape based on the idea that mouths are kind of shaped like that.  Since you didn't have enough parameters or good quality information going into the model, it might be the "best" mouth guard to be shared between humans, lemurs, and baboons, but it by no means is a good model for a mouth guard.  This point could be represented somewhere on the left side of the chart above.  Let's keep moving down the curve to the right.

**The "sweet spot":**  When you realize that most human mouths have a similar size and shape, you get smart and create a template based on a random sample of 30 humans.  You now have a general, plastic guard for sports, "one size fits all."   It's a model that takes enough human parameters into account so that it fits humans well, is representative of a generic mouth, and thus it works well for many different types of people.

**Overfitting:**  People quickly learn that they can drop the mouth guards into hot water, and then stick them onto teeth to get an almost perfect fit.  With this in mind, you throw away your generic template, and decide to create all mouth guards in this manner (of course washing them to get rid of the germies!)  Now, your training set are the mouths that you fit the guards to before selling them, and the testing set are still your buyers.  But then, to your surprise, you start to get letters from customers that particular spots in the mouth guard are too small or big, have teeth delineations that are completely different from their own,  or just plain don't fit the mouth cavity at all.  Some people even comment that their guards have more teeth than they do!  Oh lord, what happened?  This is literally a case of overfitting.  Because you have built your model based on the fine details of your training set (the mouths that the guards were specifically fit to, every last bump, lump, and tooth), the guard is not at all extendable to any mouths other than the one it was built for.

The lesson, at the end of the day, is to put some thought into how you test and train your data, and to put together an evaluation strategy that takes the model and the data it is intended for into account.  If you are writing a paper, it's probably a good idea to extend your model to as much data as your can get your hands on to demonstrate how awesomely robust it is.


