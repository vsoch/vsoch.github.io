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


**Smallest Number Divisible by 1 through 20**

This challenge was to find the smallest positive number that is evenly divisible by all of the numbers from 1 to 20. Surprise! I didn’t use a script. I found this question refreshing because I was able to whip out pencil and paper, and solve it that way. I first listed the numbers from 1 and 20, and the prime factors of each:

<table cellpadding="1%" cellspacing="1" style="height: 617px;" width="221"><tbody><tr><td>**1:** 1</td><td>**11:** 11</td></tr><tr><td>**2: **2</td><td>**12:** 2*2*3</td></tr><tr><td>**3:** 3</td><td>**13: **13</td></tr><tr><td>**4:** 2*2</td><td>**14:** 2*7</td></tr><tr><td>**5:** 5</td><td>**15:** 3*5</td></tr><tr><td>**6:** 2*3</td><td>**16:** 2*2*2*2</td></tr><tr><td>**7:** 7</td><td>**17:** 17</td></tr><tr><td>**8:** 2*2*2</td><td>**18:** 2*3*3</td></tr><tr><td>**9:** 3*3</td><td>**19:** 19</td></tr><tr><td>**10:** 2*5</td><td>**20:** 2*2*5</td></tr></tbody></table>So, it makes sense that, if you have a number like 16 which breaks down to 2*2*2*2, this also includes the prime factors of 2 (2) and 8 (2*2*2), so since we are finding the smallest number that is divisible by the numbers 1 through 20, I would only need to include 16 (2*2*2*2) in this calculation, and that will by default be divisible by 2 and 8 as well. So, when I had these listed out on paper, I just circled the largest occurrence of each prime factor, and mutiplied these together to get the answer. I won’t put the answer here, but the numbers I multiplied were:

> (2*2*2*2)*(3*3)*(5)*(7)*(11)*(13)*(17)*(19)

**Pythagorean Triplet**

<pre>
<code>
function pythagorean_triplet(number)
%————————————————————————–
% This function finds a pythagorean triplet that adds up to a certain
% number input by the user (number), if one exists!
%
% I solved the two equations, both for (c*c), and then set them equal
% to one another, and cycled through potential sets of a's and b's
% until a solution was found that sets both sides of the equation equal to
% one another, the value of (c*c)
%
% EQUATION 1:  a + b + c = 1000    –> so EQUATION 3: c = 1000-a-b
% EQUATION 2: ((a*a)+(b*b))=(c*c)  –>; Pythagorean Theorum
%
% Square EQUATION 3    (c*c) = ((1000-a-b))*(1000-a-b))
%
% Set EQUATION 2 and EQUATION 3 equal to one another, since both
% equal (c*c).  Numbers a and b that satisfy that equation = solution!
% ((a*a)+(b*b)) = ((1000*(-a)*(-b))(1000*(-a)*(-b)))
%————————————————————————-

for a=1:number
for b=1:number
if (((a*a)+(b*b)) == ((number -a -b))*(number -a -b))
fprintf('%s%d\n','a = ',a);
fprintf('%s%d\n','b = ',b);
fprintf('%s%d\n','c = ',(1000-a-b));
fprintf('%s%d\n','The product is: ',(a*b*(number-a-b)));
return;
end
end
end

fprintf('%s%d\n','There is no pythagorean triplet that adds up to ',number);
end
</code>
</pre>

</code>
</pre>

**Count Primes**

This script returns the nth prime number, where n is specified by the user. Since I had already created a function that checks if a number is prime for a previous challenge, I decided to modify that script for this task. The script sets a counting value, j, equal to 1, and then enters a while loop that continues until the variable ‘done’ is set to yes. Within this while loop for every odd number, we check if the number is prime. If the number is prime, we add one to the count of the prime_counter variable, which keeps track of what prime number we are currently at. When this prime_counter is equal to the user specified number, this is our solution.

<pre>
<code>
function prime_count(number)
%--------------------------------------------------------------------------
% This function finds the nth prime number, where n = a number input
% by the user
%--------------------------------------------------------------------------

% Place the original number in a variable so we can reference it later
prime_counter = 0;

% First check if we have been given 0 or 1.
if (number == 0)
fprintf('%d%s\n',number,' is not a valid input number.');
return
end

if (number < 0)
fprintf('Please enter a positive number.\n');
return
end

done = 'no';
j = 1;

while strcmp(done,'no')
%If the number is even, skip it
if (mod(j,2)==0)
else

% Figure out if we have a prime
if (isprime(j))
prime_counter = prime_counter+1;
if prime_counter == number;
fprintf('%s%d%s%d%s\n','The prime number at the ',number,' spot is ',j,' and we have finished searching for primes!')
done = 'yes';
end
end
end
j = j+1;
end

%--------------------------------------------------------------------------
% Function isprime
%
% This function checks if an input number is prime by dividing by all
% possible factors through the input number / 2.  In the case that there
% is always a remainder for all these divisions, we know that the number
% has to be prime, meaning that it is only divisible by 1 and itself.
%--------------------------------------------------------------------------
function f = isprime(number_two)

% if our number is even, we don't continue
if mod(number_two,2)==0
f = 0;
return;
else
for i = 3:(number_two/2)
if mod(number_two,i) == 0
f = 0;
return;
end
end
f = 1;
return
end
end
end
</code>
</pre>

**Fibonacci Even Sum**

This was the first challenge that I attempted with java. I literally downloaded netbeans right before writing this, and reintroduced myself to java syntax, which I haven’t touched in 6 years! It was super awesome, and came back to me pretty quickly. While I’m still very rusty, I apologize for the lack of elegance… I will need time to warm up!

This script calculates the numbers in the fibonacci sequence up to a certain ceiling, specified by the user. It first checks to make sure that there is only one input argument, and that it is an integer. In then calculates the Fibonnaci numbers up to that number, and in the case that the number is even, adds it to a sum. When we reach the ceiling, the script returns the sum to the user. It was very cool to compile and build this, so that I could run it in the command prompt!

<pre>
<code>
/*
* Fibonacci Even Sum
* This script finds the sum of all even Fibonacci numbers below a user specified number (4 million)
*/
package fibevensum;

/**
* Vanessa Sochat
* October 23, 2010
*/
public class Main {

public static void main(String[] args) {

// Check to make sure we have one arguments
if (args.length != 1) {
System.out.println("This script only takes one input argument.");
System.out.println("...a number ceiling to check for primes below it.");
System.exit(0);
}

//Check to make sure we have an integer
try {
int ceiling = Integer.parseInt(args[0]);
System.out.println("The number we are using is " + ceiling);
} catch(NumberFormatException ife) {
System.out.println(args[1] + "is not a number, exiting");
System.exit(0);
}

// Start off by declaring the first two numbers, and a sum.
int one = 1;
int two = 1;
int holderone;
int holdertwo;
int sum = 0;

// While our lower number (one) is below the ceiling, keep going
while (one < Integer.parseInt(args[0]))
{

// If both numbers are below the ceiling
if (one < Integer.parseInt(args[0]) && (two < Integer.parseInt(args[0])))
{

if (one==0)
{
System.out.println("Adding " + one + " to the sum");
sum = sum + one;
}

if (two%2==0)
{
System.out.println("Adding " + two + " to the sum");
sum = sum + two;
}
}

// If the smaller number is below the ceiling, but
// the larger is not
else if (two >= Integer.parseInt(args[0]) && one < Integer.parseInt(args[0]))
{
if (one==0)
{
System.out.println("Adding " + one + " to the sum");
sum = sum + one;
System.out.println ("The sum is " + sum);
System.exit(0);
}
}

// If BOTH numbers are above the ceiling (although we shouldn't be
// in this loop at all) return the sum)
else if (two >= Integer.parseInt(args[0]) && (one>= Integer.parseInt(args[0])))
{
System.out.println("Both numbers are greater than ceiling. The sum is " + sum);
}
one = one + two;
two = one + two;
}

System.out.println ("The sum is " + sum);
}

</code>
</pre>


**Difference Between Sum of Squares and Square of Sums **

This was my second java script, and it’s again pretty simple. It takes in a user specified number, and calculates the sum of the squares up to this number, as well as the square of the sum of this number, and then returns the difference.

<pre>
<code>
/*
* This script calculates the sum of the squares up to a certain number, n
* and the square of the sums, and finds the difference.
*/

package sumsquarediff;

/**
*
* @author Vanessa
*/
public class Main {

public static void main(String[] args) {
int ceiling = Integer.parseInt(args[0]);
int sum = 0;
int sumsquares = 0;
int i;

//Find the sum of the numbers, and square, and find the squares, and sum

for(i=1;<=ceiling;i++){
sum = sum + i;
sumsquares = sumsquares + (i*i);
}

int squaresum = (sum * sum);
System.out.println("The sum of the numbers squared is: " + squaresum);
System.out.println("The sum of the squares is " + sumsquares);

int difference = squaresum - sumsquares;
System.out.println("The difference is " + difference);
}
}
</code>
</pre>


**Largest Palindrome Produced by Multiplying Two Three Digit Numbers**

This script finds the largest palindrome produced by multiplying two three digit numbers. Since it was my third java script, I decided to step it up and include a sub-function, called “reverse,” which works recursively to return a reversed string. It works by cycling through potential answers, x and y, starting at 999 for each, and counting down to 1. For each potential pair, it multiples the two numbers, converts this value into a string, reverses it, checks to see if the reversed string is equal to the original number (as a string), and if so, returns the palindrome, which is the answer that we are looking for.

<pre>
<code>
/*
* PaliProd3Nums:  This script finds the largest palindrome
* that is a product of two three digit numbers
*/

package paliprod3nums;

public class Main {

public static void main(String[] args) {
int x;
int y;
int product;
String prodstring;
String reversed;
int largest = 0;
int holder;

for(x=999;x>100;x--)
{
for(y=999;y>100;y--)
{
product = x*y;
prodstring = Integer.toString(product);
reversed = reverse(prodstring);
if (prodstring.equals(reversed))
{
//Tell the user about the possible answer
System.out.println("A possibility is " + x + " times " + y);
System.out.println("which is equal to "; + prodstring);

//Check to see if this answer is larger than our current largest
holder = Integer.parseInt(prodstring);
if (holder > largest)
{
largest = holder;
}
}
}
}
System.out.println("The answer is " + largest);
}
public static String reverse(String input)
{
String holder = null;
String ending = null;

if (input.length() == 1)
{
return input;
}
else
ending = input.substring(input.length()-1,input.length());
String rest = input.substring(0, input.length() -1);
holder = ending + reverse(rest);
return holder;
}
}
</code>
</pre>

**Sum Multiples of 3 and 5 Below a Specified Ceiling**

This script is pretty dry – it takes in a user input “ceiling,” and then iterates through a loop first checking if the number is a multiple of 3, and then 5. When it finds a number that is either a multiple of 3 or 5, it adds this number to a total sum, and at the end, returns this sum to the user.

<pre>
<code>
function sum_35multiples(ceiling)

%--------------------------------------------------------------------------
% This function takes a number ceiling, finds all the multiples of three
% and five below this ceiling, and then sums them.
%
% Vanessa Sochat     October 23, 2010
%--------------------------------------------------------------------------

% Go through numbers 1 through ceiling, check if multiple of 3 or 5, and if
% it is, add it to our sum.  If it's a multiple of 3, then we skip the
% multiple of 5 check.  If it's not a multiple of 3, we check for 5, so no
% numbers get counted twice.
sum=0;

for i=1:ceiling-1
if mod(i,3)==0
sum = sum + i;
elseif mod(i,5)==0
sum = sum + i;
end
end

fprintf('\n%s%d\n','The sum is ',sum);
end
</code>
</pre>

