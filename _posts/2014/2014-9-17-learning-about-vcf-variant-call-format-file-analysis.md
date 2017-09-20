---
title: "Learning about VCF (variant call format) file analysis"
date: 2014-9-17 23:57:28
tags:
  common-model
  genetics
  rare-variant-model
  research
  snp
  variant-call-format
  vcf
---


If you just want to learn from the scripts I’m working on: [SCRIPTS](https://github.com/vsoch/vvcftools/blob/master/parseVCF.sh)  
 And as a subset of this post, if you want to learn about using awk to [work with text files](http://vsoch.com/blog/2014/09/basic-awk-to-tweak-data-files/)


# What is variant analysis?

We all know that our genes have a lot to say about phenotype: we spend countless time and money to search for genetic markers that could predict disease, and in the future we would want to be able to change these markers to prevent it. We also have different theories for how we think about the relationship between genes and disease. The **common variant model** of disease says that there are a bunch of variations in our genetic code that are pretty common, and it’s when you get a particular combination of these common variants that you develop disease.  The **rare variant model** says that disease can be accounted for by a much smaller number of rare variants (perhaps that are only present in an individual or family.)  I’m not going to state that one is more right than the other, however my opinion is that the rare variant model makes more sense in the context of diseases like autism for which we still haven’t found a “genetic signature” in the most typical places to look.  Where are those places? We typically look at protein coding sequences of the genome (called the “exome”), across a bunch of single nucleotide polymorphisms (SNPs) [[snpedia](http://www.snpedia.com/index.php/SNPedia)].  What are we looking at, exactly?

When we look at someones genetic code, you may remember that genes are made of the base pairs ATCG, called nucleotides. And you may also know that while we are all very similar in this sequence, there are random insertions, deletions, or other kinds of variation that happens. Is this good or bad? Well, a lot of the mutations don’t really do anything that is totally obvious to us. However, sometimes if a mutation changes the function of a gene (meaning that a protein is not coded, or is coded differently), this could lead to phenotypic changes (some of which might be linked to the disease!) So when we want to study diseases (and possible find explanations for them), we are interested in finding these mutations.  So in a nutshell, “variant analysis” is looking at variations in our genetic sequence, and hoping to link those variations to disease.


# What is a vcf file?

In biomedical informatics we are very good at making standard file formats. A vcf file is just a formatted text file in “[variant call format](http://en.wikipedia.org/wiki/Variant_Call_Format),” meaning that it is full of information about variants!  And here we are at this post.  I need to learn how to parse a vcf file to find rare variants. First let me (broadly) set up the analysis that I want to do:

1. Define a threshold of “rare” to be represented in <1% of the population
2. Extract these rare variants
3. Filter down the set to only include deleterious or important
4. Map these variants to genes
5. Add in some (intelligent?) weighting, (to be thought about later)
6. DAVID (more on this later)

The first step is to get a vcf file. I am using one from our autism dataset.

Next, we should decide how to work with this file. It is again notable that the file is just a text file – there is nothing magic or compiled about it :) This means that if we wanted, we could write our own script with bash, python, R, etc. However, there are already tools that are made for this! Let’s download (and learn) the [vcftools](http://vcftools.sourceforge.net/downloads.html) and a nice little package for working with big text tables called [tabix](http://sourceforge.net/projects/samtools/files/tabix/).

First, get the vcftools with subversion:

<pre>
<code>
svn checkout http://svn.code.sf.net/p/vcftools/code/trunk/ vcftools
</pre>
</code>

Note this means you can always then cd to your vcftools directory and type “svn update” to do exactly that. Once we have the tools, we need to compile for perl. CD to where you installed them:

<pre>
<code>
cd /home/vanessa/Packages/vcftools

# Export the path to the perl subdirectory:  
export PERL5LIB=/home/vanessa/Packages/vcftools/perl/

# and (in the vcftools directory), compile!  
make  
</pre>
</code>

Now for tabix, download and extract/unzip to your Packages folder

<pre>
<code>
cd tabix-0.2.6
make
</pre>
</code>

Now we need to add the tools to our path:

<pre>
<code>
vim /home/vanessa/.profile

# Add vcftools to path
VCFTOOLS=/home/vanessa/Packages/vcftools
export VCFTOOLS
PATH=$PATH:$VCFTOOLS/bin

# Add tabix to path
TABIX=/home/vanessa/Packages/tabix-0.2.6
PATH=$PATH:$TABIX
export PATH

# (now exit)
</pre>
</code>

Now source the bash profile to adjust the path

<pre>
<code>
source /home/vanessa/.profile
</pre>
</code>

and now when you type “which vcftools” you should see:

<pre>
<code>
/home/vanessa/Packages/vcftools/bin/vcftools
</pre>
</code>

Good job!


# Why do we have vcf files?

Again, the variant call format (vcf) is a text file for storing gene sequence variations. Why did someone come up with it? Well, if we stored an ENTIRE genome, that is a MASSIVE file. Someone smart a while back figured out that we could store a “standard human genome” (we call this a reference), and then a second file (the vcf) that describes how one or more people vary from this reference. It starts with lots of header fields for meta information, and then is basically rows and rows of variants, each of which has meta information of its own! Let’s take a look at what this might look like. I’m going to steal this right off of wikipedia:

The junk at the top with ## before it are all meta (header) information fields. For example, if you were opening this file for the first time, you might want to know how it was filtered, and what different annotations in the file mean (e.g., AA == Ancestral Allele”).

When the double ## goes down to a single #, these are the field names that describe the following rows, including:

- CHROM: Chromosome number
- POS: Position on the chromosome
- ID: If (for example) a SNP has a particular ID (rs*)
- REF: This is the base that is found in the reference genome
- ALT: This is the alternate allele found in the sample’s genome
- QUAL: This is a quality score, called a “Phred quality score” http://en.wikipedia.org/wiki/Phred_quality_score, 10log_10 prob(call in ALT is wrong).
- FILTER: If the nucleotide passes all filters, it will say PASS. if it says something else, this is the filter that was not passed
- INFO: NS means “number of samples” and you should look up the link provided below to see what all the other acronyms mean!
- FORMAT: the stuff here explains what the numbers mean in the next set of columns (the samples). For example,
- GT:GQ:DP:HQ says that the first thing is a genotype, followed by a conditional genotype quality, a read depth, and haplotype qualities. For the genotype, the | means phased and / means unphased.

<pre>
<code>
##fileformat=VCFv4.0
##fileDate=20110705
##reference=1000GenomesPilot-NCBI37
##phasing=partial
##INFO=<ID=NS,Number=1,Type=Integer,Description="Number of Samples With Data">
##INFO=<ID=DP,Number=1,Type=Integer,Description="Total Depth">
##INFO=<ID=AF,Number=.,Type=Float,Description="Allele Frequency">
##INFO=<ID=AA,Number=1,Type=String,Description="Ancestral Allele">
##INFO=<ID=DB,Number=0,Type=Flag,Description="dbSNP membership, build 129">
##INFO=<ID=H2,Number=0,Type=Flag,Description="HapMap2 membership">
##FILTER=<ID=q10,Description="Quality below 10">
##FILTER=<ID=s50,Description="Less than 50% of samples have data">
##FORMAT=<ID=GQ,Number=1,Type=Integer,Description="Genotype Quality">
##FORMAT=<ID=GT,Number=1,Type=String,Description="Genotype">
##FORMAT=<ID=DP,Number=1,Type=Integer,Description="Read Depth">
##FORMAT=<ID=HQ,Number=2,Type=Integer,Description="Haplotype Quality">
#CHROM POS    ID        REF  ALT     QUAL FILTER INFO                              FORMAT      Sample1        Sample2        Sample3
2      4370   rs6057    G    A       29   .      NS=2;DP=13;AF=0.5;DB;H2           GT:GQ:DP:HQ 0|0:48:1:52,51 1|0:48:8:51,51 1/1:43:5:.,.
2      7330   .         T    A       3    q10    NS=5;DP=12;AF=0.017               GT:GQ:DP:HQ 0|0:46:3:58,50 0|1:3:5:65,3   0/0:41:3
2      110696 rs6055    A    G,T     67   PASS   NS=2;DP=10;AF=0.333,0.667;AA=T;DB GT:GQ:DP:HQ 1|2:21:6:23,27 2|1:2:0:18,2   2/2:35:4
2      130237 .         T    .       47   .      NS=2;DP=16;AA=T                   GT:GQ:DP:HQ 0|0:54:7:56,60 0|0:48:4:56,51 0/0:61:2
2      134567 microsat1 GTCT G,GTACT 50   PASS   NS=2;DP=9;AA=G                    GT:GQ:DP    0/1:35:4       0/2:17:2       1/1:40:3
</pre>
</code>

This is why you should not be afraid when someone mentions a vcf file. It’s just a text file that follows a particular format. I went over the basics, but if you want more details on the format can be [found here](http://www.1000genomes.org/wiki/Analysis/Variant%2520Call%2520Format/vcf-variant-call-format-version-41).


# Basic working with vcf files

We will first get comfortable working with the tools, and then write a bash (or python) script to achieve the functionality that we want. Let’s cd to where we downloaded the vcf file:

<pre>
<code>
cd /home/vanessa/Documents/Work/GENE_EXPRESSION/tutorial/vcf
</pre>
</code>

Let’s get basic info about our vcf file:

<pre>
<code>
vcftools --vcf AU-8001_1.vcf

VCFtools - v0.1.13
(C) Adam Auton and Anthony Marcketta 2009

Parameters as interpreted:
--vcf AU-8001_1.vcf

After filtering, kept 1 out of 1 Individuals
After filtering, kept 21749 out of a possible 21749 Sites
Run Time = 0.00 seconds
</pre>
</code>


# Filtering and Writing Files

We might want to filter down to a certain chromosome, a quality score, or just for a particular region. This is super easy to do!

<pre>
<code>
# Here filter to chromosome 1, from base pairs 2,000,000 to 3,000,000
vcftools --vcf AU-8001_1.vcf --chr 1 --from-bp 2000000 --to-bp 3000000

VCFtools - v0.1.13
(C) Adam Auton and Anthony Marcketta 2009

Parameters as interpreted:
--vcf AU-8001_1.vcf
--chr 1
--to-bp 3000000
--from-bp 2000000

After filtering, kept 1 out of 1 Individuals
After filtering, kept 10 out of a possible 21749 Sites
Run Time = 0.00 seconds
</pre>
</code>

I’m not sure how you would a priori decide which bases to look at. Perhaps doing a search for a gene, and then deciding in this interface?

But the entire purpose of filtering is to reduce your data to some subset, so arguably we would want to write this subset to a new file. To do this, just add “–recode –recode-INFO-all”. The second part makes sure that we keep the metadata.

<pre>
<code>
vcftools --vcf AU-8001_1.vcf --chr 1 --from-bp 2000000 --to-bp 3000000 --chr 1 --from-bp 1000000 --to-bp 2000000 --recode --out subset
</pre>
</code>

You can also pipe the output into a file, sort of like the above

<pre>
<code>
vcftools --vcf AU-8001_1.vcf --chr 1 --from-bp 2000000 --to-bp 3000000 --chr 1 --from-bp 1000000 --to-bp 2000000 --recode -c > /home/vanessa/Desktop/shmeagley.vcf
</pre>
</code>

Two files are produced: a subset.log (containing the screen output you would have seen) and a subset.recode.vcf with the filtered data. If you want to pipe the data into your script (and not produce a gazillion new files) you can also do that pretty easily:

<pre>
<code>
vcftools --vcf AU-8001_1.vcf --chr 1 --from-bp 2000000 --to-bp 3000000 --recode --stdout
</pre>
</code>

If you want to look through it manually, add | more like this:

<pre>
<code>
vcftools --vcf input_data.vcf --diff other_data.vcf --out compare
</pre>
</code>

Or the equivalent | less will let you browse through it in a terminal like vim (and scroll up, etc.)


# Comparing Files

If I had a Mom and a Dad and child, or any people that I want to compare, I can do that too!

<pre>
<code>
vcftools --vcf input_data.vcf --diff other_data.vcf --out compare
</pre>
</code>

You could again pipe that into an output file.


# Getting Allele Frequencies

You can also get allele frequency for ALL people in your file like this:

<pre>
<code>
vcftools --vcf AU-8001_1.vcf --freq --out output
vim output.frq

CHROM POS N_ALLELES N_CHR {ALLELE:FREQ}  
 1 69511 2 2 A:0 G:1  
 1 881627 2 2 G:0.5 A:0.5  
 1 887801 2 2 A:0 G:1  
 1 888639 2 2 T:0 C:1  
 1 888659 2 2 T:0 C:1  
 1 897325 2 2 G:0 C:1  
 1 900505 2 2 G:0.5 C:0.5  
 1 909238 2 2 G:0 C:1  
 1 909309 2 2 T:0.5 C:0.5  
 1 949608 2 2 G:0.5 A:0.5  
 …
</pre>
</code>

I can imagine wanting to do this with MANY vcf files to get averages for a particular population. The above isn’t very interesting because I only have ONE person, so it’s essentially showing that for a particular chromosome, a particular position, there are 2 possible alleles at a given locus (N_ALLELES), the alternate and the reference, and we have data available for both of those at each site (N_CHR), the reference and our sample. Then the last two columns show the frequency counts for each. Let’s download another set of VCFs and see if we can merge them! I think the perl vcftools could accomplish this.


# Merging many VCF files into one

It looks like we are going to need to compress the files (using bgzip) and index (using tabix) before doing any kind of combination. Note that doing bgzip *.vcf is not going to work, so we need to feed in a list of files. Here is how to do that.

<pre>
<code>
VCFS=`ls *.vcf`
for i in ${VCFS}; do
  bgzip $i
  tabix -p vcf $i".gz";
done

ls *.gz.tbi -1
AU-2901_1.vcf.gz.tbi
AU-7801_2.vcf.gz.tbi
AU-7901_2.vcf.gz.tbi
AU-8001_1.vcf.gz.tbi
AU-8401_2.vcf.gz.tbi
AU-9201_3.vcf.gz.tbi
</pre>
</code>

There they are! If you try to look at the file, it’s compiled (hence the efficient indexing) so it looks like gobbeltee-gook.


# Merging the files into one VCF!

<pre>
<code>
vcf-merge *.vcf.gz | bgzip -c > AU-merged.vcf.gz

Using column name 'AU-26302_2' for AU-2901_1.vcf.gz:AU-26302_2
Using column name 'AU-7801_2' for AU-7801_2.vcf.gz:AU-7801_2
Using column name 'AU-7901_2' for AU-7901_2.vcf.gz:AU-7901_2
Using column name 'AU-8001_1' for AU-8001_1.vcf.gz:AU-8001_1
Using column name 'AU-8401_2' for AU-8401_2.vcf.gz:AU-8401_2
Using column name 'AU-9201_3' for AU-9201_3.vcf.gz:AU-9201_3
</pre>
</code>

Sweet! That seemed to work. We are making progress in the world! Now let’s try calculating the allele frequencies (for a more interesting result?)

<pre>
<code>
gunzip AU-merged.vcf.gz
vcftools --vcf AU-merged.vcf --freq --out all-AU

VCFtools - v0.1.13
(C) Adam Auton and Anthony Marcketta 2009

Parameters as interpreted:
--vcf AU-merged.vcf
--freq
--out all-AU

After filtering, kept 6 out of 6 Individuals
Outputting Frequency Statistics...
After filtering, kept 46228 out of a possible 46228 Sites
Run Time = 1.00 seconds

CHROM POS N_ALLELES N_CHR {ALLELE:FREQ}
1 69270 2 2 A:0 G:1
1 69511 2 10 A:0 G:1
1 69761 2 2 A:0 T:1
1 69897 2 2 T:0 C:1
1 877831 2 10 T:0.2 C:0.8
1 879317 2 2 C:0.5 T:0.5
1 881627 2 12 G:0.333333 A:0.666667
1 887801 2 12 A:0 G:1
1 888639 2 12 T:0 C:1
1 888659 2 12 T:0 C:1
1 897325 2 12 G:0 C:1
1 900505 2 6 G:0.5 C:0.5
1 906272 2 2 A:0.5 C:0.5
1 909238 2 10 G:0.2 C:0.8
1 909309 2 4 T:0.5 C:0.5
1 909419 2 4 C:0.5 T:0.5
1 949608 2 8 G:0.5 A:0.5
1 949654 2 12 A:0.0833333 G:0.916667
...
</pre>
</code>

Right off the bat we can see that there are markers that we only have for a subset of the population (the ones that are not 12 – since we have 6 people if everyone has two, this means that the N_CHR would be 12?). I think more importantly in this file is the Allele Frequency – for example having A for 949654 is super rare! Again, this is calculating frequencies across our vcf files. I think if we are looking for variants in autism, for example, we would want to compare to a reference genome, because it could be that particular variants in an ASD population are more common.


# Exporting variants to a table

This vcftools business makes it so easy! Not only can I sort (vcf-sort) and calculate statistics over the files (vcf-stats) or create a custom format file (vcf-query), I can in one swift command convert my file to a tab delimited table:

<pre>
<code>
bgzip AU-merged.vcf
zcat AU-merged.vcf.gz | vcf-to-tab > AU-merged.tab
</pre>
</code>


# Sequencing Depth

Here is how to get sequencing depth. Again, this would probably be useful to do some kind of filtering… I would imagine we would want to eliminate samples entirely that don’t have a particular depth?:

<pre>
<code>
vcftools --vcf input_data.vcf --depth -c > depth_summary.txt

INDV N_SITES MEAN_DEPTH
AU-8001_1 21749 69.3184
</pre>
</code>

70 seems OK. If it were under 10, would that not be good enough? What is an acceptable depth?


# Linkage Disequilibrium

I don’t remember exactly what this is – I seem to remember Maude explaining to me that there are chunks on chromosomes that don’t get flopped around when DNA does it’s recombination thing, and so as a result of that you have sets of alleles / genes that tend to stick around together. So (I think) that doing this, we do a pairwise comparison of our data and find markers that travel together over time? And I (think) this is how you would do that:

<pre>
<code>
vcftools --vcf AU-8001_1.vcf --geno-chisq
</pre>
</code>


# Putting this all together…

We now want to write a specific command to achieve our goal. What do we want to do again?

 1. Compile all vcfs into one  
 2. Filter down to calls with good quality  
 3. Identify rare variants (less than 1% of population, reference)  
 4. Write rare variants into a big matrix! (for further analysis in R)

Let’s do this, and write a script to perform what we want to do!


## [parseVCF.sh: A compilation of the stuff above to go from VCF –> tab delimited data file for R (currently in progress!)](https://github.com/vsoch/vvcftools/blob/master/parseVCF.sh)
