---
title: "Moving pictures from Amazon Glacier to Amazon Cloud Drive"
date: 2014-11-06 20:47:28
tags:
  amazon
  cloud
  download
  glacier
  photos
---


Recently Amazon announced [unlimited photo storage ](https://www.amazon.com/clouddrive/primephotos)for prime members. My simple backup method was using s3 and having photos automatically archived to glacier, however given that:

- I have to pay for both
- they are largely unaccessable
- I already have Amazon Prime

I wanted to take the opportunity to download my pictures, and put them on Amazon Cloud. Of course that sounds so simple, and closer inspection of the AWS management console revealed that Amazon makes it hard to restore an entire folder from glacier.  That’s ok Amazon, that’s what the command line tools are for!


## Create an authenticated user to access your bucket

Log in to the [aws management console](https://console.aws.amazon.com/s3/).

1. Under services click “IAM”
2. Click “Users”
3. Click “Create New Users”
4. Enter a name, make sure “Generate an access key for each user” is checked
5. Click create
6. Copy down the key and secret key somewhere – you will need them in a second.

Now go back to Services –> IAM

 1. click on “Groups”
 2. “Create New Group”
 3. create a name
 4. “Next Step”

You now need to select the access role. Take a look at the options, and choose something that gives full access to s3. You can always remove the user from having access when you finish.  Now add the user to the group. Click again on Users

 1. Select the user, and click “User Actions” and then “Add User to Groups”
 2. Select the group by checking the box, and then “Add to Group”
 3. Done!

Now install the aws command line tools:

<pre>
<code>
sudo pip install s3cmd
sudo pip install s3
</code>
</pre>

Configure them like so

<pre>
<code>
s3cmd --configure
s3 --configure
</code>
</pre>

It will ask for the key and security key generated above, as well as specifics about your internet connection. The s3cmd is what we really need to work – and it will let you test the credentials. If you ever forget these things, you can look under ~/.aws/credentials.  Or you can just create a new user entirely.

Follow the prompts and make sure the test connection works. Bravo!

Now let’s save a list of all of our files in the bucket, in case something happens in the middle and we want to compare this list to what we currently have. I first created a directory where I intended to eventually download the files, and then cd’d there on the command line. First let’s make a nice list of all objects in the bucket with the bucket name stripped out:

<pre>
<code>
s3cmd ls -r s3:// | awk '{print $4}' | sed 's#s3:///##' > glacier-files.txt
</code>
</pre>


Now let’s restore the items for a week, before downloading:

<pre>
<code>
for x in `cat glacier-files.txt`
do
do
    echo "restoring $x"
    aws s3api restore-object --restore-request Days=7 --bucket <bucket-name>/path/folder --key "$x"
done
</code>
</pre>


Be warned that Amazon has some small print about charging you for restores of some large size. When that finishes – time to download! Make sure you are in the folder you want to download things to, and then download:

<pre>
<code>
s3 sync s3:// .
</code>
</pre>

Hey, it works!  I did this overnight. And I wasn’t sure which files weren’t properly restored, which weren’t downloaded – so I had a pretty simple solution. I’d compare the files in my current directory to the ones in the original list, and output a file with the missing ones, to run through the pipeline again. It’s not perfect, but it worked! First print the files in your current directory to file:

<pre>
<code>
find $PWD -print >> files.txt
</code>
</pre>

Oops, that does absolute paths, as I discovered when I opened the file in gedit. I just search and replaced all of the beginning of the path to fix this, and you could integrate that into the command above if you like. Then I used R to make the new text file (and I’m sure this would be more easily accomplished with sed or diff, or awk, but I just like R ok :)

<pre>
<code>
glacier = readLines("glacier-restore.txt")
files = readLines("files.txt")
missing = glacier[-which(glacier %in% files)]
cat(missing,file="missing.txt",sep="\n")
</code>
</pre>

What I learned from this is that the missing files were those with weird characters that would do something strange on the command line, and for the most part everything had downloaded. And now I’m uploading all my photos to the free Amazon Cloud.  We will see if this was a good idea :)
