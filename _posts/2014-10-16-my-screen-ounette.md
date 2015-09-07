---
title: "My Screen-ounette!"
date: 2014-10-16 22:22:47
tags:
  
---


You got away from me, my screen-ounette!  
 A careful melody of consistent characters  
 A little puddle of pretty print  
 A trailing list of timid text  
 And then frozen.

I didn’t know what to do, my screen-ounette!  
 Like a frozen flash of green fury!  
 Like a ridiculous racing of red!  
 Like an arbitrage of ardent artichokes!  
 The sharpness bit.

I am detached, but you tell me that is not the case?  
 “screen -ls”

<pre>
<code>
There is a screen on:
29568.pts-5.screen-ounette (Attached)
1 Socket in /var/run/screen/S-vsochat.
</pre>
</code>

WHY is the word “Attached” filling your status space?!

“screen -r” …  
 Lord, mercy, please! respond to my copy paste!

<pre>
<code>
screen -r 29568.pts-5.screen-ounette
There is no screen to be resumed matching 29568.pts-5.screen-ounette
</pre>
</code>

!!!

But then I found you again, my screen-ounette!  
 It was an extra letter that I did not set:

<pre>
<code>
screen -D -r 29568.pts-5.screen-ounette
</pre>
</code>

And we are together again, screen-ounette!!!  
And my happiness quota is again well set :)

[![screenounette](http://vsoch.com/blog/wp-content/uploads/2014/10/screenounette.png)](http://vsoch.com/blog/wp-content/uploads/2014/10/screenounette.png)

If you didn’t catch it, in the case that you lose connection while in a screen, and when you restore the connection the screen is listed as “Attached” (and it isn’t) the fix is this command:

<pre>
<code>
screen -D -r 29568.pts-5.screen-ounette
</pre>
</code>
