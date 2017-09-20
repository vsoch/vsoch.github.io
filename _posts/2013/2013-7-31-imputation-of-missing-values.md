---
title: "Imputation of Missing Values"
date: 2013-7-31 20:32:25
tags:
  imputation
  missing-data
  nan
---


In a perfect world, my data is absolutely perfect, and I've collected every feature or metric for every person, to be fed cleanly into some model.  Now let's recognize the obvious reality that having complete data is rarely the case.  We usually having missing values (NAs) in analysis, and so we must consider methods to deal with these missing values.  There are two possible approaches:

1. We can drop all observations for which we have missing data
2. We can impute them, or come up with a good estimation of what they are likely to be
3. We can use a method that allows for missing values

Data is gold, and so option 1 is not ideal, although I'll note that technically you should not have a problem with removing data if the missing values are completely random.  A good example of this is some questionnaire that asks about income.  People that leave the question blank may have a good reason (e.g., a super high or low income that they are embarrassed about), in which case dropping those cases would hugely bias your analysis.   Option 3 depends on your specific data and type of method, so I won't review it just yet.    Let's assume that we don't want to boldly eliminate entire observations, and talk about option 2, or methods for imputing missing values.  This is by no means a comprehensive summary - it is the beginning of my thinking about this issue, and I will add to it as I learn more.

### Imputation of Missing Values

- <span style="line-height: 13px;">**Mean imputation:** replaces missing values with the mean of the values that we do have.  The problem with this approach, of course, is that it leads to underestimation of the standard deviation.  For just a few missing values, however, it may not be so bad.</span>
- **Last value carrier forward:** In this approach, if we are missing some clinical outcome, we fill it in with the last value recorded for a pre-treatment measure.  This is a conservative approach because we are assuming no change, and so it biases our data toward the view that "whatever protocol was implemented, there was no significant change."  If there is signal in our data to suggest otherwise, and it is a strong signal, it would need to overpower this bias for us to conclude that the intervention caused a significant change in outcome.
- **knn-imputation:** In this approach, we use a similarity metric to find the most similar observation(s), and fill in the missing value with that/those observations.  If you take more than one observation (K>1) then you would take a summary statistic.
- **Random Imputation: **In this approach, we place all of the variables that aren't missing into a bucket, and we randomly sample from that bucket to fill in missing values.  This would get rid of the NaNs, however it does not take anything specific about the observations into account.  We are just filling the missing values in with a likely number from the distribution.
- **Regression Based Imputation: **In this approach, we again take the cases for which we have observed data, and we fit a regression to these cases, with the outcome variable, Y, being one of the missing variables that we want to predict.  We can then plug our data with missing values into the model (and fill in perhaps a mean value for features, X, that we are missing) to come up with  a prediction for Y.  While this again is making assumptions by filling in mean values for some of the variables X, minimally we are predicting our Y based on *some* knowledge about the observations, the X's that we *do* know.  You could also select variables, X, for which you know that you have complete data.  With this in mind, if you have a large enough dataset, I don't see why you couldn't first find the most similar N cases, and then do a regression with just those cases to make a prediction for a particular observation.  More advanced versions of this could also add some expected error to the prediction.


