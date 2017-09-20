---
title: "Backing Up Google Site"
date: 2014-12-13 20:37:48
tags:
  backup
  google
  sites
---


I keep my research wiki on a Google Site, and have been saving PDFs of the pages over the years as a backup.  This seems like a pretty time intensive, and inefficient strategy.  There is a nice tool called “[google-data-liberation](https://code.google.com/p/google-sites-liberation/)” that I’ve tried once or twice, also over the years, and never got it working.  It occurred to me in a “acorn falling on my head from the sky” moment during my run this morning that… there is two step verification! /bonk.  Of course that must be why it didn’t work in 2009… 2011… 2013… and all the other times I failed miserably to export my site! After 6 years of trying (ha) I finally got this to work:


## Download the Application

[Here](https://code.google.com/p/google-sites-liberation/). It’s a jar file.  You need java.  I have linux, so run it, and it opens up a pretty little gui (I stole this from the main project page)

![](http://google-sites-liberation.googlecode.com/files/gui.png)


## Generate a Two Factor Authentication Password

In your google account, go to Settings –> Accounts and Import –> Other Google Account settings and then go to “**Connected Apps and Services**” section.  Click “View All.”  First, revel in terror at the number of applications you’ve granted some tiny parcel of your personal information.  Then go to the bottom and click *manage app passwords*. This will open up “App passwords,” and on the bottom is a big blue button to generate a new password, after you select a device (or custom).  When you see the password, leave the window open.


## Enter the correct information

Which is not in the example above! Let’s say your google site address is here:

> http://sites.google.com/site/petrock

You would want to enter the following:

- **Host: **sites.google.com
- **Domain: **site
- **Webspace**: petrock
- **Username: **your full gmail (iloverocks@gmail.com)
- **Password: **the password you generated above

<br>
You also need to select a folder to export to, “target directory.”  Make sure it’s a new folder, and not some place like your desktop, because a ton of files and folders are going to be generated. Then click “Export.”  Then it actually works!  I must say – 6 years of getting the “invalid credentials” bit… I’m glad I figured this out before I turn 30!
<br>

[![site](http://vsoch.com/blog/wp-content/uploads/2014/12/site.png)](http://vsoch.com/blog/wp-content/uploads/2014/12/site.png)

Now you can sleep at night knowing your graduate student drivelings are safely backed up, in the case that Google explodes.  With all those rainbows coming from Mountain View, we just can’t be too sure what kind of mystery is going on behind tose red, blue, green, and marigold yellow doors! 😉


