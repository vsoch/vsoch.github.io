---
title: "FDR Correction"
date: 2013-6-12 20:03:08
tags:
  correction
  false-discovery-rate
  fdr
  p-value
  q-value
---


The False Discovery Rate (FDR) is a method used to correct for multiple comparisons in a statistical test. It is abstractly a method that gives us the idea of the false positive rate not for one single hypothesis, but for the entire set. For example, if we have brain imaging data and are doing a voxel-wise two sample T-test to look for significant differences between two groups, we are essentially testing a single hypothesis at every single voxel. Let's say that we have 86,000 voxels. Each of these voxels can be thought of as a feature, with the identifying information being the x,y,z coordinate.

Let's say that we have two groups, Elevator Repairmen and Opera Singers, and we have structural imaging data and want to know if there are any brain regions with gray matter volumes that are significantly different. The outcome that we are generating is, for each voxel, "yes, the group means are different" or "no, the group means are not different." If we do our 2 sample T-test to compare the means of the two groups at each voxel, then we will get 86,000 p-values. How do we know which ones are significant, meaning that the difference is likely not due to chance?

Well of course, if it's less than .05, that means it is significant, right? That means that there is less than a 5% chance that, for each test, we have a 5% chance of having a false positive. Wait a minute... compounded by 86,000 voxels? This means that 5% of our 86,000 voxels are expected to be false positive, which is simply not acceptable. What we need is a standard metric that represents our chance of having a false positive across the entire hypothesis space. Introducing, the FDR, false discovery rate!

The False Discovery Rate (FDR) looks at the distribution of p-values to provide information about the type I error rate across the entire brain, represented by a q-value. What is the difference between a q-value and a p-value? From the literature:

**Given a rule for calling features significant:**

> "...the false positive rate (p-value) is the rate that truly null features are called significant  
>  The FDR (q-value) is the rate that significant features are truly null."
> 
> "A false positive rate of 5% means that, on average, 5% of the truly null features in the study will be called significant. An FDR of 5% means that among the features called significant, 5% of them will be truly null."
> 
> "a q-value threshold is the proportion of features that turn out to be false leads."

It is intended to both maximize finding significant results while minimizing false positives. You can use a Matlab function, mafdr, with a vector of p-values to get a q-value for each one. How are these two related?

- as p-values increase, q-values also increase (or stay the same)
- we choose a q-value threshold (between 0 and 1) that represents
- "the fraction of p-values with q-values equal to or less than this q-value which, when called 'significant,' are actually bogus." - Dan Golden

This gives us confidence that if we have actual signal, we will have low q-values. If we set our q-value threshold at .05, then we label features (voxels) at or less than .05 as significant, and we can be confident that 95% of our features are probably true positives, and 5% false positives. And you can share your q-value threshold with other researchers to let them decide if they like the result or not.

**In a nutshell**

FDR is an estimate of the percentage of false positives among the categories considered enriched at a certain p-value cutoff. This is calculated by performing the same analysis on your test data and permuted data. The number of positive results in the permuted data at a given threshold is considered the number of false positives you expect to get if using that threshold for your test data, so the rate is just the number of positives in the permuted data divided by the number of positives in the test data at a given cutoff.

<span style="text-decoration: underline;"># positive permutations</span>              @ a particular cutoff  
 # positive tests

**Why you should not publish without FDR:**

- It's hard to prove/disprove false results - studies without significant findings don't get published.
- Lots of time and money could be wasted trying to prove a result that never existed in the first place.

**Why not Bonferroni?**  
 In fMRI, since we like to smooth things, there are very likely spatial correlations, and Bonferroni (dividing the p-value by the number of hypotheses, N) does not take this into account.

**Functions and Resources**

- [Matlab FDR Function](http://www.mathworks.com/help/bioinfo/ref/mafdr.html)
- [Significant Signal in fMRI of an Atlantic Salmon](http://www.jsur.org/ar/jsur_ben102010.pdf) (why you need to use FDR)!
- [Statistical Significance for Genome Wide Studies](http://www.pnas.org/content/100/16/9440.long "Statistical Significance for Genome-wide Studies")
- [The Principaled Control of False Positives in Neuroimaging](http://scan.oxfordjournals.org/content/4/4/417.full)


