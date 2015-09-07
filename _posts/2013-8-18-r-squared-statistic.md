---
title: "R (squared) Statistic"
date: 2013-8-18 20:11:22
tags:
  r-squared
  rss
  tss
  variance
---


I remember making plots in middle and high school, and this curious ![R^2](http://l.wordpress.com/latex.php?latex=R%5E2&bg=FFFFFF&fg=470229&s=1 "R^2") statistic told me something about how well my data fit some regression plot.  I had no clue where this value came from, but I noticed that it ranged between 0 and 1, and values closer to 1 were indeed better.

The ![R^2](http://l.wordpress.com/latex.php?latex=R%5E2&bg=FFFFFF&fg=470229&s=1 "R^2") statistic is a measure of fit.  Further, it is intuitive because it tells us the proportion of variance of the data explained by our model.  Thus, a value of 1 means that we explain 100% of the variance, and let's just hope that we don't see any ![R^2](http://l.wordpress.com/latex.php?latex=R%5E2&bg=FFFFFF&fg=470229&s=1 "R^2") values == 0.

### How to calculate Mr. R (squared)

To calculate the ![R^2](http://l.wordpress.com/latex.php?latex=R%5E2&bg=FFFFFF&fg=470229&s=1 "R^2") statistic, we need to know the residual sum of squares (RSS), and the total sum of squares (TSS).  The TSS measure the variance in the response of Y (the y bar is representative of the mean of Y), and the RSS measures the variance in our predictions (y hat), or the variance that is not explained by our model.  Each is defined as follows:

[![eq1](http://www.vbmis.com/learn/wp-content/uploads/2013/08/eq13.png)](http://www.vbmis.com/learn/wp-content/uploads/2013/08/eq13.png)

[![eq1](http://www.vbmis.com/learn/wp-content/uploads/2013/08/eq14.png)](http://www.vbmis.com/learn/wp-content/uploads/2013/08/eq14.png)

In this regard, if we were to subtract the RSS from TSS (TSS - RSS) we would get the amount of variance that *is* explained by our model.  Then if we divide by the TSS, we get variance explained by the model as a percentage of total variance, which is what we want:

[![eq1](http://www.vbmis.com/learn/wp-content/uploads/2013/08/eq15.png)](http://www.vbmis.com/learn/wp-content/uploads/2013/08/eq15.png)

Now with this ![R^2](http://l.wordpress.com/latex.php?latex=R%5E2&bg=FFFFFF&fg=470229&s=1 "R^2") statistic, since it is normalized, we can compare between different models and data.  Cool!  So what does it mean if the percentage of the variability of Y as explained by X is really low?  It means that the regression model isn't good to fit the data.  Try something else!

### A Note of Caution...

Be cautious about using this statistic to do any form of feature selection (i.e., don't!) because when you add variables to the model, Mr. R (squared) will always increase.  However, you could look at the degree of the increase.  For example, if a variable adds little to the model, the increase will be tiny, as opposed to a variable that makes it much better.


