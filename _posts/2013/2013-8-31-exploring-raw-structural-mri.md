---
title: "Exploring Raw Structural MRI"
date: 2013-8-31 19:33:31
tags:
  brain-structure
  mri
  vbm
---


I'm happy to report that I've passed my Qualifying exam, and so the past week has largely been filled with what I consider "fun" work, e.g., playing with data with no pre-defined goal or purpose, and reading about methods just for the heck of it.  Before I delve into some basic data exploration I want to recommend two things.  **1)** Andrew Ng's [Deep Learning tutorial](http://ufldl.stanford.edu/wiki/index.php/UFLDL_Tutorial) as a good place to start learning about how to implement such algorithms, and **2)** the [radiolab podcast](http://www.radiolab.org/) as just a wonderful show to learn about unexpected topics in the frame of narrative intermixed with interview and humor.

### Voxel Based Morphometry to assess Differences in Brain Structure

The commonly used method to derive maps of gray, white, and csf volumes for each little cube (called a voxel) in the human brain is called [Voxel Based Morphometry](http://en.wikipedia.org/wiki/Voxel-based_morphometry).  This method starts with a structural scan (a T1 image), and some of the outputs include maps of volumes, where each voxel numerical value represents the amount of the tissue type within the voxel in cubic mm.  The maps are also normalized to a standard template, so you could do statistical tests with a group of individuals to assess for significant differences in the volumes of a particular matter type.  And to answer the questions that you are thinking, yes we must correct for multiple comparisons because we are testing a hypothesis at each voxel, and yes, people have differently shaped brains, and so the normalized maps are modulated to account for whatever smooshing and scaling was done to fit the template.  This method is the bread and butter, or at least a starting point, for most structural analysis.

### Distribution of Gray, White, and CSF Matter in the Human Brain

I've used this method many times before, and mostly that meant building a solid pipeline with careful preprocessing, registration checking, and derivation of the resulting maps for my data.  What I haven't done, and have been dying to do, is just playing around with the data.  I'm sure that these simple questions were investigated long ago and so no one bothers to ask them anymore, but hey, I want to ask!

**1.  What is the distribution of each matter type in the human brain?**

I really just wanted to plot each matter type, and compare, and so I did.  The charts below are reading in each of the maps, and then plotting a histogram for only nonzero voxels, with 100 bins:

[![matter_volumes](http://www.vbmis.com/learn/wp-content/uploads/2013/08/matter_volumes-785x207.png)](http://www.vbmis.com/learn/wp-content/uploads/2013/08/matter_volumes.png)

From this we see that most of the brain is gray matter.  But I kind of wanted to get a sense of the distribution of different matter types, on a regional basis.

**2.  How does the composition of gray, white, and csf vary by region?**

So I registered the [AAL atlas](http://www.gin.cnrs.fr/spip.php?article217) template (consisting of 116 regions) to my data, and then calculated a mean volume for each region, and then plot them in 3D.  (Just as a side note, this data is registered to one of the [icbm templates](http://www.bic.mni.mcgill.ca/ServicesAtlases/ICBM152NLin2009), so getting the AAL atlas in the space of my images meant registering to that).  You probably need to click on this to see the larger version:

[![regional_matter](http://www.vbmis.com/learn/wp-content/uploads/2013/08/regional_matter-785x383.png)](http://www.vbmis.com/learn/wp-content/uploads/2013/08/regional_matter.png)

Most voxels are, as you would guess, a mixed bag of tissue types.  It's cool that, depending on the partition of the cerebellum we are looking at, there is a pretty big range of gray matter composition.  Actually, the plot is kind of misleading because it doesn't show the range of white matter.  Let's get rid of csf and just look at gray vs. white matter:

[![gray_vs_white](http://www.vbmis.com/learn/wp-content/uploads/2013/08/gray_vs_white-785x364.png)](http://www.vbmis.com/learn/wp-content/uploads/2013/08/gray_vs_white.png)

Remember that these are mean regional values, which is why the range looks smaller than before.  We again see the nice range of gray matter in the cerebellum, and it makes sense that there is a sort of inverse relationship between the two.  But how does this compare between people?

**3.  How does the composition of gray, white, and csf vary by region for many people?**

Let's take a look at the fuzzy chart that we get when we plot ll 116 regions for... 55 brains!

[![regional_volumesn55](http://www.vbmis.com/learn/wp-content/uploads/2013/08/regional_volumesn55.png)](http://www.vbmis.com/learn/wp-content/uploads/2013/08/regional_volumesn55.png)

It looks like a sneeze cloud, and given the huge number of regions, we only see some clustering in the outskirt regions.

**4.  How does composition (represented by percentages, and not volumes)  vary by region?**

I have a better idea.  Instead of plotting the matter amount in cubic mm, let's calculate and plot the percentage of matter in each region.  I think we will see a nicer clustering:

[![brain_comp](http://www.vbmis.com/learn/wp-content/uploads/2013/08/brain_comp.png)](http://www.vbmis.com/learn/wp-content/uploads/2013/08/brain_comp.png)

We sure do!  it's still largely a mixed bag, but this rescales it to give better defined clusters.  For each region (distinct colors above) the percentage of white + gray + csf (not shown) must sum to 1.  It's interesting to see that there is nice variation within each region, depending on the person.  Could we predict the region based on these values?

**5.  Can mean tissue composition distinguish regions?**

Based on the pictures above, I would guess that the answer is no for most of the data.  But I thought I'd give it a try anyway!  I used linear discriminant analysis to build a classifier to predict region label based on mean regional values for tissue composition.  I hypothesized that using the percentage of each matter type (the chart directly above) would do slightly better than using raw, modulated volumes (two charts up), and that both (given the huge overlap that we see) would do rather poorly.  Glancing at the data above, I decided to use linear instead of quadratic discriminant analysis because I think it's safe to assume the same covariance matrix.  Since I don't have a separate test dataset (and deriving one would take many hours of processing and space on my computer that I just don't have), I decided to just use leave one out cross validation, make a prediction for each person's set of three mean values (corresponding to one label out of 116) to calculate an overall accuracy.  116 labels is a lot.  And there is a lot of overlap.  Still, I was surprised that for the above chart, the accuracy was 31%.  Each region has 55 sets of values, and there are 116 regions, so actually I think that's pretty good given the sillyness of this problem of predicting brain region based on percentage matter composition.  Who were our top performers?  The values here are the percentage that we got right:

code

Wait a minute, in using these 116 AAL labels, we have separate labels for the same region on the left and right hemispheres of the brain, as well as different "sub" regions.  What if we do away with this detail and instead use the same label for regions on corresponding sides of the brain, as well as subregions?  Yeah, let's try that! 😀  Woohoo! Accuracy increases to... a still dismal 37%.  But it increases!  Here is what the data now look like:

[![55regions](http://www.vbmis.com/learn/wp-content/uploads/2013/08/55regions-785x486.png)](http://www.vbmis.com/learn/wp-content/uploads/2013/08/55regions.png)

I still contend that is pretty good.  What if we go up another degree and combine subregions?  Here is what it looks like for 30 regions:

[![30regions](http://www.vbmis.com/learn/wp-content/uploads/2013/08/30regions-785x454.png)](http://www.vbmis.com/learn/wp-content/uploads/2013/08/30regions.png)

Oh dear, this isn't going to be good - in combining all the different parts of the frontal and parietal lobes, for example, we've actually lost information in combining regions that do have different matter compositions, and telling our learning algorithm that they are the same.  In fact, accuracy drops to 8%.  Oh dear.

**6.  Can tissue composition distinguish disorder type?**

It's not so useful to predict brain region based on matter composition.  A better question might be something about the people.  How about a disorder?  I will reveal to you that this data is a subset of NDAR, and so this is a mixed cohort of ASD (autism spectrum disorder) and healthy controls.  While we know that ASD have significantly larger brains, I don't think that we would find meaningful differences with regard to the compositions, represented by percentages.  Still, I'd like to try.  (Going back to the original 116 labels) first I visualized each region, and added a label to distinguish disorder type.  Zero (0) == healthy control, and 1, 2, and 3 correspond to different severity of ASD.  Here, for example, is what most of these plots looked like:

[![postcentral](http://www.vbmis.com/learn/wp-content/uploads/2013/08/postcentral.png)](http://www.vbmis.com/learn/wp-content/uploads/2013/08/postcentral.png)

I'm not sure how well we could do using these features to predict disorder... it's hard to tell from looking at the plots individually.  I actually think it would be more meaningful to predict specific behavioral traits (e.g., anxiety, impulsivity, that sort of thing) because I'm not a huge fan of the DSM labels to begin with.  I want to try building a classifier, but first I want to explore functional data.  From the investigation above we can see that there is variation in volumes / percentages, but the question is now if this variation is meaningful.  With this in mind, each of my values for gray, white, and csf for each region becomes a unique feature.  But what will I use for functional data features?  What is normally done in region based analyses is to extract an average timeseries across the region.  But is that a good idea?  Does a mean timeseries truly reflect the entire region?  Methinks that another investigation is in order before making this classifier, and I'll also put that investigation in its own post.  Yes, I do have resting BOLD data for these individuals, and yes I've already done all the preprocessing to have nice filtered, normalized brains over time (what else is a girl supposed to do with a long weekend? :P)

Just kidding, don't answer that!

I will do some functional investigation, and then we will combine these two feature sets to try building a bunch of different classifiers.  Cool cool!
