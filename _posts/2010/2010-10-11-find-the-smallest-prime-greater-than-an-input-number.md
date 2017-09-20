---
title: "Find the smallest prime greater than an input number"
date: 2010-10-11 20:01:25
tags:
  code
  grelin
  matlab
  puzzle
---


that is also in the Fibonacci Sequence!

For this one I left in all my print lines that were used for debugging / testing purposes. This script takes in a number, and finds the smallest prime that is greater than that number that is also part of the [Fibonacci Sequence](http://en.wikipedia.org/wiki/Fibonacci_sequence). It starts with the numbers 1 and 1, of course (the first two in the Fibonacci Sequence) and moves upward in the sequence until it hits a member of the sequence that is above the input number. It stops at the two members of the sequence before this number, and then adds these two numbers, tests if the outcome is prime, and if so, returns the value as an answer. If not, it calculates the next number in the sequence, and continues testing.

- The main function is called prime_fibonacci() with the number going in as input. There are two subfunctions one_up, which moves us up one order in the sequence to the next two numbers (so from 1, 1 to 1 2, for example) and

- is_prime: which does exactly what you would think – it first tests if the number is divisible by two, and if so, returns false (0). If not, it takes in an input number and tests for primeness by dividing by all possible factors – 1 through the (number + 1) /2. The modulus function is used for this test. In the case that there is no remainder, this means that the number is not prime, and we return false. In the case that there is always a remainder, then hooray! The number is prime, and we return it as the answer.

<pre>
<code>
function prime_fibonacci(number)

% Find 2 fibonacci numbers below the number given by the user.  Start with
% n_one as 1, and n_two as 1, and slowly work upwards until we are just
% below the user specified number.
n_one = 1;
n_two = 1;

% n_one is always larger, we check it first.  At the end of this loop we
% have the two numbers in the Fibonacci sequence directly before our input
% number
fprintf('%s%d%s%d\n','Number one is ',n_one,' and Number two is ',n_two);

while n_one < number && n_two < number
if n_one + n_two <= number
[n_one,n_two] = up_one(n_one,n_two);

fprintf('%s\n','The summed numbers are still less than the input number, getting next set.');
fprintf('%s%d%s%d\n','Number one is now ',n_one,' and Number two is ',n_two);
else
fprintf('%s\n','The summed numbers would be equal or greater than the input number, stopping');
break;
end
end

% We add the two numbers to get the next number in the Fibonacci sequence,
% which we know is larger than our number after the tests above.  We now
% need to check if this number is a prime.  If yes, then we've found our
% answer.  If not, then we need to look at the next number.

decision = 0;
while decision == 0;
decision = isprime(n_one + n_two);
if decision == 0
fprintf('Creating a new set of numbers...')
fprintf('%s%d%s%d\n','New Numbers: Number one (',n_one, ') and Number two: (',n_two, ')');
[n_one,n_two] = up_one(n_one,n_two);
else
answer = n_two + n_one;
fprintf('%s%d%s%d%s%d\n','The sum of Number one (',n_one, ') and Number two (',n_two, ') is a prime number! ',answer);
fprintf('%s%d\n','The answer is ',answer);
end
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
fprintf('%s%d%s%d\n','The number ',number_two,' is even so it cannot be prime');
f = 0;
return;
else
fprintf('%s%d%s\n','The number ',number_two,' is not even, checking divisibility')
for i = 3:(number_two/2)
fprintf('%s%d\n','Checking divisibility for ',i)
if mod(number_two,i) == 0
fprintf('%d%s\n',number_two,' is divisible by ',i, ' and therefore cannot be prime!');
f = 0;
return;
end
end
f = 1;
fprintf('%d%s\n',number_two,' is not divisible by anything and is therefore prime!');
return

end
end

%--------------------------------------------------------------------------
% Function upone
%
% This function creates the next two fibonacci numbers.  n_one is always
% treated as the larger of the two.
%--------------------------------------------------------------------------
function [numone,numtwo] = up_one(one, two)

numone = one + two;
numtwo = one;
return

end

end

</code>
</pre>


