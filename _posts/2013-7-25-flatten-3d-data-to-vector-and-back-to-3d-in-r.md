---
title: "Flatten 3D Data to Vector, and back to 3D in R"
date: 2013-7-25 13:31:22
tags:
  3d-image
  import
  r
---


There is surprisingly little help online about how to flatten some 3D data, and then “unflatten” it back to its original size. Why would you want this functionality? Many machine learning algorithms that work with images treat pixel values as features, and so we represent each image as a vector of image intensities. The output (depending on the algorithm) might be an equivalently sized vector that we want to re-assemble into its previous 3D loveliness.

This is by no means a clever way of doing this, however it works and so I’ll share it. For my specific implementation I am reading in structural brain imaging data (called nifti files), however the 3D data could be of any type. This simply demonstrates the basic functionality – it’s more likely you would read in many files and stack the vectors into a 2D matrix before whatever manipulation you want to do, in which case you can just add some loops :)

<pre>
<code>
# Load nifti library
library('Rniftilib')

# Try loading in a nifti file
nii = nifti.image.read("NDARZW794FK8_anat.nii";,read_data=1)

# For each file, flatten into a vector
niivector = as.vector(nii[,,])

# Create empty array of same size to fill up
niinew = array(0, dim=dim(nii))

# Do some manipulation to vector(s)
# Option 1: Reconstruct 3D image manually
mrcounty = 1
for (i in 1:dim(nii)[3]) {
  niinew[,,i] = niivector[mrcounty:(mrcounty+dim(nii)[1]*dim(nii)[2]-1)]
  mrcounty = mrcounty + dim(nii)[1]*dim(nii)[2]
}

# Option 2: The one line answer
niinew = array(niivector, dim=dim(nii))

# Rewrite the image to file
template = nii
template[,,] = niinew
nifti.set.filenames(template,"C:/Users/Vanessa/Documents/test.nii")
nifti.image.write(niicopy)
</code>
</pre>


