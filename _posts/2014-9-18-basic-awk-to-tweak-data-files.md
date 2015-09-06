---
title: "Basic awk to tweak data files!"
date: 2014-9-18 00:08:36
tags:
  awk
  code-2
  script
  vcftools
---



# Making an Annotation File for Genes

I had the task to make a little annotation file (for use with vcftools) to annotate a big list of SNPs with genes, because  
 I don’t speak “SNP” language. This turned into having fun with awk and text files, and I wanted to share what I learned.

We could easily get chromosome positions using R, but I happen to know that my diabolical lab mate had so nicely provided a file with positions for 827 autism genes, and so we will use this file. Thanks Maude!! You will have to ask her if you want this file, but I’ll just give you a preview of what the format looks like:

code

And for our file to do gene annotations with vcftools, we want it to match this format:  
 And we want to get it in this format

code

Time for some awk magic!!

 au-827.annot ">code

Let’s talk about the command above. The -F command tells awk that the file is separated by commas. The NR!=1 command says that we want to skip the first line (this is the old header). The {print $2,$5,$3,4$} says that we want to print the 2nd, 5th, 3rd, and 4th column. Finally, OFS=”\t” indicates an output field separator to print, and the final appendage of > AU-827.annot has all that screen output concat into the file “AU-827.annot”

Don’t freak out – putting the starting chromosome position first was intentional because we want to sort the file by that.

code

The -t\t tells sort that the file is tab delimited. The -nk1 tells to sort by the first column, and it’s a number.

Now we can put it in the correct order (if it even matters, might as well!)

 au-827.annot ">code

Let’s get rid of the annotations for which there are no gene names (I don’t know if Maude meant to include these or not!)

 au-827-filter.annot bgzip au-827-filter.annot ">code

If you wanted to add a header, you could do it like this (although we don’t need to)

 au-827-header.annot vim au-827-header.annot #chr from to annotation ki270752.1 144 268 mt 577 647 mt-tf mt 648 1601 mt-rnr1 ki270724.1 1529 1607 ">code

Omg. So awesome.

NOW we can annotate our vcf file with the genes! First, we need to get rid of the ones that we don’t have gene names for (sadface). We know that each line SHOULD have 4 things, so let’s get rid of ones that do not.

code

# Now convert to tabix (indexed) format:

code

This is where I stopped at this point, because the script writing algorithm in my brain told me I should do these steps in R instead, and I agreed!


