---
title: "BrainArt. No, really!"
date: 2015-12-05 04:15:00
tags:
  art
  reproducibility
  science
---

<img src="https://raw.githubusercontent.com/vsoch/brainart/master/img/jiggleypuff.png" style="width:100%">

There have been several cases in the last year when we've wanted to turn images into brains, or use images in some way to generate images. The first was for the <a href="http://www.nature.com/nature/journal/v526/n7573/full/nature15692.html">Poldrack and Farah</a> Nature piece on what we do and don't know about the human brain. It came out rather splendid:

![Nature526](https://s-media-cache-ak0.pinimg.com/736x/ac/ba/3f/acba3fff31edbee43eed082a8e18c5e8.jpg)

And I <a href="http://www.slideshare.net/VanessaSochat/clipboards/my-clips">had some fun</a> with this in an informal talk, along with generating a badly needed <a href="http://vsoch.github.io/2015/brain-matrix/">animated version</a> to do justice to the matrix reference. The next example came with the NeuroImage cover to showcase brain image databases:

![NeuroImage](https://pbs.twimg.com/media/CUXmKufUAAAQk-9.jpg)

This is closer to a "true" data image because it was generated from actual brain maps, and along the lines of what I would want to make.

# BrainArt

You can skip over everything and just look at the <a href="http://vsoch.github.io/brainart">gallery</a>, or the <a href="http://www.github.com/vsoch/brainart">code</a>. It's under development and there are many things I am not happy with (detailed below), but it does pretty well for this early version. For example, here is "The Scream":

<img src="/assets/images/posts/brainart/screamblack.png" style="width:100%">

This isn't just any static image. Let's look a little closer...

<img src="/assets/images/posts/brainart/scream2.png" style="width:100%">

Matter of fact, each "pixel" is a tiny brain:

<img src="/assets/images/posts/brainart/scream3.png" style="width:100%">

And when you see them <a href="http://vsoch.github.io/brainart">interactively</a>, you can click on any brain to be taken to the data from which it was generated in the NeuroVault database. BrainArt!

## Limitations
The first version of this generated the image lookup tables (the "database") from <a href="https://github.com/vsoch/brainart/blob/master/brainart/db.py#L136">a standard set of matplotlib color maps</a>. This means we had a lot of red, blue, green, purple, and not a lot of natural colors, or dark "boring" colors that are pretty important for images. For example, here was an original rendering of a face that clearly shows the missing colors:

<img src="https://raw.githubusercontent.com/vsoch/brainart/master/img/face.png" style="width:100%">

UPDATE 12/6/2015: The color tables were extended to include brainmaps of single colors, and the algorithm modified to better match to colors in the database:

<img src="https://raw.githubusercontent.com/vsoch/brainart/master/img/face_fixed.png" style="width:100%">

The generation could still be optimized. It's really slow. Embarrassingly, I have <a href="https://github.com/vsoch/brainart/blob/master/brainart/utils.py#L89">for loops</a>. The original implementation did not generate x and y to match the specific sampling rate specified by the user, and this has also been fixed.

<img src="/assets/images/posts/brainart/girl_with_pearl_black.png" style="width:100%">

I spent an entire weekend doing this, and although I have regrets about not finishing "real" work, this is pretty awesome. I should have more common sense and not spend so much time on something no one will use except for me... oh well! It would be fantastic to have different color lookup tables, or even sagittal and/or coronal images. Feel free to contribute if you are looking for some fun! :)

## How does it work?
The package works by way of generating a bunch of axial brain slices using the NeuroVault API <a href="https://github.com/vsoch/brainart/blob/master/brainart/db.py#L33">(script)</a>. This was done by me to generate a database and lookup tables of black and white background images, and these images (served from github) are used in the function. You first install it:

```
pip install brainart
```

This will place an executable, 'brainart' in your system folder. Use it!

```
brainart --input /home/vanessa/Desktop/flower.jpg

# With an output folder specified
brainart --input /home/vanessa/Desktop/flower.jpg --output-folder /home/vanessa/Desktop
```

It will open in your browser, and tell you the location of the output file (in tmp), if you did not specify. Type the name of the executable without any args to see your options.


### Color Lookup Tables
The default package comes with two lookup tables, which are generated from a combination of matplotlib color maps (for the brains with multiple colors) and single hex values (the single colored brains for colors not well represented in matplotlib). Currently, choice of a color lookup table just means choosing a black or white background, and in the future could be extended to color schemes or different brain orientations. The way to specify this:

```
brainart --input /home/vanessa/Desktop/flower.jpg --color-lookup black
```


### Selection Value N
By default, the algorithm randomly selects from the top N sorted images with color value similar to the pixel in your image. For those interested, it just takes the minimum of the sorted sums of absolute value of the differences (I believe this is a Manhattan Distance). There is a tradeoff in this "N" value - larger values of N mean more variation in both color and brain images, which makes the image more interesting, but may not match the color as well. You can adjust this value:

```
brainart --input /home/vanessa/Desktop/flower.jpg --N 100
```

Adding more brain renderings per color would allow for specifying a larger N and giving variation in brains without deviating from the correct color, but then the database would be generally larger, and increase the computation time. The obvious fix is to streamline the computation and add more images, but I'm pretty happy with it for now and don't see this as an urgent need.

### Sampling Rate
You can also modify the sampling rate to produce smaller images. The default is every 15 pixels, which seems to generally produce a good result. Take a look in the gallery at "girl with pearl" huge vs. the other versions to get a feel for what I mean. To change this:

```
brainart --input /home/vanessa/Desktop/flower.jpg --sample 100
```


## Contribute!
The [gallery](http://vsoch.github.io/brainart) is the index file hosted on the github pages for this repo. See [instructions](https://github.com/vsoch/brainart#gallery) for submitting something to the gallery. While I don't have a server to host generation of these images dynamically in the browser, something like this could easily be integrated into [NeuroVault](http://www.neurovault.org) for users to create art from their brainmaps, but methinks nobody would want this except for me :)

<img src="/assets/images/posts/brainart/spiderman_zoom1.png" style="width:100%">
