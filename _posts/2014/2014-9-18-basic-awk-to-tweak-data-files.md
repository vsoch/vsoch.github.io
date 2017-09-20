---
title: "Basic awk to tweak data files!"
date: 2014-9-18 00:08:36
tags:
  awk
  code
  script
  vcftools
---



# Making an Annotation File for Genes

I had the task to make a little annotation file (for use with vcftools) to annotate a big list of SNPs with genes, because  
 I don’t speak “SNP” language. This turned into having fun with awk and text files, and I wanted to share what I learned.

We could easily get chromosome positions using R, but I happen to know that my diabolical lab mate had so nicely provided a file with positions for 827 autism genes, and so we will use this file. Thanks Maude!! You will have to ask her if you want this file, but I’ll just give you a preview of what the format looks like:

<pre>
<code>
Ensembl Gene ID,Gene Start (bp),Gene End (bp),HGNC symbol,Chromosome Name,EntrezGene ID
ENSG00000162068,2471499,2474145,NTN3,16,4917
ENSG00000275351,54832726,54848250,KIR2DS4,CHR_HSCHR19KIR_G085_A_HAP_CTG3_1,3809
ENSG00000271771,34158121,34158767,,5,
</pre>
</code>


And for our file to do gene annotations with vcftools, we want it to match this format, and we want to get it in this format

<pre>
<code>
#CHR     FROM   TO      ANNOTATION 
1        12345  22345   gene1
1        67890  77890   gene2
</pre>
</code>

Time for some awk magic!!

<pre>
<code>
awk -F"," 'NR!=1{print $2,$5,$3,$4}' OFS="\t" all_chrom_position.txt > AU-827.annot
</pre>
</code>

Let’s talk about the command above. The -F command tells awk that the file is separated by commas. The NR!=1 command says that we want to skip the first line (this is the old header). The {print $2,$5,$3,4$} says that we want to print the 2nd, 5th, 3rd, and 4th column. Finally, OFS=”\t” indicates an output field separator to print, and the final appendage of > AU-827.annot has all that screen output concat into the file “AU-827.annot”

Don’t freak out – putting the starting chromosome position first was intentional because we want to sort the file by that.

<pre>
<code>
sort -t\t -nk1 AU-827.annot > AU-827-sorted.annot
</pre>
</code>

The -t\t tells sort that the file is tab delimited. The -nk1 tells to sort by the first column, and it’s a number.

Now we can put it in the correct order (if it even matters, might as well!)

<pre>
<code>
awk -F"\t" '{print $2,$1,$3,$4}' OFS="\t" AU-827-sorted.annot > AU-827.annot
</pre>
</code>

Let’s get rid of the annotations for which there are no gene names (I don’t know if Maude meant to include these or not!)

<pre>
<code>
awk -F'\t' '$4 != ""' AU-827.annot > AU-827-filter.annot
bgzip AU-827-filter.annot
</pre>
</code>

If you wanted to add a header, you could do it like this (although we don’t need to)

<pre>
<code>
#CHR FROM TO ANNOTATION
awk 'BEGIN{print "#CHR\tFROM\tTO\tANNOTATION"}1' AU-827-sorted.annot > AU-827-header.annot

vim AU-827-header.annot

#CHR    FROM    TO      ANNOTATION
KI270752.1      144     268
MT      577     647     MT-TF
MT      648     1601    MT-RNR1
KI270724.1      1529    1607
</pre>
</code>

Omg. So awesome.

NOW we can annotate our vcf file with the genes! First, we need to get rid of the ones that we don’t have gene names for (sadface). We know that each line SHOULD have 4 things, so let’s get rid of ones that do not.

<pre>
<code>
awk -F'\t+' 'NF == 4' AU-827-header.annot > AU-827-header-filter.annot
bgzip AU-827-header.annot

# Now convert to tabix (indexed) format:

tabix -p vcf AU-827-header.annot.gz
vcf-annotate -h

cat AU-merged.vcf | vcf-annotate -a AU-827-header.annot.gz -d key=ANNOTATION,ID=ANN,Number=1,Type=Integer,Description='GENE' -c CHROM,FROM,TO,INFO/ANN > test.vcf

#CHR FROM TO ANNOTATION
16 2471499 2474145 NTN3
</code>
</pre>

This is where I stopped at this point, because the script writing algorithm in my brain told me I should do these steps in R instead, and I agreed!
