---
title: "Naive Bayes"
date: 2013-6-25 14:56:40
tags:
  generative-learning
  machine-learning-2
  naive-bayes
  probabilistic
  supervised-2
---


**Naive Bayes** is a supervised, probabilistic classification method for discrete classes that makes some strong assumptions about the data, but works pretty well.  If you think back to regression,  regression, we were trying to predict p(y|x), and this is called a **discriminative learning model. ** We were trying to predict the probability of a class given a feature set.  What if we turn this on its head, and instead model p(x|y), or in other words, given a particular feature set, the probability of each class?  This is called a **generative learning model.  **Abstractly, we create models of each of our classes based on the features (x), and then for a new set of features that we want to classify, we ascribe the label of the model that is most likely given those features.  As usual, to explain it I will set up a toy problem.

Let's say that I really like ice cream and sorbet.  I have a huge catalog of recipes for the two, and they are nicely organized in two folders.  I then proceed to drop the folders, and at the same time a huge wind picks up and scatters the recipe papers everywhere!  I now have no idea which recipes are for sorbet, and which are ice cream.  I have thousands of them, and so manual curation is not feasible, however I'm willing to look through and label a subset of the recipes.  We will call this subset my **training****set.**

I then decide to get clever.  I know that I can scan my recipes and have the text read automatically, so I decide to write a little script that can classify the recipe based on the ingredients.  I know that ice cream and sorbet have different ingredients, namely ice cream is typically cream or milk based, and sorbet is not.  I could do a really simple algorithm that slaps a label of ice cream on anything with a milk based ingredient, but I am hesitant to do that because I know that some of my sorbet recipes have mix-ins and toppings that use milk products, and my ice cream recipes most definitely use sugar and fruit.  Instead, I decide that naive bayes is the way to go!

### **The Basic Steps**

- **Create my training set: **I take a sample of my recipes, and label them as "ice cream" or "sorbet."
- **Define my features: **My features are the ice cream ingredients (e.g., cream, sugar, milk, strawberry, vanilla, etc.).   I contact [this crazy company](http://www.mastersoncompany.com/ice_cream_ingredients.html) to get a comprehensive list of all ingredients that can be used for ice cream or sorbet.  I then put them in alphabetical order (this list is called my **vocabulary****)**, and write a little script that works with my text reader.  As I scan each recipe, my script creates a vector of 0's and 1's that correspond to if the ingredient is in the recipe (1) or not (0) (Note that using 0s and 1s is a version of Naive Bayes called a **Bernoulli Naive Bayes** model).  I do this for each recipe in my training set.
- **Model p(x|y):**  I now want to model the probability of a particular combination of ingredients given that I have an ice cream or sorbet recipe.  For example, if my ingredients are "cream, vanilla, sugar, salt, and eggs" the p(ingredients|ice cream) would be very high, while the p(ingredients|sorbet) would be close to zero.  You can see why I wouldn't want to do some sort of gaussian discriminant analysis... there are way too many features!  This is where we make *drumroll*

### **The Naive Bayes Assumption**

We assume that each of our x features is conditionally independent given y.  This means that if I tell you a particular recipe has the ingredient "strawberry," this tells you nothing about whether or not it has "cream."  Now, for particular pairs of ingredients this might be true, however we can see right away that all of our variables are not conditionally independent.  If you tell me that a recipe has "eggs," that increases my belief that it has some milk-based ingredient, because it's likely an ice cream.  However, Naive Bayes is (unfortunately?) still applied to many problem spaces for which conditional independence is not the case.  Let's continue the example.  We model the p(x|y) as:

[![eq1](http://www.vbmis.com/learn/wp-content/uploads/2013/06/eq13.png)](http://www.vbmis.com/learn/wp-content/uploads/2013/06/eq13.png)

We again would want to write an equation that represents the likelihood of our data, and then maximize it.  This equation should is parameterized by the following:

- φi|y=1 = p(xi = 1|y = 1)       **The fraction of our ice cream recipes (y=1) that have an ingredient i**
- φi|y=0 = p(xi =1|y= 0 )       **The fraction of our sorbet recipes (y=0) that have an ingredient i**
- φy = p(y = 1)                            **The fraction of all recipes that are ice cream (y=1)**

More explicitly, we define these as:

[![eq1](http://www.vbmis.com/learn/wp-content/uploads/2013/06/eq14-300x163.png)](http://www.vbmis.com/learn/wp-content/uploads/2013/06/eq14.png)

However, I find it much easier and more intuitive to define them based on the textual descriptions above.  The notation says that we add 1 to the sum if an ingredient j is present for a recipe i AND (^) the class of the recipe is ice cream (y=1).  Basically, this is counting!

So if I pick up a recipe without a label, I would define my features for the recipe (the vector of 1's and 0's that corresponds to the absence and presence of each ingredient), and then I would use the entire labeled data to calculate each of the above (this is like the "training" step).  I would then want to know, is my unlabeled recipe more likely to be ice cream or sorbet?  To answer this question I need to know:

- p(y = 1|x)       **The probability of ice cream given my features**
- p(y = 0|x)      **The probability of sorbet given my features**

And now *drumroll* we use Bayes Rule:

[![eq2](http://www.vbmis.com/learn/wp-content/uploads/2013/06/eq28-300x57.png)](http://www.vbmis.com/learn/wp-content/uploads/2013/06/eq28.png)

[![eq3](http://www.vbmis.com/learn/wp-content/uploads/2013/06/eq33-300x37.png)](http://www.vbmis.com/learn/wp-content/uploads/2013/06/eq33.png)

This is a lot more simple than the equation suggests, because at the end of the day we are just calculating two numbers (each a probability of a class), and assigning the one that is larger.  It would be arduous to do by hand, but is relatively feasible to write a script to do for you.  To put this in the context of "training" and "testing" - training would encompass calculating our posterior probabilities from some training subset, and testing would mean coming up with a set of predictions for a test set, and then evaluating those predictions with standard ROC curve metrics.

### How do we deal with more than two classes?

For the above example, we model our problem with features that fit a Bernoulli distribution (0 or 1), the **Bernoulli Naive Bayes **model.  If you wanted to use features with more than two values (e.g., k={1,2,3,...n} you would use a **Multinomial Naive Bayes** model, and simply model them as multinomial.  The parameterization for each word is a multinomial distribution and not a Bernoulli, and we instead are modeling a distribution for words in each position of the document.  We are making the assumption that the word in position 1 is independent of the word in position 2.

In the case of continuous values, you could simply discretize them, or define bins based on ranges of numbers, each bin corresponding to an integer.

### Summary

Overall, even if the independence assumption isn't completely true, Naive Bayes is incredibly efficient and easy to put together,  and works very well with problems that have many (weakly) relevant features.  However, be careful if you have many highly correlated features, in which case the model will not work as well.


