---
title: "Beer Rankings 1.0 (beerrank.m)"
date: 2010-12-14 15:28:52
tags:
  beer
  code
  holiday
  matlab
---


I should say first and foremost that I do not drink! However, my lab is going into the second year of what will be an annual Christmas tradition of having a “Holiday Beer Tasting,” and I am the official server. Last year we recorded everything on paper and had to do all the calculations manually, but this year I decided it would be cool to go a little more high tech. I of course would never pass up the opportunity to write a script!

Since yesterday evening I’ve whipped up and tested beerrank.m, which will take in all beer rankings, calculate averages, record raw and average data to file, and present the winners. The script works as follows:

**1) Run **by typing beerrank into the matlab terminal window.

[![](http://www.vsoch.com/blog/wp-content/uploads/2010/12/1-Title.jpg "1 Title")](http://www.vsoch.com/blog/wp-content/uploads/2010/12/1-Title.jpg)

**2) Input **the number of beers, and the desired name of the output file. If the output file already exists, the data will be appended to the next empty row. If the file does not exist, it will be created with all the appropriate headers (what I recommend to do!) The file will be put in whatever is your pwd (present working directory).

[![](http://www.vsoch.com/blog/wp-content/uploads/2010/12/2-User-Prompt.jpg "2 User Prompt")](http://www.vsoch.com/blog/wp-content/uploads/2010/12/2-User-Prompt.jpg)

**3) ****Input Beer Names:** A window will pop up for each of the number of beers that you have specified! In this window you should put the actual beer name. Note that this step should be done by the server whom knows the secret identify of each beer in the order that it is being served. These names will be hidden from view until the final results are displayed, and beers will be referenced as BEER 1, BEER 2, etc.

[![](http://www.vsoch.com/blog/wp-content/uploads/2010/12/3-Name-Input.jpg "3 Name Input")](http://www.vsoch.com/blog/wp-content/uploads/2010/12/3-Name-Input.jpg)

**4) **Next, the user is prompted with an empty rankings table for BEER1. The ranking categories have been determined in advance, and at this point the server can start serving, and one person can input results as they are decided by each person, or you could go around the table at the end and have everyone read the ranking for each category. Note: An update to the script would be to allow the user to specify categories.

[![](http://www.vsoch.com/blog/wp-content/uploads/2010/12/4-Rankings-Input-200x300.jpg "4 Rankings Input")](http://www.vsoch.com/blog/wp-content/uploads/2010/12/4-Rankings-Input.jpg)

**5) Here **is an example of input data. Numbers can be entered with spaces between them, and extra spaces on the front, end, and in between do not matter – the script will nip them in the butt! Note that there is currently no input validation – so in the case that a user entered a non numerical value anywhere other than the comments box, the script would error out when it converts the string number into a double (a type of number) with the function str2double(). This could be another future update – to save data temporarily, check it, and re-present the prompt to the user in the case of a faulty input. I also want to note that it doesn’t matter how many numbers are input into each ranking – the average will be calculated nonetheless. I thought it would be unwise to ask the user to specify a number of rankings in advance, and then only accept that number!

[![](http://www.vsoch.com/blog/wp-content/uploads/2010/12/5-Rankings-Example-201x300.jpg "5 Rankings Example")](http://www.vsoch.com/blog/wp-content/uploads/2010/12/5-Rankings-Example.jpg)

**6) Output files **produced include a **RESULTS.mat**, a matrix of all the variables, which is updated as the script runs in the case that someone accidentally shuts out of it, and two excel files: one for raw data, and one for the averages.

[![](http://www.vsoch.com/blog/wp-content/uploads/2010/12/6-Output-Files.jpg "6 Output Files")](http://www.vsoch.com/blog/wp-content/uploads/2010/12/6-Output-Files.jpg)

**7) **After the output files are produced, the script calculates the winners for each category, and presents them to the user, along with the revealed list of beer names. Note that I didn’t do any sort of rounding or truncation for decimal points.

[![](http://www.vsoch.com/blog/wp-content/uploads/2010/12/7-Results-in-WIndow-294x300.jpg "7 Results in WIndow")](http://www.vsoch.com/blog/wp-content/uploads/2010/12/7-Results-in-WIndow.jpg)

**8 ) Average Results File **contains the average ratings for each category for each beer, in the case that people are curious about 2nd, 3rd, 4th place, etc. Here is also where the comments are stored, which could be fun to save to look back on every year, if you’re into that kind of thing. I should also point out that the script doesn’t do anything in the case of two beers coming in at a tie – it simply keeps whichever one was found first as a winner. This is another update that could be implemented at some future point.

[![](http://www.vsoch.com/blog/wp-content/uploads/2010/12/8-Average-Results-File-300x121.jpg "8 Average Results File")](http://www.vsoch.com/blog/wp-content/uploads/2010/12/8-Average-Results-File.jpg)

**9) Raw Data Results File: **I’m a proponent of always having your raw data somewhere, in the case that there was an error in calculation, or the results file explodes, you still have something to work with! Here it is.

[![](http://www.vsoch.com/blog/wp-content/uploads/2010/12/9-Raw-Results-File-300x107.jpg "9 Raw Results File")](http://www.vsoch.com/blog/wp-content/uploads/2010/12/9-Raw-Results-File.jpg)

and [here is the script](https://gist.github.com/vsoch/8248034), if you care to take a look at the hard-coded monstrosity, haha. It’s shamefully ugly, but it’s going to work perfectly for how we need it, and I’m sure I’ll make a second, more elegant version at some future point!

Merry Christmas everyone! Be safe!

**Added December 15, 2010: **Here are the actual results:

[![](http://www.vsoch.com/blog/wp-content/uploads/2010/12/beerrank_output-288x300.jpg "Beerrank Real Output")](http://www.vsoch.com/blog/wp-content/uploads/2010/12/beerrank_output.jpg)

and for lab pictures, see [here](http://www.haririlab.com/xmas.html)


