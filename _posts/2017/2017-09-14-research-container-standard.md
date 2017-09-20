---
title: "The Research Container Standard"
date: 2017-07-14 7:24:00
---

Containers, on the level of the operating system, are like houses. We carry an expectation that we find food in the kitchen, a bed in a bedroom, and toiletries in a bathroom.  We can imagine a fresh Ubuntu image is akin to a newly furnished house. When you shell in, most of your expectations are met. However, as soon as a human variable is thrown into the mix (we move in), the organization breaks. Despite our best efforts, the keys sometimes end up in the refrigerator. A sock becomes a lone prisoner under a couch cushion. The underlying organization of the original house is still there with the matching expectations, but we can no longer trust it. What do I mean? If I look at a house from the outside and someone asks me "Are the beds in the bedroom?" I would guess yes. However, sometimes I might be wrong, because we are looking at a Bay Area house that has three people residing in a living area.

Now imagine that there is a magical box, and into it I can throw any item, or ask for any item, and it is immediately retieved or placed appropriately. Everything in my house has a definitive location, and there are rules for new items to follow suit. I can, at any moment, generate a manifest of everything in the house, or answer questions about the things in the house. If someone asks me "Are the beds in the bedroom?" knowing that this house has this box, I can answer definitively "yes!"

The house is the container, and the box represents what a simple standard and software can do for us. In this post I want to discuss how our unit of understanding systems has changed in a way that does not make it easy for reproducibility and scalable modularity to co-exist in harmony.


## Modular or Reproducibile?
For quite some time, our unit of understanding has been based on the operating system. It is the level of magnification at which we understand data, software, and products of those two things. Recently, however, two needs have arisen.

We simultaneously need modularity and reproducible practices. At first glance, these two things don't seem very contradictory. A modular piece of software, given that all dependencies are packaged nicely, is very reproducible. The problem arises because it's never the case that a single piece of software is nicely suited for a particular problem. A single problem, whether it be sequencing genetic code, predicting prostate cancer recurrence from highly dimensional data, or writing a bash script to play tetris, requires many disparate libraries and other software dependencies. Given our current level of understanding of information, the operating system, the best that we can do is give the user absolutely everything - a complete operating system with data, libraries, and software. But now for reproducibility we have lost modularity. A scientific software packaged in a container with one change to a version of a library yields a completely different container despite much of the content duplicated. We are being forced to operate on a level that no longer makes sense given the scale of the problem, and the dual need for modularity and dependency. How can we resolve this?


## Level of Dimensionality to Operate
The key to answering this question is deciding on the level, or levels, of dimensionality that we will operate. On one side of the one extreme, we might break everything into the tiniest pieces imaginable. We could say bytes, but this would be like saying that an electron or proton is the ideal level to understand matter. While electrons and protons, and even one level up (atoms) might be an important feature of matter, arguably we can represent a lot more consistent information by moving up one additional level to a collection of atoms, an element. In file-system science an atom matches to a file, and an element to a logical grouping of files to form a complete software package or scientific analysis. Thus we decide to operate on the level of modular software packages and data. We call these software and data modules, and when put together with an operating system glue, we get a full containers.  Under this framework we make the following assertions:

 >> a container is the packaging of a set of software and data modules, reproducible in that all dependencies are included 
<br>
 >> building multiple containers is efficient because it allows for re-use of common modules
<br>
 >> a file must not encompass a collection of compressed or combined files. I.e., the bytes content 
<br>
 >> each software and data module must carry, minimally, a unique name and install location in the system

This means that the skeleton of a container (the base operating system) is the first decision point. This will filter down a particular set of rules for installation locations, and a particular subset of modules that are available. Arguably, we could even take organizational approaches that would work across hosts, and this would be especially relevant for data containers that are less dependent on host architecture. For now, let's stick to considering them separately.  

```
Operating System --> Organization Rules --> Library of Modules --> [choose subset] --> New Container
```

Under this framework, it would be possible to create an entire container by specifying an operating system, and then adding to it a set of data and software containers that are specific to the skeleton of choice. A container creation (bootstrap) that has any kind of overlap with regard to adding modules would not be allowed. The container itself is completely reproducible because it (still) has included all dependencies. It also carries complete metadata about its additions. The landscape of organizing containers also becomes a lot easier because each module is understood as a feature.

>> TLDR: we operate on the level of software and data modules, which logically come together to form reproducible containers.

## Metric for Assessing Modules
Given that a software or data module carries one or more signatures, the next logical question is about the kinds of metrics that we want to use to classify any given module. 

### Manual Annotation
The obvious approach is the human labeled organization, meaning that a person looks at a software package, calls it "biopython" for "biology" in "python" and then moves on. Or perhaps it is done automatically based on the scientists domain of work, tags from somewhere, or a journal published in. This metric works well for small, manageable projects, but is largely unreliable as it is hard to scale or maintain. 

### Functional Organization
The second is functional organization. We can view software as a black box that performs some task, and rank/sort the software based on comparison of that performance. If two different version of a python module act exactly the same, despite subtle differences in the files (imagine the silliest case where the spacing is slightly different) they are still deemed the same thing. If we define a functional metric likes "calculates standard deviation" and then test software across languages to do this, we can organize based on the degree to which each individual package varies from the average. This metric maps nicely to scientific disciplines (for which the goal is to produce some knowledge about the world. However if this metric is used, the challenge would be for different domains to be able to robustly identify the metrics most relevant, and then derive methods for measuring these metrics across new software. This again is a manual bottleneck that would be hard to overtake. Even if completely programmatic, data driven approaches existed for deriving features of these black boxes, without the labels to make those features into a supervised classification task, we don't get very far. 

### File Organization and Content
A third idea is a metric not based on function or output, but simple organizational rules. We tell the developer that we don't care what the software package does, or how it works, but we assert that it must carry a unique identifier, and that identifier is mapped to a distinct location on a file system. With these rules, it could be determined immediately if the software exists on a computer, because it would be found. It would be seamless to install and use, because it would not overwrite or conflict with other software. It would also allow for different kinds of (modular) storage of data and software containers.

For the purposes of this thinking, I propose that the most needed and useful schema is functional, but in order to get there we must start with what we already have: files and some metadata about them. I propose the following:

 >> Step 1 is to derive best practices for organization, so minimally, given a particular OS, a set of software and data modules have an expected location, and some other metadata (package names, content hashes, dates, etc.) about them.
<br>
 >> Step 2, given a robust organization, is to start comparing across containers. This is where we can do (unsupervised) clustering of containers based on their modules.
<br>
 >> Step 3, given an unsupervised clustering, is to start adding functional and domain labels. A lot of information will likely emerge with the data, and this is the step I don't have vision for beyond that. Regardless of the scientific questions (which others vary in having interest in) they are completely reliant on having a robust infrastructure to support answering them.
<br><br>

The organization (discussed more below) is very important because it should be extendable to as many operating system hosts as possible, and already fit into (what exist/are) current cluster file-systems. We should take an approach that affords operating systems designing themselves. E.g., imagine someday that we can do the following:

>> We have a functional goal. I want an operating system (container) optimized to do X. I can determine if X is done successfully, and to what degree. 
<br>
 >> We start with a base or seed state, and provide our optimization algorithm with an entire suite of possible data and software packages to install. 
<br>
>> We then let machine learning do it's thing to figure out the optimized operating system (container) given the goal. 
<br>

Since the biggest pain in creating containers (seems to be) the compiling and "getting stuff to work" part, if we can figure out an automated way to do this, one that affords versioning, modularity, and transparency, we are going to be moving in the right direction. It would mean that a scientist could just select the software and data he/she wants from a list, and a container would be built. That container would be easily comparable, down the difference in software module verison, to another container. With a functional metric of goodness, the choices of data and software could be somewhat linked to the experimential result. We would finally be able to answer questions like "Which version of biopython produces the most varying result? Which brain registration algorithm is most consistent? Is the host operating system important? 

If we assume that these are important questions to be able to answer, and that this is a reasonable approach to take, then perhaps we should start by talking about file system organization.

## File Organization
File organization is likely to vary a bit based on the host OS. For example, busybox has something like 441 "files" and most of them are symbolic links. Arguably, we might be able to develop an organizational schema that remains (somewhat) true to the [Filesystem Hierarchy Standard](https://en.wikipedia.org/wiki/Filesystem_Hierarchy_Standard), but is extendable to operating systems of many types. I'm not sure how I feel about this standard given that someday we will likely have operating systems designing themselves, but that is a topic for another day.

### Do Not Touch
I would argue that the following folders, most scientific software should not touch:

 - `/boot`: boot loader, kernel files
 - `/bin`: system-wide command binaries (essential for OS)
 - `/etc`: host-wide configuration files
 - `/lib`: again, system level libraries
 - `/root`: root's home. Unless you are using Docker, putting things here leads to trouble.
 - `/sbin`: system specific binaries
 - `/sys`: system, devices, kernel features


### Variable and Working Locations

 - `/run`: run time variables, should only be used for that, during running of programs.
 - `/tmp`: temporary location for users and programs to dump things.
 - `/home`: can be considered the user's working space. Singularity mounts by default, so nothing would be valued there. The same is true for..


### Connections
Arguably, connections for containers are devices and mount points. So the following should be saved for that:

 - `/dev`: essential devices
 - `/mnt`: temporary mounts.
 - `/srv`: is for "site specific data" served by the system. Perhaps this is the logical mount for cluster resources?

The point that "connections" also means mounting of data has not escaped my attention. This is an entire section of discussion.


## Data
This is arguably just a mount point, but I think there is one mount root folder that is perfectly suited for data:

`/media`: removable media. This is technically something like a CD-ROM or USB, and since these media are rare to use, or used to mount drives with data, perhaps we can use it for exactly that.

Data mounted for a specific application should have the same identifier (top folder) to make the association. The organization of the data under that location is up to the application. The data can be included in the container, or mounted at runtime, and this is under the decision of the application. Akin to software modules, overlap in modules is not allowed. For example, let's say we have an application called bids (the bids-apps for neuroimaging):

 >> the bids data would be mounted / saved at `/media/bids`.
<br>
 >> importing of distinct data (subjects) under that folder would be allowed, eg `/media/bids/sub1` and `/media/bids/sub2`.
>> importing of distinct data (within subject) would also be allowed, e.g., `/media/bids/sub1/T1` and `/media/bids/sub1/T2`.
<br>
>> importing of things that get overwritten would not be allowed.
<br>

An application's data would be traceable to the application by way of it's identifier. Thus, if I find `/media/bids` I would expect to find either `/opt/bids` or equivalent structure under `/usr/local` (discussed next). 


## Research Software
Research software is the most valuable element, along with data, and there are two approaches we can take, and perhaps define criteria for when to use each.  There must be general rules for packaging, naming, and organizing groups of files. The methods must be both humanly interpretable, and machine parsable.  For the examples below, I will reference two software packages, singularity and sregistry:


### Approach 1: /usr/local
For this approach, we "break" packages into shared sub-folders, stored under `/usr/local`, meaning that executables are in a shared bin:

```
/usr/local/
        /bin/
           singularity
           sregistry
```

and each software has it's own folder according to the Linux file-system standard (based on its identifier) under `/usr/local/[ name ]`. For example, for lib:

```
/usr/local/lib
          singularity/
          sregistry/
```


The benefits of this approach are that we can programatically identify software based on parsing `/usr/local`, and just need one `/bin` on the path. We also enforce uniqueness of names, and have less potential for having software with the same name in different bins (and making the determinant of which to use based on the `$PATH`). The drawbacks are that we have a harder time removing something from the path, if that is needed, and it will not always be the case that all programs need all directories. If we are parsing a system to discover software, for example, we would need to be very careful not to miss something. This is rationale for the next approach.

### Approach 2: /opt
This is a modular approach that doesn't share the second level of directories. The `/opt` bin is more suited to what we might call a modern ["app"](https://en.wikipedia.org/wiki/Application_software). For this approach, each installed software would have it's own sub-folder. In the example of using singularity and sregistry:

```
/opt/
  singularity/
  sregistry/
```

and then under each, the software could take whatever approach is necessary (in terms of organization) to make it work. This could look a lot like small clones of the Linux file system standard, eg:

```
/opt/
  singularity/
        /bin
        /lib
        /etc
        /libexec
```

or entirely different


```
/opt/
  singularity/
        /modules
        /functions
        /contrib
```

The only requirement is that we would need a way / standard to make the software accessible on the path. For this we could do one of the following:

>> require a `bin/` folder with executables. The sub-folders in `/opt` would be parsed for `/bin` and the bin folders added to the path. This would work nicely with current software distributed, which tends to have builds dumped into this kind of hierarchy.
<br>
>> In the case that the above is not desired because not all applications conform to having a bin, then the application would need to expose some environment variable / things to add to the `$PATH` to get it working.
<br>

### Approach 3: /opt with features of /usr/local
If the main problem with `/opt` is having to find/add multiple things to the path, there could be a quasi solution that places (or links) main executables in a main `/bin` under `/opt`. Thus, you can add one place to the path, and have fine control over the programs on the path by way of simply adding/removing a link. This also means that the addition of a software module to a container needs to understand what should be linked.


### Submodules
We are operating on the level of the software (eg, python, bids-app, or other). What about modules that are installed to software? For example, pip is a package manager that installs to python. Two equivalent python installations with different submodules are, by definition, different. We could take one of the following approaches:

>> represent each element (the top level software, eg python) as a base, and all submodules (eg, things installed with pip) are considered additions. Thus, if I have two installations of python with different submodules, I should still be able to identify the common base, and then calculate variance from that base based on differences between the two.
<br>
>> Represent each software version as a base, and then, for each distinct (common) software, identify a level of reproducibility. Comparison of bases would look at the core base files, while comparison of modules would look across modules and versions, and comparison within a single module would look across all files in the module.
<br>

The goal would be to be able to do the following:

>> quickly sniff the software modules folder to find the bases. The bases likely have versions, and the version should ideally be reflected in the folder name. If not, we can have fallback approaches to finding it, and worse case, we don't. Minimally, this gives us a sense of the high level guts of an image.
<br>
>> If we are interested in submodules, we then do the same operation, but just a level deeper within the site-packages of the base.
<br>
>> if we are interested in one submodule, then we need to do the same comparison, but across different versions of a package.


### Metadata
As stated above, a software or data module should have a minimal amount of metadata:

>> unique identifier, that includes the version
<br>
>> a content hash of it's guts (without a timestamp)
<br>
>> (optionally, if relevant) a package manager
<br>
>> (optionally, if relevant) where the package manager installs to


### Permissions
Permissions are something that seem to be very important, and likely there are good and bad practices that I could image. Let's say that we have a user, on his or her local machine. He or she has installed a software module. What are the permissions for it?


 - **Option 1** is to say "they can be root for everything, so just be conservative and require it." A user on the machine that is not sudo, too bad. This is sort of akin to maintaining and all or nothing binary permission, but for one person, that might be fine. Having this one (more strict) level, as long as it's maintained, wouldn't lead to confusion between user and root space, because only operation in root space is allowed.
 - **Option 2** is to say "it's just their computer, we don't need to be so strict, just change permissions to be world read/write/execute." This doesn't work, of course, for a shared resource where someone could do something malicious by editing files.
 - **Option 3** is to say "we should require root for some things, but then give permissions just to that user" and then of course you might get a weird bug if you switch between root/user, sort of like Singularity has some times with the cache directory. Files are cached under `/root` when a bootstrap is run as root, but under the user's home when import is done in user space.

I wish that we lived in a compute world where each user could have total control over a resource, and empowered to break and change things with little consequences. But we don't. So likely we would advocate for a model that supports that - needing root to build and then install, and then making it executable for the user.

## Overview
A simple approach like this:

>> fits in fairly well with current software organization
<br>
>> is both modular for data and software, but still creates reproducible containers
<br>
>> allows for programmatic parsing to be able to easily find software and capture the contents of a container.

We could then have a more organized base to work from, along with clearer directions (even templates) for researchers to follow to create software. In the context of Singularity containers, these data and software packages become their own thing, sort of like Docker layers (they would have a hash, for example) but they wouldn't be random collections of things that users happened to put on the same line in a Dockerfile. They would be humanly understood, logically grouped packages. Given some host for these packages (or a user's own cache that contains them) we can designate some uri (let's call it `data://` that will check the user's cache first, and then the various hosted repositories for these objects. A user could add `anaconda3` for a specific version to their container (whether the data is cached or pulled) like:

```
import data://anaconda3:latest
```

And a user could just as easily, during build time, export a particular software or data module for his or her use:

```
export data://mysoftware:v1.0 
```

and since the locations of mysoftware for the version would be understood given the research container standard, it would be found and packaged, put in the user's cache (and later optionally / hopefully shared for others).

This would also be possible not just from/during a bootstrap, but from a finished container:

```
singularity export container.img data://anaconda3:latest 
```

I would even go as far to say that we stay away from system provided default packages and software, and take preference for ones that are more modular (fitting with our organizational schema) and come with the best quality package managers. That way, we don't have to worry about things like "What is the default version of Python on Ubuntu 14.04? Ubuntu 14.06? Instead of a system python, I would use anaconda, miniconda, etc.


### Challenges
Challenges of course come down to:

>> symbolic links of libraries, and perhaps we would need to have an approach that adds things one at a time, and deals with potential conflicts in files being updated. 
<br>
>> reverse "unpacking" of a container. Arguably, if it's modular enough, I should be able to export an entire package from a container.
<br>
>> configuration: we would want configuration to occur after the addition of a new piece, calling ldconfig, and then add the next, or things like that.
<br>
>> the main problem is library dependencies. How do we integrate package managers and still maintain the hierarchy?
<br>

One very positive thing I see is that, at least for Research Software, a large chunk of it tends to be open source, and found freely available on Github or similar. This means that if we do something simple like bring in an avenue to import from a Github uri, we immediately include all of these already existing packages.

### First Steps
I think we have to first look at the pieces we are dealing with. It's safe to start with a single host operating system, Ubuntu is good, and then look at the following:

>> what changes when I use the package manager (apt-get) for different kinds of software, the same software with different versions
<br>
>> how are configurations and symbolic links handled? Should we skip package managers and rely on source? (probably not)
<br>
>> how would software be updated under our schematic?
<br>
>> where would the different metadata/ metrics be hosted?

 to one that does not 

Organization and simple standards that make things predictible (while still allowing for flexibility within an application) is a powerful framework for reproducible software, and science. Given a standard, we can build tools around it that give means to test, compare, and make our containers more trusted. We never have to worry about capturing our changes to decorating the new house, because we decorate with a tool that captures them for us. 

I think it's been hard for research scientists to produce software because they are given a house, and told to perform some task in it, but no guidance beyond that. They lose their spare change in couches, don't remember how they hung their pictures on the wall, and then get in trouble when someone wants to decorate a different house in the same way.  There are plenty of guides for how to create an R or Python module in isolation, or in a notebook, but there are minimal examples outlined or tools provided to show how a software module should integrate into it's home. 

I also think that following the traditional approach of trying to assemble a group, come to some agreement, publish a paper, and wait for it to be published, is annoying and slow. Can open source work better? If we work together on a simple goal for this standard, and then start building examples and tools around it, we can possibly (more quickly) tackle a few problems at once. 

>> `1.` the organizational / curation issue with containers
<br>
>> `2.` the ability to have more modularity while still preserving reproducibility, and 
<br>
>> `3.` a base of data and software containers that can be selected to put into a container with clicks in a graphical user interface.
<br>

Now if only houses could work in the same way! What do you think?
