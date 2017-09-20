---
title: "I am experiencing: matching terms to brain activation."
date: 2011-5-31 11:01:20
tags:
  analysis
  brains
  creation
  fun
  interface
  meta
  neuroscience
  voxels
  web
---


Based on our limited understanding and ability to represent the human brain with numbers and images, it is unwise to claim that any state of brain activation can be matched to a particular emotional state or experience. That said, the recent (beta) release of the [NeuroSynth project](http://www.neurosynth.org "Neurosynth") offers a promising view of the future ease of neuroimaging meta analysis.

The interface is connected to databases of meta information from many studies pertaining to significant findings about brain activation. In a nutshell, text mining algorithms comb through HTML tables from online journals, and pull out reports of maximum voxel activations as well as count the number of times that various terms appear in the actual text of the paper. If a term (“fear,” for example) appears at a greater than .001 significant (once in 1000 terms), then the paper’s findings are linked to the term. So when you search for a term on the NeuroSynth website and are presented with an activation map, you are essentially seeing the compiled maximum voxels significantly associated with that term. This is, of course, an incredibly simplified explanation, and I suggest that you reference the [NeuroSynth website](http://neurosynth.org/faqs "NeuroSynth FAQ") to get a more detailed and correct description.

This type of interface and analysis has me super excited, because it is a prominent example of the direction that we are moving in to better share, visualize, and compile massive amounts of brain data. Of course the mining algorithms aren’t perfect and the technology is in its infancy, but the implications for research, learning, and work-efficiency blow my mind!

With access to such cool data, I knew that I wanted to create something. I was so excited that I maxed out the download limit of these meta maps two days in a row, and then found myself with beautiful data that I wanted to do something fun with. I decided to reverse the idea: instead of providing a term and getting a map, I thought it would be fun to be shown a map and guess the term. I first created a poster, and then built a web interface from the poster. This is hard coded, but I see no reason that it couldn’t be generated dynamically, and as the accuracy and reputation of this sort of interface improves, we can build research tools. Woot! For now, enjoy this fun little project!

[I AM EXPERIENCING: matching terms to brain activation](http://www.vsoch.com/media/brain/ "I AM EXPERIENCING...")

this has only been tested in firefox and chrome – no promises about functionality elsewhere!

![Hmm robust amygdala activation and a little OFC, what could that be?](http://www.vsoch.com/blog/wp-content/uploads/2011/05/brainmap-150x150.png "Hmm robust amygdala activation and a little OFC, what could that be?")Hmm robust amygdala activation and a little OFC, what could that be?
