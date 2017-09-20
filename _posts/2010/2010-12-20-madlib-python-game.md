---
title: "Madlib Python Game!"
date: 2010-12-20 12:21:03
tags:
  code
  game
  madlib
  python
---


In my free time I’ve been figuring out object oriented programming. I am happy to post that I have just finished my first OOC (object oriented code) in python, and am excited to share what I’ve learned!

I decided to pick a simple project that would require some file reading and writing, as well as user input and standard output, since these basic ideas can be tweaked and applied towards running imaging analysis. The following script uses a text file as a template to play a game of madlib. The text file can be however you like, however the words that will be found and presented to the user for substitution should be in the format SUB_NOUN_SUB, SUB_ADJECTIVE_SUB, etc.

**Here is how it works:**

1. When madlib.py is called, we of course start in main(), and the madlib class makes an instance of itself (mymadlib = madlib())
2. **mymadlib.getFile():** The user is asked to specify a text file to be used. If in the same directory, you can just type “mytext.txt.” If not in the same directory, the full path should be written out. The script checks to make sure that the file is a .txt or .doc file (other types could be added), and then checks if the file exists. If it does, we open it, if not, we spit out an error.
3. **mymadlib.outputName():** We then keep asking the user for an output name until one is entered that doesn’t already exist in the current directory. The output will be put in the present working directory.
4. **mymadlib.readFile():** This function does the majority of the heavy lifting. It first reads all words in the text file into a list, and and then uses regular expressions to create an expression to match of the format (SUB_anything_SUB). Case does not matter, however there can be no spaces between the SUBs. If there is a space, the expression will get split into two when the file is read in, and then will not get matched, and will be not filled in with user input. So it’s important to format the substitutions with no spaces! Underscores are fine.
5. We then check if the length of the list is greater than zero, meaning we aren’t dealing with a blank file. When I tested this, it also reported a file filled with only carriage returns as having a length of 0,m so it should skip over reading the words if the file is empty OR filled with carriage returns.
6. We search through each word looking for the expression. If we find a word to substitute, we present it to the user with
7. **mymadlib.getWord(): **which is referred to as self.getWord() since we are calling it within the class. This function simply prompts the user for input for whatever expression is specified between the SUB’s.
8. It returns the user’s word choice, which is then insert into the list at the same spot as the original word, and then since the original word is moved one spot forward in the list, we remove it completely by using a function called pop() which can be applied to lists.
9. When this process has been done for every SUB word, we use **mymadlib.createLib() **to print out new list to the terminal for the user to say, and also save it to our specified output file. Since this function is also called within the class, we reference it as self.createLib().

**A few things that I learned:**

- A class is essentially an object. You create instances of the object, and then can call functions specific to that object on your instance. So for example, since my class is called class madlib:, I can create a madlib object with a simple mymadlibname = madlib(). Then if I want to call a function in this class on my object instance, I can say mymadlibname.myfunction().
- If we create an object and simply call the class as a script (calling madlib.py, for example) this goes directly to the main() class.
- The if statement at the bottom is necessary because it makes sure that main() is only run if the script is being called. If madlib is just being used as an object for another script, then we don’t want to call the first main().
- The import statements at the top are basically pointing to common classes that add functionality to my script. For example, import re let’s me use regular expressions. How do I feel about the ability to do this and select from a seemingly endless library of classes? …like a kid in a candy store! :O)
- Each function within the class, since we are dealing with an object, by default takes the object as an input parameter, represented as ‘self.’ If a function has multiple inputs ‘self’ MUST be the first parameter, unless it’s called with the variables specified, in which case the order doesn’t matter.
- A couple of very powerful data structures include lists, dictionaries, and tuples. I created a tuple by accident, and had a lot of fun playing around with these different structures with my friend!
- re.compile returns a MatchObject, which can be referenced with myobject.group() (to print out the entire match) and myobject.start() and myobject.end() to print the start and end locations of the match in the string.
- Holy cow, if I just type “python” into my terminal window, that allows me to play! Previously I was writing python code in a .py file, and testing it by running it.

Here is the class and a sample text file, if you would like to try out my script! If you make any madlib’s, send them my way and I’d love to play them :O)

[Madlib.py](https://gist.github.com/vsoch/8247992)  
[TownStory.txt](http://www.vsoch.com/LONG/Vanessa/SCRIPTY/python/townstory.txt)


