---
title: "Creating Script Directory and Moving Files..."
date: 2010-7-19 09:51:54
tags:
  bash
  code-2
  files
  move
  navigation
---


I’m just putting this here so I can copy paste it the next time that I need it. It’s a little ditty that better organizes our Processed output folders. Navigate to the top directory of all the individual subject folders and run from there!

<pre>
<code>
for file in *
do
cd $file
mkdir -p Scripts

for output in *.out *.m
do
mv $output --target-directory=Scripts
done
cd ..
done
</code>
</pre>

