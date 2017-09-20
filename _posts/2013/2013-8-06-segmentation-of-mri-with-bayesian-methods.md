---
title: "Segmentation of MRI with Bayesian Methods"
date: 2013-8-06 21:19:05
tags:
  atlas
  bayesian
  freesurfer
  intensity-based
  markov
  segmentation
  subcortical-segmentation
---


Let's say that I am a proponent of the idea that I can segment the brain into meaningful regions (e.g., caudate, amygdala, hippocampus...), which some may think is akin to cutting up the United States into said states.  This could be useful to assess differences in morphometry (the study of shape) between two populations.  This task is more challenging than the task of segmenting based on tissue type (white, gray, csf), because most of these anatomical regions that we are interested in are the same tissue type, namely gray matter.  How could I do this?

**Manual Segmentation:** I could use my favorite software package, click through the slices, and define regions manually.  I don't really want to do that, because it would take forever.

**Image Intensity Segmentation:** This obviously doesn't work, because most of these regions are going to have huge overlap in image intensity.  The image below (from [Fischl et. al 2002](http://www.nmr.mgh.harvard.edu/~fischl/reprints/sequence_independent_segmentation_reprint.pdf)) shows this overlap nicely:

[![Screenshot at 2013-08-06 09:34:38](http://www.vbmis.com/learn/wp-content/uploads/2013/08/Screenshot-at-2013-08-06-093438.png)](http://www.vbmis.com/learn/wp-content/uploads/2013/08/Screenshot-at-2013-08-06-093438.png)

...and in fact, this paper lays out the basic methods that underlie the subcortical segmentation procedures for the software package freesurfer.  I'll be upfront with you and tell you that I'm writing this post in the first place to better understand this subcortical segmentation, because I don't like using black boxes.  Let's walk through these methods!  The strength comes by way of incorporating spatial information.

**Incorporate Spatial Information:?**  Yes!  A good way to go about this must include some kind of spatial information about where each subcortical structure "should" be.  This "should" hints at some kind of probabilistic approach.  In fact, we need a probabilistic atlas.  This is where some people might get uncomfortable, because any kind of atlas is made by averaging over many brains, and this average may not be representative of the group that the atlas is used with.  This approach is strong, however, because we can model the probability of a particular structure being in a certain place independently of the intensity.  But we don't want to completely throw intensity away, because if you look at the plot above, you will see that some subcortical structures do have significant differences in intensity.  It's only when we shove everything into a tissue class (e.g., gray matter) that we widen the distribution and lose this distinction.

**Incorporate Neighboring Voxels?:**  This is another way of incorporating spatial information, and it's based on the idea that we generally find structures in the same spots relative to one another.  Instead of just modeling the intensity and prior probabilities of any voxel in the brain belonging to a particular structure, we are going to assess if a voxel is likely to belong to a structure given its neighboring voxels.  For example, if I've labeled a voxel as being in the prefrontal cortex, what is the probability that a neighboring voxel is... part of the cerebellum?  Obviously zero! 😛  But you get the idea.  To do this we will use Markov Random Fields (MRF), which will let us model the probability of a label given the neighboring labels.

### Our Segmentation Approach

1. Calculate the means and covariance matrices of each region of a set of anatomical structures using linear methods to register a brain with an average template
2. Calculate prior probabilities of each anatomical structure with a frequency histogram, and with this we will calculate the probability that any particular label occurs in a certain location
3. Incorporate this prior probability of a particular spatial arrangement of labels into segmentation.

### Model the Segmentation in a Bayesian Framework

We start by modeling the probability of the segmentation, W, given the observed image, I:

P(W|I) = P(I|W)P(W)

The P(W) is the prior information about the segmentation.  Both this P(W) and the probability of the image given the segmentation, for this application, can be modeled in an atlas space, meaning that the function varies depending on where we are in the brain. For example, the probability that a segmentation has a particular region, r, that is equal to some class, c, is represented by:

P(W(r) = c)

What can we say about this?  Since we have many anatomical labels, many of them small,  we can say that for a set region, r (think one voxel in the brain), we can look at all of its potential class labels, c, and most of these are going to have a probability of zero.    The number of possible classes for each location is pretty small (the average is actually around 3, and it rarely is > 4).  This reduces our problem of needing to classify all the voxels in the brain into some 40+ subcortical classes into needing to classify each voxel into maybe 3-4 labels. See, including spatial information is kind of a good idea!  Now we need a function that can take a particular spot in the subject's native space, and find the corresponding spot in the atlas (this is the basic definition of an atlas, period).

### Add in a Function to Map Native Brain Space --> Atlas

In order to use our probabilistic atlases with some person's unique brain, we need to be able to map each voxel in the native brain to the "correct" one in the atlas.  This is our "normalization" step, which lets us relate coordinates across different people.  Let's call this function f(r), and let's place it in the context of our atlas function:

P(W,f|I) = P(I|W,f)P(W|f)P(f)

The equation now says "the probability of a particular segmentation and normalization of a person's brain given the imaging data can be expressed as a function of:

- P(I|W,f):  This is the relationship between the predicted image intensities and the class label.  Unfortunately, this term does depend on specifics of the scanner where the image is acquired, and we reduce this independence by instead modeling this term in terms of the *relationship* between the image intensities (n) and acquisition parameters (b):

P(I|W,f) =P(I(n)|b) * P(b|W,f)

The tissue parameters, b, can be estimated with MR relaxometry techniques, meaning that instead of modeling the conditional densities for each class in terms of the actual image intensities, we model them in terms of the T1 relaxation times for each class.  The second term to the right of the equals sign, the probability of the tissue parameters, can be estimated using manually labeled subjects (more on this in the next section).

- P(W|f): This is the probability of an anatomical class given the spatial location
- P(f): This constrains our atlas functions based on the normalization

again, the terms P(I|W,f) and P(W|f) are going to be probabilistic brain atlases, or prior information.

### How do we make the probabilistic brain atlases?

I keep mentioning these atlases that have prior information about classes for any particular anatomical location.  For most neuroscientists that download software, click on the GUI buttons, and plug and chug their data through an analysis, these probabilistic maps come with the software.  The harsh reality is that at some point, in order to have these atlases, someone had to make them.  There are two possible ways someone might go about this:

- Use an individual as a template brain, and register many other people to this template brain.  In this context, each voxel represents a unique anatomical region.  The problems with this approach, of course, are that we are hugely biased based on whomever we have chosen as the initial template.
- Average across many brains to create a fuzzy picture of the average intensity for each voxel.  This means that we only retain common brain structure.  The problem with this approach is obvious - we remove interesting variation among people.

### Model the intensity distribution for each class, each voxel, as Gaussian:

To address the problematic approaches above, we strive for a method that can preserve information about each class label for each voxel.  We first need to do some dirty work, namely, taking a large set of brains and manually segmenting them into our different classes.  We can then, for a particular voxel, estimate the prior probability for each class, c:

[![fig1](http://www.vbmis.com/learn/wp-content/uploads/2013/08/fig13.png)](http://www.vbmis.com/learn/wp-content/uploads/2013/08/fig13.png)

Now we need to model the intensity distribution for each voxel, r.  If you've ever been bored and randomly modeled the intensities of a particular dataset, the distributions tend to look Gaussian, so we do that.  What do we need to define a Gaussian?  A mean and standard deviation, of course.  The equation below is how we get the mean (muuuu!) for a given location (r) defined over a set of M images:

[![fig1](http://www.vbmis.com/learn/wp-content/uploads/2013/08/fig14.png)](http://www.vbmis.com/learn/wp-content/uploads/2013/08/fig14.png)

The term Ii (I think) is like an indicator variable - in each image, M, we add 1 to the count if the label c occurs at the location r.  Then we divide by M to get an average, our mean.

Then we can get the covariance matrix by plugging in the same terms that we used above to the standard [calculation of covariance](http://www.itl.nist.gov/div898/handbook/pmc/section5/pmc541.htm):

[![fig1](http://www.vbmis.com/learn/wp-content/uploads/2013/08/fig15.png)](http://www.vbmis.com/learn/wp-content/uploads/2013/08/fig15.png)

The above two steps give us the parameters to define a Gaussian intensity distribution for each voxel location, r, for some class c.  So in the context of many classes, we have one of these guys for every single class, for every single voxel location.  Whoa.  This improves upon our "average brain" approach because we don't need to average intensities across classes.

###  Calculate Pairwise "Neighbor" Probabilities

Remember how I mentioned that we want to be able to take some voxel location, r, and model the probability of a certain class given the neighboring classes?  We can also do this using our manually labeled images.  The equation below says that we can estimate the probability of a certain voxel, r, being class c given the classes of the neighboring voxels:

[![fig1](http://www.vbmis.com/learn/wp-content/uploads/2013/08/fig16.png)](http://www.vbmis.com/learn/wp-content/uploads/2013/08/fig16.png)

Each of the ri terms represents one of the neighbor locations of voxel r, and I think the little m just represents our M images.  For the above equation, for each pair of classes, for each voxel, r, we count the number of times that the second class is a neighbor when the first class is defined at the voxel, and divide by the number of times the first class is defined at the voxel.  We have to store these probabilities for each pair of voxels, for each class.  You may be asking, "Wouldn't this make my computer explode?" and the answer is actually no, because a lot of these probabilities will turn out to be zero, and there are very efficient ways in computer science for storing zeros.

### Defining the Function to Normalize Brains, Least Sum of Squared Intensity Differences?

The function mentioned above, f(r), is going to help us to get a rough alignment for people's brains, and this is where we throw in our favorite registration algorithm for our images, M, to some standard template like the Talaraich atlas or MNI template, both created based on the approach of defining a "common brain."  The standard method is to use intensity information (because the images are from the same modality), and align locations in the brain with similar intensities by finding the linear transformation, L, that minimizes the least sum of squared error between an individual's brain (I) and the template brain (T).  This will result in a registration that will likely have different tissues aligned on top of each other for different subjects.

We can actually do better, although we are faced with quite a problem. We want to maximize the probability of the segmentation given an observed image, however neither the alignment function or the segmentation are known.  We would need to maximize the *joint* probability of these two things, again, this equation:

P(W,f|I) = P(I|W,f)P(W|f)P(f)

and the result would be the Maximum a Posteriori (MAP) estimate.  If you read about common methods to go about this (e.g., [Gaussian pyramids](http://en.wikipedia.org/wiki/Gaussian_pyramid)), it comes down to again averaging across smoothed images, which we don't want to do.  So, what should we do?

### Defining f(r) with LSS Intensity Differences with a meaningful subset of voxels!

For hundreds of thousands (or even millions) of parameters, finding an alignment function, L, to minimize the sum of squared error for intensity differences is REALLY HARD.  Could there be a way to drastically minimize the number of paramters that we need to estimate?  Yes!  Let's think back to the equation that calculates the probability of a class for a particular equation, r:

[![fig1](http://www.vbmis.com/learn/wp-content/uploads/2013/08/fig13.png)](http://www.vbmis.com/learn/wp-content/uploads/2013/08/fig13.png)

Although people's brains don't line up *perfectly*, there are actually a good number of voxels (think of voxels toward the center of defined regions) for which this probability approaches 1.  For these voxels, the segmentation is done - we know the class label.  So we can actually come up with a subset of voxels for which our segmentation is "known."  We can now find the alignment transformation, L, that maximizes the likelihood of this sample.

### How do we choose the subset of voxels?

The voxels that we choose for this subset must fit the following criteria:

- Remember that we are working within the scope of one class label, c.  Thus, we choose voxels for which the probability of c is greater for that label than any other label.
- We also choose voxels for which the probability of our class is greater for that particular location than any other location.

This will define a subset of a few thousand voxels, down from hundreds of thousands.  We can now find our affine transform, L, that maximizes the probability of the transform given the segmentation and images:

[![fig1](http://www.vbmis.com/learn/wp-content/uploads/2013/08/fig17.png)](http://www.vbmis.com/learn/wp-content/uploads/2013/08/fig17.png)

We assume that the term P(I|L,W) is normally distributed, defined by the mean and covariance matrix that we calculated earlier.  We can then assess our registration based on looking at the number of classes that are assigned across people for each voxel.  A better registration has fewer (ideally 1), classes.  We now have our equation, L, which is f(r) to map an individual's brain into our atlas.  Now we need to actually assign class labels to each voxel.  This is the problem of segmentation.

### Segmentation (Finally) with Bayesian Methods

As a reminder, the guts of this method are doing a segmentation based on priors (probabilities) about a particular voxel being a class, c, based on 1) **spatial information** and 2) **neighboring voxels:**

P(W,L|I) = P(I|W,L)P(W|L)

### Solving for P(I|W,L)

The term P(I|W,L) is the product of the intensity distributions at each voxel:

[![fig1](http://www.vbmis.com/learn/wp-content/uploads/2013/08/fig18.png)](http://www.vbmis.com/learn/wp-content/uploads/2013/08/fig18.png)

over R voxels in the entire image.  Since we went through and calculated the means and covariance matrices for every class and voxel earlier, we can calculate this product by plugging in these values to a Gaussian density function, specifically:

[![fig1](http://www.vbmis.com/learn/wp-content/uploads/2013/08/fig19.png)](http://www.vbmis.com/learn/wp-content/uploads/2013/08/fig19.png)

Do not be afraid of the equation above!  It's just a mean and covariance matrix for a class c and region r plugged into a standard [Gaussian density function](https://en.wikipedia.org/wiki/Normal_distribution).  We plug in these values for each voxel in our space of R voxels for a given class C, take the product, and this gives us our value for P(I|W,L).  Now all that is left to solve for P(W|I,L) is to find P(W|L), or the prior probability of a given label.  This is where we look to the neighbors, and use a Markov model.

### Solving for P(W|L)

The Markov assumption says that we can calculate the prior probability of a label at a given voxel, r, based on the voxels in its neighborhood, in the set {r}:

[![fig1](http://www.vbmis.com/learn/wp-content/uploads/2013/08/fig110.png)](http://www.vbmis.com/learn/wp-content/uploads/2013/08/fig110.png)

I'm not great in my knowledge of statistical distributions, however there is a particular one called a "[Gibbs distribution](http://en.wikipedia.org/wiki/Gibbs_measure)" that embodies this Markov assumption, so we can equivalently model the P(W) using this distribution:

[![fig1](http://www.vbmis.com/learn/wp-content/uploads/2013/08/fig111.png)](http://www.vbmis.com/learn/wp-content/uploads/2013/08/fig111.png)

I won't go into the details, but Z is a normalizing constant, and U(W) is an energy function (see the paper linked at the beginning of the post for a more satisfactory explanation).  This allows us to write the probability of the segmentation as the product of the probability of the class at each location, given the neighborhood:

[![fig1](http://www.vbmis.com/learn/wp-content/uploads/2013/08/fig112.png)](http://www.vbmis.com/learn/wp-content/uploads/2013/08/fig112.png)

This would be computationally impossible to implement, so instead we model the dependence of a label on its neighbors based on the probability of the label given each of the neighbors:

[![fig1](http://www.vbmis.com/learn/wp-content/uploads/2013/08/fig113.png)](http://www.vbmis.com/learn/wp-content/uploads/2013/08/fig113.png)

Now we can plug in the above into the long second term in our equation for P(W) (two equations up) to get a final equation for the prior probability of a segmentation:

[![fig1](http://www.vbmis.com/learn/wp-content/uploads/2013/08/fig114.png)](http://www.vbmis.com/learn/wp-content/uploads/2013/08/fig114.png)

- P(W(r)): tells us the probability of a particular structure being in a location, r.
- The term in the second product gives us the probability of the structure given the neighbors labels.  Now we have our P(W), and we can use the [iterated condition modes](http://en.wikipedia.org/wiki/Iterated_conditional_modes) (ICM) algorithm to find the label, c, that maximizes the conditional probability.  This procedure is done iteratively until no voxels are changed (and this is covergence).

There are some pre and post-processing steps [detailed in the paper](https://surfer.nmr.mgh.harvard.edu/ftp/articles/fischl02-labeling.pdf), however the above summarizes the general approach.  We would now have a segmentation of an individual's brain for each voxel, r, into different classes, c, using probabilistic atlases that incorporate spatial and neighborhood information.

### On to Freesurfer!

We can now venture into subcortical segmentation in freesurfer with a little more understanding of what is going on under the GUI, and come up with beautiful delineations, as shown below, demonstrating the method in action.  And (hopefully) we can build on this understanding to extend the tools for our particular goals.

[![freesurfer](http://www.vbmis.com/learn/wp-content/uploads/2013/08/freesurfer-785x509.png)](http://www.vbmis.com/learn/wp-content/uploads/2013/08/freesurfer.png)
