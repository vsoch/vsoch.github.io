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

<pre>
<code>
for i = ( 0:(2^numel(theSet))-1 )
</code>
</pre>

3) We then want to find the indices for each possible set. This means that, for each value of i, we will generate an array of 0’s and 1’s, with a one at each spot where a member is located.

<pre>
<code>
indices = logical(bitget( i,(1:numel(theSet)) ));
</code>
</pre>

4) We can then use these indices to get the actual numbers from the set, and put the set into a variable.

<pre>
<code>
set_holder = {theSet(indices)};
</code>
</pre>

5) We then look at only the subsets that have greater than one member, find the largest value, and compare this value to the sum of the remaining elements. This is where the script would break if the input set wasn’t ordered from least to greatest, because it assumes that the last element in the set is the largest. If the sum matches the largest member, we add it to our candidates variable (p is returned, which feeds into “candidates”), and add one to the count!


<pre>
<code>
% If the set is greater than one element
if length(set_holder{1}) > 1
% Find the index of the largest number, get the number
% (Assuming set organized least --> greatest)
largest_member = find(indices,1,'last');
largest_member = theSet{largest_member};

total_sum=0;
% Get the sum of the remaining numbers
set_sum = find(indices(1:length(indices)),'1');
for z = 1:length(set_sum)-1
total_sum = total_sum + theSet{set_sum(z)};
end

% If the sum of the elements matches the largest number,
% add it to our output set:

if (total_sum == largest_member)
p{candidate_count+1} = {theSet{indices}};
candidate_count = candidate_count +1;
end
end
</code>
</pre>

6) Lastly, if at the end of this process we haven’t found any answers, we return p as an empty set, so the script notifies the user that there are no sets that fit the criteria.

**Things that I would change:**

I will post the script that I used to find the answer below, but I also want to talk about some tweaks that I would make to it to make it slightly more efficient. Efficiency and speed isn’t something that I’ve been overly concerned about, but I realize that if I want to get better, I need to start taking it into consideration. So, if I were to add to this script, I would do the following:

- Possibly pre-allocate memory for the variable that holds the answers. I don’t have a great understanding of this stuff, but I think that if a variable changes size on every iteration, it always has to find a new spot in memory. But on the other hand, if I allocate memory based on the largest possible subset, that would be a waste for the smaller subsets. So it’s a question of whether it’s better to take up more memory off the bat, or leave it to allocate on the fly.
- Recursion! There is likely a clever way to do this recursively, and of course that would be even more efficient.
- The challenge just needed the count of the number of subsets that match the criteria, and I decided to save them all into a variable, and then cycle through them to not only return a count, but present the largest to the user. This obviously wasn’t required, and isn’t necessary, and instead I could just present the “candidate_count” variable to the user at the end.
- I think that getting an ordered list was nice, but it is potentially not always going to be the case. So you would want the script to first order the numbers from least to greatest, and then perform the algorithm. That way, we can be assured that the last member of the script is always the greatest. As is, if this script was fed an out of order array, it would still assume the last number to be the greatest, and not function appropriately.

Here is the full script, a la Matlab. How I love Matlab! Keep in mind that this display mucks up greater than and less than symbols.

<pre>
<code>
function powerset(Set)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This script takes in a set of numbers, and finds the largest subset
% for which the largest number is the sum of the remaining numbers, and
% returns a count of and list of all the subsets that this criteria applies
% to, as well as the largest subset.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% First we want to cycle through all the subsets of the input set, and save the
% ones that have the largest number be the sum of all other numbers.  Since,
% according to wikipedia, the largest number of subsets for any set is 2 to
% the n, we can go through a loop of that size and create indices for every
% combination of subsets, and then add subsets to an array that are
% candidates.  We will use the function powerset_review to do this!

candidates = powerset_review(Set);

% Once we have our candidates, we want to find the largest of the set, and
% return this as the answer.

% If we have zero candidates:
if size(candidates) == 0;
fprintf('%s\n','No subsets found for which the largest number is equal to the sum of the remaining numbers')
return
end

% If we have one candidate, return as the answer.
if size(candidates) == 1
fprintf('%s\n','The following subset is the only set in the powerset for which the largest number is equal to the sum of the remaining numbers:')
candidates{1}
return
end

% For all others, when we have more than one candidate, we keep track of the
% largest subset that the pattern applies to, and in the case of finding an
% equivalent length, we keep the first one found:

if length(candidates)&amp;amp;amp;amp;amp;amp;gt;1
fprintf('\n%s\n','All sets for which the largest number is equal to the sum of the remaining numbers include: ')
candidates{1,:}
current_largest = candidates{1};

for k=2:length(candidates)
compare_set=candidates{k};
if (length(compare_set) && length(current_largest))
current_largest = compare_set;
end
end
fprintf('%s%d\n','The number of total candidate subsets is ',length(candidates));
fprintf('%s\n','The following subset is the first largest set found in the powerset for which the largest number is equal to the sum of the remaining numbers:')
current_largest
return
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This function returns subsets from the powerset that have the largest
% number = the sum of the rest of the numbers!
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function p = powerset_review(theSet)
candidate_count=0;

% Deal with empty and one member sets
if isempty(theSet)
fprintf('%s\n','You have provided an empty set.  There is no solution!');
p={};
return
end

if length(theSet)==1
fprintf('%s\n','You have provided a set with only one member.  There is no solution!');
p={};
return
end

% Generate all numbers from 0 to 2^(num elements of the set)-1
for i = ( 0:(2^numel(theSet))-1 )

% Convert i into binary, convert each digit in binary to a boolean
% and store that array of booleans
indices = logical(bitget( i,(1:numel(theSet)) ));

% Use the array of booleans to extract the members of the original
% set, and check the set to see if the largest number is equal to
% the sum of the additional numbers.  If yes, store the set
% containing these members in the powerset.  This algorithm
% assumes that the set is sorted from least --&amp;amp;amp;amp;amp;amp;gt; greatest.
set_holder = {theSet(indices)};

% If the set is greater than one element
if length(set_holder{1}) > 1
% Find the index of the largest number, get the number
% (Assuming set organized least --> greatest)
largest_member = find(indices,1,'last');
largest_member = theSet{largest_member};

total_sum=0;
% Get the sum of the remaining numbers
set_sum = find(indices(1:length(indices)),'1');
for z = 1:length(set_sum)-1
total_sum = total_sum + theSet{set_sum(z)};
end

% If the sum of the elements matches the largest number,
% add it to our output set:

if (total_sum == largest_member)
p{candidate_count+1} = {theSet{indices}};
candidate_count = candidate_count +1;
end
end
end
% If we go through the set and find nothing, be sure to return an
% empty variable
if candidate_count == 0;
p={};
return
end
end
end
</code>
</pre>

and here is a snapshot of finding the answer!

[![](http://www.vsoch.com/blog/wp-content/uploads/2010/10/powerset_output-300x191.png "powerset_output")](http://www.vsoch.com/blog/wp-content/uploads/2010/10/powerset_output.png)
