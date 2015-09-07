---
title: "Cross Validation"
date: 2013-6-16 19:45:05
tags:
  cross-validation
  k-fold
  leave-one-out
  parameter-selection
---


In a perfect world, we would be able to ask any question that our little hearts desire, and then have available immediately infinite numbers of datasets to test our hypothesis on, and know exactly the model and parameters to use.  Of course, we do not live in such a world, and commonly we approach a problem with:

- <span style="line-height: 13px;">not enough data</span>
- no clue about the parameters
- possibly no clue about the model or algorithm to use

Different flavors of **cross validation**, or a model validation technique that can give us a sense of how generalizable our model is, can help with all of these challenges.  Let's start with a problem that we face every single day: bed bugs.

### Building a Model to Describe Bed Bugs

Let's say I wake up one morning, and I am shrunk down to the size of an eyelash.  My green bed is a vast landscape covered in, to my horror, a sea of brightly colored bed bugs, chatting and munching on my dead skin, and otherwise having a grand old time.  Also to my horror, some of these bed bugs seem quite ornery, while others seem friendly.  Chatting with a random bug, he tells me that I should be weary of his comrades general mood, because moody bugs tend to bite harder, and so someone with a bed of moody bugs is not going to sleep as well.  Oh dear!  Knowing that I am faced with a once in a life-time opportunity to interact with the bugs, and knowing that moody bugs bite harder, I realize that it would be valuable to predict bug moodiness based on physical features that we might observe with a microscope.  A person who isn't sleeping well could bring in a pillow with a sample of bed bugs, and the bugs moods could be assessed based on the physical features to determine if they are contributing to the poor quality of sleep.  Knowing that my time as a mini-me is limited and wanting to solve this problem, I decide to collect as much phenotypic data about these party animals as I possibly can.  I approach them randomly and record the color, number of eyes, ears, height, girth, and if the bug is mean or friendly.  I'm lucky enough to get a sample of 100 before whatever spell that shrunk me down runs out, and I am returned to my normal, ginormous human size.

I run to the computer to input my features into a data matrix, with each bed bug in a row, and each feature in a column, and I create a separate vector of "mood" labels to distinguish if the bug was mean (0) or friendly (1).  I hypothesize that I can find patterns in these features to predict the mood, and so I have on my hands a supervised classification problem: predicting mood from phenotype.  It could be the case that particular species of bed bugs associated with a certain phenotype tend to be more or less moody, or it could be that some state of the bug (e.g., a smaller, less well-fed bug) is more ornery than a larger, satiated one.

I decide to try using logistic regression, specifically glmnet, for which I must choose a value of the parameter lambda that controls the sparsity.  (Please be aware that glmnet is best suited for cases when the number of features far outnumbers the number of samples, but let's just disregard that for the purpose of the example.)  How do I choose this value of lambda?  Let's define a set of 5 hypotheses, each being glmnet with a different value of lambda (and note that this could also easily be a set of different models that we want to test). If I were to train on all my data and get a metric of accuracy for each hypothesis, if I were to choose the value that minimized this training error, I am taking the risk that the model is overfit to my data, and if presented with novel bed bug features, it would not do very well.  If you remember from my post about the [tradeoff between bias and variance](http://www.vbmis.com/learn/?p=127), this is called **generalization error**.  We want to build models that can be extended to data that we have not seen.

### Using Cross Validation to Build an Extendable Model

The idea of cross validation is simple.  We are going to break our data into different partitions for training and testing, i.e.,  "holding out" a subset to test on, and training on the rest.  This will ensure that we can choose the best hypothesis that is not overfit to the training set.  An example cross validation pseudo-code is as follows for our bed bug sample, B:

1. Randomly split B into B-train (70% of the data, 70 bugs) and Bcv (the remaining 30%, 30 bugs).  "cv" is called the hold-out cross validation set that we will test on.
2. Train each hypothesis (remember our algorithm with different values of lambda) on Btrain only, to get a set of models to test
3. Input the remaining held out 30 bugs (Bcv) into each model and calculate an error
4. Select the model with the smallest error

If we had a tiny amount of data that we wanted to "maximize the utility of" to build a model, we might want to use **leave one out cross validation**, for which we hold out one data sample, train the model using the other 99, and then test the model on the one sample.  We would iterate through our entire dataset, giving each sample the opportunity to be held out, and each time getting an accuracy assessment (if we were correct or incorrect in our prediction).  When we finished iterating through the entire dataset, we would have a prediction for each sample based on training on the other 99, and we could use these predictions to calculate an accuracy.

Another common flavor of cross validation is **ten fold cross validation, **for which we break the data into ten equally sized partitions, and iterate through the partitions, training on 9, and testing on 1.  This is also called k-fold cross validation, when k is defined as the size of the partition.  But people choose k=10 quite a lot.

### It's important to have CV *and* test data!

If you use cross validation to build a model, you should also have another separate dataset to test your model on after cross validation, because the cross validation can bias your resulting parameters.  It will also further show how awesome your model is in that it is extendable to even more data.  This test set is more convincing than using CV alone because it is an independent assessment of your model.

### Summary of Cross Validation

From the above, you can see that by testing on data that we did not train on, we get a better estimate of the model's generalization error, and if we aren't sure about a particular parameter or model to use, we can pick the one with the smallest generalization error without worrying that it is overfit to our training data.  Sometimes people lik to choose the model or parameter in this way, and then re-train using all of the data.  In this particular case, I will be able to sleep at night knowing that I have best modeled predicting bug mood from phenotype.  That is, if my bugs aren't particularly moody ![:)](http://www.vbmis.com/learn/wp-includes/images/smilies/simple-smile.png)


