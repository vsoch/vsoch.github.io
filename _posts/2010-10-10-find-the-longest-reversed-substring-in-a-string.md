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

<pre>
<code>
'FourscoreandsevenyearsagoourfaathersbroughtforthonthiscontainentanewnationconceivedinzLibertyandded
icatedtothepropositionthatallmenarecreatedequalNowweareengagedinagreahtcivilwartestingwhetherthatnapti
onoranynartionsoconceivedandsodedicatedcanlongendureWeareqmetonagreatbattlefiemldoftzhatwarWehave
cometodedicpateaportionofthatfieldasafinalrestingplaceforthosewhoheregavetheirlivesthatthatnationmightliv
eItisaltogetherfangandproperthatweshoulddothisButinalargersensewecannotdedicatewecannotconsecratew
ecannothallowthisgroundThebravelmenlivinganddeadwhostruggledherehaveconsecrateditfaraboveourpoorpon
wertoaddordetractTgheworldadswfilllittlenotlenorlongrememberwhatwesayherebutitcanneverforgetwhatthey
didhereItisforusthelivingrathertobededicatedheretotheulnfinishedworkwhichtheywhofoughtherehavethusfars
onoblyadvancedItisratherforustobeherededicatedtothegreattdafskremainingbeforeusthatfromthesehonored
deadwetakeincreaseddevotiontothatcauseforwhichtheygavethelastpfullmeasureofdevotionthatweherehighly
resolvethatthesedeadshallnothavediedinvainthatthisnationunsderGodshallhaveanewbirthoffreedomandthatg
overnmentofthepeoplebythepeopleforthepeopleshallnotperishfromtheearth'
</code>
</pre>

and my scripty-doo got it right on the first try! :O)

<pre>
<code>
function reverse_substring(stringy)

string_length = length(stringy);

count = 1;

for i = 1:string_length-2
if strcmp(stringy(i),stringy(i+2))
center{count}= i+1;
count = count+1;
end
end

for i = 1:size(center,2)
if string_length/2 >= center{i}

extent = center{i};
else extent = string_length - center{i};
end

j=1;
while j < extent-1
if strcmp(stringy(center{i}+j),stringy(center{i}-j))
answer = stringy(center{i}-j:center{i}+j);
j = j+1;
else break
end
end
CONTENDERS(i) = struct('Answer',answer,'Length',(2*j)+1);
end

longest = CONTENDERS(1).Length;
for i = 1:size(CONTENDERS,2)
if CONTENDERS(i).Length > longest

longest = CONTENDERS(i).Answer;
end
end

longest

end
</code>
</pre>

