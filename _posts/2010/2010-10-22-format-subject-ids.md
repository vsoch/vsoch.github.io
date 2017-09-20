---
title: "Format Subject IDs"
date: 2010-10-22 10:28:09
tags:
  code
  matlab
  tool
---


This script was created to format a list of subject IDs to be used in a python script to batch run an analysis. Currently, the user has to copy paste the IDs from excel into a text document, and then from the text document into nedit, and then spend an inordinate amount of time formatting each ID to be surrounded by parenthesis, and separated by commas. I’ve been the primary runner of batch analysis, which is likely why no one has complained about the process. However, if/when that changes, this will be incredibly useful. With hundreds of subjects, many datasets, and many different types of analysis, doing this manually just… shouldn’t happen! I’m unsure why I didn’t whip this up sooner! /bonk.

So, while this script is incredibly simple, it is incredibly valuable for the lab, so I thought I’d share it.

**How Does it Work?**

This script takes in a text file, either specified at command line (if you run Format_ID(‘mytextfile.txt’)) or input via a GUI (if you run Format_ID() with no arguments). The text file should be a list of subject IDs, one per line, to be used in the python script. These will be formatted to be surrounded by quotes, and separated by commas. For example, if the text file has the following IDs:

> 12345_11111
> 
> 12345_22222
> 
> 12345_33333

the output will be:

> subnums = [“12345_11111″,”12345_22222″,”12345_33333”]

**Why a Text File?**

I can imagine that some users might prefer a .csv file for input, or perhaps just an excel, however I decided to do this format because I always copy paste my subject IDs from the organizational file into a text file, to be used as reference for various stages of the analysis. So you could say that my reasons were slightly selfish, however I’d be happy to modify the script if anyone has a deep penchant for excel or .csv files.! I, however, will always have a strong preference for good old notepad and wordpad. :O)

You can view the script [here](http://www.vsoch.com/LONG/Vanessa/MATLAB/FormatID/format_ID.m)


