---
title: "GIT Basic Commands to Update Repository"
date: 2011-9-24 19:34:51
tags:
  code
  documentation
  git
  github
---


This summer I started to use github as a repository for my code, and I wanted to document instructions for updating a repository. This is assuming you already have [created the repository](http://help.github.com/create-a-repo/), and have the appropriate .git folder on your machine, the local repository!

**Get the status of your local repository**

<pre>
<code>
# Shows files that you have in folder, which ones are added (A) or modified (M)
git status -s
</code>
</pre>

**Set up your credentials**

<pre>
<code>
# credentials
git config --global user.name 'My Name'
git config --global user.email 'myemail.address'
</code>
</pre>

**Adding new files to your local repository:**

<pre>
<code>
git add file1 file2
</code>
</pre>

**Commit files to the local repository**

<pre>
<code>
# commits the files to your local repository -
# this will bring up a text document and you can
# uncomment the files that you want to commit, save, and exit.
git commit -a
</code>
</pre>

**Send to github repository**

<pre>
<code>
git push origin master
</code>
</pre>


