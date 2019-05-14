---
title: "Ubuntu Dependencies"
date: 2019-01-20 6:05:00
categories: rse
---

# Ubuntu Package Dependencies

I've always been obsessively interested in studying software, package managers,
version control, and and general coding practices. This means I've spent inordinate
numbers of weekend afternoons scraping Github, or trying to understand containers.
If you want to jump on the nerd train that I'm riding, today I created a tool for
you! I was using the [libraries.io](https://libraries.io/api) API to extract
dependencies for Pypi (Python package manager), and it hit me like a container
turd in the face that the service didn't provide an Apt endpoint (they call this
a platform).  Oh no!

## How do I figure out package dependencies?


It's actually fairly simple! You can use:

```bash

$ apt-cache depends <package>

```

For example, here is a common favorite:

```bash

$ apt-cache depends lolcat
lolcat
 |Depends: ruby
  Depends: <ruby-interpreter>
    jruby
  Depends: ruby-trollop
  Depends: ruby-paint

```

> Holy cow, I didn't know lolcat was implemented in Ruby!

See you learn new things! But there is a <italic>cache</italic> (see what I did there?). 
When I run this command on my host without doing an update first, or if I don't have the package,
I get something that looks like this:

```bash

$ apt-cache depends <package>
E: No packages found

```

I also realized that it would be near impossible to get package dependencies for
different versions of Ubuntu, or if I was using a different host all together!
To make this easier, I built containers to do it.

<br><br>


# Ubuntu Dependencies via Docker

We can build containers to do it! So that's what I've done. And if you are interested
in studying the package dependencies for some Apt package, you can do that! And I built
one per Ubuntu LTS (long term support) version since 12.04, so you can choose the base
that you desire:

<ol class="custom-counter">
 <li>vanessa/ubuntu-dependencies:12.04</li>
 <li>vanessa/ubuntu-dependencies:14.04</li>
 <li>vanessa/ubuntu-dependencies:16.04</li>
 <li>vanessa/ubuntu-dependencies:18.04</li>
</ol>

<br>

Here is using one of the containers to inspect lolcat again:

```bash

$ docker run -it vanessa/ubuntu-dependencies:16.04 lolcat
{"Depends": ["ruby", "<ruby-interpreter>", "jruby", "ruby-trollop", "ruby-paint"]}

```

Each one will take as input some Apt package, and output a json structure that will list
PreDepends, Depends, Conflicts, Replaces, and Suggests. If I forgot any, please
let me know so we can add them in.

The container works as I mentioned above - by first installing the package, 
and then using `apt-cache depends` to show the list of dependencies, 
which are parsed into json. For example, let's look at dependencies for bash across all versions of Ubuntu!
(Note that I've parsed the output to pretty json so you can read it)

### Ubuntu 12.04

```bash

$ docker run -it vanessa/ubuntu-dependencies:12.04 bash
{
  "Recommends": [
    "bash-completion"
  ],
  "PreDepends": [
    "dash",
    "libc6",
    "libtinfo5"
  ],
  "Suggests": [
    "bash-doc"
  ],
  "Depends": [
    "base-files",
    "debianutils",
    "debianutils:i386"
  ],
  "Replaces": [
    "bash-completion",
    "<bash-completion:i386>",
    "bash-doc",
    "<bash-doc:i386>"
  ],
  "Conflicts": [
    "bash-completion",
    "<bash-completion:i386>",
    "bash:i386"
  ]
}

```

### Ubuntu 14.04

```bash

$ docker run -it vanessa/ubuntu-dependencies:14.04 bash
{
  "Recommends": [
    "bash-completion"
  ],
  "PreDepends": [
    "dash",
    "libc6",
    "libtinfo5"
  ],
  "Suggests": [
    "bash-doc"
  ],
  "Depends": [
    "base-files",
    "debianutils"
  ],
  "Replaces": [
    "bash-completion",
    "bash-doc"
  ],
  "Conflicts": [
    "bash-completion"
  ]
}

```
```bash

$ docker run -it vanessa/ubuntu-dependencies:16.04 bash
{
  "Recommends": [
    "bash-completion"
  ],
  "PreDepends": [
    "dash",
    "libc6",
    "libtinfo5"
  ],
  "Suggests": [
    "bash-doc"
  ],
  "Depends": [
    "base-files",
    "debianutils"
  ],
  "Replaces": [
    "bash-completion",
    "bash-doc"
  ],
  "Conflicts": [
    "bash-completion"
  ]
}

```
```bash

$ docker run -it vanessa/ubuntu-dependencies:18.04 bash
{
  "Recommends": [
    "bash-completion"
  ],
  "PreDepends": [
    "libc6",
    "libtinfo5"
  ],
  "Suggests": [
    "bash-doc"
  ],
  "Depends": [
    "base-files",
    "debianutils"
  ],
  "Replaces": [
    "bash-completion",
    "bash-doc"
  ],
  "Conflicts": [
    "bash-completion"
  ]
}

```

For more details, see the [repository](https://github.com/vsoch/dockerfile-packages/tree/master/docker) 
that builds the containers, or the [containers](https://cloud.docker.com/repository/docker/vanessa/ubuntu-dependencies)
on Docker Hub. That's right, join me on this nerd train to obsessively 
study things that nobody else seems to be interested in!
