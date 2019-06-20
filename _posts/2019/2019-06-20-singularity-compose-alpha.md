---
title: "Singularity Compose: Alpha"
date: 2019-06-20 1:34:00
categories: rse
---

Since I started working with Singularity in early 2016, I've wanted to create
an orchestration tool for it. I knew it would be a long time coming, because
not only did we need to be able to stop and start containers, we also needed
to be able to (akin to Docker) create a 
<a href="https://en.wikipedia.org/wiki/Bridging_(networking)">bridge network</a>
(conceptually similar to a router) on the host, and then programatically query for their process ids.

In the last week or so, I decided that it was time! Today I want to share you an
<a target="_blank" href="https://singularityhub.github.io/singularity-compose">Alpha release</a> 
of singularity-compose" (yes it is intentionally
named to mirror <a href="https://docs.docker.com/compose/" target="_blank">docker-compose</a>) 
and it's also implemented in Python like it's counterpart.
This was also an easy choice because <a target="_blank" href="https://www.github.com/singularityhub/singularity-cli">Singularity
Python</a> already has nice handles to work with instances and Singularity from Python.

## Why an Alpha Release?

While most of the ducks are in a row, there is a <a href="https://github.com/sylabs/singularity/issues/3766" target="_blank">networking issue</a> that makes it impossible for instances on Linux hosts that have used Docker (like mine)
to see one another. But actually, this exact bug ultimately meant that I learned a ton
about networking, and that is exactly what I want to share with you today. If you
want an overview of singularity-compose (alpha), there is a beautiful guide for
you <a target="_blank" href="https://singularityhub.github.io/singularity-compose">here</a>
with a working (single container) example. For those interested, here is a quick demo
of the single container example:

<iframe width="560" height="315" src="https://www.youtube.com/embed/q4dAPVK964Q" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

The beginning has a weird echo (I don't use anything beyond the mic on my laptop, so there's that)
and the color is also completely off (meh?). I'll update you when the multi-container example is ready to go, meaning the networking issue linked
above is closed. For now, let's jump into some basics that I learned about networking.

## Networking

Mind you I'm still rather green, and I'm describing these components in a way that makes
sense to me. I want to say a big dinosaur thank you to my colleagues @griznog, @dwd and @cclerget (from Sylabs).
for the great fun we had yesterday starting to debug this issue.

### Hosts

If you type `hostname` on most linux systems, you see something like this:

```bash

$ hostname
vanessa-ThinkPad-T460s

```

It's actually both written into a file "/etc/hostname":

```bash

$ cat /etc/hostname 
vanessa-ThinkPad-T460s

```

and an entry in "/etc/hosts"

```bash

$ cat /etc/hosts
127.0.0.1	localhost
127.0.1.1	vanessa-ThinkPad-T460s

# The following lines are desirable for IPv6 capable hosts
::1     ip6-localhost ip6-loopback
fe00::0 ip6-localnet
ff00::0 ip6-mcastprefix
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters

```

Without getting into the gritty details, it's the name of your computer. This was my
starting point when I started working with instances yesterday. I knew that,
within each container instance, given that the instance could "see" the addresses
of the others, I'd want to give them a name for the user. So instead of needing
to hard code some ephemeral address into some dependency file in a container, 
you can write the name of the instance (like "app" or "nginx"). Let's say I created instances
named "app" and "nginx." They might have entries like this:

```bash

10.22.0.2	app
10.22.0.3	nginx
127.0.0.1	localhost

```

And then in some nginx.conf (a nginx configuration file) I could create a block
that references "app," fully knowing that the actual address might change (but
the name will stay constant).

```

upstream django {
    server app:3031;      # web port socket
}

```

### Bridge Networks

Okay, so great! We now (conceptually) know that we want to bind a hosts
file to each instance so that it can associate an ip address with a name.

> But wait, how do we know if an instance can see another's address?

I thought about this. What first came to mind was the idea of a bridge. I knew
that Docker was creating bridges in order for containers to talk to one another.
I read in the <a href="" target="_blank">Singularity docs</a> that a bridge is
created by default for Singularity 3.0 and over. Great!

> Um, but where is it?

I found a command called "brctl" (bridge control!) that will list bridges on
your host:

```bash

$ brctl show
bridge name	bridge id		STP enabled	interfaces
docker0		8000.0242e77953e2	no		
sbr0		8000.2280256f1d10	no		
							
```

I was really quite overjoyed to see docker0 there, because I would have expected that.
I got more excited when I saw "sbr0" because I hoped that it meant "Singularity Bridge"
and its existence was an indication that the bridge was created as expected.
I then realized that I could of course look in the singularity source code to
confirm this. I found a <a href="https://github.com/sylabs/singularity/blob/72551a988ed57a7e367f833c7d2a10abfabd7402/etc/network/00_bridge.conflist" target="_blank">configuration file</a> that creates it! And actually, these
are stored locally:

```bash

$ ls /usr/local/etc/singularity/network/
00_bridge.conflist  10_ptp.conflist  20_ipvlan.conflist  30_macvlan.conflist

```

And that confirmed it. And guess what, you can easily create your own. I thought about doing this
for singularity-compose, but if it's being installed by a user (without permission
to write to that particular folder) it would be a hassle when it failed, and I'd have to
provide another workaround anyway. So instead I
decided to develop using the default bridge. This means that on a single host,
all container instances (from a singularity-compose application and others
started at random, for example) would see one another. This wouldn't be desired
for production given a shared host, but for the average user to orchestrate
instances it will do. I suspect I'll add an argument at some point
to create and use a custom bridge, for the advanced user.

> What about the instances?

The next veriication I needed was that when I created instances, they were added to it.
This would mean that their addresses (assigned in the address space of the bridge) would
be viewable to one another. All I had to do in this case was start a group
of containers (with singularity-compose). If you run it with `--debug` it will
show you the commands that are run to start the instances. Here is one (abridged) 
example (networking pun!):

```bash
$ singularity instance start \
  --bind /home/vanessa/Documents/Dropbox/Code/singularity/singularity-compose-simple/etc.hosts:/etc/hosts \
  --net --network-args "portmap=80:80/tcp" --network-args "IP=10.22.0.2" \
  --hostname app \
  --writable-tmpfs app.sif app
```

Notice that we provide "--net" to indicate that we want to set up networking, following
by other network arguments. We could have even defined a specific kind (or custom) network
with "--network". I'll also quickly tell you that, based on knowing the sbr0 bridge used "10.22.0.0/16",
I was able to pre-emptively generate the addresses for the containers, write them
into host files to bind (see /etc/hosts above) and assign the address with "--network-args".
But check this out - there is an entire <a href="https://github.com/containernetworking" target="_blank">project</a>
to provide plugins for Container networking! It's referred to as "CNI" and if you
look in the Singularity source code, <a href="https://github.com/sylabs/singularity/blob/43b4df3e6c660f797c1c93d3e6413b9c02aed471/pkg/network/network_linux.go" target="_blank">it's being used</a>. This is how
we told Singularity to expose port 80:

```
--network-args "portmap=80:80/tcp"
```

And we could also specify to create a bridge <strong>within</strong> the container! I actually
did this first, and then realized I didn't need to. If I had created separate bridges, I'd
need to connect them with a fabric. I think maybe we do this with <a href="https://github.com/coreos/flannel" target="_blank">flannel?</a> I'm not sure. I need to read more about it.

And a quick Python trick - since we know the address of the bridge sbr0, we can use the 
<a href="https://docs.python.org/3/library/ipaddress.html#ipaddress." target="_blank">ipaddress</a> 
module to generate addresses for us. I wrote a function to generate a lookup
table of ip address by name, to pass around:

```python

def get_ip_lookup(names, bridge="10.22.0.0/16"):
    '''based on a bridge address that can serve other addresses (akin to
       a router, metaphorically, generate a pre-determined address for
       each container.

       Parameters
       ==========
       names: a list of names of instances to generate addresses for. 
       bridge: the bridge address to derive them for.
    '''
        
    host_iter = IPv4Network(bridge).hosts()
    lookup = {}
 
    # Don't include the gateway
    next(host_iter)

    for name in names:
        lookup[name] = str(next(host_iter))

    return lookup

```

So once I had run singularity-compose to bring up my instances, lo and behold - the interfaces appeared!

```bash

$ brctl show sbr0
bridge name	bridge id		STP enabled	interfaces
sbr0		8000.2280256f1d10	no		veth2cdea445
							vethda62c8b6
```

At this point, we hit the bug that I couldn't ping one instance ip from the 
other, and I moved on to creating the <a target="_blank" href="https://github.com/singularityhub/singularity-compose-simple">working example</a>  with a single container in the docs. That worked,
so I finished up the example, these docs, and I'll report back when
the networking bug is fixed and we can do examples with multiple containers.


## Overview

We've walked through a simple example of showing how singularity-compose
can help you to orchestrate container instances. I'd like to close with some
wisdom from my colleague @griznog, who has so many good quotes, he really
should have his own website just to house them. To give you some context,
he had compared "/etc/hosts" with a phone book, and was describing the meaning
of "localohost" (and why I couldn't change it):

> The takehome there is that you can't talk to other people on localhost, it's only for the voices in your head. Where "your" refers to each phone. `/etc/hosts` is a convenience, only needed if you can't remember everyone else's number.

It's definitely a good idea to not let any others in on those voices :) Thanks everyone,
and if you'd like to follow singularity-compose or ask a question, 
<a target="_blank" href="https://github.com/singularityhub/singularity-compose">you know what to do</a>.
