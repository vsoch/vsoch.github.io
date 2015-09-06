---
title: "Introduction to Gephi"
date: 2014-4-24 22:00:35
tags:
  
---


This is a guest post by my diabolically awesome lab-mate Maude, who is very experienced using the software Gephi to make beautiful network visualizations.


## 


## How to use Gephi ?

Here I try to describe the procedure I used in a few steps, to help you to start with this pretty easy and awesome software.


## 


## 1/ [Download Gephi](https://gephi.org/users/download/)

(no you don’t need to donate)  
 (well you can)


## 


## 2/ What does it do ?

It is an Open Source Software for Exploring and Manipulating Networks . It uses a force-directed graph drawing algorithms based on a linear-linear model (attraction and repulsion proportional to distance between nodes) . The (attraction,repulsion)-model of ForceAtlas has an intermediate position betweenNoack’s LinLog (technical university of Cottbus) and the algorithm of Fruchterman and Rheingold.  Basically: the higher is the number that linked 2 nodes = the edge, the closer they will appear on a graph. The smaller, the more apart the nodes will be.


## 


## 3/ File format.

The format that works well and I use is a matrix, separated by semi colon ( check for format error with wrangler is a good way to avoid a lot of problem, needs to be “unix” and the first column and raw needs to be empty, and make sure you don’t have any spaces in the names)

You can basically apply this software for any matrix. But I think it is more interesting to determine the correlation between variables based on solid correlation stats, and with the network making some sense (positive/negative correlations…..) Below is an example.


## 


## 4/In the example of Vanessa:

1. For each gene set that were significantly enriched ( 4 different ones) Vanessa gave the list of genes with the ES value (=enrichment score) which gives an idea of the ranking of the genes in the list when the GSEA is performed.
2. Which mean that we keep all the genes in the gene sets, but we attribute them their ES.
3. Perform Shapiro test: here, out of 200 genes 12 were not normal , so I kept going (5% ? not bad)
4. Then use a Pearson test to determine if there was a correlation. And corrected the p-value ( FDR, ade4 package, local variation)
5. Build a matrix.

**Which value did I put in the matrix? **

- I built it with all the correlations tested = symmetric
- I appended the r scare of the Pearson tests performed
- I brought to zero the r scare of the correlations that where not significant after p value correction
- I added in front the sign of the r value of the pearson ( negative or positive regressive slope)

That way : the lowest value is -1, the highest +1, and the non correlated zero, which is what Gephi is trying to take in account.

[![ASDgrouping](http://vsoch.com/blog/wp-content/uploads/2014/04/ASDgrouping-1024x723.png)](http://vsoch.com/blog/wp-content/uploads/2014/04/ASDgrouping.png)

 


## What is the purpose of this ?

To see which genes are together at the beginning of the list of at the end, or if some genes are at the end when some other are at the beginning i.e. they are negatively correlated.


