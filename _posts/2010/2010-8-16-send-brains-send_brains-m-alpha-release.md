---
title: '"Send Brains" (send_brains.m) Alpha Release!'
date: 2010-8-16 14:28:50
tags:
  brain-images
  code
  software
  spm
---


It’s a weekly duty in our lab to preprocess data and send out a brain image (with a lab logo) for each subject that has participated in our study. It used to be one of my weekly duties, and I handed my scripts over to an undergrad to take charge of. However, it stayed with me how tedious the entire process was, and I added it to my list to create a better way, when I found the time!

I’m happy to announce the release of send_brains.m – a matlab script that I wrote to automatically create AND send brain images. While this isn’t like the coverage checking script in that it would be easy to run “as is” for another lab, with some modifications it could easily be used. It has a couple really cool features, including using an SPM function called “slover” to prepare axial and sagittal views of a high resolution anatomical, saving .jpg and .zip files, and sending an email directly from MATLAB.

**What Does it Do?**

The script looks at subjects that have been Processed (through the BOLD processing pipeline that I created for our lab), and compares this list with completed brain images in a folder where all brain image output is stored. Subjects that are in the Processed folder but not in the Brain Images folder are added to a list of potential sendees.

**How Do I Run It?**

- To run the script, make sure that you have its path added. We have a Script folder with many subfolders, so if you have something similar, it’s easiest to add the path with subfolders : addpath(genpath(‘Your/path/here/’));
- To run, simply type brain_images on the MATLAB command line.

**How does it work?**

1. The script first creates the list of potential sendees – whoever has been newly processed that week and does not have a brain image created yet.
2. The script then presents this list to the user in a graphical window, and the user can select subjects to send brain images to by highlighting the user IDs. (updated 10/12/2010) ( The old method asked the user if he/she would like to delete any participants, and the user had to enters the ID into the GUI, and then the script would present the user with the new list. I wanted to make this easier so I changed it.)
3. Next, the script looks for the processed anatomical in the subject’s anat directory under Processed. This image will normally always have the same name – however in rare cases when the name is different, for whatever reason, the script will not find the highres, and will present the user with a GUI to select the image that he/she would like to use for that participant. It then prepares two slice views of the highres, crops them, puts them together as a zip, moves the zip to the Graphics/Brain Images folder, and cleans up the old files.
4. Once all brain image zips have been created, the script prompts the user if he/she wants to send a brain image for each subject, and asks the user to enter the email. This process is fairly rapid and easy. In the case that the user mistypes an email, the easiest thing to do is delete the output image, and quickly run the script again.
5. As each address in entered, the script sends the email directly from MATLAB.

**Instructions**

**1. **Run by typing “send_brains” into MATLAB. Select your experiment top directory.

**[![](http://www.vsoch.com/blog/wp-content/uploads/2010/08/1-Select-Experimentjpg-300x293.jpg "1 Select Experiment")](http://www.vsoch.com/blog/wp-content/uploads/2010/08/1-Select-Experimentjpg.jpg)**  
**2**. Select your brain images output folder:  
[![](http://www.vsoch.com/blog/wp-content/uploads/2010/08/2-Select-Output-Directory-300x240.jpg "2 Select Output Directory")](http://www.vsoch.com/blog/wp-content/uploads/2010/08/2-Select-Output-Directory.jpg)  
**3. **Select the subjects that you want to send images to from the GUI. In the case that the standard highres is not present for a subject, the script will prompt you to choose another file, or select “cancel” to skip the subject.  
**4. **Go have a sandwich. The script will now first create a slices image with a logo overlay for each participant…  
[![](http://www.vsoch.com/blog/wp-content/uploads/2010/08/4-Slices-and-Logo-199x300.jpg "4 Slices and Logo")](http://www.vsoch.com/blog/wp-content/uploads/2010/08/4-Slices-and-Logo.jpg)  
**5. **…and then a sagittal slices view.  
[![](http://www.vsoch.com/blog/wp-content/uploads/2010/08/5-Sagittal-View-240x300.jpg "5 Sagittal View")](http://www.vsoch.com/blog/wp-content/uploads/2010/08/5-Sagittal-View.jpg)  
**6.** When everyone’s images have been created and intermediate files cleaned up, then you will be prompted for each subject if you want to send a brain image or not:  
[![](http://www.vsoch.com/blog/wp-content/uploads/2010/08/6-Send-Image-Prompt-300x195.jpg "6 Send Image Prompt")](http://www.vsoch.com/blog/wp-content/uploads/2010/08/6-Send-Image-Prompt.jpg)  
**7. **and then lastly you enter the participant’s email. That’s it!  
[![](http://www.vsoch.com/blog/wp-content/uploads/2010/08/7-Enter-Email-Prompt-300x215.jpg "7 Enter Email Prompt")](http://www.vsoch.com/blog/wp-content/uploads/2010/08/7-Enter-Email-Prompt.jpg)

The one con (between this method and the old manual one) is that we are moving from processing on the cluster (parallel) to a local machine (one at a time!). So instead of everyone being processed at once, and the images taking 30 seconds for everyone, the time to send the images is n X 30 seconds. However, the key point is that you don’t have to do anything! With the old method, you would have to log into the cluster, navigate to the script, manually figure out the new IDs to run and input them into the script, chmod u+x and run it, then manually open up each image in FSLview, take a screen shot, copy paste into paint, copy the logo from a URL, paste and resize it, and then save the entire thing as (Subject_ID).jpg. Yep, I’d say that the script is a heck of a lot easier!

The scripts that are needed include  
[send_brains.m](https://gist.github.com/vsoch/8251564#file-send_brains-m)

[crop.m](http://vsoch.com/LONG/Vanessa/MATLAB/Send%20Brains/crop.m) (I did not write this script, but it is necessary to crop the images)

If you would like to see sample output, look at:  
[Zip Send to Participant](http://vsoch.comLONG/Vanessa/MATLAB/Send%20Brains/22222.ZIP)


