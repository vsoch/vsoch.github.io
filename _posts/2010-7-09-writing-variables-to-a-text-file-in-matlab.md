---
title: "Writing Variables to a Text File in MATLAB"
date: 2010-7-09 12:03:46
tags:
  code-2
  matlab
  text-file
  variables
---


I recently have been playing with writing variables in MATLAB to a text file for a coverage checking script that I’m working on. After doing many different calculations, I have a list of structures and variables that I want to print to file for the user.

First, you need to initialize your text file for writing. Because I only write a text file given that a particular structure exists, I first check to see if it exists:

code

So we only enter the loop if the expression above is true, meaning that the variable ELIMINATED exists.

Then we need to initialize the text file that we want to write to, putting it into a variable called “fid” – file identifier. fopen “opens” the file “eliminated.txt” for writing (‘wt’).

code

And here is an example of how to write a variable (the date) to file:

code

We use the function fprintf, which first takes the file identifier (fid), and then a format string (%s\n), and then the variable name(s), or things to write (date). The first line simply prints the string ‘Date: ‘ and it is immediately followed by the variable date. The second line prints the variable called date. %s is part of the format string, and tells us that the variable “date” should be printed as a string, and the \n will create a carriage return (new line) after the print. Since there is no instruction for a new line after the string ‘Date’, the output will look something like “Date: 09-Jul-2010”

Here is a similar example of setting up a few headings:

code

And lastly, we loop through the structure called ELIMINATED, and print three fields to file: a Subject_ID, a Mask_number, and a Voxel count. You can just think of these as various strings and numbers inside of a structure. The use of fprintf is the same, however our formatting is a little more complex.

code

- %s\t%d\t\t%d\n – tells it the format – %s means a string, /t means a tab, %d means double, and the \n is a new line

- the variable ELIMINATED is a structure that holds a list of people who don’t pass certain criteria. There are equivalent structures for INCLUDED, and MISSING.

- it’s going through a loop, so ELIMINATED(i) represents one subject.

- The variables “elim_start” and “elim_end” are the start and end index of the subject ID, which is part of a longer file path to the folder. I calculated these values by using regexp to identify the last two “\”‘s, which enclose the Subject ID.

Lastly, we are done writing to the file, so we need to close it! That’s pretty simple.

code


