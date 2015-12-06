---
title: "BrainArt. No, really!"
date: 2015-12-05 04:15:00
tags:
  art
  reproducibility
  science
---

<img src="https://raw.githubusercontent.com/vsoch/brainart/master/img/brainart.png" style="width:100%">

There have been several cases in the last year when we've wanted to turn images into brains, or use images in some way to generate images. The first was for the <a href="http://www.nature.com/nature/journal/v526/n7573/full/nature15692.html">Poldrack and Farah</a> Nature piece on what we do and don't know about the human brain. It came out rather splendid:

![Nature526](https://s-media-cache-ak0.pinimg.com/736x/ac/ba/3f/acba3fff31edbee43eed082a8e18c5e8.jpg)

And I <a href="http://www.slideshare.net/VanessaSochat/clipboards/my-clips">had some fun</a> with this in an informal talk, along with generating a badly needed <a href="http://vsoch.github.io/2015/brain-matrix/">animated version</a> to do justice to the matrix reference. The next example came with the NeuroImage cover to showcase brain image databases:

![NeuroImage](https://pbs.twimg.com/media/CUXmKufUAAAQk-9.jpg)

This is closer to a "true" data image because it was generated from actual brain maps, and along the lines of what I would want to make.

# BrainArt

You can skip over everything and just look at the <a href="http://vsoch.github.io/brainart">gallery</a>, or the <a href="http://www.github.com/vsoch/brainart">code</a>. It's under development and there are many things I am not happy with (detailed below), but it does pretty well on colorful, abstract images. For example, here is some resemblance of "Starry Night":

<img src="/assets/images/posts/brainart/starrynight.png" style="width:100%">

This isn't just any static image. Let's look a little closer...

<img src="/assets/images/posts/brainart/starrynight1.png" style="width:100%">

Matter of fact, each "pixel" is a tiny brain:

<img src="/assets/images/posts/brainart/starrynight2.png" style="width:100%">

And when you see them <a href="http://vsoch.github.io/brainart">interactively</a>, you can click on any brain to be taken to the data from which it was generated in the NeuroVault database. BrainArt!


### Limitations
There are many things I am not happy with, namely that the image lookup tables (the "database") used to generate the images are <a href="https://github.com/vsoch/brainart/blob/master/brainart/db.py#L35">generated from</a> a standard set of matplotlib color maps. This means we have a lot of red, blue, green, purple, and not a lot of natural colors, or dark "boring" colors that are pretty important for images. For example, here we can see well what is missing:

<img src="https://raw.githubusercontent.com/vsoch/brainart/master/img/face.png" style="width:100%">

I will likely "fix" this the next time I get around to wanting an image, and my tool doesn't produce what I want. The generation could also be optimized. It's really slow. Embarrassingly, I have <a href="https://github.com/vsoch/brainart/blob/master/brainart/utils.py#L89">for loops</a>. Instead of generating x and y to match the specific sampling rate specified by the user for function, I use the x and y coordinate iterating through the image, and this will produce an image with too much white space around the images if the sampling rate is too large. These have been added as <a href="https://github.com/vsoch/brainart/issues">issues</a> to the repo. It pains me that I don't have proper tests and streamlined documentation and optimized functions, but since this is mostly useless, I am trying to have some common sense and not strive for perfection for something no one will use except for me. Feel free to contribute if you are looking for some fun! :)

### How does it work?
The package works by way of generating a bunch of axial brain slices using the NeuroVault API <a href="https://github.com/vsoch/brainart/blob/master/brainart/db.py#L35">(script)</a>. This was done by me to generate a database and lookup tables of black and white background images, and these images (served from github) are used in the function. You first install it:


<pre>
<code>
pip install brainart
</code>
</pre>

This will place an executable, 'brainart' in your system folder. Use it!

<pre>
<code>
brainart --input /home/vanessa/Desktop/flower.jpg

# With an output folder specified
brainart --input /home/vanessa/Desktop/flower.jpg --output-folder /home/vanessa/Desktop
</code>
</pre>

It will open in your browser, and tell you the location of the output file (in tmp), if you did not specify. Type the name of the executable without any args to see your options.


#### Color Lookup Tables
The default package comes with two lookup tables, each of which are somewhat limited as they are generated from matplotlib color maps. Currently, choice of a color lookup table just means choosing a black or white background. The way to specify this:

<pre>
<code>
brainart --input /home/vanessa/Desktop/roman.jpg --color-lookup black
</code>
</pre>

There is currently no option for black and white images.

#### Similarity Threshold
By default, the similarity threshold is 0.9, meaning that a random image is selected from the lookup with average color of the brain above the threshold in that similarity (pearson's R). If you want to adjust that value:

<pre>
<code>
brainart --input /home/vanessa/Desktop/roman.jpg --threshold 0.8
</code>
</pre>

as in the case that the result set is empty (meaning the lookup does not have a good color match) a random image is selected, and this can reduce the quality of your result.


#### Contribute!
The [gallery](http://vsoch.github.io/brainart) is the index file hosted on the github pages for this repo. See [instructions](https://github.com/vsoch/brainart#gallery) for submitting something to the gallery.
