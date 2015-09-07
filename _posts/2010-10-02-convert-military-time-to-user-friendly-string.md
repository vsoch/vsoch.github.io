---
title: "Convert Military Time to User Friendly String"
date: 2010-10-02 14:59:48
tags:
  code-2
  matlab
  time
---


I want to share this, because it could be useful in many contexts. I am working on a script that downloads information from a Google Calendar, and automatically sends reminder emails based on a user specified time. Given that the times are military, you don’t exactly want the email to say “You have an imaging appointment at 1730,” so I wrote this quick little portion of my script to, after pulling the time from the text file, convert it to a user friendly string, like “5:30 pm.”

This script starts when it knows that it’s on the line that contains the appointment time (the line is stored as the “currentline” variable, and for this line in the file exported from the gmail calendar, the actual time always starts and ends at the same character location.

<pre>
<code>
% read in military time
time = currentline(18:21);
% Convert military time to standard time
if (str2double(time)&amp;amp;amp;amp;gt;1259)
time = str2double(time)-1200;
period = 'pm';
else
period = 'am';
end
% Format time by separating the last two characters
% from the first, and sticking them together with the :
time_end = time(length(time)-1:length(time));
time_beg = regexprep(time, time_end, '','once');
% Put it all together into a user friendly format for printing
time = [ time_beg ':' time_end ' ' period ];
</code>
</pre>

And now I can save it into a structural array of subjects, and use it when I create the text for my email. Hooray! Also note that the “>” should be a greater than symbol, I’m not sure why it’s stubbornly coming out like that!


