---
title: "Find all sets in the powerset whose members sum to the largest"
date: 2010-10-19 13:09:33
tags:
  challenge
  grelin
  matlab
  puzzle
---


The last challenge in the Grelin Code Challenge asks to create a script that finds all subsets of an array where the largest number is the sum of the remaining numbers. For example, if we input (1, 2, 3, 4, 6) we should get the following subsets:

- 1 + 2 = 3
- 1 + 3 = 4
- 2 + 4 = 6
- 1 + 2 + 3 = 6

and the count is 4. The set of numbers that is provided to use is:

- (3,4,9,14,15,19,28,37,47,50,54,56,59,61,70,73,78,81,92,95,97,99)

For this question I couldn’t immediately sit down and start working. I knew that I needed to do some reading up on sets. I first refreshed my memory about powersets – a powerset of a set is all the possible subsets. So, for example, if we have a set (x,y,z), the entire powerset would include: (x),(y),(z),(xy),(xz),(yz),(xyz), plus the empty set (). And very cool – there is an equation to calculate the powerset! You can get the number of subsets in the powerset by using the equation P(s) = 2 to the n, where n is the number of elements in the set. So given that the set provided by the challenge has 22 members, this means that there are 2 to the 22 possible subsets, or 4,194,304 possible answers. Holy cow! I definitely need a script to figure this out!

**So what I decided to do: **

1. I first check for a set that is empty or only has one member. There are no solutions in these cases. If we have more than 1 member, then I cycle through a loop for the number of iterations equal to the number of possible sets in the powerset (2 to the n, where n is the number of possible subsets). We subtract one because the loop starts at 0.

code

3) We then want to find the indicies for each possible set. This means that, for each value of i, we will generate an array of 0’s and 1’s, with a one at each spot where a member is located.

code

4) We can then use these indicies to get the actual numbers from the set, and put the set into a variable.

code

5) We then look at only the subsets that have greater than one member, find the largest value, and compare this value to the sum of the remaining elements. This is where the script would break if the input set wasn’t ordered from least to greatest, because it assumes that the last element in the set is the largest. If the sum matches the largest member, we add it to our candidates variable (p is returned, which feeds into “candidates”), and add one to the count!

code

6) Lastly, if at the end of this process we haven’t found any answers, we return p as an empty set, so the script notifies the user that there are no sets that fit the criteria.

**Things that I would change:**

I will post the script that I used to find the answer below, but I also want to talk about some tweaks that I would make to it to make it slightly more efficient. Efficiency and speed isn’t something that I’ve been overly concerned about, but I realize that if I want to get better, I need to start taking it into consideration. So, if I were to add to this script, I would do the following:

- Possibly pre-allocate memory for the variable that holds the answers. I don’t have a great understanding of this stuff, but I think that if a variable changes size on every iteration, it always has to find a new spot in memory. But on the other hand, if I allocate memory based on the largest possible subset, that would be a waste for the smaller subsets. So it’s a question of whether it’s better to take up more memory off the bat, or leave it to allocate on the fly.
- Recursion! There is likely a clever way to do this recursively, and of course that would be even more efficient.
- The challenge just needed the count of the number of subsets that match the criteria, and I decided to save them all into a variable, and then cycle through them to not only return a count, but present the largest to the user. This obviously wasn’t required, and isn’t necessary, and instead I could just present the “candidate_count” variable to the user at the end.
- I think that getting an ordered list was nice, but it is potentially not always going to be the case. So you would want the script to first order the numbers from least to greatest, and then perform the algorithm. That way, we can be assured that the last member of the script is always the greatest. As is, if this script was fed an out of order array, it would still assume the last number to be the greatest, and not function appropriately.

Here is the full script, a la Matlab. How I love Matlab! Keep in mind that this display mucks up greater than and less than symbols.

code

and here is a snapshot of finding the answer!

[![](http://www.vsoch.com/blog/wp-content/uploads/2010/10/powerset_output-300x191.png "powerset_output")](http://www.vsoch.com/blog/wp-content/uploads/2010/10/powerset_output.png)


