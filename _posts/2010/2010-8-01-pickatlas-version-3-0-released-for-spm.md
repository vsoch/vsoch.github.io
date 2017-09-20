---
title: "PickAtlas Version 3.0 Released for SPM"
date: 2010-8-01 11:50:27
tags:
  pickatlas
  review
  software
  spm
  toolbox
---


PickAtlas, an SPM extension created by the folk over at Wake Forest, has just had the release of Version 3.0. I’ve installed the new version in SPM8, and wanted to give everyone some feedback. The biggest change is with the addition of masks – there are now rodent atlases, monkey atlases, and other small critters that my lab is unlikely to use. However, it’s very cool that we have them, if we ever decided to look at critter brains!

An important change to note is the use if nifti images from analyze. All of the atlas image files are nifti, as well as any mask that you save from the PickAtlas GUI. When I first tried to add the JHU White Matter Atlas (that I had added to my older version) it spat out a big ugly error – which was fixed when I converted the .img/.hdr file into a .nii. So if you want to add any atlases, the procedure is exactly the same, but you must use nifti!

When using it for “Results” – the only slight tweak is user experience:

> The only change that will be noticeable to the user from this point on **(after selecting PickAtlas GUI or a mask from file) **is that the mask will be resliced and a completion meter will be displayed during this process. Because mask area is generally smaller than the whole brain, the number of multiple comparisons will be reduced. Thus, results viewed using the PickAtlas Tool will include a small volume correction that will be reflected in the p-values.

I’m not sure if this was there before – but there is a “Generate Table” button that allows you to select one or more analyze images with an ROI, and it spits out a table with the following statistics:

- Size
- Average
- Std.Dev.
- T
- Region
- ROI name
- L/R/B
- Study
- Image
- Max Value
- Max Loc
- Min Value
- Min Loc

These definitely might be useful!

Everything else is the same – it still does talarach/MNI coordinates, allows for dilation and shapes, right vs left selection, all that good stuff!

[Download PickAtlas 3.0 Here](http://www.nitrc.org/projects/wfu_pickatlas/)

Happy PickAtlasing everyone!


