---
title: "DNS Score 1.5 Alpha Release"
date: 2011-2-26 17:02:51
tags:
  
---


This is an incredibly exciting day for me, because I have finished my first “real” application (meaning that it is an .exe file that runs with an installer and plops something into Program Files.) I shall first provide an overview, and then more details about how I put it together.

**Overview**

This application is used for creating syntax (.sps) files to score behavioral data for the Duke NeuroGenetics Study. The user can select a data file (.sav), an output folder, and whether or not results should also be merged into one file. This application simply writes the script to produce the desired output, and does NOT run the script. After using this application, the user should go to the output folder and run the .sps script in PASW Statistics to produce the scored data.

**Tips for Use**

Install DNS Score on your machine and create a shortcut for it in a folder close to your syntax and/or output folders. The DNS Score file selector opens in the present working directory, so running it directly from Program Files will make your file selector start from there, which is not ideal.

**Instructions**

1. Create an output folder for storing the script and your results on your local machine
2. Launch DNS Score
3. Select your output folder, the syntax desired, whether you want a merged file, and the data in the GUI, and click CREATE SPS
4. The .sps file will be saved to your output folder
5. Simply open this file in PASW and run it.
6. This script will score the measures that you selected using the scoring syntax you selected, and save all individual and compiled results to your output folder. You can rename the dns_score.sps script to whatever is appropriate for your run.

[![](http://www.vsoch.com/blog/wp-content/uploads/2011/02/dns_score-261x300.png "dns_score GUI")](http://www.vsoch.com/blog/wp-content/uploads/2011/02/dns_score.png)

**What does the .sps syntax do?**

This application was created to address the problem of creating quick merged files with custom measures, and the problem of one tiny error in a massive syntax file corrupting an entire results data file. The script that this application creates does the following, specifically for use with the Duke NeuroGenetics Study:

1.  Loads user specified dataset
2. Resolves ID confusion issues between two variables, and prints the correct ID as an integer “dns_id”
3. For each measure, works directly from a copy of the raw data, scores the measure, saves a measure specific file. (This means that an error in one syntax will not have averse effects on the rest)
4. As it goes, if the user has asked to make a merged file, it concatenates the results based on the dns_id

**What can we learn from this application?**

While this application is a custom job for the Duke NeuroGenetics Study, it is a good example of how python can be used to create a GUI to run in Windows to create custom job scripts for users. This is the first of hopefully multiple small projects that I hope to do that will write custom scripts based on user input. This of course is a very rough version with limited use within my lab, but feel free to contact me with things that I can fix or do better!

[DOWNLOAD 64 BIT](http://www.vsoch.com/LONG/Vanessa/Applications/DNS_SCORE/dns_score_setup_1.5_64bit.exe)

[DOWNLOAD 32 BIT](http://www.vsoch.com/LONG/Vanessa/Applications/DNS_SCORE/dns_score_setup_1.5_32bit.exe)


