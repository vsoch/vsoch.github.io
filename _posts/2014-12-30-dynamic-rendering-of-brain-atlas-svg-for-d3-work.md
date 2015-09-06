---
title: "Dynamic Rendering of Brain Atlas SVG for D3 Work"
date: 2014-12-30 22:27:44
tags:
  cairo
  graphics
  nibabel
  nilearn
  python
  svg
  visualization
---


I was using traditional python tools to convert a brain atlas into an svg for use in a d3 visualization. Here is an example image (very pretty!)

[![atlas](http://vsoch.com/blog/wp-content/uploads/2014/12/atlas.png)](http://vsoch.com/blog/wp-content/uploads/2014/12/atlas.png)

But when you look at the svg data in a text editor, I ran into this horrific finding:

[![eek](http://vsoch.com/blog/wp-content/uploads/2014/12/eek-1024x281.png)](http://vsoch.com/blog/wp-content/uploads/2014/12/eek.png)

What you see is png image data being shoved into an svg image object, and they are calling that an “svg” file! What this means is that, although the format of the file is .svg, you can’t actually manipulate any of the paths, change colors, sizes, nada. It’s akin to giving someone a banana split made of plastic, and when they reach to pull the cherry off the top they discover in one horrific moment that it’s *all one piece*! Not acceptable. So I decided to roll my own (likely unnecessarily complicated) method together, and I learned a lot:


## [Making SVG Images for a Brain Atlas](http://nbviewer.ipython.org/url/vbmis.com/bmi/share/david/make_atlas_svg.ipynb)

 

It’s not that making an svg of a brain atlas slice is so hard, but if you want it to happen dynamically no matter what the atlas, then you can’t do tricks in Illustrator or Inkscape.  The example above starts with a brain atlas image (a nifti file) and uses some basic image processing methods, including edge detection, segmentation, and drawing a line by walking along a distance path (I don’t remember what that’s called, I just made it up for the purpose) to end up with a proper svg file with paths for each region of the atlas. It’s also pretty cool because I used a library called [Cairo](http://en.wikipedia.org/wiki/Cairo_%28graphics%29) to draw and render an svg, which is like a vector graphics API. Here is an example of one of my equivalent regions, this time represented as paths and not… clumps of misleading data!

[![better](http://vsoch.com/blog/wp-content/uploads/2014/12/better-1024x514.png)](http://vsoch.com/blog/wp-content/uploads/2014/12/better.png)

Very cool!


