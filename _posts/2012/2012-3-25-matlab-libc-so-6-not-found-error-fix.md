---
title: "MATLAB libc.so.6 not found error Fix"
date: 2012-3-25 10:51:42
tags:
  library
  linux
  matlab
---


For as long as I’ve had linux, my MATLAB spits out the following “not found” error on startup:

<pre>
<code>
.../MATLAB/bin/util/oscheck.sh: 605: /lib/libc.so.6: not found
</pre>
</code>

However it is clear that I have the library:

<pre>
<code>
locate libc.so.6
/lib/i386-linux-gnu/libc.so.6
</pre>
</code>

The answer is to create a symbolic link from this library to your machine’s standard lib folder, as follows:

<pre>
<code>
ln -s /lib/i386-linux-gnu/libc.so.6 /lib/libc.so.6
</pre>
</code>

…and you will never see the not found error again!


