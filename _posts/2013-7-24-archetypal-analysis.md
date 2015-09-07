---
title: "Archetypal Analysis"
date: 2013-7-24 19:59:28
tags:
  archetypal
  dimensionality-reduction
  machine-learning-2
  prototype
  unsupervised-2
---


**Archetypal Analysis **is an unsupervised learning algorithm that postulates that each of our set of observations is some combination of some number, K, "pure subtypes," or archetypes.  I'll also refer to these as prototypes.  In the simple case of adult human faces, you can imagine that there might be a prototypical face for each gender and ethnicity, and then every human being can be modeled as some combination of these prototypes.  Similar to [non-negative matrix factorization](http://www.vbmis.com/learn/?p=471 "Non-Negative Matrix Factorization"), we start by modeling our data, X, as the result of multiplying some matrix of weights, W, by the prototypes, H:

[![eq1](http://www.vbmis.com/learn/wp-content/uploads/2013/07/eq129.png)](http://www.vbmis.com/learn/wp-content/uploads/2013/07/eq129.png)

- X is sized N x p, number of observations  x number of features
- W is sized N x r, number of observations x number of prototypes
- H is sized r x p, number of prototypes x number of features
- We assume that the number of prototypes, r is less than or equal to N, our number of observations.  It makes sense that in the case of r = N, each prototype is just an observation itself!
- The number of prototypes, r, can be greater than the number of features, p.  In the case of faces, this is saying that the number of prototype faces can be greater than the number of pixels in the image.

Since a negative weight doesn't make much sense, in this algorithm we assume that our weights are greater than (or equal to) zero.  We also assume that, if we sum up a row of weights defining a particular observation, we must get a value of 1.  Intuitively, the weights would be saying "this observation is 50% Prototype 1, 25% prototype 2, 25% protype N, and so adding up all of these weights we want to get a value of 1 (100%).  We can still have some weights set to zero (for example, if there was an alien face prototype in the mix, a human observation would (hopefully) have the weight for this prototype as zero.  We are modeling each of our observations as some convex combination of the subtypes.  We also can say that:

[![eq1](http://www.vbmis.com/learn/wp-content/uploads/2013/07/eq133.png)](http://www.vbmis.com/learn/wp-content/uploads/2013/07/eq133.png)

and I (think) that B is akin to the inverse of W, in ICA we would call this the "unmixing matrix."  The values in this matrix B need to equivalently be positive, and it is size r x N.  Here we are modeling the prototypes as convex combinations of our original data!  That's pretty neat.  With the two equations above, we can come up with an incredibly simple way to solve for W and B.  Since we want WH (or WBX) to best approximate X, to solve for W and B we can minimize the function that subtracts WH from X.  If X - WH is zero, that means that our prototypes and weights approximate the data *perfectly*.  As the value gets larger, we obviously aren't doing as good a job:

[![eq1](http://www.vbmis.com/learn/wp-content/uploads/2013/07/eq134.png)](http://www.vbmis.com/learn/wp-content/uploads/2013/07/eq134.png)

The second equation simply comes from substituting in BX for H.  We are taking the L2 norm (the euclidian distance, meaning that we find the difference between each feature vector by subtraction, square this value so it's positive, and then take the square root of the entire thing.  We minimize this function in an alternating fashion, and while each separate minimization involves a convex optima, the overall problem is not convex, and so we usually converge to a local minimum.

### Achetypal Analysis is sort of like K-Means

The picture below shows Archetypal analysis (top row) compared to K-Means clustering (bottom row) on the same dataset for different values of K archetypes or clusters.  What I notice from this is that Archetypal analysis gets at the "extremes" in the dataset (notice how the archetypes, the <span style="color: #ff0000;">**red points**</span>, are around the edges?) while K-means centroids (the <span style="color: #0000ff;">**blue points**</span>) try harder to get the most average representations.  Thank you again to the ESL book for this photo!  Statistics / machine learning / informatics students everywhere are thankful for your loveliness:

[![eq1](http://www.vbmis.com/learn/wp-content/uploads/2013/07/eq136.png)](http://www.vbmis.com/learn/wp-content/uploads/2013/07/eq136.png)

With this understanding, how would you hypothesize archetypal analysis would perform when applied to learning a dataset of pictures of numbers?

[![eq1](http://www.vbmis.com/learn/wp-content/uploads/2013/07/eq137.png)](http://www.vbmis.com/learn/wp-content/uploads/2013/07/eq137.png)

If you guessed that the resulting archetypes are "extreme" threes, you are correct.  The picture above doesn't show any "average" looking 3's: they are all super long, super thin, super fat, etc.  Those are some **extreme 3's! **![:)](http://www.vbmis.com/learn/wp-includes/images/smilies/simple-smile.png)  As is the case for all these methods, I have not discussed how to decide on the number of prototypes, or the number of components.  There are methods to come up with a good number, to be discussed in a different post.


