---
title: "Generalized Linear Models (GLM)"
date: 2013-6-26 19:58:11
tags:
  
---


If you think of regression (e.g., linear with gaussian distributions) and classification (logisitic with bernoulli) as cousins, they belong under the larger family of **General Linear Models.  **A **GLM** is a broad family of models that can all be simplified to a particular equation that defines something in the "exponential family."  Basically, if you can simplify your distribution into this form, it belongs to this family.  This is the equation that defines something in the **exponential family**:

[![eq2](http://www.vbmis.com/learn/wp-content/uploads/2013/06/eq212-300x56.png)](http://www.vbmis.com/learn/wp-content/uploads/2013/06/eq212.png)

If we choose a particular value of T, a, and b, then we define a family of distributions parameterized by η.  Then when we vary the η we get different distributions within that family.  And all of these families are, broadly, general linear models.  So, what are each of these parameters?

- **η**: The natural, or canonical parameter
- **T(y)**: The sufficient statistic
- **a(η)**: The log partition function
- **canonical response function: **is the  function (g) that states the mean as a function of η.  So g(η) = E[T(y); η]).  The inverse is the **canonical link function.**

### 

### **What assumptions do we make?**

We usually start with some data, including features (x) and some random variable y, and we want to predict p(y|x).  To construct a GLM, we make the following three assumptions:

1. <span style="line-height: 13px;">p(y|x) parameterized by θ is a member of the exponential family, so it can be re-written in the exponential family form above parameterized by η.</span>
2. Our predicted value, our hypothesis h(x), should output the expected value of y given x:   E[y|x;θ]
3. The natural parameter η and the inputs x are linearly related

I'm not going to go through the derivation of any of these models, because it's largely hard statistics that give me a headache, and I think that it's more important to understand the broad concept.  If you can start with a bernoulli, gaussian, poisson, or some other distribution, and get it in this form, then you know that it is a generalized linear model.  And more importantly is the application.  If you have a dataset of interest, you would want to use appropriate functions in your scripting language of choice (e.g., [Matlab](http://www.mathworks.com/help/stats/examples/fitting-data-with-generalized-linear-models.html) and [R](http://www.statmethods.net/advstats/glm.html)) to try fitting your data with different models, and evaluating how well each fits.  If you are interested, here are the parameters for some common distributions, but I'd say that you will be fine just starting from the application standpoint.

### Bernoulli

[![eq2](http://www.vbmis.com/learn/wp-content/uploads/2013/06/eq214.png)](http://www.vbmis.com/learn/wp-content/uploads/2013/06/eq214.png)

Bernoulli(φ) (meaning with mean φ)  specifies a distribution over y ∈ {0, 1}, such that:

- p(y = 1; φ) = φ
- p(y = 0; φ) = 1 − φ

The parameters, defining it as a member of the exponential family and a GLM, are as follows:

[![eq2](http://www.vbmis.com/learn/wp-content/uploads/2013/06/eq213.png)](http://www.vbmis.com/learn/wp-content/uploads/2013/06/eq213.png)

### Gaussian Distribution

[![eq2](http://www.vbmis.com/learn/wp-content/uploads/2013/06/eq215-300x147.png)](http://www.vbmis.com/learn/wp-content/uploads/2013/06/eq215.png)

### Multinomial Distribution

[![eq1](http://www.vbmis.com/learn/wp-content/uploads/2013/06/eq15.png)](http://www.vbmis.com/learn/wp-content/uploads/2013/06/eq15.png)


