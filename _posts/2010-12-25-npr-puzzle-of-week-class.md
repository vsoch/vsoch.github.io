---
title: "NPR Puzzle of Week Class"
date: 2010-12-25 09:58:16
tags:
  npr
  puzzle
  python
---


Merry Christmas everyone! I wanted to share the start of a class that I have written (and will very likely keep modifying) in python to solve NPR Puzzle’s of the Week. These puzzles commonly involve shuffling around letters in a state / city / TV show / etc, and re-arranging, subtracting, adding, to make something new. The way to get from some starting point to an answer is usually systematical and logical, and the limiting factor of the entire process is the human’s ability to filter through massive amounts of data.

So let’s say that you have the patience of a monk. You still can very likely go through hundreds of possibilities and miss the answer. With this in mind, I wanted to create a class that would help solve the puzzles. I am very much someone who enjoys developing procedure to get to a solution that might be used again, and so instead of writing a more extensive script for every puzzle, I chose to write a class. It would have basic functionalities like reading data from file, retrieving data points, getting field names, and writing output to file. I would bet that if I searched, I’d find a combination of modules that I could use that would do this just fine, but I really wanted to create my own, and modify it over time to fit my needs.

> **The challenge for last week was the following:** Name a city in the United States that ends in the letter S. The city is one of the largest cities in its state. Change the S to a different letter and rearrange the result to get the state the city is in. What are the city and state?

**I broadly decided that I wanted the following functions in my class:**

**INPUT**

- setFile(): we need something to be able to make sure the file exists and is readable
- parseData(): should be able to read in all of the data, regardless of how many columns of data we have, after checking that file has been set.

**READ**

- lookup(): should be able to look up a value in the data based on an x,y coordinate
- entireRow(): we should be able to return an entire row of data at once
- getFieldNum(): given that the number of columns isn’t predictable, I want a function that tells me how many I have
- getFieldName(): I want a function that, if called without argument, gives me all the headers / first entries of each field, and if given a coordinate, n, returns the header of the nth row

**OUTPUT**

- fileout(): sets the output name, so I can always specify what I want my results file to be called
- writeOut(): writes to the output file, and will alert the user if the output file has not been defined

**Given these functions, I decided on these class variables:**

- self.file: the data file name to be read, originally set as Null
- self.fields: will be a list holding the column titles of the data read from file
- self.data: will be a list that holds the raw data for each column
- self.numentries: the number of data entries (rows)
- self.numfields: the number of fields (columns) in the file

**Here is the first draft of the class**:

code

I also want to note that I found functionality in the csv class. something called “sniffer” that I am going to implement to make it possible to figure out if the data file has header info or not. Since I am still working on this, the sniffer code is currently commented out.

**…and here is the script that uses this class to solve the puzzle detailed above:**

code

and [here is the data file](http://www.vsoch.com/LONG/Vanessa/SCRIPTY/python/solvedata.txt) that I input (sans extension), which includes just under 300 of the largest cities, their respective states, and the population (didn’t need this one, but threw it in since it was available) in the United States.

The second script above reads through each entry, and for each one, puts each character (made lowercase) from both the state and city into separate lists. It then removes all white spaces, and checks to see if the list lengths are equal. if they aren’t, we shouldn’t bother going any further. If they are, we move through one list and check each character for existence in the other. Whenever we find a match, we add one to the count. Here is where I would have added a line that removes the “found” character from the second list after being found in the case that we are dealing with strings with duplicate characters. Without the check, a city with two a’s would add one to the count for a state with only one a, since the a isn’t removed after being found. I am aware that this could produce imperfect results, however for this early version I decided that my human eye could be the solution for any slip-ups. And honestly, I jumped the gun a bit – I was so excited to give it a test run that I didn’t go back and add functionality to remove the character.

The next step looks to see if the count is equal to the length minus 1, theoretically meaning that they might match by all but one of the characters. What I wanted was a short list of city/state contenders, and then my human eye could easily pick out the winner. I lucked out in that the script found only one possible answer, and it was the correct answer!

> [‘Yonkers’,’New York’,’201,066′]

Hooray! That definitely is a solution. For those familiar with python, the above output is obviously just a print of the entire row of data that fit the bill. It would be entirely do-able to add more functionality to the class and to the script that uses it to produce a more attractive output file.

I will continue to work to modify this class to fit my needs for new puzzles in coming weeks. And I think that it’s important to note that there is still an extremely large probability of error. Whether you are human or machine, you could always do a bad job of selecting your data. If the data file is weirdly formatted, it would have a lot of trouble being read, and I didn’t make any checks for a standard format. I also assume that the first row is the header data, and it might be the case that someone uses data without headers. These are things that are on my mind that I will continue to try and improve as I learn more python.


