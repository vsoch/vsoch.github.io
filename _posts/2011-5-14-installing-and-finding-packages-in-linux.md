---
title: "Installing and Finding Packages in Linux"
date: 2011-5-14 23:12:42
tags:
  chrome-os
  linux
  rpm
  search
  unix
  yum
---


I’m pretty new to using anything other than windows, and I’m using CentOS 5 on a virtual machine, and just getting comfortable with some pretty basic installation procedures. For my own reference, I am going to document several procedures.

**Download and compile from source**

****1) downloading .tar.gz files, unzipping them with:

code

2) look for README and INSTALL files, which will provide further details about specifics of the installation. Generally, the following works:

code

3) The other option is to find a nice .rpm file, and have your system install it for you.

**Find Something that You’ve Installed**

If you install something and then another something cannot find it, it’s likely not on the path. To step back, the path variable is basically a list of places that are browsed through to find files, whenever you call any command. So if you want to know if something is “findable” in the terminal, you can echo $PATH to see if it’s there!

Of course, what if you are like me, and you install something, and then have no idea where it is? I was missing a required library for a package, so my run of ./configure wasn’t working. I read in the INSTALL file that I could specify a path to look for libraries, so to get this to work, I needed to find that path. So first I used yum to check if it was installed.

code

And sure enough, I did indeed have it, but I had no idea where it was! Silly yum just told me that it was installed, and the version number, and not much else. So I blindly looked in the folders where the internet told me it was “supposed” to be, but found nothing. I then needed another strategy, and started to look at the rpm command.

**Use rpm to find an installed package**

You can use the following to list all of your installed packages:

code

The command above tells the package manager to query all installed packages, and the addition of less just makes it more manageable in the terminal. The following gives you information about a specific package:

code

and then to find where the little bugger is hiding, you can do:

code

From this basic troubleshooting, I was able to find the location of my package, and then add it to the path variable. To edit your path, you want to change either ./bash_profile or ./bashrc – which I think are hidden files when you cd to ~.

**Add package to path**

code

If you do “ls” you won’t see it, I think because it starts with a “.”. The basics of adding a folder to your path is appending it, and then exporting, like so:

code

and then save the .bash_profile, and you will have to log out and in again for the changes to happen. If you don’t want to do that, you can also type those commands into the terminal window.

And to provide closure to my particular problem, after eight hours of compiling from source for a gazillion and one libraries, attempting to edit source code on my own, and installing different compilers to see if it made a difference, I finally admitted defeat to getting this particular package installed. However, that doesn’t take away from the utility of the commands that I detailed above, nor does it qualify the time spent as a waste. I found this experience fun, and learned a very significant amount. I am continually awed by the intricate design of software and machines, and excited as my brain continues to make sense of them.

**If an OS is like a religion, am I converted?**

Am I converted? Well, I don’t like the idea of joining an OS bootcamp and bashing the other side, because I don’t see why I can’t enjoy them all. However, my love for the command line combined with my recent escapade of installing Ubuntu 11.04 on my Dad’s old laptop and seeing huge improvements in performance has me excited. On some future date I would like to configure a system with something other than Windows, and not just do a dual boot or virtual machine. I’m pretty excited about Chrome OS too, but I don’t think the browser alone is ready for the type of applications that I use on a daily basis. Until then, it’s back to regedit, blue screens of death, using SSH to satisfy command line urges, constant searching for the right .dll, Windows Update, and Dell Diagnostics. Oh Windows, you are so special! :O)


