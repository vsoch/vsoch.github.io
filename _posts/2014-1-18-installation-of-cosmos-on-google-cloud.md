---
title: "Installation of COSMOS on Google Cloud"
date: 2014-1-18 22:26:42
tags:
  
---


Google Compute Engine is the equivalent of Amazon’s EC2. In this test I’m going to try setting up an instance and saving an image. I’m following the quickstart instructions [here](https://developers.google.com/compute/docs/quickstart).

#### Update: 1/23/2014:

The SGE cluster is working, however output does not return to the master node because we need a shared file system. I will test this tomorrow, and hopefully get a finished cluster working soon!

[Launching Instance with Attached Snapshot](#snap)  
[Creating a New Instance](#new)  
[Cosmos Installation](#cosmos)  
[Installing GenomeKey, Etc](#gk)  
[Testing GenomeKey](#gktest)  
[Mounting Resource Bundle](#mnt)  
[Saving an Image](#save)  
[Loading an Image](#load)  
[Log of Instances](#log)


## **Launching Instance with Attached Snapshot**

First see if the gatk-bundle disk is running

code

If not, create it – must be same time zone as your instance.

code

Now start a new instance with read online gatk-bundle attached

code

Log in to your instance

code

Mount the disk – the folder already exists, -n specifies read only

code

Create a symbolic link to resources folder

code


## **Creating a New Instance**

These are the steps that I took to create a new instance, and save it as an image for later use.  See

**1) **Created a new project under the [Google Developer’s Console](https://cloud.google.com/console/project).  <span style="line-height: 1.5em;">You will create a “Project ID” – remember this for step 2.</span>  
**2)** Downloaded [gcutil](https://developers.google.com/compute/docs/gcutil), a command line program for communicating with Google cloud tools

The basic command to install the Google SDK is:

code

and then I specified that I would be developing in Python. Keep following the instructions to run gcloud auth login. The command line will then ask you to enter a Project ID, so I entered my Project ID from step 1.

**3)** I then enabled billing for my project, which can be done under the “Settings” tab. I then clicked on “Compute Engine” to get it started, and then returned to the command line to create an instance. (Note that I am skipping the step to “add a firewall” because I’m not concerned with making anything available on the web.)

code

Note – if it tells you there is an upgrade and you upgrade by doing “gcloud components update,” you will need to re-authorize your account with google SDK before doing the addinstance command above.

code

The first time I did this, I chose a small and cheap image. Since this is an image I’d like to do analysis with, I’m going to try and choose one (somewhat) like the one suggested on Amazon EC2:

- Instance Family: Compute Optimized
- Instance Type: c3.4xlarge
- Arch: 64-bit
- vPCU: 16
- ECU: 55
- Memory: 30 GB
- Storage: 2 x 160 SSD
- EBS-Optimized: Yes
- Available Network Performance: High

The complete list of prices are [here](https://cloud.google.com/products/compute-engine/). I chose n1-highmem-8.

code

Cosmos on AWS was on an Ubuntu image (I think), so the first time that I did this, I choose Debian Wheezy. It will ask you to set up an ssh key, and enter a password. Don’t forget it ![:)](http://vsoch.com/blog/wp-includes/images/smilies/simple-smile.png)

The second time around, since I had saved my previous image, I was able to load it! If you have an image saved on Google Cloud, you will see it in the list, eg:

code

I should note that I selected a more powerful machine to deploy an image that was created on a much dinkier one. It seemed to work! This is a lesson that if you just want to setup infrastructure (and no analysis) it’s ok to choose the cheaper option. When you finish, you’ll see something like this:

code

**4)** Cosmos has a web interface (I think) so I also [set up a firewall](https://developers.google.com/compute/docs/networking#addingafirewall) to access the instance from my IP address. I used gcutil again:

code

Now that the billing clock is started, let’s log in:

code

If you are installing a new cosmos instance, see below. To continue on the cosmos-test instance that I created, skip this section.


## Cosmos Installation

I first checked the version of python, and it is indeed 2.7.3. I now am following the instructions on the [cosmos wiki](http://ec2-107-22-176-16.compute-1.amazonaws.com/docs/Cosmos/install.html). I proceeded to update all packages, and install required packages:

code

All the installations worked without error. For mysql-server it will ask you to set root’s password. I then moved forward with installing pip, which we need for virtualenv:

code

I want to point out that installing pkg-config is extremely important!  It’s not obvious unless you spend lots of time reading error logs that installing this package eliminates enormous amounts of installation errors. Lynx is also important for peeking at the cosmos web browser from the terminal window.

code

Note – we are installing sqlite3 for a local database solution – trying out the simplest option.

code

I then added this to .bash_aliases

code

(and reminder, to stop, do “deactivate cosmos”)

code

I got an error about graphviz, because my setup had trouble finding graphviz, so I had to edit the setup.py file to include the paths:

code

Uncomment the lines for the library_path and include_path, of course making sure that they are correct!

then I did this again:

code

Now, we need to create a sqlite3 database for cosmos to use. Go to your home directory, and make a db directory:

code

Specifically, go to to databases, and add the path to your cosmos.db

code

Now that our database is setup, and since this is a django installation, we should use cosmos and run “syncdb,” and collect static files.

code

A successful run will show all of the application tables being created. Lastly, we need to create the cosmos_out folder, and change permissions:

code


## Installation of GenomeKey, etc.

Now that we have cosmos up and running, let’s install GenomeKey and the bucketload of software it uses, which cosmos will use (I think) to perform analyses:

code

If we now look at the wga_settings.py file, we can see that it needs to be updated for running on Google Cloud:

code

It looks like I can’t fork the repository, so I’ll log here the changes that I make to the code. This script reads the cosmos.ini file to figure out configuation settings, so let’s first tweak that to include Google Cloud:

code

I changed the “default_server” to “google_cloud”:

code

And then I added this option to the wga_settings.py

code

Then obviously we need to install WGA there! Let’s do that now. I followed my own instructions [here](http://www.vbmis.com/learn/introduction-to-the-genome-analysis-toolkit-gatk-i/ ).  I’ll repeat the steps here. First, install java. We must have 1.7:

code

Now download and test GATK. I had to download from their GUI and upload to my server – so this is the version as of 1/19/2014.

code

Let’s also install the Picard tools and the Burrows Wheeler Aligner, and everything else in the ginormous list in wga_settings.py:

code

We now need to run it for the first time to edit the configuration file. Still from within the Annovar Extensions directory…

code

Listen to what it says! Here is how I edited the configuration file:

code

Then when you try “annovarext listdb” again, you will see a long list of databases. Now let’s return to the Packages/tools folder and download the rest.

code

You can either put it where it expects it (as instructed above), or see line 52 of the MakeFile and change the path to where you installed it. Now let’s add the GATK, Picard tools, and Burrows Wheel Aligned to your path. This is probably unnecessary if the wga_settings.py has all these paths, but it doesn’t hurt.

code

Now we should go back to the wga settings and update the paths for our added software. I’m not going to post this yet because I still need confirmation for some of the above.

code


## Testing Genome Key

First check that we are calling genome key from our virtual environment. This is a little confusing because the Genome Key documentation says to call it from the bin directory under the folder in Packages, but we should be calling the one installed to our virtualenv:

code

This is where I ran into trouble – it hangs on loading the config.ini file, and then pressing enter, there is a cascade of errors about not being able to find my data directory. This seems to be an issue with the Annovar Extensions and not genomekey. After [much troubleshooting](http://www.vbmis.com/bmi/share/wall/genomeKey_error.txt), the workaround I found is to edit the data directory path, commenting out the old line, and adding the new one:

code

Then everything works! Now let’s run a test job. First we need to update the paths for the bam files:

code

and run the job:

code

This is where I got a huge error stream about failed job attempts, because clearly this software expects some kind of job manager. I’m currently reading about this and figuring it out. We need a job manager!


## Mounting Resource Bundle

We now have the issue of the resource bundle, which does not yet have a “cloud solution.” It would be ideal for them to host this in the cloud, and we just connect to it over making our own copy, but since we need some of the files, I figured out which ones by reading the wga_settings file, and downloaded to my local machine with FTP:

code

When I first tried to download these to the instance directly, I ran into trouble doing this – ran out of room! Instead, I created a google cloud folder, /stanford-genomes/resources/bundle/current to send these files to. I assumed that it would be easy to mount a google cloud folder, but I still haven’t figured out how to map it. There are [unreliable solutions](https://code.google.com/p/s3fuse/) and the most I can find is ability to connect and download / read, but [it’s not a mount](https://developers.google.com/compute/docs/authentication#applications).

Here is my proposed solution (and I would like feedback on this). I can [create an external disk](https://developers.google.com/compute/docs/transition-v1), and then [save this disk to a snapshot](http://googlecloudplatform.blogspot.com/2013/10/persistent-disk-backups-using-snapshots.html). I don’t think that the mounted disk should be saved in the image, but rather mounted with a new instance. I also checked that multiple images can mount, and the data is read only. For now, I’ll send them to our Google Cloud Storage.

First let’s create a persistent disk. The files are just under 25GB, but I read that creating a disk less than 200GB creates problems, so let’s do 200GB. We also need to be under the same zone as the instance:

code


## Saving an Image

When we finish working and want to save an image (for next time)

code

Then we need to upload it to Google Cloud Storage

code

The next time that you use gsutil to add an instance, you will see your image as an option


## Loading an Image

If the instance is running, then you can connect to it via:

code

If not, see the instructions under [Creating a New Instance](#one), and be sure to select “cosmos-instance” as the image for your instance. Then do the command above. Once you ssh in, we first need to jump back into our virtual environment:

code

Now I am following the instructions [here](http://ec2-107-22-176-16.compute-1.amazonaws.com/docs/Cosmos/getting_started.html).

code

We can then use lynx to view the cosmos web gui:

code


## **Log of Instances**

Currently existing instances are genomekey-test-5, genomekey-test-6, to be used to create a shared file system and then a job manager. I will save images for both a master and slave nodes, and create documentation for use.

I will delete unnecessary images when I have everything working, and an image finalized.


