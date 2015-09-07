---
title: "Diffusion Tensor Imaging (DTI)"
date: 2013-6-22 18:58:59
tags:
  dti
  fa
  imaging-modality
  mri
---


**Diffusion Tensor Imaging** looks at white matter integrity.  It is a MRI based method that uses diffusion properties of water molecules to construct white matter fibers (anatomical connections) between brain regions.  There are [many metrics of white matter tracts](http://vistalab.stanford.edu/newlm/index.php/MrDiffusion#Backgrounds) you can calculate from the data, but the two most commonly done things are [tractography](http://en.wikipedia.org/wiki/Tractography), or seeing how things are connected and how strongly, or [Fractional Anisotrophy](http://en.wikipedia.org/wiki/Fractional_anisotropy), or calculating the level of perfusion at each voxel.

[![dti](http://www.vbmis.com/learn/wp-content/uploads/2013/06/dti-300x239.jpg)](http://www.vbmis.com/learn/wp-content/uploads/2013/06/dti.jpg)

This is currently the only non-invasive method for mapping anatomical connections in the human brain, and the disadvantages are that you can’t get a sense of the direction of the connection, crossing fibers are challenging to pick up on, and smaller fibers are harder to detect.  We are getting better with higher resolution scanners, but it isn't perfect, of course.

### How does the scan work?

1. Standard 90 deg excite
2. Gradient pair (G,-G) has no net effect on stationary spin
3. Spins that have moved experience a mean field that differs from stationary. This dephases them and causes T2 to decay
4. The amount of the decay depends on the distance moved during time DT (diffusion time)

### What software should I use to process data?

The two suites I have experience with are [FSL](http://fsl.fmrib.ox.ac.uk/fsl/fsl-4.1.9/fdt/index.html) (via DTI-fit and BEDPOST-X for tractography) and the Diffusion II toolbox in SPM, now available under an umbrella of packages called [SPMTools](http://sourceforge.net/projects/spmtools/).  There are many more GUI based solutions available, and [a good overview can be seen here](http://mrrcwiki.einstein.yu.edu/index.php/Diffusion).


