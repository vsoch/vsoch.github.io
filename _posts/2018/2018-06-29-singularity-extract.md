---
title: "Windows Extraction with Singularity"
date: 2018-06-29 2:40:00
toc: false
---

Today one of my colleagues hit an infinite loop when a support technician
required the extraction of (Linux) drivers from an `.exe` file. The convseration 
went something like this, and I have a feeling many administrators have "been here."

> But I don't have Windows...

and the response?

> Just run the `.exe`

Awkward silence

> ...

Face palms ensued. He was able to do it with other means (I'm sure this isn't a new
request), but because I was curious, I wanted to give a go at using a Singularity container to do it. And I had the perfect container in mind.

## Windows in Linux
A long while back, one of our users created an awesome container, <a href="https://singularity-hub.org/collections/106" target="_blank">Dolmades</a> that I featured on the <a href="http://singularity.lbl.gov/dolmades-windows-containers" target="_blank">Singularity site</a> that would <strong>drumroll</strong> let you play a Windows game via <a href="https://www.winehq.org/" target="_blank">wine</a> on a Linux machine via a Singularity container.  I thought this was a long shot, and I knew I would still have to endure a gazillion dialog boxes of doom, but here is how I was able to extract a (dummy) `.exe` archive.


### Pull the container
Let's first pull the container from Singularity Hub!

```bash

$ singularity pull shub://katakombi/dolmades
Progress |===================================| 100.0% 
Done. Container is at: /home/vanessa/katakombi-dolmades-master-latest.simg

```

And now shell inside

```bash

$ singularity shell katakombi-dolmades-master-latest.simg 
Singularity: Invoking an interactive shell within container...

```

Do we have wine?

```bash

Singularity katakombi-dolmades-master-latest.simg:~> which wine
/usr/bin/wine

```

Here I'm downloading an example file. I have no idea what it is, it's a random
Dell driver I found that thappens to have an .exe that is meant to extract (and then install).

```bash

$ wget https://downloads.dell.com/FOLDER00331497M/2/VideoOPGA6_XP_A00_setup-R3M7Y_ZPE.exe

```

Make a directory to dump stuff

```bash

$ mkdir -p /tmp/stuff

```

Run wine.

``` bash

$ wine VideoOPGA6_XP_A00_setup

```

With this command you are going to get a TON of prompts that wine can't find a dependency,
and needs to install it. Just click install. Be patient. Be brave. You'll get through it!
There might also be some more prompts with "Continue" and "OK" and "Would you like pancakes with that?" I'm so sorry in advance for all those prompts, it's not my fault. When you get to the screen to where to extract the files, typo in `/tmp/stuff`, and then extract! After extraction, the install executable (GUI) will start to run, just exit it. You can then peep into `/tmp/stuff` and... see all the stuff!

```bash

$ ls /tmp/stuff/
Bin  Bin64  Config  Images  MUP.xml  Packages  Setup.exe  mfc100u.dll  msvcp100.dll  msvcr100.dll

```

There you go! No need for Windows! And we have... the stuff :) As a pro tip, you
can name the folder to be how you feel about the software at the moment. I chose to call it
stuff, although you may have other sentiments :) 

What other Windows things can we do with Dolmades? If you do something cool, please share!
