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

<pre>
<code>
 
function prime_divisors(number) 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% This function takes in a number, and returns the prime divisors of that % number, and also a sum of those divisors 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
% Place the original number in a variable so we can reference it later
original_number = number;
divisor_count = 0;

% First check if we have been given 0 or 1.
if (number == 0 ) || (number ==1 )
    fprintf('%d%s\n',number,' does not have any prime factors.');
    return
end

if (number < 0 )
    fprintf('Please enter a positive number.\n');
    return
end
    
% Check if the number is even (divisible by 2) If it is, divide by
% 2, and save 2 as the first divisor.  If not, use &quot;filter_primes&quot; to 
% find all numbers it is divisible by, and find the list of prime factors.
if mod(number,2)==0
    number = number/2;
    divisors{divisor_count+1}=2;
    divisor_count = divisor_count+1;
    
    % After we divide by 2 to get the new number, we need to check if it's
    % prime.  If it is, then we have finished and have our completed list.
    % We don't want to waste time checking for other potential numbers,
    % because this number = 2 * a prime
    if (isprime(number))
        divisors{divisor_count+1} = number;
        divisor_count = divisor_count+1;
        fprintf('%s%d%s\n','The number ',number,' is prime, and we have finished searching for primes.  Adding to list!')
        fprintf('%s\n','The list of primes is:')
        
        % Print out the list of prime divisors, as well as a sum.
        report_answer(divisors);
    else
        filter_primes(number);
    end
else
    filter_primes(number);
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
        for i = 3:(number_two/2)
            if mod(number_two,i) == 0
                fprintf('%d%s%d%s\n',number_two,' is divisible by ',i,' and therefore cannot be prime!');
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
% Function filter primes
%
% This function cycles through a number and finds all the numbers it is
% divisible by.  When it finds a number that it is divisible by, if the
% number is prime, it adds it to the list we are saving.
%--------------------------------------------------------------------------
function h = filter_primes(number_three)

    fprintf('%s%d%s\n','The number ',number_three,' is not even, checking divisibility')
    for j = 3:((number_three/2)+1)
        if mod(number_three,j) == 0
            fprintf('%d%s%d%s%d%s\n',number_three,' is divisible by ',j, ' checking if ',j,' is prime...');
            if (isprime(j)==1);
                divisors{divisor_count+1}=j;
                divisor_count=divisor_count+1;
            end
        end
    end
     report_answer(divisors);   
end
%--------------------------------------------------------------------------
% Function report_answer
%--------------------------------------------------------------------------
function r = report_answer(divs)

fprintf('\n%s%d%s\n','The list of prime divisors for ',original_number,' is:')
divs

sum=0;
for z= 1:divisor_count
    sum = sum + divs{z};
end
    
fprintf('%s%d\n','The sum of this list is: ',sum)
return
end
end
</code>
</pre>

Here is a visual. I could remove a lot of the print lines (minus the answer) – these were just for debugging purposes! [![](http://www.vsoch.com/blog/wp-content/uploads/2010/10/fibonacci-output-300x172.jpg "output image")](http://www.vsoch.com/blog/wp-content/uploads/2010/10/fibonacci-output.jpg)


