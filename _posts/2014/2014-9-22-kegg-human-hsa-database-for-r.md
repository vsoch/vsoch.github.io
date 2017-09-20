---
title: "KEGG Human (hsa) Database for R"
date: 2014-9-22 20:01:02
tags:
  api
  genes
  hsa
  kegg
  pathways
---


This morning I was trying to link some of my genes to pathways, so of course my first stop was [KEGG](http://www.genome.jp/kegg/pathway.html).

What in the world is KEGG? Kegg is a database of pathways. The pathway identifiers for human are numbered and prefixed with hsa, for example, [here is one](http://www.genome.jp/dbget-bin/www_bget?hsa:100101267). So if I want to get a link between a gene and this hsa identifier, I can do a REST call like this: http://rest.kegg.jp/link/pathway/hsa:100101267

That’s great, so I wrote a script to do this in R, for a pretty reasonable set of genes (about 800). This is when I felt like this:

[![cat](http://vsoch.com/blog/wp-content/uploads/2014/09/cat.jpg)](http://vsoch.com/blog/wp-content/uploads/2014/09/cat.jpg)

It made it 200 something the first time. Then R froze. Then it only made it to 38. I will not have any of this, KEGG database! So I downloaded the entirety (with other methods) and parsed the entire thing into an R object. You can download from one of my repositories.


# **<span style="color: #ff6600;">[kegg.Rda](https://github.com/vsoch/gene2drug/blob/master/data/kegg.Rda)</span>**

Here are details:

<pre>
<code>
KEGG database with 30739 entries, downloaded 9/22/2014/n gene2hsa: maps gene names to hsa identifiers
gene2path: maps gene symbols to pathway descriptions
hsa2gene: maps hsa pathway identifiers to gene symbols
hsa2path: maps hsa identifiers to pathways.
questions: email vsochat [at] stanford [.] edu
</code>
</pre>

My diabolical lab mate also just pointed me to a much better resource:

[http://www.pathwaycommons.org/about/](http://www.pathwaycommons.org/about/)

Awesome!
