---
title: "Python Environments, A User Guide"
date: 2016-10-18 9:00:00
---

Do you want to run Python? I can help you out! This documentation is specific to the `farmshare2` cluster at Stanford, on which there are several versions on python available. The python convention is that python v2 is called 'python', and python v3 is called 'python3'. They are not directly compatible, and in fact can be thought of as entirely different software. 

{% include toc.html %}

## How do I know which python I'm calling?
Like most Linux software, when you issue a command to execute some software, you have a variable called `$PATH` that loads the first executable it finds with that name. The same is true for `python` and `python3`. Let's take a look at some of the defaults:

<pre>
<code>
# What python executable is found first?
rice05:~> which python
/usr/bin/python

# What version of python is this?
rice05:~> python --version
Python 2.7.12

# And what about python3?
rice05:~> which python3
/usr/bin/python3

# And python3 version
rice05:~> python3 --version
Python 3.5.2
</code>
</pre>

This is great, but what if you want to use a different version? As a reminder, most clusters like Farmshare2 come with packages, modules, and can also be installed with your custom software ([here's a refresher](https://srcc.stanford.edu/farmshare2/software) if you need it). Let's talk about the different options for extending the provided environments, or creating your own environment. So, what to do when the default python doesn't fit your needs? You have many choices:

1. **Install to a User Library** if you want to continue using a provided python, but add a module of your choice to a personal library
2. **Install a conda environment** if you need standard scientific software modules, and don't want the hassle of compiling and installing them.
3. **Create a virtual environment** if you want more control over the version and modules

<br>

## 1. Install to a User Library
The reason that you can't install to the shared `python` or `python3` is because you don't have access to the `site-packages` folder, which is where the modules are looked for automatically by python. But don't despair! You can install to your (very own) `site-packages` by simply appending the `--user` argument to the install command. For example:

<pre>
<code>
# Install the pokemon-ascii package
pip install pokemon --user

# Where did it install to?
rice05:~> python
Python 2.7.12 (default, Jul  1 2016, 15:12:24) 
[GCC 5.4.0 20160609] on linux2
Type "help", "copyright", "credits" or "license" for more information.
>>> import pokemon
>>> pokemon.__file__
'/home/vsochat/.local/lib/python2.7/site-packages/pokemon/__init__.pyc'
</code>
</pre>

As you can see above, your `--user` packages install to a site packages folder for the python version under `.local/lib`. You can always peek into this folder to see what you have installed.

<pre>
<code>
rice05:~> ls $HOME/.local/lib/python2.7/site-packages/
nibabel			 pokemon		      virtualenv.py
nibabel-2.1.0.dist-info  pokemon-0.32.dist-info       virtualenv.pyc
nisext			 virtualenv-15.0.3.dist-info  virtualenv_support
</code>
</pre>

You probably now have two questions.

1. How does python know to look here, and 
2. How do I check what other folders are being checked?

<br>

### How does Python find modules?
You can look at the `sys.path` variable, a list of paths on your machine, to see where Python is going to look for modules:

<pre>
<code>
rice05:~> python
Python 2.7.12 (default, Jul  1 2016, 15:12:24) 
[GCC 5.4.0 20160609] on linux2
Type "help", "copyright", "credits" or "license" for more information.
>>> import sys
>>> sys.path
['', '/usr/lib/python2.7', '/usr/lib/python2.7/plat-x86_64-linux-gnu', '/usr/lib/python2.7/lib-tk', '/usr/lib/python2.7/lib-old', '/usr/lib/python2.7/lib-dynload', '/home/vsochat/.local/lib/python2.7/site-packages', '/usr/local/lib/python2.7/dist-packages', '/usr/lib/python2.7/dist-packages']
</code>
</pre>

Above we can see that the system libraries are loaded before local, so if you install a module to your user folder, it's going to be loaded after. Did you notice that the first entry is an empty string? This means that your present working directory will be searched first. If you have a file called `pokemon.py` in this directory and then you do `import pokemon`, it's going to use the file in the present working directory.

### How can I dynamically change the paths?
The fact that these paths are stored in a variable means that you can dynamically add / tweak paths in your scripts. For example, when I fire up `python3` and load numpy, it uses the first path found in `sys.path`:

<pre>
<code>
>>> import numpy
>>> numpy.__path__
['/usr/lib/python3/dist-packages/numpy']
</code>
</pre>

And I can change this behavior by removing or appending paths to this list before importing. Additionally, you can add paths to the environmental variable `$PYTHONPATH` to add folders with modules (read about [PYTHONPATH](https://docs.python.org/2/using/cmdline.html#envvar-PYTHONPATH) here). First you add the variable to the path:

<pre>
<code>
# Here is setting an environment variable with csh
rice05:~> setenv PYTHONPATH /home/vsochat:$PYTHONPATH

# And here with bash
rice05:~> export PYTHONPATH=/home/vsochat:$PYTHONPATH

# Did it work?
rice05:~> echo $PYTHONPATH
/home/vsochat
</code>
</pre>

Now when we run python, we see the path has been appended to the beginning of `sys.path`:

<pre>
<code>
rice05:~> python
Python 2.7.12 (default, Jul  1 2016, 15:12:24) 
[GCC 5.4.0 20160609] on linux2
Type "help", "copyright", "credits" or "license" for more information.
>>> import sys
>>> sys.path
['', '/home/vsochat', '/usr/lib/python2.7', '/usr/lib/python2.7/plat-x86_64-linux-gnu', '/usr/lib/python2.7/lib-tk', '/usr/lib/python2.7/lib-old', '/usr/lib/python2.7/lib-dynload', '/home/vsochat/.local/lib/python2.7/site-packages', '/usr/local/lib/python2.7/dist-packages', '/usr/lib/python2.7/dist-packages']
</code>
</pre>

Awesome!

### How do I see more information about my modules?
You can look to see if a module has a `__version__`, a `__path__`, or a `__file__`, each of which will tell you details that you might need for debugging. Keep in mind that not every module has a version defined.

<pre>
<code>
rice05:~> python
Python 2.7.12 (default, Jul  1 2016, 15:12:24) 
[GCC 5.4.0 20160609] on linux2
Type "help", "copyright", "credits" or "license" for more information.
>>> import numpy
>>> numpy.__version__
'1.11.0'
>>> numpy.__file__
'/usr/lib/python2.7/dist-packages/numpy/__init__.pyc'
>>> numpy.__path__
['/usr/lib/python2.7/dist-packages/numpy']
>>> numpy.__dict__
</code>
</pre>

If you are really desperate for seeing what functions the module has available, take a look at (for example, for numpy) `numpy.__dict__.keys()`. While this doesn't work on the cluster, if you load a module in iPython you can press TAB to autocomplete for available options, and add a single or double `_` to see the hidden ones like `__path__`.

### How do I ensure that my package manager is up to date?
We've hit a conundrum! How does one "pip install pip"? And further, how do we ensure we are using the pip version associated with the currently active python? The same way that you would upgrade any other module, using the `--upgrade` flag:

<pre>
<code>
rice05:~> python -m pip install --user --upgrade pip
rice05:~> python -m pip install --user --upgrade virtualenv
</code>
</pre>

And note that you can do this for virtual environments (`virtualenv`) as well.


## 2. Install a conda environment
There are a core set of scientific software modules that are quite annoying to install, and this is where anaconda and miniconda come in. These are packaged virtual environments that you can easily install with pre-compiled versions of all your favorite modules (numpy, scikit-learn, pandas, matplotlib, etc.). We are going to be following instructions from the [miniconda installation](http://conda.pydata.org/docs/install/quick.html#linux-miniconda-install) documentation. Generally we are going to do the following:

- Download the installer
- Run it to install, and install to our home folder
- (optional) add it to our path
- Install additional modules with conda

First get the installer from [here](http://conda.pydata.org/miniconda.html), and you can use `wget` to download the file to your home folder:
<pre>
<code>
rice05:~> cd $HOME
rice05:~> wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh

# Make it executable
rice05:~> chmod u+x Miniconda3-latest-Linux-x86_64.sh 
</code>
</pre>

Then run it! If you do it without any command line arguments, it's going to ask you to agree to the license, and then interactively specify installation parameters. The easiest thing to do is skip this, using the `-b` parameter will automatically agree and install to `miniconda3` in your home directory:

<pre>
<code>
rice05:~> ./Miniconda3-latest-Linux-x86_64.sh -b
PREFIX=/home/vsochat/miniconda3
...
(installation continues here)
</code>
</pre>

If you want to add the miniconda to your path, meaning that it will be loaded in preference to all other pythons, then you can add it to your .profile:

<pre>
<code>
echo "export PATH=$HOME/miniconda3/bin:$PATH >> $HOME/.profile"
</code>
</pre>

Then source your profile to make the python path active, or log in and out of the terminal to do the same:

<pre>
<code>
source /home/vsochat/.profile
</code>
</pre>

Finally, to install additional modules to your miniconda environment, you can use either conda (for pre-compiled binaries) or the pip that comes installed with the miniconda environment (in the case that the conda package managed doesn't include it).

<pre>
<code>
# Scikit learn is included in the conda package manager
/home/vsochat/miniconda3/bin/conda install -y scikit-learn

# Pokemon ascii is not
/home/vsochat/miniconda3/bin/pip install pokemon
</code>
</pre>


## 3. Install a virtual environment
If you don't want the bells and whistles that come with anaconda or miniconda, then you probably should go for a virtual environment. The [Hitchhiker's Guide to Python](http://docs.python-guide.org/en/latest/dev/virtualenvs/) has a great introduction, and we will go through the steps here as well. First, let's make sure we have the most up to date version for our current python:

<pre>
<code>
rice05:~> python -m pip install --user --upgrade virtualenv
</code>
</pre>

Since we are installing this to our user (`.local`) folder, we need to make sure the bin (with executables for the install) is on our path, because it usually won't be:

<pre>
<code>
# Ruhroh!
rice05:~/myproject> which virtualenv
virtualenv: Command not found.

# That's ok, we know where it is!
rice05:~/myproject> export PATH=/home/vsochat/.local/bin:$PATH

# (and for csh)
rice05:~/myproject> setenv PATH /home/vsochat/.local/bin:$PATH

# Did we add it?
rice05:~/myproject> which virtualenv
/home/vsochat/.local/bin/virtualenv
</code>
</pre>

You can also add this to your `$HOME/.profile` if you want it sourced each time.

Now we can make and use virtual environments! It is as simple as creating it, and activating it:

<pre>
<code>
rice05:~>mkdir myproject
rice05:~>cd myproject
rice05:~/myproject> virtualenv venv
New python executable in /home/vsochat/myproject/venv/bin/python
Installing setuptools, pip, wheel...done.
rice05:~/myproject> ls
venv
</code>
</pre>

To activate our environment, we use the executable `activate` in the bin provided. If you take a look at the files in `bin`, there is an activate file for each kind of shell, and there is also the executables for `python` and the package manager `pip`:

<pre>
<code>
rice05:~/myproject> ls venv/bin/
activate       activate_this.py  pip	 python     python-config
activate.csh   easy_install	 pip2	 python2    wheel
activate.fish  easy_install-2.7  pip2.7  python2.7
</code>
</pre>

Here is how we would active for csh:

<pre>
<code>
rice05:~/myproject> source venv/bin/activate.csh 
[venv] rice05:~/myproject> 
</code>
</pre>

Notice any changes? The name of the active virutal environment is added to the terminal prompt! Now if we look at the python and pip versions running, we see we are in our virtual environment:

<pre>
<code>
[venv] rice05:~/myproject> which python
/home/vsochat/myproject/venv/bin/python
[venv] rice05:~/myproject> which pip
/home/vsochat/myproject/venv/bin/pip
</code>
</pre>

Again, you can add the source command to your `$HOME/.profile` if you want it to be loaded automatically on login. From here you can move forward with using `python setup.py install` (for local module files) and `pip install MODULE` to install software to your virtual environment.

To exit from your environment, just type `deactivate`:

<pre>
<code>
[venv] rice05:~/myproject> deactivate
rice05:~/myproject>
</code>
</pre>

**PROTIP**
You can specify commands to your virtualenv creation to include the system site packages in your environment. This is useful for modules like numpy that require compilation (lib/blas, anyone?) that you don't want to deal with:

<pre>
<code>
rice05:~/myproject> virtualenv venv --system-site-packages
</code>
</pre>


## Reproducible Practices
Whether you are a researcher or a software engineer, you are going to run into the issue of wanting to share your code, and someone on a different cluster running it. The best solution is to container-ize everything, and for this we recommend using [Singularity](https://singularityware.github.io). However, let's say that you've been a bit disorganized, and you want to quickly capture your current python environment either for a [requirements.txt](https://pip.pypa.io/en/stable/user_guide/#requirements-files) file, or for a [container configuration](http://singularity.lbl.gov/bootstrap-image#post)? If you just want to glance and get a "human readable" version, then you can do:

<pre>
<code>
rice05:~> pip list
biopython (1.66)
decorator (4.0.6)
gbp (0.7.2)
nibabel (2.1.0)
numpy (1.11.0)
pip (8.1.2)
pokemon (0.32)
Pyste (0.9.10)
python-dateutil (2.4.2)
reportlab (3.3.0)
scipy (0.18.1)
setuptools (28.0.0)
six (1.10.0)
virtualenv (15.0.1)
wheel (0.29.0)
</code>
</pre>

If you want your software printed in the format that will populate the `requirement.txt` file, then you want:

<pre>
<code>
rice05:~> pip freeze
biopython==1.66
decorator==4.0.6
gbp==0.7.2
nibabel==2.1.0
numpy==1.11.0
pokemon==0.32
Pyste==0.9.10
python-dateutil==2.4.2
reportlab==3.3.0
scipy==0.18.1
six==1.10.0
virtualenv==15.0.1
</code>
</pre>

And you can print this right to file:

<pre>
<code>
# Write to new file
rice05:~> pip freeze > requirements.txt

# Append to file
rice05:~> pip freeze >> requirements.txt
</code>
</pre>
