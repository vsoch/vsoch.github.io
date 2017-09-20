---
title: "Coverage Check (cov_check.m) Alpha Release!"
date: 2010-7-12 15:43:05
tags:
  code
  coverage
  signal
  spm
---


Haha, this is my first little go at releasing something that is moderately useful, a script that helps FSL or SPM users check the coverage for each single subject before jumping into a group analysis. Here are the details!

**Overview**

When doing a group analysis in FSL or SPM, if any one subject is missing coverage due to signal loss, this means that the group map will not have this area either (only voxels that ALL subjects have are included in the group analysis). This presents us with the problem of seeing a bad group mask, and not having any idea which individual subject is responsible for the loss in coverage. Since there is no methodical way to look through individual subject masks (the mask.img for each subject in the first level output directory) I created this script to help find subjects with poor coverage, and create a list of good subjects to use for the group analysis.

****

Variables

This matlab script checks the coverage for a group of subjects that have completed single subject analysis, and are ready for a group analysis. The script takes in:

- An experiment directory (AHABII.01, DNS.01, FIGS.01, etc)

- The task (Cards, Faces –> block vs affect)

- The number of subjects

- An ROI mask that the user wants to use for group analysis (can be created in SPM with pickatlas, or however you like)

- A percent coverage minimum, which is the minimum coverage of the ROI that is acceptable to include a subject in the group analysis. For example, if our mask has 5000 voxels and we specify a % coverage minimum of .95, then only subjects with .95 X 5000 voxels (minimally) will be included.

**Order of Operations**

1. The script first sets up output directories and paths. All output goes into N:\(EXPERIMENT)\Analysis\SPM\Second_level\(TASK)\Coverage_Check\(DATE and TIME). Output folders include “results,” “logs,” and “masks.” The “masks” folder will hold the raw copied masks from the single subject directory. A subfolder called “ROI_applied” will hold these same images that have been masked by the user specified ROI. The naming convention for the ROI_applied folder is “brainmsk#.*”

Here we are selecting the output directory

[![](http://www.vsoch.com/blog/wp-content/uploads/2010/07/1-Select-experiment-300x199.jpg "1 Select experiment")](http://www.vsoch.com/blog/wp-content/uploads/2010/07/1-Select-experiment.jpg)

the task…

[![](http://www.vsoch.com/blog/wp-content/uploads/2010/07/2-Select-task-300x263.jpg "2 Select task")](http://www.vsoch.com/blog/wp-content/uploads/2010/07/2-Select-task.jpg)

the number of subjects…

[![](http://www.vsoch.com/blog/wp-content/uploads/2010/07/3-Number-of-Subjects-300x129.jpg "3 Number of Subjects")](http://www.vsoch.com/blog/wp-content/uploads/2010/07/3-Number-of-Subjects.jpg)

the percent coverage desired…

[![](http://www.vsoch.com/blog/wp-content/uploads/2010/07/4-Percent-Coverage-281x300.jpg "4 Percent Coverage")](http://www.vsoch.com/blog/wp-content/uploads/2010/07/4-Percent-Coverage.jpg)

the subjects (I just chose 5 to keep it quick for this example)…

[![](http://www.vsoch.com/blog/wp-content/uploads/2010/07/5-Select-Subjects-300x195.jpg "5 Select Subjects")](http://www.vsoch.com/blog/wp-content/uploads/2010/07/5-Select-Subjects.jpg)

and finally, the ROI (region of interest) mask.

[![](http://www.vsoch.com/blog/wp-content/uploads/2010/07/6-Select-Mask-300x202.jpg "6 Select Mask")](http://www.vsoch.com/blog/wp-content/uploads/2010/07/6-Select-Mask.jpg)

2. We calculate the number of voxels in the ROI, and multiply that by the % coverage specified to get the minimum number of acceptable voxels for each subject.

3. The subject data (the mask.img and mask.hdr file) is copied from the Analysis directory of each subject into the output directory under “masks.” Each subject is assigned a mask number, so the new files are saved as “mask_#.img” and “mask_#.hdr.” This number will be important for identifying the subject in the output text files, and matching masks with subject IDs. Here is a quick shot of the top and lower levels of a freshly run output directory:

[![](http://www.vsoch.com/blog/wp-content/uploads/2010/07/16-Output-folders-300x150.jpg "16 Output folders")](http://www.vsoch.com/blog/wp-content/uploads/2010/07/16-Output-folders.jpg)

4. We use the ROI to mask the subject data, and each subject has a new mask saved under “ROI_applied” with the prefix “brainmsk” followed by the appropriate mask number. We then calculate the number of voxels in this resulting image. If we are below the threshold, the subject is flagged for review. If we are above the threshold, the subject is added to the “INCLUDED” list. If the mask cannot be found, the subject is added to the “MISSING” list. Here we are using IMCalc to mask each subject image with the ROI.

[![](http://www.vsoch.com/blog/wp-content/uploads/2010/07/7-IM-Calc-300x153.jpg "7 IM Calc")](http://www.vsoch.com/blog/wp-content/uploads/2010/07/7-IM-Calc.jpg)

5. For each subject that is flagged, the user is prompted if he/she wants to visually check the images, and if the graphical output should be printed to file. The script then displays a 3D image and a slices image for each flagged subject, and the user is asked to select if the subject should be eliminated. If the user selects to not visually check the flagged images, then all subjects flagged for elimination get placed in the eliminated list. Here is the prompt to ask the user if he/she wants to visually check the flagged subjects (note that I recently changed this to “Visual Check Flagged”):

[![](http://www.vsoch.com/blog/wp-content/uploads/2010/07/8-Visual-Check-Option-286x300.jpg "8 Visual Check Option")](http://www.vsoch.com/blog/wp-content/uploads/2010/07/8-Visual-Check-Option.jpg)

and here we ask the user if graphical output should be printed to file:

[![](http://www.vsoch.com/blog/wp-content/uploads/2010/07/9-print-views-to-file-287x300.jpg "9 print views to file")](http://www.vsoch.com/blog/wp-content/uploads/2010/07/9-print-views-to-file.jpg)

6. If the user selects to print graphical output, this output gets printed to the post script (.ps) file in the top level of the output directory. Double clicking this file will convert it to PDF with Adobe Distiller.

Here is a 3D view of a subject flagged for elimination, so the user can compare the individual subject mask with the area of the brain he/she is interested in. This happens to be a VS mask, which is a big round blob 😛 We can see that there is a chunk taken out of the bottom of the blob, which represents an area that coverage was lost in for this particular subject.

[![](http://www.vsoch.com/blog/wp-content/uploads/2010/07/10-3D-View-300x272.jpg "10 3D View")](http://www.vsoch.com/blog/wp-content/uploads/2010/07/10-3D-View.jpg)

We then can click Slice View –> “View” to see the slice View:

[![](http://www.vsoch.com/blog/wp-content/uploads/2010/07/11-Slice-View-300x271.jpg "11 Slice View")](http://www.vsoch.com/blog/wp-content/uploads/2010/07/11-Slice-View.jpg)

and then you can see above that the user is prompted to choose to eliminate or keep the subject.

7. If we eliminate the subject, they are added to the “ELIMINATED” list. If we don’t eliminate them, they are added to the “INCLUDED” list.

8. Finally, the lists of subjects that are missing, eliminated, and included are printed to text files under “logs.” Each log includes the Subject ID, Mask ID number, and Voxel count for each subject. The included subjects are under (included.txt), the missing subjects are under (missing.txt), and the eliminated subjects are under (eliminated.txt). Here is a quick shot of the eliminated and included logs for the test run with 5 subjects:

[![](http://www.vsoch.com/blog/wp-content/uploads/2010/07/17-Text-Files-300x187.jpg "17 Text Files")](http://www.vsoch.com/blog/wp-content/uploads/2010/07/17-Text-Files.jpg)

9. The user is shown a final “group mask” whole brain and group_ROI image in both the 3D and slices view, and these images are saved under “Results” with a print out.

[![](http://www.vsoch.com/blog/wp-content/uploads/2010/07/14-Group-Brain-3D-300x273.jpg "14 Group Brain 3D")](http://www.vsoch.com/blog/wp-content/uploads/2010/07/14-Group-Brain-3D.jpg)

[![](http://www.vsoch.com/blog/wp-content/uploads/2010/07/15-Group-Brain-Slice-300x268.jpg "15 Group Brain Slice")](http://www.vsoch.com/blog/wp-content/uploads/2010/07/15-Group-Brain-Slice.jpg)

and of course, the raw image files are available for all of these graphics so you can mess around with them to your heart’s desire! The idea is that you would then take the list of “included” subject IDs and use those subject’s in a group analysis to get the same coverage that is predicted by the script. Cool!

**The script**

- To run, make sure that it is saved in a scripts directory that is part of your MATLAB path. Our standard is to save it under DNS.01/Scripts/MATLAB

- To run, simply type “cov_check()” in the MATLAB window, and it will prompt you for all of your variables

- cov_check: I’m unfortunately not going to post it on here, because I’m not sure about the rules of scripts and lab property. If you are curious about the script, however, I’d be glad to share!


