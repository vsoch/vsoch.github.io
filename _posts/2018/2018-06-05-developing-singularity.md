---
title: "Developing for Singularity 3.0"
date: 2018-05-06 2:12:00
toc: true
---

{% include toc.html %}

Barriers to entry in the open source development world correspond to how hard it is to
get started working on something. This can include any and all of:

<ol class="custom-counter">
  <li>How hard is it to set up my development environment?</li>
  <li>How well do I know the language(s) we are developing in?</li>
  <li>How hard is it to ask for help, and how quickly do I get a response?</li>
</ol>

I was contemplating this over the weekend as I realized that the new development workflow for
Singularity 3.0 was very different than the original
code base. And I was unfamiliar with it. In this mindset I realized very
quickly that

> unfamilarity with a code base can deter me from contributing!

Whether I didn't want to install a bunch of new dependencies, or I had trouble doing 
it, or I just didn't want to spend the time, the thought of this need to "set up
from scratch" a development environment that is (additionally) unfamiliar is 
a scary thing for open source. It's terrifying because sometime so trivial like a few
`apt-get install ...` might make the difference between a fun contribution and 
changing your mind to return to watching slow motion cake icing on YouTube (no judgment!) 

## Comfort Drives Choices
This general idea of familiarity with a language or development workflow isn't
specific to the software, it's specific to the experience of the human developer.
The lower the barriers to entry, meaning the familiarity of the development environment, the
language, and an ability to get help, are direct factors to influence if it's an evening
of programming or buttercream.

## Development Environment for Singularity
So how can we help with this problem of feeling lost in the dinosaur wilderness,
that everyone must face at multiple points in their careers?  We create a reproducible development environment. 
That's sort of what these container things are for, right? I like doing something once, and then never having to do it again. And if I'm going to do it once, why should someone else
need to do it again? My future self is really lazy, and doesn't want to look up the dependencies
again.

For this work, I wanted a quick "up and running" solution that was easier than
having to find and read a (probably dated) documentation about how to do it. Ironically, this (for me)
meant creating a Docker image to develop Singularity. I'll walk through the generation
of this environment and then how to use it to show you how easy it is to contribute.

<strong>Note</strong> that this
development workflow is relevant to May 2018, and the <a href="https://github.com/vsoch/singularity/blob/3.0-ShubProvisioner/Dockerfile" target="_blank">development environment</a> detailed here only 
<a href="https://github.com/vsoch/singularity/tree/3.0-ShubProvisioner" target="_blank">exists in my branch</a>. It's also
likely to change when the pull request is reviewed. As the current development branch for singularity is
changed, you should always check it first
<a href="https://github.com/singularityware/singularity/blob/master/INSTALL.md" target="_blank"> here</a> for up-to-date instructions.


## The Development Environment
You can go from 0mph to chipmunk speed by dumping the dependencies, meaning installation
of host libraries, addition of files, and building of things, into a container. 
For my case, I decided to create a Dockerfile, and here is what 
it looks like:

```bash

FROM golang:stretch

ENV PATH="${GOPATH}/bin:${PATH}"

RUN echo "Installing build dependencies!\n" && apt-get update && \
    apt-get install -y squashfs-tools \
                       libssl-dev \
                       uuid-dev \
                       curl \
                       libarchive-dev \ 
                       libgpgme11-dev

WORKDIR /code
ENV SRC_DIR=/go/src/github.com/singularityware/singularity
ADD . $SRC_DIR
WORKDIR $SRC_DIR

RUN curl https://raw.githubusercontent.com/golang/dep/master/install.sh | sh && \
    dep ensure -vendor-only

# Compile the Singularity binary
RUN ./mconfig && \
     cd ./builddir && \
     make dep && make && make install

WORKDIR $SRC_DIR
RUN test -z $(go fmt ./...)

# HEALTHCHECK go test ./tests/

ENTRYPOINT ["singularity"]
```

and here are various ways that you can use it.

```bash
# Building: 
docker build -t vanessa/singularity-dev .
```
```bash 
# Interactive Session
docker run --privileged -it --entrypoint bash vanessa/singularity-dev
```
```bash
# Testing example
docker run --privileged -it --entrypoint go vanessa/singularity-dev test ./tests/
```

Note that you could just as 
easily issued the commands in the file above on your host, but I didn't want
to do that (hence creating the container to begin with). You could also likely generate
the above in a Singularity container (with writable) to get the full "welcome to the Matrix!"
effect. I haven't tried that yet!

There may be some ruffling of feathers with respect to "Hey, I don't want to use that
**other** container technology" but you know what? Let's not forget about the
importance of <a href="https://sci-f.github.io/snakemake.scif" target="_blank">container friends</a>. This is a very good case of one container technology giving another one a leg up to make development much easier! Will we hit some bugs because of the additional
layer? Maybe. But I would go as far to say that, given that users might want to build
Dockerized services for Singularity, having this implementation down spot is a worth
while addition. Just to review, we've done the following:

<ol class="custom-counter">
  <li>Started with a debian base and installed a bunch of dependencies.</li>
  <li>Added the Singularity code base to its proper spot in the GOPATH</li>
  <li>Built Singularity (you can comment the last make lines if you want to do this later)</li>
</ol>

To reiterate, this manner of development isn't required or forced, it's just an option. 
And it's mostly because future me doesn't want to do the same thing twice. There are also
likely other ways to set up this environment. For example, I had originally  
started with a more slim alpine base, but hit some issues with
installing dependencies.


## The New Feature
Given that we have this Dockerfile as part of our core development repository, here is
what the entire process would look like to develop a new feature. In this case,
I want to add the endpoint to ping Singularity Hub and dump an image into a
sandbox folder.  I am basically going to start by cloning some base, checking out
a branch for my feature, developing, then building. The build of the Docker image can
happen anywhere in there, just before I need to compile Singularity!

First clone your base branch, whatever it may be. This one has the Dockerfile in it.

```bash

$ git clone -b 3.0-ShubProvisioner git@github.com/vsoch/singularity.git
$ cd singularity

```

Next build the container. You could also do this after writing some code for
your feature, but likely you should do it first in case your changes lead to 
compile errors (and the container doesn't build)

```
$ docker build -t vanessa/singularity-dev .
```
Finally, if you haven't yet, checkout a new branch for your feature, and start coding!

```bash
$ git checkout -b 3.0-new-feature
```

At this point, I would run the container and bind my local code to the container's
singularity repo directory under the `$GOPATH`, and ask for an interactive bash session
(`-it` means interactive terminal, and `--entrypoint bash` says we want to run a bash 
shell). If you use an image like alpine, be aware that you may want a different shell
(like `sh`) since bash isn't natively installed.


```bash

$ docker run -v $PWD/src:/go/src/github.com/singularityware/singularity/src \
             --privileged -it --entrypoint bash vanessa/singularity-dev

```

Here we are inside the container! The folder we have mapped is `src`.

```

root@948c449ce46c:/go/src/github.com/singularityware/singularity# ls
CONTRIBUTING.md  Dockerfile  INSTALL.md       README.md  docs		  examples  mlocal  vendor
CONTRIBUTORS.md  Gopkg.lock  LICENSE-LBNL.md  builddir	 environment.tar  makeit    src
COPYRIGHT.md	 Gopkg.toml  LICENSE.md       dist	 etc		  mconfig   tests

```

At this point, your local folder with `singularity/src` is bound to the folder here
called `src` in the container, which means you can use the editor on your local machine to change
the files, and run things in the shell we just created. Before you make any changes,
you might want to test the code that currently is there:

```bash

go test ./tests/
ok  	github.com/singularityware/singularity/tests	46.563s

```

Cool! I think the slowness has more to do with the immense lack of resources currently on
my computer, because previously this ran in under 20s. I'm okay with this for now, because
I didn't have to install a bunch of extra stuff on my host. So at this point, we do our development thing. 
I'm going to <a href="https://github.com/bauerm97/singularity/pull/4/files" target="_blank">create some new files</a>, 
and make some changes. I won't go into detail about these changes, but I'll go over some basic helper 
commands for development that I am just learning.


## Formatting Code
If you like to get into arguments about tabs versus spaces, GoLang isn't for you! It 
has its own command for formatting code. Outside the container, you can run this command to have
the files automatically formatted for you:

```
$ go fmt ./...
```
I believe the above says to go three levels down in subfolders in the present working directory.
The reason that you want to do this from the outside is that if you write changes from the inside,
you risk having weird permissions issues, because you are running as the root user in the container.


## Building
After we've written some code, we have to compile in order to test (and find bugs that 
prevent it from compiling before that!) To build our new feature, let's go back to inside the
container:

```bash
$ ./mconfig
...

$ cd builddir/ && make
 CC src/runtime/c/lib/image/bind.c
 CC src/runtime/c/lib/image/dir_init.c
 CC src/runtime/c/lib/image/dir_mount.c
...
 AR lib/libruntime.a
 DEPENDS
 AR librpc.so
 GO singularity
# github.com/singularityware/singularity/src/pkg/build/provisioners
../src/pkg/build/provisioners/provisioner_shub.go:15:2: imported and not used: "io"
../src/pkg/build/provisioners/provisioner_shub.go:19:2: imported and not used: "path"
../src/pkg/build/provisioners/provisioner_shub.go:20:2: imported and not used: "path/filepath"
../src/pkg/build/provisioners/provisioner_shub.go:21:2: imported and not used: "strings"
../src/pkg/build/provisioners/provisioner_shub.go:116:11: undefined: types
../src/pkg/build/provisioners/provisioner_shub.go:118:11: undefined: types
Makefile:519: recipe for target 'singularity' failed
make: *** [singularity] Error 2
```

Woohoo, errors! I was overjoyed to see this, because I had figure out enough to get the
compiler chewing on my contribution. At this point you would:

<ol class="custom-counter">
  <li>Make changes to the files still on your local machine</li>
  <li>Re-run the sequence above until you get it right</li>
  <li>Then test an actual usage of your contribution (e.g., run singularity)</li>
</ol>

The line I used to cd out of the build directory, generate the makefile, and then 
cd back in turned out to be:

```bash
cd .. && ./mconfig && cd builddir && make dep && make && make install
```

and then I tested my feature (building from Singularity Hub) via:

```bash
$ root@0c5a31c18cea:/go/src/github.com/singularityware/singularity/builddir# singularity build /tmp/test.simg
INFO    [U=0,P=2242]       getManifest()                 www.singularity-hub...
INFO    [U=0,P=2242]       getManifest()                 {https    www.singu...
INFO    [U=0,P=2242]       getManifest()                 response: &{200 OK 200...
INFO    [U=0,P=2242]       getManifest()                 manifest: https://www...
INFO    [U=0,P=2242]       Provision()                   https://www.googleap...
INFO    [U=0,P=2242]       fetch()                       
Creating temporary image file /tmp/temp-shub-752751900/shub-container935023563
INFO    [U=0,P=2242]       unpackTmpfs()                 Here we need to unpack ...
Parallel mksquashfs: Using 4 processors
Creating 4.0 filesystem on /tmp/squashfs-724622510.img, block size 131072.
...
```

I'm fairly new to the world of GoLang, and the biggest change from Python is that I can't interactively debug.
For this reason, the printing of outputs above is essential, because I'm able to carefully walk through each step.

## Discussion
The feature isn't done yet, but the pull request <a href="https://github.com/bauerm97/singularity/pull/4" target='_blank'>in progress is here</a>
for all those interested! I was moved to write this today because I am having a lot of fun
working with <a href="https://github.com/bauerm97" target="_blank">@bauerm17</a> who is helping me
to learn and with this new feature. This brings us to our last bullet point that is a challenge
to contributing to open source:

> How hard is it to ask for help, and how quickly do I get a response?

The interaction between developers is the heart beat of our community. When communication
is good and we feel like we are working together, and having fun, does it really get any better than that?
I think this presents a pretty strong competitor for those YouTube frosting sessions. The jury
is still out on making cinnamon buns, though. :L) I definitely learned a lot with 
this bit of work, hope that I can polish up this feature to be included in Singularity 3.0 proper,
and I want to encourage you to contribute to the development of Singularity 3.0 too!
