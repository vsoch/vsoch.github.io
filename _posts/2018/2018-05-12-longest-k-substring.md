---
title: "Longest K Unique Characters Substring"
date: 2018-05-12 1:49:00
toc: false
---

Today I want to share a quick antecdote about struggling through deriving an equation for 
<a href="https://practice.geeksforgeeks.org/problems/longest-k-unique-characters-substring/0" target="_blank">an algorithm.</a>
Yes, I'm aware it has label <strong style="color:seagreen">easy</strong>. I thought it would be easy too until I
started programming it up, and my solution didn't work. What I learned is that when I am having trouble, 
I shouldn't try to solve the "best case" scenario first and then grab a ride on the fail bus because
I couldn't do it. Instead, I tried to derive a solution that was simple and logical to me, and then
attempt improving on that. If this were the real world? I would have colleagues and others to share my
thinking with, and you know what they say about counting heads. In my case, since it's only me, 
I am mainly satisifed that I got **some** solution and it's not the **worst** one *wink). Here is our problem:

>> Given a string, print the size of the longest possible substring that has exactly k unique characters.

And if there is no possible substring print `-1`, because nothing like a good, sharp negative number
to tell you that you've ended up less far along than you were before!

## Example
We can look at an actual string as an example and derive an expected solution. For 
the string `aabacbebebe`, with k = 3, we would expect the answer to be `cbebebe`. 
This is the longest with length 7, and it has unique characters c, b, and e. 
My first assumption is that we aren't reordering the string, and we aren't dealing
with weird characters or considering upper/lowercase. 

## First Attempt
Have you noticed that posts like these always have more than one attempt? That's because these
problems are hard (I don't care what the hacker-schmaker-geek board says). 
I first started out with this approach:

```python
S='aabacbebebe'

k=3
longest=-1    # keep record of the longest
start=0       # start of the current substring being evaluated
chars=set()   # keep a record of characters that we've seen

def update_longest(start, end, S, longest):
    contender = S[start:end]
    if longest == -1:
        return contender
    if len(contender) > len(longest):
        longest=contender
    print('New longest is %s' %longest)
    return longest


for idx in range(len(S)):
    s = S[idx]

    # The character is in the current substring
    if s in chars:
        print('%s is in %s, continuing' %(s, chars))
        longest = update_longest(start, idx, S, longest)
    else:
        # S isn't one of the characters, and we are at stopping point
        if len(chars) == k:
            print('final evaluation of %s,%s' %(s, chars))
            longest = update_longest(start, idx, S, longest)
            start=idx
            chars=set(s)
        else:
            chars.add(s)
            longest = update_longest(start, idx, S, longest)
            print('added %s,%s' %(s, chars))
```

And I continually would get an answer that didn't seem to move along the string (e.g., 

```bash
added a,{'a'}
a is in {'a'}, continuing
New longest is a
New longest is aa
added b,{'b', 'a'}
a is in {'b', 'a'}, continuing
New longest is aab
New longest is aaba
added c,{'c', 'b', 'a'}
b is in {'c', 'b', 'a'}, continuing
New longest is aabac
final evaluation of e,{'c', 'b', 'a'}
New longest is aabac
New longest is aabac
added b,{'b', 'e'}
e is in {'b', 'e'}, continuing
New longest is aabac
b is in {'b', 'e'}, continuing
New longest is aabac
e is in {'b', 'e'}, continuing
New longest is aabac
```

### Why isn't it working?
Option 1 is to throw an avocado against the wall, get frustrated, and give up. I haven't actually done
this because avocados are like gold to me, but I sure have fantastized about it. Option 2 is to try and understand
why your soliution isn't working, and come up with a good example of it. My first attempt wasn't able to "look backwards,"
and I'll try to illustrate what I mean. When we hit the case that the number of unique characters is equal to k, and the next character isn't in the set k, I am "resetting" the state by setting the start to be that current index. The problem with this is that it could be the case that we could step backwards along the string and grab some k-N characters that, along with our next character, would be the solution! For example if we have (and here I am splaying out the string and showing you indices):

```python

0|1|2|3|4|5|6   # i
A|B|B|C|C|C|C

```

and we set k=2, once we hit the first index of C (i=3) we would first check the current start (i=0) through the end (i=2) to see if
the string (`ABB`) could be our new longest. Regardless of this outcome, after the check we would throw away the `ABB` 
by setting the new start to be our current index, which is 3, for the next loop. We would then go through the same
procedure again, but since we are only checking a long array of C's, we wouldn't meet our k=2 requirement and the presented solution would
be `ABB`. Why is this wrong? Because the length of this solution is 3, and we could have done better finding `BBCCCC`. We
didn't do that because we had no logic in the implementation for looking backwards.

## Attempt Two
Keep it simple! I decided to rethink the problem at this point. You see, I'm very block headed
when it comes to algorithms, and once I realized I had this "backtracking" error I was becoming
infinitely more frustrated creating loops inside loops. If the solution isn't something 
simple that I can think of today and then remember tomorrow, 
it's not a good solution for me. Instead of trying to shove all this logic into one complicated loop, I decided to step
back and think of the problem much more simply.  Gogo Dinosaur Strategy Session!

### Strategy:
Hello my name is strategy! I don't remember complicated things, but I like simple ALOT. Today we are going to:

<ol class="custom-counter">
<li>generate all substrings</li>
<li>count unique characters</li>
<li>The longest one with k wins!</li>
</ol>

```python

def generate_substrings(S, k=3):
    substrings = []

    # Case 1: fewer characters in S than k, impossible
    if len(S) < k:
        return substrings
    # Case 2: if the substring is == k, then it's the only option
    elif len(S) == k:
        return [S]

    # Case 3: we can generate substrings!
    for s1 in range(len(S)):
        substrings.append(S[s1:])
    return substrings

```

This would produce this output:

```python

$ generate_substrings(S)

['aabacbebebe',
 'abacbebebe',
 'bacbebebe',
 'acbebebe',
 'cbebebe',
 'bebebe',
 'ebebe',
 'bebe',
 'ebe',
 'be',
 'e']

```

Note that we aren't considering the number of unique characters, actually if 
the length of the above is less than our k, it's impossible to have three unique,
so let's filter those out.

```python

def generate_substrings(S, k=3):
    substrings = []

    # Case 1: fewer characters in S than k, impossible
    if len(S) < k:
        return substrings
    # Case 2: if the substring is == k, then it's the only option
    elif len(S) == k:
        return [S]

    # Case 3: we can generate substrings!
    for s1 in range(len(S)):
        if len(S[s1:]) >= k:
            substrings.append(S[s1:])
    return substrings

```

Now we get a slightly smaller list:

```python

$ generate_substrings(S)

['aabacbebebe',
 'abacbebebe',
 'bacbebebe',
 'acbebebe',
 'cbebebe',
 'bebebe',
 'ebebe',
 'bebe',
 'ebe']

```

Okay, so now we want to just find the longest with k unique. Let's do that.

```python

substrings = generate_substrings(S, k=3)
longest = -1

for contender in substrings:
    unique_chars = len(set(contender))
    # Condition 1: the number of characters must be less than = k
    if unique_chars == k:
        # Case 1: we don't have a longest. Now we do
        if longest == -1:
            longest = contender
        # Case 2: the new string is longer
        elif len(contender) > len(longest):
            longest = contender

```

We can then run the above and get the longest, `cbebebe` (this I assume is 
pronounced SEE BAYBAY+). I realize that it's 
probably not super efficient to do this in two steps - generating
all the substrings and then testing, but it's so much more clean and logical, and
so is a solution I'm happy with. 

## More Optimized?
About 10 minutes after doing the above, I was again not happy with the solution.
I didn't have a better way, but had the intuition that I wanted to move the second
(redundant) loop somehow into the first. Was there a reason we couldn't check
for the substring to be the longest as we generated it? Let's try to make it better.
Actually, no promises that this is better, but actually just different. My first
strategy was to get a sense of how I was going to combine the two things:

```python

def generate_longest(S, k=3):

    ## DEFINE LONGEST DEFAULT HERE

    # Case 1: fewer characters in S than k, impossible
    if len(S) < k:
        return longest

    # Case 2: if the substring is == k, AND it has k unique, only option
    elif len(S) == k and len(set(S)) == k:
        return S

    # Case 3: we can check substrings
    for s1 in range(len(S)):
        substring = S[s1:]

        ## COMPARE AGAINST LONGEST HERE

    return longest
```

In the above, you can see how (my thinking) started. I would need to rescope
my thinking about the function to (instead of returning substrings) to return
just the longest. This changed the first set of checks. Next I would need to
do some comparison with the longest in Case 3. What I came up with is this:

```python

def generate_longest(S, k=3):

    # We can take len() of empty string
    longest = ''

    # Case 1: fewer characters in S than k, impossible
    if len(S) < k:
        return longest

    # Case 2: if the substring is == k, AND it has k unique, only option
    elif len(S) == k and len(set(S)) == k:
        return S

    # Case 3: we can check substrings
    for s1 in range(len(S)):
        substring = S[s1:]

        # Exactly k! This could be a solution
        if len(set(substring)) == k: 

            substring = S[s1:]
            if len(substring) > len(longest):
                longest = substring

        # Greater than k, could be? But we need to trim
        else: 
            while len(set(substring)) > k:

                # Remove last element, try again
                substring = substring[:-1] # remove last element
                if len(set(substring)) == k and len(substring) > len(longest):
                    longest = substring

    # If we still have empty for longest, return -1 as desired
    if longest == '':
        longest = -1

    return longest
```

What I originally implemented was just checking if the unique characters was k,
and if yes, comparing against the longest and calling success if it was of
greater length. I then had a <strong>ruhroh</strong> moment because I realized that I was _always_
comparing from some index to the end of the string, and it could very well be that we could
find a solution by chopping off a character. So I added a while loop to eat away at the substring
and do these checks up until hitting k unique characters. Did it work for the previously
failing test?

```

$ generate_longest(S,2)
# 'BBCCCC'

```
It seems to! No promises for other tests, heh. 

## Final Dinosaur Drivelings
To summarize, from this I learned that it's okay to approach things simply,
and then try to improve upon. I'd even say you don't <strong>have</strong> to
find the perfect answer because there are others to help, and you can only do your best.
I also think I disagree with returning a value of -1 given no longest substring. I would
find it more natural to return an empty string `` which arguably is the longest string
you could derive given that you cannot :).
