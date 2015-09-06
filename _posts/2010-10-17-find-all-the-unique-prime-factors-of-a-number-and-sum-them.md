---
title: "Find all the unique prime factors of a number, and sum them"
date: 2010-10-17 13:36:35
tags:
  challenge-puzzle
  grelin
  matlab
---


Here is part two of the coding challenge: to write a script that takes an input number, and finds the sum of all of the unique prime factors of that number. My script is by no means elegant, but it logically goes through a series of steps to get the correct answer, probably in a similar way to how I might solve the problem. It first creates a structural array to hold unique prime factors, and first checks for 0 and 1, and then if the number is divisible by two.

- If we are dealing with 0 or 1 or a negative number. a very prompt is returned!

- If the number is not divisible by 2, we move on to the subfunction “filter_primes” that checks to see if the input number is divisible by the numbers 1 through the (input number / 2 +1). If we find a number that works, we check to see if it’s prime. If it’s prime, then we add it to our array. If not, we move on.

- If the number IS divisible by 2, we just add 2 to our list of prime factors, and then we create a new number, our first number divided by two. We check to see if that number is prime, because if it is, then our answer is simply 2 and that number, and we are done. If the new number isn’t prime, then we go right into “filter_primes.”

At the end, we present the user with the array of unique prime factors, and the sum.

code

Here is a visual. I could remove a lot of the print lines (minus the answer) – these were just for debugging purposes! [![](http://www.vsoch.com/blog/wp-content/uploads/2010/10/fibonacci-output-300x172.jpg "output image")](http://www.vsoch.com/blog/wp-content/uploads/2010/10/fibonacci-output.jpg)


