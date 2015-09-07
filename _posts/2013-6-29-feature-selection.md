---
title: "Feature Selection"
date: 2013-6-29 20:13:16
tags:
  backward-feature-selection
  feature-selection
  filter-approaches
  forward-feature-selection
  wrapper-approaches
---


Science these days is defined by big data.  In economics, medicine, politics, just about any field, we are constantly collecting information about things and trying to build models to understand and predict our world.  In this light, you can imagine that a lot of this big data is... complete junk.  Let's say that we are collecting phenotypic data about cats with the goal of predicting how ugly they are (yes, I do not like cats so much).  We collect everything that we can think of, including hair and eye color, nail and hair length, height, width, mass, tail curl, etc.  it's very likely that there will be some relationship between hair length of ugliness, because [hairless cats are terrifying](https://www.google.com/search?q=hairless+cat&hl=en&tbm=isch&tbo=u&source=univ&sa=X&ei=QDXPUcHxCMnxigK6_ICwCA&ved=0CDwQsAQ&biw=746&bih=598#hl=en&tbm=isch&q=scary%20hairless%20cat&revid=1546664648&ei=TDXPUc6yI-KniQLppoDwDg&ved=0CA0QsyU&bav=on.2,or.r_cp.r_qf.&bvm=bv.48572450,d.cGE&fp=c1494d1c907999f3&biw=746&bih=598&imgdii=_), and longer haired cats are considered fancier (according to the [Fancy Feast commercials](http://www.youtube.com/watch?v=umczO5Y5Av0)).  However, it's unlikely that toenail length will be of any use in our model.  In fact, including it will make our model very bad.  This is where ****feature selection comes in!  Given that we are overwhelmed with data, we need methods to pick out the features that we want to use in our models.

**Feature selection **is a method of model selection that helps to select the most relevant features to the learning task.  If we have n features, if we were to try every possible subset of features, this would give us 2^n subsets.  For only a handful of features, it might be feasible to do this exhaustive test.  For many features, it is a very bad idea.  The basic kinds of algorithms for feature selection are **wrapper approaches** and **filter approaches.  **Wrapper approaches generally create a loop that 'wraps" around your learning algorithm and runs it many times to evaluate different subsets, while filter approaches use a heuristic, and calculate some goodness score S(i) for each feature, and then just choose the best.  We will start by reviewing the simplest wrapper approaches: forward and backward search

### Forward Search

The idea of forward search is that we start with an empty set, and repeatedly iterate through our set of features, each time evaluating the performance of our model with each feature, and at the end choosing to add the feature that has the lowest generalization error.  And of course we stop adding features if we aren't improving our ability to classify the data.  More simply put:

Create an empty set, let's call it S.

Repeat {

1. Train a classifier with S + each feature that is not currently in S, and estimate its generalization error
2. Choose the feature from above that does best, add to S.

}

Stop when error stops improving, or we run out of features, and here we output the best feature subset.

So for our problem of selecting features that are informative about cat ugliness, we would likely start with an empty subset, and then build and evaluate a classifier using each of the features alone.  We would find that hair length performs best to predict ugliness, so we would add that feature to our set, and then start round two.  In round two we would again add each feature (all features not currently in our subset) to our current set, S, and build and evaluate a classifier.  We would then add the feature to S that improves the model.  For example. we might find that hair length + eye color do better to predict ugliness than hair length alone.  We would continue in this manner of adding features until we hit a desired number of features, a desired performance, or if performance stops improving.  And how do we figure out when to stop adding features? It is common to use the F-ratio:

[![eq1](http://www.vbmis.com/learn/wp-content/uploads/2013/06/eq125.png)](http://www.vbmis.com/learn/wp-content/uploads/2013/06/eq125.png)

You can see that this looks at the difference between the residual sum of squares (between the old and new model), and we divide by our estimate of the variance.  If the F ratio is a big number, (I think) this means that our old error was much larger than the new, and we should keep going.  I the F ratio is negative, then the new model had a higher error than the old, and we should not continue.  If the F ratio is zero, then we are indifferent.

### Backward Search

Backward search is similar to forward search, except we start with ALL the features of our data in our subset, and remove the feature that leaves a subset that does better than previously.  We of course stop if our performance stops improving, or if we reach an empty set.  More simply:

Start with our set S = all features

Repeat {

1. Train a classifier with S - (minus) each single feature that is still in S, and estimate its generalization error
2. Remove the feature from S whose removal improves performance most

}

When we get to here, we hopefully have a subset of features, and haven't removed them all.

Of course, these filter methods can be very computationally expensive because we have to run our model so many times.  In the case of very large data, it can be easier to use a filter method.

### Filter Feature Selection

A good example of a heuristic for filter feature selection is calculating the (absolute value of) the correlation between each feature x and the outcome variable y.  This is pretty simple.  More commonly, we use something called mutual information.  **Mutual information** gets at how much we can learn about one variable from another, and the resulting calculation is between 0 and 1.  A mutual information score of 1 means that knowing X tells us exactly what Y is, and it's a good feature to have.  A mutual information score of 0 says that X tells us nothing about Y, and we can throw it away.  The calculation for the mutual information between X and Y is as follows:

[![eq1](http://www.vbmis.com/learn/wp-content/uploads/2013/06/eq115.png)](http://www.vbmis.com/learn/wp-content/uploads/2013/06/eq115.png)

If x and y are completely independent, meaning that X tells us nothing about Y, then p(x,y) = p(x)p(y), and log(1) goes to zero, and the resulting MI value also approaches (or is) zero.  However, if x and y are completely dependent, this means that knowing X gives us a lot of information about Y, and our resulting MI value gets larger.  We can therefore calculate these MI scores for each feature and Y, and use something like cross validation to decide how many k features to include in our model.

Again, for our problem of predicting cat ugliness from phenotype, we would likely find high MI values for features like hair length and eye color, and values close to zero for something like toe nail length.  We would then use cross validation with different numbers of features (k=1:5, for example) to decide on the optimal value of k corresponding to the number of features to include in our model.

### A Few Tips About Feature Selection

- <span style="line-height: 13px;">Adding redundant variables (i.e., transforming your data) can achieve better noise reduction and better class separation. For example, if we have a feature x, by transforming it to make a new feature x_2 we aren't adding any new information, but this new feature transformation might be better at distinguishing class labels.  This is likely why kernels are so important for support vector machines - we are essentially transforming our features to infinite dimensional spaces with the goal of making them linearly separable.</span>
- Perfect correlation or anti-correlation doesn't say anything about variable utility for classification.  Two variables could be perfectly correlated, but still very separable (for example, think of some line like Y=2x, and then shift it up a few units, Y=2X+3.
- Unfortunately, selecting a useful subset of features is not the same thing as selecting features that perform well individually.  Some features are useless on their own, but when taken with others, can result in significant improvement of classification performance.
