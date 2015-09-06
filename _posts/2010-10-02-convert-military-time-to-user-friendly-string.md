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

code

And now I can save it into a structural array of subjects, and use it when I create the text for my email. Hooray! Also note that the “>” should be a greater than symbol, I’m not sure why it’s stubbornly coming out like that!


