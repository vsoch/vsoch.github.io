---
title: "Find the Longest Reversed Substring in a String"
date: 2010-10-10 20:58:30
tags:
  code-2
  grelin
  matlab
  puzzle
---


This function takes in a string, “stringy,” and finds the longest reversed substring (palindrome) in the larger string. So, racecar would be an example because it is the same thing backwards and forwards!

I basically did it by identifying all the possible centers in the string (indicated by the pattern xyx, and then I went through those, and looked at the character directly to the left, and directly to the right, and checked for a match. If it matched, I then went one letter farther out, until they no longer matched, and the longest string found for each is recorded in a structural array with two fields: the answer, and the length. When I was finished looking through all of my possible centers, I print out the one with the longest length, and that is the answer!

The string given for the challenge was:

code

and my scripty-doo got it right on the first try! :O)

code


