---
title: "Connecting to MySQL Databases in R 3.0.1 using RODBC"
date: 2013-12-17 19:30:28
tags:
  mysql
  odbc
  r
  rodbc
---


I want to connect to MySQL databases from R.  It's easy to do in Python, but nothing is more painful than trying to get [RMySQL](http://cran.r-project.org/web/packages/RMySQL/index.html) working in R for Windows.  This is possibly punishment from some higher god for having an installation of Windows, period.  Don't hate, Linux gods, your Gimp and Inkspace just aren't up to par!  As a solution, I stumbled on the [RODBC package](http://cran.r-project.org/web/packages/RODBC/index.html), which I actually got working.  I [followed the steps here](http://blog.iwanluijks.nl/?!=/post/5-connecting-to-mysql-with-r-using-rodbc-on-windows-xp.html), which I will re-iterate specially for Windows 7:

 

### 1. Install R

Obviously, first you need [R installed for Windows](http://cran.r-project.org/bin/windows/base/).  I have version 3.0.1, run via RStudio.  If you want/need to install multiple versions, you can still use the Windows executable, and check "Full Installation," and then "customized startup."  One of the boxes asks if you want to save the version into a Windows registry - I'm guessing that you wouldn't want to check that.  To switch between versions in R-Studio, just hold down the Control key when it's booting up, or once in RStudio, go to Tools --> Options --> General, and the "R Version" selection box is right at the top.

 

### 2. Install RODBC

Either launch Rgui.exe (in your start menu or under "C:\Program Files\R\R-2.15.2\bin\i386\Rgui.exe," or launch R-Studio.  If you've used R before, this is probably all set up.  Now type

<pre>
<code>
install.packages('RODBC')
</code>
</pre>
 

### 3. Configure MySQL

You first need a MySQL Connector/ODBC.  I'm not a Windows database expert, but I have MySQL Workbench installed, and know that the guts to connect to a MySQL server with ODBC is slightly different.  You can download [MySQL Connector/ODBC from here](http://dev.mysql.com/downloads/connector/odbc/), or if you already have MySQL Workbench, there is a "MySQL Installer" in the start menu under "MySQL" that will allow you to select "MySQL Connector/ODBC."  I chose the MSI-installer, the ansi version.  Install away, Merrill!</span>

 

### 4. Adding your data source

This was a little confusing at first, because I'm used to specifying credentials from within R or python, as opposed to having them stored in my computer.  You actually need to add your different connections to the "ODBC Data Source Administrator," which I found under Control Panel --> Administrative Tools --> Data sources (ODBC).   The first tab that you see is "User DSN."  A DSN in a Data Source Name, or one of your connections.  Thank you, Microsoft, for the excess of random acronyms that make things seem much more complicated than they actually are ![:)](http://www.vbmis.com/learn/wp-includes/images/smilies/simple-smile.png)

1. First hit "Add," and select "MySQL ODBC 5.2a Driver."
2. When you hit finish, it will open up a "MySQL Connector/ODBC Data Source Configuration" dialog.
3. Nope, you can't leave it empty!  Enter the hostname under TCP-IP, and your username and password.  You can specify the credentials from within R, which is probably a better idea, but you should enter them now to test the connection.
4. Come up with a nice name for it under "Data Source Name."(DSN!)
5. I would hit test to test the connection.  For me it worked the first time!
6. There are additional options under "Details," if you desire to tweak.
7. Press OK.  You are done.

 

### 5. Connecting from R

First, load the package, and use the odbcConnect function (with the first argument being the dsn) to connect to your database:

<pre>
<code>
library(RODBC)
dsn = 'candyDatabase'
conn = odbcConnect(dsn)
query = sqlFetch('candyDatabase.TABLE')
</code>
</pre>

If you have trouble with the case (eg, the sqlFetch tells you it cannot find "candyDatabase.table," then in your initial connection you need to specify the case varible:

<pre>
<code>
ch = odbcConnect('candyDatabase',case="nochange") # other options include toupper and tolower
</code>
</pre>

There are beautiful examples of how to work with your database in the documentation for ODBC.  To see, type the following in R:

<pre>
<code>
RShowDoc("RODBC", package="RODBC")
</code>
</pre>

Happy databasing! :)
