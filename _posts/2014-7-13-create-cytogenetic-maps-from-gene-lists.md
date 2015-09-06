---
title: "Create Cytogenetic Maps from Gene Lists"
date: 2014-7-13 21:19:20
tags:
  chromosomes
  cytogenetic-map
  genes
  visualization
---


I have two or more lists of genes that I want to compare.  If I compare strings directly, I could run into trouble if there is slight variation (e.g., SLC6A4 vs. SLC6A9).  I could also look at functional annotation, but that still doesn’t give me a nice visualization of “how close are these two sets?.” What I basically want is a nice snapshot of where the genes are in relation to one another.


## **This is a job for… Cytogenetic Mapping!**

A cytogenetic map [historically means chromosomes stained under a microscope](http://www.ncbi.nlm.nih.gov/Class/MLACourse/Original8Hour/Genetics/cytogenetic.html).  Let’s be real.  Most of us don’t work with microscopes, and thus a cytogenetic map is simply a mapping of something (genes, SNP’s, etc) to chromosomes.  I would like to create these maps with d3 (to allow for interactive graphics), however a rule of thumb when you are a noob at anything is to start simple.  So today we will do the following:

1. Start with gene lists
2. Look up chromosome id and position
3. Create a static cytogenetic map with  an easy-to-use software solution

**An important note! We will be mapping the **starting position** of genes, since we are working with full genes and not SNPs. This means that the genes may take up more real estate on the chromosomes than the map indicates.


## Writing a Script in R

R can do my laundry for me, so it sure as heck can do this simple task:

code


## Creating the Map

You can combine different gene lists from the output files if you want more than one phenotype in your map.  It’s then simply a matter of [using this tool to show you map](http://visualization.ritchielab.psu.edu/phenograms/plot).  It’s so easy! [![phenogramDisorderSubset](http://vsoch.com/blog/wp-content/uploads/2014/07/phenogramDisorderSubset-1024x682.png)](http://vsoch.com/blog/wp-content/uploads/2014/07/phenogramDisorderSubset.png)


## When is this a good idea?

I’m not great at visualization, but I want to be.  The first question I’ve been asking myself is “What do I want to show?” I think it’s easy to get sucked into wanting to make some crazy cool network without actually thinking about what you are trying to communicate to your viewer.  Don’t do that!  Once you know what you want to show, the second question is “Does this strategy achieve that?”  We already know we want to show physical proximity for different gene sets, if we can justify that closeness == relatedness.  With this in mind, when will the static cytogenetic map be a good visualization strategy?  It will be good when…

- **you have a small number of genes or SNPs**: too many things to plot means a visually overwhelming graphic that just isn’t that meaningful
- **you have more phenotypes: **The strength of this visual is to show the relationship between multiple phenotypes
- **chromosome position is meaningful: **if physical closeness isn’t useful or related to what you are trying to show, this is pretty useless

 


## How can I do better?

This is a good start, but I’d really like this interactive.  I’ll start by incorporating these static plots into a d3 visualization, and ultimately (hopefully) have these maps be integrated into the d3 as well.  As always, start simple, and grow from that! ![:)](http://vsoch.com/blog/wp-includes/images/smilies/simple-smile.png)


