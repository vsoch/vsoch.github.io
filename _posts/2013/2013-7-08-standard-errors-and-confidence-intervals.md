---
title: "Standard Errors and Confidence Intervals"
date: 2013-7-08 17:13:10
tags:
  
---


I've been reading over beautiful notes from STATS315A (thanks to my awesome fellow graduate student Katie!), one of the three statistics courses I wanted to take, but haven't been able to squeeze in (yet!)   The course notes provide beautifully clear explanations of very common concepts.  Specifically for this post, we will review standard errors and confidence intervals.

The **standard error** of an estimate is the standard deviation.  it's called "standard error" because in most cases we don't actually know this value, and so we estimate it.  This estimate is called the standard error (se).

[![Screenshot at 2013-07-08 10:03:05](http://www.vbmis.com/learn/wp-content/uploads/2013/07/Screenshot-at-2013-07-08-100305.png)](http://www.vbmis.com/learn/wp-content/uploads/2013/07/Screenshot-at-2013-07-08-100305.png)

We estimate the variance (the top term) by:

[![Screenshot at 2013-07-08 10:05:53](http://www.vbmis.com/learn/wp-content/uploads/2013/07/Screenshot-at-2013-07-08-100553.png)](http://www.vbmis.com/learn/wp-content/uploads/2013/07/Screenshot-at-2013-07-08-100553.png)

A **confidence interval **lets us say that we are some percentage confident that our parameters fall in a specific interval.  This reflects the quality of our estimates.  It is common to use a 95% confidence interval, and we get it by adding/subtracting 1.96 multiplied by the standard error of our estimates (defined above), i.e.,:

![B +- 1.98 * se(B)](http://l.wordpress.com/latex.php?latex=B%20%2B-%201.98%20%2A%20se%28B%29&bg=FFFFFF&fg=470229&s=1 "B +- 1.98 * se(B)")


