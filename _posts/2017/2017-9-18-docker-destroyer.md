---
title: "The Docker Destroyer"
date: 2017-09-19 7:24:00
comments:true
---

I've had to reinstall my Ubuntu operating system once, and today almost twice, because of what comes down
to a grubby daemon (no pun intended) sticking his sausage fingers into the important bits of my computer. What happened?
Well, the scenario (both times) has looked something like this:

>> It all starts with Docker

I'm doing something with Docker. In this case, I was trying to reproduce an error on CircleCI for a build running in a Centos 7 container. I very naively followed what they were doing, and ran a centos 7 container:

```
docker run --privileged -d -ti -e container=docker -v /sys/fs/cgroup:/sys/fs/cgroup \
           -v $PWD/singularity:/build:rw centos:7 /usr/sbin/init
```

I always remind myself to be careful with that "privileged" tag, and then promptly forget. The command I was investigating was running test for Singularity on Travis CI, and I was trying to reproduce their build environment because I didn't see the ssh option anymore.

>> My computer freaks out

At some point, actually exactly when the tests were using http protocol to download and pull layers for a Singularity image, my computer did that split second "am I gonna freeze? am I gonna freeze? thing" immediately followed by the music I was listening to pausing infinititely on one shrill female vocal. I immediately controlled C-d the tests, expecting the OS to be completely frozen. It actually wasn't. I had full control of my other programs, and could save and close things up. What I couldn't stop, however, was the container. Exiting hung, executing commands with force hung, and I decided to do a clean restart. Perhaps this was my error, or maybe there is something else I could have tried, but whatever that "something else" might be, it's definitely beyond the skill set of an average user. The tests in the container stopped.

>> I restart, and held my breath

I then restarted, and was glad to see wireless connections popping up in the upper right, and a seemingly clean system. But what happened when I
opened my browser to restore pages?

>> resolving host

and this was true regardless of browser, clearing caches, and restarting networking both hardware and controllers for it. 
I remained calm, but it was eerily too similar to just about a week ago when I had the exact same issue, and it was only resolved with a clean wipe of my operating system.

>> I knew Docker was involved

Having this happen twice, for both cases having something go wrong with Docker and then needing to restart (the first time was a complete freeze) I knew it had to be related. I first noticed that there was this `docker0` defined in networking. I removed it, restarted, but it will still there. I then decided to try every way I knew to remove the Docker installation, and debug:

```
ifconfig
which docker
sudo service docker stop
sudo apt-get --purge remove docker
sudo apt-get --purge remove docker-engine
sudo apt-get --purge remove docker-compose
sudo rm -rf /var/lib/docker

which docker
ifconfig
sudo apt autoremove
ls /etc/init.d/
ls /etc/init.d/resolvconf 
cat /etc/init.d/resolvconf 
/bin/bash /etc/init.d/resolvconf 
/bin/bash /etc/init.d/resolvconf restart
/bin/bash /etc/init.d/resolvconf reload
ping google.com
```

That's an incomplete list of things I did, but if you do a Google search for "how to remove Docker from Ubuntu" you
will find the myriad of suggestions.

>> Removing Docker didn't fix it

Only about 10 minutes had gone by, but I had a system cleaned (to my best knowledge and ability) of Docker. But the error remained. I then realized the worst of the two cases was true - Docker had modified my system in some way so it was unusable. I then thought back to basic stuff. I mean, really stupid. Like "huh, it can't resolve the hostame, isn't that what that `/etc/resolv.conf` file that we bind with Singularity does? So just for kicks and giggles, I opened the file. What did I find?

After the first line with some specific command stuffs, I found some added

```
nameserver 172.xx.xxx.xxx
nameserver 172.xx.xxx.xxx
```

I don't remember the numbers exactly, but that's exactly what I saw - a muddled with file.  A standard resolv.conf usually uses Google's nameservers, with lots of 8's and 4's

```
nameserver 8.8.4.4
nameserver 8.8.8.8
```

So on a whim, I just edited the content. And guess what? My internet came back immediately. Get your nubby little container fingers out of my important places, Docker!
