---
title: "Correlation"
date: 2013-8-18 20:38:30
tags:
  correlation
  covariance
  standard-error
  statistics-2
---


Correlation is a measure of the extent to which two variables change together.  A positive correlation means that when we increase one variable, the other increases as well.  It also means that when we decrease one variable, the other decreases as well.  We are moving in the same direction!  A negative correlation means that when we change one variable, the other moves in the opposite direction.  A correlation of zero means that the variables are independent - changing one doesn't influence the other at all.

### How to calculate correlation?

Let's say that we have two variables, x and y.  Correlation is basically the covariance(x,y) divided by the  standard deviation(x) multiplied by the standard deviation(y).  It's easy to remember because the equation for covariance and standard deviation are pretty much the same except for the variables that you plug in.  To calculate standard deviation, we subtract the mean from each value of x or y, square those values, add them up, and take the square route. You can see that we do this calculation for both x and y on the bottom of the fraction below.  Covariance (on the top!) is exactly the same except we subtract each of x and y from their respective means, and square those two results.  We don't take the square route to calculate covariance ([see my post comparing the two](http://www.vbmis.com/learn/?p=613 "What is Standard Error?")):

[![eq1](http://www.vbmis.com/learn/wp-content/uploads/2013/08/eq16.png)](http://www.vbmis.com/learn/wp-content/uploads/2013/08/eq16.png)

Again, the top of this equation is covariance(x,y), and the bottom is standard deviation (x) multiplied by standard deviation (y).  I think that this makes sense, because if x and y were exactly the same, the denominator would simplify to be the same as the numerator, and we would get Cor(X,Y) = 1.

### Correlation is related to R (squared) statistic!

One cool thing that I learned recently is that squared correlation is equal to the [R (squared) statistic](http://www.vbmis.com/learn/?p=623 "R (squared) Statistic") in the case of two variables, x and y!  I think that also means that we could take the square route of the R (squared) statistic and get the correlation.  This means that we could also use correlation as a metric for goodness of fit.  This works nicely in the case of our two variables, however since correlation is only defined to be between these two variables, we can't use it as this metric for multivariate regression.  In this case, Mr. R (squared) wins.

 


