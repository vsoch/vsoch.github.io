---
title: "More Number Games"
date: 2010-10-25 15:37:18
tags:
  euler
  java
  matlab
  puzzle
---


These are incredibly fun, and I realize that it doesn’t make sense to write a separate entry for each one, so I will post them in clusters. I decided to attempt most of these using java over matlab, which will be good review, and more challenging than Matlab. Keep in mind that I haven’t looked at java in 6 years, so the first few will likely be done by brute force! For the ones done in Matlab, this is because I was working on a computer other than my personal laptop.

[Smallest Number Divisible by 1 though 20](#PosNumDiv1to20)  
[Pythagorean Triplet (Matlab)](#PythTheorum)  
[Count Primes (Matlab)](#PrimeCount)  
[Fibonacci Even Sum](#FibEvenSum)  
[Difference b/w Sum of Square and Square of Sum](#SumSquareDiff)  
[Largest Palindrome Produced by Multiplying Two 3 Digit Numbers](#ProdPali)  
[Sum Multiples of 3 and 5 Below a Specified Ceiling (Matlab)](#Sum35)

[]()  
**Smallest Number Divisible by 1 through 20**

This challenge was to find the smallest positive number that is evenly divisible by all of the numbers from 1 to 20. Surprise! I didn’t use a script. I found this question refreshing because I was able to whip out pencil and paper, and solve it that way. I first listed the numbers from 1 and 20, and the prime factors of each:

<table cellpadding="1%" cellspacing="1" style="height: 617px;" width="221"><tbody><tr><td>**1:** 1</td><td>**11:** 11</td></tr><tr><td>**2: **2</td><td>**12:** 2*2*3</td></tr><tr><td>**3:** 3</td><td>**13: **13</td></tr><tr><td>**4:** 2*2</td><td>**14:** 2*7</td></tr><tr><td>**5:** 5</td><td>**15:** 3*5</td></tr><tr><td>**6:** 2*3</td><td>**16:** 2*2*2*2</td></tr><tr><td>**7:** 7</td><td>**17:** 17</td></tr><tr><td>**8:** 2*2*2</td><td>**18:** 2*3*3</td></tr><tr><td>**9:** 3*3</td><td>**19:** 19</td></tr><tr><td>**10:** 2*5</td><td>**20:** 2*2*5</td></tr></tbody></table>So, it makes sense that, if you have a number like 16 which breaks down to 2*2*2*2, this also includes the prime factors of 2 (2) and 8 (2*2*2), so since we are finding the smallest number that is divisible by the numbers 1 through 20, I would only need to include 16 (2*2*2*2) in this calculation, and that will by default be divisible by 2 and 8 as well. So, when I had these listed out on paper, I just circled the largest occurrence of each prime factor, and mutiplied these together to get the answer. I won’t put the answer here, but the numbers I multiplied were:

> (2*2*2*2)*(3*3)*(5)*(7)*(11)*(13)*(17)*(19)

[]()  
**Pythagorean Triplet**

For this problem, the instructions were to find a Pythagorean triplet that summed to 1000. For review, a Pythagorean triplet is a set of three natural numbers, a so equation 3: c = 1000-a-b % equation 2: ((a*a)+(b*b))=(c*c) –>; pythagorean theorum % % square equation 3 (c*c) = ((1000-a-b))*(1000-a-b)) % % set equation 2 and equation 3 equal to one another, since both % equal (c*c). numbers a and b that satisfy that equation = solution! % ((a*a)+(b*b)) = ((1000*(-a)*(-b))(1000*(-a)*(-b))) %————————————————————————- for a=1:number for b=1:number if (((a*a)+(b*b)) == ((number -a -b))*(number -a -b)) fprintf(‘%s%d\n’,’a = ‘,a); fprintf(‘%s%d\n’,’b = ‘,b); fprintf(‘%s%d\n’,’c = ‘,(1000-a-b)); fprintf(‘%s%d\n’,’the product is: ‘,(a*b*(number-a-b))); return; end end end fprintf(‘%s%d\n’,’there is no pythagorean triplet that adds up to ‘,number); end “>code

[]()  
**Count Primes**

This script returns the nth prime number, where n is specified by the user. Since I had already created a function that checks if a number is prime for a previous challenge, I decided to modify that script for this task. The script sets a counting value, j, equal to 1, and then enters a while loop that continues until the variable ‘done’ is set to yes. Within this while loop for every odd number, we check if the number is prime. If the number is prime, we add one to the count of the prime_counter variable, which keeps track of what prime number we are currently at. When this prime_counter is equal to the user specified number, this is our solution.

code

[]()  
**Fibonacci Even Sum**

This was the first challenge that I attempted with java. I literally downloaded netbeans right before writing this, and reintroduced myself to java syntax, which I haven’t touched in 6 years! It was super awesome, and came back to me pretty quickly. While I’m still very rusty, I apologize for the lack of elegance… I will need time to warm up!

This script calculates the numbers in the fibonacci sequence up to a certain ceiling, specified by the user. It first checks to make sure that there is only one input argument, and that it is an integer. In then calculates the Fibonnaci numbers up to that number, and in the case that the number is even, adds it to a sum. When we reach the ceiling, the script returns the sum to the user. It was very cool to compile and build this, so that I could run it in the command prompt!

= integer.parseint(args[0]) && one = integer.parseint(args[0]) && (one>= integer.parseint(args[0]))) { system.out.println("both numbers are greater than ceiling. the sum is " + sum); } one = one + two; two = one + two; } system.out.println ("the sum is " + sum); } } ">code

[]()  
**Difference Between Sum of Squares and Square of Sums **

This was my second java script, and it’s again pretty simple. It takes in a user specified number, and calculates the sum of the squares up to this number, as well as the square of the sum of this number, and then returns the difference.

code

[]()

**Largest Palindrome Produced by Multiplying Two Three Digit Numbers**

This script finds the largest palindrome produced by multiplying two three digit numbers. Since it was my third java script, I decided to step it up and include a sub-function, called “reverse,” which works recursively to return a reversed string. It works by cycling through potential answers, x and y, starting at 999 for each, and counting down to 1. For each potential pair, it multiples the two numbers, converts this value into a string, reverses it, checks to see if the reversed string is equal to the original number (as a string), and if so, returns the palindrome, which is the answer that we are looking for.

 largest) { largest = holder; } } } } system.out.println("the answer is " + largest); } public static string reverse(string input) { string holder = null; string ending = null; if (input.length() == 1) { return input; } else ending = input.substring(input.length()-1,input.length()); string rest = input.substring(0, input.length() -1); holder = ending + reverse(rest); return holder; } } ">code

[]()  
**Sum Multiples of 3 and 5 Below a Specified Ceiling**

This script is pretty dry – it takes in a user input “ceiling,” and then iterates through a loop first checking if the number is a multiple of 3, and then 5. When it finds a number that is either a multiple of 3 or 5, it adds this number to a total sum, and at the end, returns this sum to the user.

code


