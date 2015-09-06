---
title: "Find the smallest prime greater than an input number"
date: 2010-10-11 20:01:25
tags:
  code-2
  grelin
  matlab
  puzzle
---


that is also in the Fibonacci Sequence!

For this one I left in all my print lines that were used for debugging / testing purposes. This script takes in a number, and finds the smallest prime that is greater than that number that is also part of the [Fibonacci Sequence](http://en.wikipedia.org/wiki/Fibonacci_sequence). It starts with the numbers 1 and 1, of course (the first two in the Fibonacci Sequence) and moves upward in the sequence until it hits a member of the sequence that is above the input number. It stops at the two members of the sequence before this number, and then adds these two numbers, tests if the outcome is prime, and if so, returns the value as an answer. If not, it calculates the next number in the sequence, and continues testing.

- The main function is called prime_fibonacci() with the number going in as input. There are two subfunctions one_up, which moves us up one order in the sequence to the next two numbers (so from 1, 1 to 1 2, for example) and

- is_prime: which does exactly what you would think – it first tests if the number is divisible by two, and if so, returns false (0). If not, it takes in an input number and tests for primeness by dividing by all possible factors – 1 through the (number + 1) /2. The modulus function is used for this test. In the case that there is no remainder, this means that the number is not prime, and we return false. In the case that there is always a remainder, then hooray! The number is prime, and we return it as the answer.

code


