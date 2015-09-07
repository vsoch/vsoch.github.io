---
title: "Look up Probe IDs with Bioconductor"
date: 2014-6-08 23:34:49
tags:
  annotation
  bioconductor
  gene
  probe
  r
---


This is one of those “I’ll store this here for safekeeping” posts, specifically for a snippet of code to seamlessly translate between gene probe IDs.

I started doing genomic analyses at the beginning of the calendar year, 2014. Before delving in I was under the naive impression that genes existed in a cleanly defined set, each with a unique name, and of course, plenty of documentation. Little did I know such thoughts were fantastic! There are more probe IDs than I know what to do with. And of course the format that I’m currently working with is not the format that I need. This calls for easy ways to convert IDs between formats.

What did I do first? I found a [few](http://idconverter.bioinfo.cnio.es/) [places](http://david.abcc.ncifcrf.gov/conversion.jsp) to convert IDs. My browser would hang for hours on end, and sometimes return a result, sometimes not. Inputting smaller set sizes was arduous and annoying.  I’m sure that’s where every poor noob soul browser goes to cough and die.

Silly me, silly me. The same can be accomplished programmatically, of course! Bioconductor is quite amazing.

<pre>
<code>
# Install and load packages
source("http://bioconductor.org/biocLite.R")
biocLite(c("hgu95av2.db", "GO.db"))
library(AnnotationDbi)
library("GO.db")
library("hgu95av2.db")

# What kind of IDs can I choose from?
keytypes(hgu95av2.db)

# What does an ACCNUM Id look like?
head(keys(hgu95av2.db, keytype="ACCNUM"))

# Now GIVE ME DATA FRAME that goes from my ids (accnum) to the gene symbol (for gsea chip file)
test = select(hgu95av2.db, as.character(genes$GB_ACC), "GENENAME", "ACCNUM")

# What is the result?
head(test)
ACCNUM SYMBOL
1 AB000409 MKNK1
2 AB000463 SH3BP2
3 AB000781 KNDC1
4 AB001328 SLC15A1
5 AB002294 ZNF646
6 AB002308 SEC16A
</pre>
</code>


