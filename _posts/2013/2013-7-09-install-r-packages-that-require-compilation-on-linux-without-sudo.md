---
title: "Install R Packages (that require compilation) on Linux"
date: 2013-7-09 14:32:33
tags:
  linux
  r
  unixtools
---


When trying to install packages in R that require compiling on one of my servers (that I did not have admin access to) I ran into the following error:

```
ERROR: 'configure' exists but is not executable -- see the 'R Installation and Administration Manual'
```


The problem here is that the temporary directory that R is clunking the files to be compiled does not have permissions set to execute. To fix this problem, I needed to do BOTH of the following (it doesn’t work without both)

**1. Create a folder somewhere that you do have power to write/execute, etc.**


```
mkdir /path/to/folder
chmod 777 /path/to/folder
```

You can undo these permissions later if it makes you anxious.

**2. Set the TMPDIR variable in your bash to this folder:**

```
export TMPDIR=/path/to/folder
```

**3. Start R, and install the library “unixtools” that will give you power to set the temporary directory:**

```
install.packages('unixtools')
```

Note that you can see the currently set temporary directory with tempdir(). Before changing it, it will look something like this:

```
[1] "/tmp/RtmpQrgNII";
```

**4. Use unixtools to set this to a new directory:**

```
library('unixtools')
set.tempdir('/path/to/folder')
tempdir()
[1] "/path/to/folder";
```

Now you should be able to install packages that require compilation. At least, it worked for me!


