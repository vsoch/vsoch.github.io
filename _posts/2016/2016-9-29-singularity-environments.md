---
title: "Contained Environments for Software for HPC"
date: 2016-9-29 6:41:00
category: hpc
---

I was recently interested in doing what most research groups do, setting up a computational environment that would contain version controlled software, and easy ways for users in a group to load it. There are several strategies you can take. Let's first talk about those.

## Strategies for running software on HCP

### Use the system default
Yes, your home folder is located on some kind of server with an OS, and whether RHEL, CentOS, Ubuntu, or something else, it likely comes with, for example, standard python. However, you probably don't have any kind of root access, so a standard install (let's say we are installing the module `pokemon`) like any of the following won't work:

```
# If you have the module source code, with a setup.py
python setup.py install

# Install from package manager, pip
pip install pokemon

# use easy_install
easy_install pokemon
```

Each of the commands above would attempt to install to the system python (something like `/usr/local/lib/pythonX.X/site-packages/`) and then you would get a permission denied error.

```
OSError: [Errno 13] Permission denied: '/usr/local/lib/python2.7/dist-packages/pokemon-0.1-py2.7.egg/EGG-INFO/entry_points.txt'
```

Yes, each of the commands above needs a sudo, and you aren't sudo, so you can go home and cry about it. Or you can install to a local library with something like this:

```
# Install from package manager, pip, but specify as user
pip install pokemon --user
```

I won't go into details, but you could also specify a --prefix to be some folder you can write to, and then add that folder to your `PYTHONPATH`. This works, but it's not ideal for a few reasons:

- if you need to capture or package your environment for sharing, you would have a hard time.
- on your `$HOME` folder, it's likely not accessible by your labmates. This is redundant, and you can't be sure that if they run something, they will be using the same versions of software.

Thus, what are some other options?


### Use a virtual environment
Python has a fantastic thing called virtual environments, or more commonly seen as `venv`. It's actually a package that you install, create an environment for your project, and activate it:

```
# Install the package
pip install virtualenv --user
virtualenv myvenv
```

There are also ones that come prepackaged with scientific software that (normally) are quite annoying to compile like <a href="https://www.continuum.io/downloads" target="_blank">anaconda</a> and <a href="http://conda.pydata.org/miniconda.html" target="_blank">miniconda</a> (he's a MINI conda! :D). And then you would install and do stuff, and your dependencies would be captured in that environment. More details and instructions can be found <a href="http://docs.python-guide.org/en/latest/dev/virtualenvs/" target="_blank">here.</a> What are problems with this approach?

- It's still REALLY redundant for each user to maintain different virtual environments
- Personally, I just forget which one is active, and then do stupid things.

For all of the above, you could use `pip freeze` to generate a list of packages and versions for some requirements.txt file, or to save with your analysis for documentation sake:

```
pip freeze >> requirements.txt

# Inside looks like this
adium-theme-ubuntu==0.3.4
altgraph==0.12
amqp==1.4.7
aniso8601==1.1.0
anyjson==0.3.3
apptools==4.4.0
apt-xapian-index==0.45
arrow==0.7.0
artbrain==1.0.0
...
xtermcolor==1.3
zonemap==0.0.5
zope.interface==4.0.5
```


### Use a module
Most clusters now use <a href="http://modules.sourceforge.net/" target="_blank">modules</a> to manage versions of software and environments. What it comes down to is running a command like this:

```
# What versions of python are available?
module spider python

Rebuilding cache, please wait ... (written to file) done.

----------------------------------------------------------------------------
  python:
----------------------------------------------------------------------------
     Versions:
        python/2.7.5
        python/3.3.2

----------------------------------------------------------------------------
  For detailed information about a specific "python" module (including how to load the modules) use the module's full name.
  For example:

     $ module spider python/3.3.2
----------------------------------------------------------------------------
```

Nice! Let's load 2.7.5. I'm old school.

```
module load python/2.7.5
```

What basically happens, behind the scenes, is that there is a file written in a language called <a href="https://www.lua.org/" target="_blank">lua</a> that adds folders to the beginning of your path with the particular path to the software, and possibly maps the locations as well. We can use the module software to show us this code:

```
# Show me the lua!
module show python/2.7.5

----------------------------------------------------------------------------
   /share/sw/modules/Core/python/2.7.5:
----------------------------------------------------------------------------
conflict("python")
whatis("Provides Python 2.7.5 ")
prepend_path("version","2.7.5")
prepend_path("MANPATH","/opt/rh/python27/root/usr/share/man")
prepend_path("X_SCLS","python27")
prepend_path("LD_LIBRARY_PATH","/opt/rh/python27/root/usr/lib64")
prepend_path("LIBRARY_PATH","/opt/rh/python27/root/usr/lib64")
prepend_path("PATH","/opt/rh/python27/root/usr/bin")
prepend_path("XDG_DATA_DIRS","/opt/rh/python27/root/usr/share")
prepend_path("PKG_CONFIG_PATH","/opt/rh/python27/root/usr/lib64/pkgconfig")
prepend_path("PYTHON_INCLUDE_PATH","/opt/rh/python27/root/usr/include/python2.7")
prepend_path("CPATH","/opt/rh/python27/root/usr/include/python2.7/")
prepend_path("CPATH","/opt/rh/python27/root/usr/lib64/python2.7/site-packages/numpy/core/include/")
help([[ This module provides support for the
        Python 2.7.5 via Redhat Software Collections.
]])
```

I won't get into the hairy details, but this basically shows that we are adding paths (managed by an administrator) to give us access to a different version of python. This helps with versioning, but what problems do we run into?

- We still have to install additional packages using --user
- We don't have control over any of the software configuration, we have to ask the admin
- This is specific to one research cluster, who knows if the python/2.7.5 is the same on another one. Or if it exists at all.

Again, it would work, but it's not great. What else can we do? Well, we could try to use some kind of virtual machine... oh wait we are on a login node with no root access, nevermind. Let's think through what we would want.


## An ideal software environment
Ideally, I want all my group members to have access to it. My pokemon module version should be the same as yours. I also want total control of it. I want to be able to install whatever packages I want, and configure however I want. The first logical thing we know is that whatever we come up with, it probably is going to live in a group shared space. It also then might be handy to have equivalent lua files to load our environments, although I'll tell you off the bat I haven't done this yet. When I was contemplating this for my lab, I decided to try something new.


## Singularity for contained software environments
### A little about Singularity
We will be using <a href="https://singularityware.github.io">Singularity</a> containers that don't require root privileges to run on the cluster for our environments. Further, we are going to "bootstrap" Docker images so we don't have to start from nothing! You can think of this like packaging an entire software suite (for example, python) into a container that you can then run as an executable:

      $ ./python3 
      Python 3.5.2 (default, Aug 31 2016, 03:01:41) 
      [GCC 4.9.2] on linux
      Type "help", "copyright", "credits" or "license" for more information.
      >>> 

Even the environment gets carried through! Try this:

      import os
      os.environ["HOME"]


We are soon to release a new version of <a href="https://singularityware.github.io" target="_blank">Singularity</a>, and one of the simple features that I've been developing is an ability to immediately convert a Docker image into a Singularity image. <a href="https://github.com/singularityware/docker2singularity" target="_blank">The first iteration</a> relied upon using the Docker Engine, but the new <a href="https://singularityware.github.io/bootstrap-image" target="_blank">bootstrap</a> does not. Because... I (finally) figured out the Docker API after <a href="http://vsoch.github.io/2016/dockerapi/" target="_blank">many struggles</a>, and the bootstrapping (basically starting with a Docker image as base for a Singularity image) is done using the API, sans need for the Docker engine.

As I was thinking about making a miniconda environment in a shared space for my lab, I realized - why am I not using Singularity? This is one of the main use cases, but no one seems to be doing it yet (at least as determined by the Google Group and Slack). This was my goal - to make contained environments for software (like Python) that my lab can add to their path, and use the image as an executable equivalently to calling python. The software itself, and all of the dependencies and installed modules are included inside, so if I want a truly reproducible analysis, I can just share the image. If I can't handle about ~1GB to share, I can minimally share the file to create it, called the definition file. Let's walk through the steps to do this. Or if you want, skip this entirely and just look at the <a href="https://github.com/radinformatics/singularity-environments" target="_blank">example repo</a>.

## Singularity Environments
The basic idea is that we can generate "base" software environments for labs to use on research clusters. The general workflow is as follows:


 1. On your local machine (or an environment with sudo) build the contained environment
 2. Transfer the contained environment to your cluster
 3. Add the executable to your path, or create an alias.


We will first be reviewing the basic steps for building and deploying the environments. 

### Step 0. Setup and customize one or more environments
You will first want to clone the repository, or if you want to modify and save your definitions, fork and then clone the fork first. Here is the basic clone:

```
      git clone https://www.github.com/radinformatics/singularity-environments
      cd singularity-environments
```

You can then move right into building one or more containers, or optionally [customize environments first](CUSTOM.md).


### Step 1. Build the Contained Environment

First, you should use the provided <a href="https://github.com/radinformatics/singularity-environments/blob/master/build.sh" target="_blank">build script</a> to generate an executable for your environment:

```
      ./build.sh python3.def
```

The build script is really simple - it just grabs the size (if provided), checks the number of arguments, and then creates and image and runs bootstrap (note in the future this operation will likely be one step):

```
#!/bin/bash

# Check that the user has supplied at least one argument
if (( "$#" < 1 )); then
    echo "Usage: build.sh [image].def [options]\n"
    echo "Example:\n"
    echo "       build.sh python.def --size 786"
    exit 1
fi

def=$1

# Pop off the image name
shift

# If there are more args
if [ "$#" -eq 0 ]; then
    args="--size 1024*1024B"
else
    args="$@"
fi

# Continue if the image is found
if [ -f "$def" ]; then

    # The name of the image is the definition file minus extension
    imagefile=`echo "${def%%.*}"`
    echo "Creating $imagefile using $def..."
    sudo singularity create $args $imagefile
    sudo singularity bootstrap $imagefile $def
fi
```

Note that the only two commands you really need are:

```
sudo singularity create $args $imagefile
sudo singularity bootstrap $imagefile $def
```

I mostly made the build script because I was lazy. This will generate a python3 executable in the present working directory. If you want to change the size of the container, or add any custom arguments to the <a href="https://singularityware.github.io/docs-bootstrap" target="_blank">Singularity bootstrap</a> command, you can add them after your image name:

```
      ./build.sh python3.def --size 786
```

Note that the maximum size, if not specified, is 1024*1024BMiB. The python3.def file will need the default size to work, otherwise you run out of room and get an error. This is also true for R (r-base), which I used `--size 4096` to work. That R, it's a honkin' package!

### Step 2. Transfer the contained environment to your cluster

You are likely familiar with FTP, or hopefully your cluster uses a secure file transfer (sFTP). You can also use a command line tool <a href="https://www.garron.me/en/articles/scp.html" target="_blank">scp</a>. For the Sherlock cluster at Stanford, since I use Linux (Ubuntu), my preference is for <a href="http://www.howtogeek.com/howto/ubuntu/install-and-use-the-gftp-client-on-ubuntu-linux" target="_blank">gftp</a>.

### Step 3. Add the executable to your path

Let's say we are working with a `python3` image, and we want this executable to be called before the `python3` that is installed on our cluster. We need to either add this `python3` to our path (BEFORE the old one) or create an alias. 


#### Add to your path
You likely want to add this to your `.bash_profile`, `.profile`, or `.bashrc`:

```
      mkdir $HOME/env
      cd $HOME/env
      # (and you would transfer or move your python3 here)
```

Now add to your .bashrc:

```
      echo "PATH=$HOME/env:$PATH; export PATH;" >> $HOME/.bashrc
```
  

#### Create an alias
This will vary for different kinds of shells, but for bash you can typically do:

```
      alias aliasname='commands'

      # Here is for our python3 image
      alias python3='/home/vsochat/env/python3'
```


For both of the above, you should test to make sure you are getting the right one when you type `python3`:

```
      which python3
      /home/vsochat/env/python3
```


The definition files in this base directory are for base (not hugey modified) environments. But wait, what if you want to customize your environments?

## I want to customize my environments (before build)!

The definition files can be modified before you create the environments! First, let's talk a little about this Singularity definition file that we use to bootstrap.

### A little about the definition file
Okay, so this folder is filled with *.def files, and they are used to create these "executable environments." What gives? Let's take a look quickly at a definition file:

```
      Bootstrap: docker
      From: python:3.5

      %runscript
      
          /usr/local/bin/python


      %post

          apt-get update
          apt-get install -y vim
          mkdir -p /scratch
          mkdir -p /local-scratch
```

The first two lines might look (sort of) familiar, because "From" is a Dockerfile spec. Let's talk about each:

- Bootstrap: is telling Singularity what kind of Build it wants to use. You could actually put some other kind of operating system here, and then you would need to provide a Mirror URL to download it. The "docker" argument tells Singularity we want to use the guts of a particular Docker image. Which one?
- From: is the argument that tells Singularity bootstrap "from this image." 
- runscript: is the one (or more) commands that are run when someone uses the container as an executable. In this case, since we want to use the python 3.5 that is installed in the Docker container, we have the executable call that path.
- post: is a bunch of commands that you want run once ("post" bootstrap), and thus this is where we do things like install additional software or packages.

### Making changes
It follows logically that if you want to install additional software, do it in post! For example, you could add a `pip install [something]`, and since the container is already bootstrapped from the Docker image, pip should be on the path. For example, here is how I would look around the container via python:

```
      ./python3 
      Python 3.5.2 (default, Aug 31 2016, 03:01:41) 
      [GCC 4.9.2] on linux
      Type "help", "copyright", "credits" or "license" for more information.
      >>> import os
      >>> os.system('pip --version')
      pip 8.1.2 from /usr/local/lib/python3.5/site-packages (python 3.5)
      0
      >>> 
```
 
or using the Singularity shell command to bypass the runscript (/usr/local/bin/python) and just poke around the guts of the container:

```
      $ singularity shell python3
      Singularity: Invoking an interactive shell within container...

      Singularity.python3> which pip
      /usr/local/bin/pip
```

If you would like any additional docs on how to do things, please <a href="https://github.com/radinformatics/singularity-environments/issues" target="_blank">post an issue</a> or just comment on this post. I'm still in the process of thinking about how to best build and leverage these environments.


## I want to customize my environments! (after build)

Let's say you have an environment (node6, for example), and you want to install a package with npm (which is located at /usr/local/bin/npm), but then when you run the image:

```
      ./node6
```

it takes you right into the node terminal. What gives? How do you do it? You use the Singularity shell, with write mode, and we first want to move the image back to our local machine, because we don't have sudo on our cluster. We then want to use the writable option:


```
      sudo singularity shell --writable node6
      Singularity: Invoking an interactive shell within container...

      Singularity.node6> 
```

Then we can make our changes, and move the image back onto the cluster.


## A Cool Example
The coolest example I've gotten working so far is using <a href="https://www.tensorflow.org/" target="_blank">Google's TensorFlow</a> (the basic version without GPU - testing that next!) via a container. Here is the basic workflow:

```
./build tensorflow.def --size 4096

....

# building... building...

./tensorflow
Python 2.7.6 (default, Jun 22 2015, 17:58:13) 
[GCC 4.8.2] on linux2
Type "help", "copyright", "credits" or "license" for more information.
>>> import tensorflow
>>>
```

Ok, cool! That takes us into the python installed in the image (with tensorflow), and I could run stuff interactively here. What I first tried was the "test" example, to see if it worked:

```
singularity shell tensorflow
python -m tensorflow.models.image.mnist.convolutional
```

Note that you can achieve this functionality without shelling into the image if you specify that the image should take command line arguments, something like this in the definition file:

```
exec /usr/local/bin/python "$@"
```

and then run like this!

```
./tensorflow -m tensorflow.models.image.mnist.convolutional
Extracting data/train-images-idx3-ubyte.gz
Extracting data/train-labels-idx1-ubyte.gz
Extracting data/t10k-images-idx3-ubyte.gz
Extracting data/t10k-labels-idx1-ubyte.gz
Initialized!
Step 0 (epoch 0.00), 6.6 ms
Minibatch loss: 12.054, learning rate: 0.010000
Minibatch error: 90.6%
Validation error: 84.6%
...
```

Another added feature, done specifically when I realized that there are different Docker registries, is an ability to specify the Registry and to use a Token (or not):

```
Bootstrap: docker
From: tensorflow/tensorflow:latest
IncludeCmd: yes
Registry: gcr.io
Token: no
```


## Final Words
Note that this software is under development, I think the trendy way to say that is "bleeding edge," and heck, I came up with this idea and wrote all this code most of yesterday, and so this is just an initial example to encourage others to give this a try. We don't (yet) have a hub to store all these images, so in the meantime if you make environments, or learn something interesting, please share! I'll definitely be adding more soon, and customizing the ones I've started for my lab.
