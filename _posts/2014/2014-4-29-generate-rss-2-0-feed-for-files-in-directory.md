---
title: "Generate RSS 2.0 Feed for Files in Directory"
date: 2014-4-29 21:57:39
tags:
  code
  feed
  php
  rss
---


This was hard to find, so I want to share a little script for automatically generating an RSS 2.0 feed for files (with a particular extension) in a server directory.  For example, you may have a set of photos, videos, or audio files that you want to share! Here are steps for customizing it for your server:

1. Create a directory, and add your files
2. Download the [script](https://gist.github.com/vsoch/4898025919365bf23b6f#file-index-php)
3. Change the $allowed_ext variable to include extensions of files you want to include in the feed
4. Change the $feedName, $feedDesc, $feedURL, and $feedBaseURL to your server paths
5. Drop the file in your http://www.mysite/directory
6. Navigate to http://www.mysite/directory to see the feed’s xml

Done! Now you can subscribe via your favorite [RSS service](http://www.feedly.com), or [check that your feed is valid.](http://validator.w3.org/feed/)


