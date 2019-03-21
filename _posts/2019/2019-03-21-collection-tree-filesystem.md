---
title: "Collection Tree Filesystems"
date: 2019-03-21 6:30:00
---

The [containertree](https://singularityhub.github.io/container-tree/) software
aims to support and encourage research that can help us to better
optimize container development, distribution, and inheritance.
Specifically, it provides various tree data structures to describe 
different facets of containers. I won't go into detail because I've 
[discussed](https://vsoch.github.io/2018/container-tree/) these
data structures, visualizations, and functions previously, but I'll briefly
review each one:

## Container Filesystem Trees

[Container Filesystem Trees](https://singularityhub.github.io/container-tree/pages/demo/files_tree/) are exactly what you think - a tree data structure where nodes are folders and files within a single container. One or more containers or tags can be mapped to the tree to allow for easy search, trace, or comparison of a container or tag across the tree. I'm tickled by the fact that a Container Filesystem tree technically *is* a container.
The structure you interact with via the library mirrors what you see as the actual filesystem. This data structure should be interesting
to you if you want to study the guts of a single container, or compare guts between one or more containers.

## Container Package Trees

[Container Package Trees](https://singularityhub.github.io/container-tree/examples/package_tree/) keep track of packages and versions for one or more containers, and make it easy to [export data frames](https://singularityhub.github.io/container-tree/examples/export_data/) of that data. I've been doing a cool analysis that shows a nice (expected) relationship between
packages and container inheritance, but I'll save that for a later post. The software can easily export package metadata by using
[container-diff](https://github.com/GoogleContainerTools/container-diff) under the hood.

<br>

# Collection Trees

Okay let's get excited, because I've been working heavily on developing the 
[Collection Tree](https://singularityhub.github.io/container-tree/examples/collection_tree/) 
data structure, and it's super cool. A collection tree represents an inheritance structure 
for a family of containers. This means that the root node is [scratch](https://hub.docker.com/_/scratch), 
the first level likely includes containers in the [docker library](https://hub.docker.com/u/library/) 
(e.g., think of `library/ubuntu:16.04` or similar)
and the children inherit from that. These are of course the defaults (you can enforce your tree
to have a first level of "chewbacca" if that floats your boat) that can be easily modified.
With a collection tree you can:

<ol class="custom-counter">
<li>Trace, search, or find a particular container</li>
<li>Compare containers based on distances in the tree</li>
<li>Export your tree as an <strong>actual</strong> filesystem</li>
</ol>

<br>

Let's walk through an example to show you what I mean! I've already shown you
creating trees, and searching, removing, or tracing nodes, so today let's talk about
the last bullet. The last bullet is fresh off the keyboard, and it's about
creating collection tree filesystems.

## Collection Tree Filesystem

The more I thought about it, akin to the container tree, the Collection Tree itself also 
mapped really well to a filesystem. But instead of actual files and folders, the files
and folders of the Collection Tree Filesystem represent the collection namespaces and tags.
So I wrote a function to export the nodes as paths:


```python

for path in tree.paths():
    print(path)

/scratch
/scratch/library/debian
/scratch/library/python
/scratch/library/python/.latest/continuumio/miniconda3
/scratch/library/python/.latest/continuumio/miniconda3/.latest/singularityhub/containertree
/scratch/library/python/.latest/continuumio/miniconda3/.latest/singularityhub/singularity-cli
/scratch/library/python/.latest/continuumio/miniconda3/.1.0/childof/miniconda3

```

and then from that I could easily create the structure [in a container](http://hub.docker.com/r/vanessa/collection-tree-fs).

### 1. A Collection Tree Filesystem Container

Let's shell into this collection tree filesystem container! I thought about creating this as a squashfs filesystem
that could be mounted from a container, but decided to just make another root (/scratch) in a traditional
Docker container to make it most readily usable:

```bash

$ docker run -it vanessa/collection-tree-fs

```

If you run the example above, be warned that I've built a tree with inheritance for over 100K 
Docker images I've extracted from 2017. The dummy example below is a fake tree that I used 
during testing to exemplify that. First, notice that when we shell inside, the 
working directory is scratch. This is the root of the filesystem tree:

```bash
(base) root@c1e3d68bac93:/scratch# tree
.
└── library
    ├── debian
    │   └── tag-latest
    │       └── vanessa
    │           └── pancakes
    └── python
        └── tag-latest
            └── continuumio
                └── miniconda3
                    ├── tag-1.0
                    │   └── childof
                    │       └── miniconda3
                    └── tag-latest
                        └── singularityhub
                            ├── containertree
                            └── singularity-cli

12 directories, 0 files
```

You can [see here](https://github.com/singularityhub/container-tree/tree/master/examples/collection_tree) 
to understand how I created the Collection Tree data structure,
and then exported it into a container. You basically need to know pairs of containers, a single
container, and then whatever it's base happens to be. I had a set of Dockerfiles (with FROM statements)
that I also knew the unique resource identifiers for, so I was able to do this. This comes
from the [Dockerfiles dataset](https://vsoch.github.io/datasets/2018/dockerfiles/) if anyone else is interested. 

### 2. Collection Tree Filesystem Interaction

This is another really cool part. Once you have your Container namespaces exported to
an actual filesystem, you can interact with them using standard linux command line tools! 
For example, here we are searching for a tag of interest across all collections:

```bash

$ find . -name tag-latest
./library/debian/tag-latest
./library/python/tag-latest
./library/python/tag-latest/continuumio/miniconda3/tag-latest

```
 
Or finding a collection namespace with a particular string (singularityhub):

```bash

$ find . -name singularityhub
./library/python/tag-latest/continuumio/miniconda3/tag-latest/singularityhub

```

As a more substantial example, here I am using the (bigger) container `vanessa/collection-tree-fs`
and looking at all the ubuntu tags! Since the defaults exports tags as hidden folders (starting with ".")
for this container I changed the "tag_prefix" variable so they would all be prefixed with "tag-". I knew
that containers have a lot of tags, but I never imagined this many!

```bash

(base) root@60a8aa15ef1c:/scratch# ls library/ubuntu
tag-10.04    tag-15.04		  tag-bionic-20180426  tag-trusty-20150814  tag-xenial-20160125    tag-x...
tag-12.04    tag-15.10		  tag-devel	       tag-trusty-20160323  tag-xenial-20160331.1  tag-x...
tag-12.04.5  tag-16.04		  tag-latest	       tag-trusty-20160624  tag-xenial-20160809    tag-x...
tag-12.10    tag-16.10		  tag-lucid	       tag-trusty-20160711  tag-xenial-20160818    tag-x...
tag-13.04    tag-17.04		  tag-precise	       tag-trusty-20161214  tag-xenial-20160923.1  tag-x...
tag-13.10    tag-17.10		  tag-quantal	       tag-trusty-20170602  tag-xenial-20161010    tag-x...
tag-14.04    tag-18.04		  tag-raring	       tag-trusty-20170728  tag-xenial-20161213    tag-y...
tag-14.04.1  tag-artful		  tag-rolling	       tag-trusty-20170817  tag-xenial-20170119    tag-z...
tag-14.04.2  tag-artful-20170916  tag-saucy	       tag-utopic	    tag-xenial-20170214    tag-z...
tag-14.04.3  tag-artful-20171116  tag-trusty	       tag-vivid	    tag-xenial-20170510    tag-z...
tag-14.04.4  tag-artful-20180417  tag-trusty-20150427  tag-wily		    tag-xenial-20170619
tag-14.04.5  tag-bionic		  tag-trusty-20150528  tag-wily-20150829    tag-xenial-20170802
tag-14.10    tag-bionic-20180125  tag-trusty-20150612  tag-xenial	    tag-xenial-20170915

```

Here is how we can just count them:

```bash

(base) root@60a8aa15ef1c:/scratch# ls library/ubuntu | wc -l
75

```

Here is a peek into one of the smaller tag folders, raring, which I believe is version 13.04 (a long time ago!)

```bash

(base) root@60a8aa15ef1c:/scratch# tree library/ubuntu/tag-raring/
library/ubuntu/tag-raring/
├── ewindisch
│   └── docker-bomb
└── leifw
    └── tokumx-builder-ubuntu-raring

4 directories, 0 files

```

What could you do with this filesystem? You could do something as simple as using it as a storage structure.
Some related file content could be stored in the correct container namespace folder, or possibly even
the container itself. If you are interested in calculating metrics, you might want to stick with
the collection tree data structure itself. But another cool thing you can do is to write metadata
to the filesystem directly. Let's talk about that next.


### 3. Collection Tree Filesystem Metadata

What about metadata? What got me really excited was discovering that
using filesystem [xattrs](https://en.wikipedia.org/wiki/Extended_file_attributes#Linux)
I can add metadata to the actual nodes in the filesystem. First I tried doing it manually,
inside my container (I was too afraid to do this on my host). Here is the usage"

```bash

Usage: attr [-LRSq] -s attrname [-V attrvalue] pathname  # set value
       attr [-LRSq] -g attrname pathname                 # get value
       attr [-LRSq] -r attrname pathname                 # remove attr
       attr [-LRq]  -l pathname                          # list attrs 
      -s reads a value from stdin and -g writes a value to stdout

```

We could do something like add a count at each node, meaning the number of times the container was added as a
parent or a child. You can do this in python or with the xattr library on the system.  Here is
how to add an attribute:

```bash

(base) root@38ecc937efda:/scratch# attr -s maintainer -V vanessasaur library/debian/
Attribute "maintainer" set to a 11 byte value for library/debian:
vanessasaur

```
The "V" means the value, and "-s" means set, so we use the general form `attr -s <key> -V <value> <path>`.
And then list the attribute:

```bash

(base) root@38ecc937efda:/scratch# attr -g maintainer library/debian/
Attribute "maintainer" had a 11 byte value for library/debian/:
vanessasaur

```

As another example, here is how to list attributes for an example library/debian folder that has
had a count added:

```bash

(base) root@f379adcb3cb7:/scratch# attr -l library/debian/
Attribute "count" has a 3 byte value for library/debian/

```

To actually get the count:

```bash

(base) root@f379adcb3cb7:/scratch# attr -g count library/debian/
Attribute "count" has a 3 byte value for library/debian/
3

```

How awesomely wicked cool is this! We can put metadata with our files! 
For those interested in using this with containertree, there is 
a [python package](https://github.com/xattr/xattr) that would make integration
easy. 

## Final Thoughts

I <strong>really</strong> want you to get excited about studying containers. 
While you are distracted with AI taking over the world, and everything touted as cool
on social media, I'm over here jumping up and down trying to get you interested in data
structures and organizational standards. Think about it -
containers are the new unit of reproducible analysis, and enterprise deployment. We need
to be thinking hard and carefully about mapping 
this universe of containers, or developing a rigorous method to not just randomly use a machine
learning container to achieve a goal, but how to optimize your choice. And nobody is studying
how different container bases map to different use cases. Do more people use alpine with 
GPUs, or something else? If I want to do some genomic analysis, can I quickly find
the best container to do that?

If anyone wants to do a fun project to ask some of these questions, I'm a dynamo dinosaur programmer, 
and I'm in! I submit a small [paper](https://joss.theoj.org/papers/f7b46a7f922b468e535adabc2337b330)
for the software to be reviewed, and will follow up with a small analysis with package trees.
In the meantime, please contribute or provide feedback - the library is under development,
and I'm continually hoping to improve it.
