---
title: "Analysis of Affymetrix .CEL Files"
date: 2014-3-17 23:01:53
tags:
  affymetrix
  genetics
  microarray-expression
---


I've been working with microarray expression data from the Broad Connectivity Map, and of course decided to download raw data (to work with in R) over using their GUI. The raw data is in the form of “.CEL” files, which I believe are produced by the Affymetrix [GeneChip System](http://icahn.mssm.edu/static_files/MSSM/Images/Research/Labs/Life%20Science%20Technology%20Laboratory/affymetrix_genechip_system.jpg "GeneChip"). What in the world? Basically, we can evaluate mRNA expression of thousands of genes at once, which are put on one of those cool chips. I'm not going to claim to know anything about the preparation of the DNA - that's for the wet lab folk :). What is important to me is that this machine can scan the array, analyze the images, and spit out [expression profiles](http://dept.stat.lsa.umich.edu/~kshedden/Courses/Stat545/Notes/AffxFileFormats/cel.html, "expression profiles") For more details, here is [the reference](http://icahn.mssm.edu/research/labs/life-science-technology-laboratory/projects-and-grants/applications/affymetrix-genechip-technology) I was reading. For Affymetrix methods (implemented in Bioconductor), I will reference [this document](http://media.affymetrix.com/support/technical/whitepapers/sadd_whitepaper.pdf).

Instead of going through the pain of formatting code for this blog, I created an RMarkdown and published on RPubs.  So much easier!  Note that toward the end I filtered my data based on the affymetrix IDs that I had entrez IDs for (to submit to gene ontology (GO), and you of course don't have to do this, and can cluster without filtering.


## [Analysis of Affymetrix .CEL Files](http://rpubs.com/vsoch/meanalysis)


