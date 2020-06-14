---
title: "Data Containers"
date: 2020-06-14 12:30:00
---

Back in 2016, there was discussion and excitement for data containers.
Two recent developments have told me that now is the time to address this once
more:

<ul class="custom-counter">
  <li>The <a target="_blank" href="https://iximiuz.com/en/posts/not-every-container-has-an-operating-system-inside">knowledge</a> that  containers don't necessary need an operating system.</li>
  <li>The ability to create a container from scratch supported by Singularity (pull request <a href="https://github.com/hpcng/singularity-userdocs/pull/328">here</a>.</li>
</ul>

<br>

I was also invited to speak at <a href="https://projects.iq.harvard.edu/dcm2020/people/vanessa-sochat" target="_blank">dataverse</a> and thought it would be a great opportunity to get people
thinking again about data containers. I had less than a week to throw something together, but with
a little bit of thinking and testing, this last week and weekend I have a skeleton,
duct-taped together, preliminary cool idea to get us started! You can continue
reading below, or jump to read the <a href="https://vsoch.github.io/cdb" target="_blank">container database</a>
site for detailed examples.

## What are the needs of a data container?

Before I could build a data container, I wanted to decide what would be important for it
to have, or generally be. I decided to take a really simple perspective. Although I could
think about runtime optimization, for my starting use case I wanted to be asap - as simple
as possible! If we think of a "normal" container as providing a base
operating system to support libraries, small data files, and ultimately running
scientific software, 

<div style="padding:20px">
<img src="https://raw.githubusercontent.com/vsoch/vsoch.github.io/master/assets/images/posts/data-container/regular-container.png">
</div>

then we might define a data container as:

> a container without an operating system optimized for understanding and interacting with data

<div style="padding:20px">
<img src="https://raw.githubusercontent.com/vsoch/vsoch.github.io/master/assets/images/posts/data-container/data-container.png">
</div>

That's right, remove the operating system and all the other cruft, and just provide the data!
With this basic idea, I started by creating a <a href="https://github.com/singularityhub/data-container/tree/master/devel/docker" target="_blank">data-container</a> repository to play around with some ideas. I knew that I wanted:

<ul class="custom-counter">
  <li>a container without an operating system</li>
  <li>an ability to interact with the container on its own to query the data (metadata)</li>
  <li>an ability to mount it via an orchestrator to interact with the data</li>
  <li>flexibility to customize the data extraction, interaction, metadata.</li>
</ul>

<br>

If we need to interact with the data still, although we won't have an operating system,
we'll need some kind of binary in there.

### How do we develop something new?

I tend to develop things with baby steps, starting with the most simple example
and slowly increasing in complexity. If you look at the <a href="https://github.com/singularityhub/data-container/tree/master/devel/docker" target="_blank">data-container</a> repository, you'll likely be able to follow my thinking.

<br>

**hello world**

I started by building a hello world binary on the host (in Golang) and then adding it to a scratch container as an entrypoint.  These basic commands I'll show once - they are generally the same for the following tests that I did.
This is how we compile a GoLang script on my host.

```bash
GOOS=linux GOARCH=amd64 go build -ldflags="-w -s" -o hello
```

Here is how we add it to a container, and specify it to be the entrypoint.

```

FROM scratch
COPY hello /
CMD ["/hello"]

```

And then here is how we build and run the container. It prints a hello world message. Awesome!

```

$ docker build -f Dockerfile.hello -t hello .
$ docker run --rm hello
Hello from OS-less container (Go edition)

```

<br>

**sleep**

The next creation was a "sleep" type entrypoint that I could
use with a "docker-compose.yml" file to bring up the container with another, and bind 
(and interact with) the data. Running the container on it's own would
leave your terminal hanging, but with a "docker-compose.yml" it would keep
the container running as a service, and of course share any data volumes you
need with other containers.

<br>

**in memory database**

Once that was working, I took it a step further and used
an <a href="https://github.com/vsoch/containerdb" target="_blank">in-memory</a> database to add
some key value pair, and then print it to the terminal. After this worked it was smooth sailing,
because I'd just need to create an entrypoint binary that would generate this database
for some custom dataset, and then build it into a container. I wanted to create 
a library optimized for generating the entrypoint.

## How do we generate it?

Great! At this point I had a simple approach that I wanted to take: to create a executable with an in-memory database to query a dataset. The binary, along with the data, would be added to an "empty" (scratch) container.
I started a library <a href="https://github.com/vsoch/cdb" target="_blank">cdb</a> (and 
documentation <a href="https://vsoch.github.io/cdb" target="_blank">here</a>) that would
be exclusively for this task. Since Python is the bread and butter
language for much of scientific programming (and would be easier for a scientist to use) I decided
to implement this metadata-extraction, entrypoint-generation tool using it. Let's walk
through the generation steps.

### Entrypoint

Adding data to a scratch base is fairly trivial - it's the entrypoint that will provide
the power to interact with the data. Given that we have a tool (cdb) that takes a database folder
(a set of folders and files) and generates a script to compile:

```bash
# container database generate from the "data" folder and output the file "entrypoint.go"
$ cdb generate /data --out /entrypoint.go
```

We can create a multi-stage build that will handle all steps from metadata generation, to golang
compile, to generation of the final data container. If you remember from above, we had originally
compiled our testing Go binaries on our host. We don't need to do that, or even to install the cdb
tool, because it can be done with a multi-stage build. We will use the follow stages:

<ul class="custom-counter">
  <li><strong>Stage 1</strong> We install <a href="https://github.com/vsoch/cdb" target="_blank">cdb</a> to generate a GoLang template for an <a href="https://github.com/vsoch/containerdb" target="_blank">in-memory database</a>.</li>
  <li><strong>Stage 2</strong> We compile the binary into an entrypoint</li>
  <li><strong>Stage 3</strong> We add the data and the binary entrypoint to a scratch container (no operating system).</li>
</ul>

<br>

In stage 1, both the function for extraction and the template for the binary can be customized.
The default will generate an entrypoint that creates the in-memory database, creates indices on 
metadata values, and then allows the user to search, order by, or otherwise list contents. The
default function produces metadata with a file size and hash.

```python

import os
from cdb.utils.file import get_file_hash


def basic(filename):
    """Given a filename, return a dictionary with basic metadata about it
    """
    st = os.stat(filename)
    return {"size": st.st_size, "sha256": get_file_hash(filename)}

```

You can imagine writing a custom function to use any kind of filesystem organization (e.g., BIDS via <a href="https://github.com/bids-standard/pybids" target="_blank">pybids</a>) or
other standard (e.g., schema.org) to handle the metadata part. I will hopefully
be able to make some time to work on these examples. We'd basically just provide
our custom function to the cdb executable, or even interact from within Python.
Before I get lost in details, let's refocus on our simple example, and take a look at this multi-stage build. Someone has likely done this before, it's just really simple!

### The Dockerfile

Let's break the dockerfile down into it's components. This first section will install
the `cdb` software, add the data, and generate a GoLang script to compile, which will generate an in-memory database.

<br>

**stage 1**
```

FROM bitnami/minideb:stretch as generator
ENV PATH /opt/conda/bin:${PATH}
ENV LANG C.UTF-8
RUN /bin/bash -c "install_packages wget git ca-certificates && \
    wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh && \
    bash Miniconda3-latest-Linux-x86_64.sh -b -p /opt/conda && \
    rm Miniconda3-latest-Linux-x86_64.sh"

# install cdb (update version if needed)
RUN pip install cdb==0.0.1

# Add the data to /data (you can change this)
WORKDIR /data
COPY ./data .
RUN cdb generate /data --out /entrypoint.go

```

<br>

**stage 2**

Next we want to build that file, `entrypoint.go`, and also carry the data forward:

```

FROM golang:1.13-alpine3.10 as builder
COPY --from=generator /entrypoint.go /entrypoint.go
COPY --from=generator /data /data

# Dependencies
RUN apk add git && \
    go get github.com/vsoch/containerdb && \
    GOOS=linux GOARCH=amd64 go build -ldflags="-w -s" -o /entrypoint -i /entrypoint.go

```

<br>

**stage 3**

Finally, we want to add just the executable and data to a scratch container 
(meaning it doesn't have an operating system)

```

FROM scratch
LABEL MAINTAINER @vsoch
COPY --from=builder /data /data
COPY --from=builder /entrypoint /entrypoint

ENTRYPOINT ["/entrypoint"]

```

And that's it!  Take a look at the entire <a href="https://github.com/vsoch/cdb/tree/master/examples/docker-simple/Dockerfile" target="_blank">Dockerfile</a> if you are interested, or a more 
verbose <a href="https://vsoch.github.io/cdb/tutorial/docker-simple-data-container/" target="_blank">tutorial</a>.

### Building

We have our Dockerfile that will handle all the work for us, let's build the data container!

```bash
$ docker build -t data-container .
```

### Single Container Interaction

We then can interact with it in the following ways (remember this can be customized if you
use a different template):

<br>

**metadata**

If we just run the container, we get a listing of all metadata alongside the key.

```bash

$ docker run data-container
/data/avocado.txt {"size": 9, "sha256": "327bf8231c9572ecdfdc53473319699e7b8e6a98adf0f383ff6be5b46094aba4"}
/data/tomato.txt {"size": 8, "sha256": "3b7721618a86990a3a90f9fa5744d15812954fba6bb21ebf5b5b66ad78cf5816"}

```

<br>

**list** 

We can also just list data files with `-ls`

```bash

$ docker run data-container -ls
/data/avocado.txt
/data/tomato.txt

```

<br>

**orderby**

Or we can list ordered by one of the metadata items:

```bash

$ docker run data-container -metric size
Order by size
/data/tomato.txt: {"size": 8, "sha256": "3b7721618a86990a3a90f9fa5744d15812954fba6bb21ebf5b5b66ad78cf5816"}
/data/avocado.txt: {"size": 9, "sha256": "327bf8231c9572ecdfdc53473319699e7b8e6a98adf0f383ff6be5b46094aba4"}

```

<br>

**search**

Or search for a specific metric based on value.

```bash

$ docker run data-container -metric size -search 8
/data/tomato.txt 8

$ docker run entrypoint -metric sha256 -search 8
/data/avocado.txt 327bf8231c9572ecdfdc53473319699e7b8e6a98adf0f383ff6be5b46094aba4
/data/tomato.txt 3b7721618a86990a3a90f9fa5744d15812954fba6bb21ebf5b5b66ad78cf5816

```

<br>

**get**

Or we can get a particular file metadata by it's name:

```bash

$ docker run data-container -get /data/avocado.txt
/data/avocado.txt {"size": 9, "sha256": "327bf8231c9572ecdfdc53473319699e7b8e6a98adf0f383ff6be5b46094aba4"}

```

or a partial match:

```bash

$ docker run data-container -get /data/
/data/avocado.txt {"size": 9, "sha256": "327bf8231c9572ecdfdc53473319699e7b8e6a98adf0f383ff6be5b46094aba4"}
/data/tomato.txt {"size": 8, "sha256": "3b7721618a86990a3a90f9fa5744d15812954fba6bb21ebf5b5b66ad78cf5816"}

```

<br>


**start**

The start command is intended to keep the container running, if we are using
it with an orchestrator.

```bash
$ docker run data-container -start
```

<br>

### Orchestration

It's more likely that we want to interact with files in the container via
some analysis, or more generally, another container. Let's put together
a quick `docker-compose.yml` to do exactly that.

```

version: "3"
services:
  base:
    restart: always
    image: busybox
    entrypoint: ["tail", "-f", "/dev/null"]
    volumes:
      - data-volume:/data

  data:
    restart: always
    image: data-container
    command: ["-start"]
    volumes:
      - data-volume:/data

volumes:
  data-volume:

```

Notice that the command for the data-container to start is `-start`, which
is important to keep it running. After building our `data-container`, we can then bring these containers up:


```bash

$ docker-compose up -d
Starting docker-simple_base_1   ... done
Recreating docker-simple_data_1 ... done

```
```bash

$ docker-compose ps
        Name                Command         State   Ports
---------------------------------------------------------
docker-simple_base_1   tail -f /dev/null    Up           
docker-simple_data_1   /entrypoint -start   Up           

```

We can then shell inside and see our data!

```bash

$ docker exec -it docker-simple_base_1 sh
/ # ls /data/
avocado.txt  tomato.txt

```

The metadata is still available for query by interacting with the data-container
entrypoint:

```bash

$ docker exec docker-simple_data_1 /entrypoint -ls
/data/avocado.txt
/data/tomato.txt

```

Depending on your use case, you could easily make this available inside the
other container.

<br>

## Why should I care?

I want you to get excited about data containers. I want you to
think about how such a container could be optimized for some organization of 
data that you care about. I also want you to possibly get angry, and exclaim,
"Dinosaur, you did this all wrong!" and then promptly go and start working on
your own thing. The start that I've documented here and put together this weekend
is incredibly simple - we build a small data container to query and
show metadata for two files, and then bind that data to another orchestration
setup. Can you imagine a data container optimized for exposing and running workflows?
Or one that is intended for being stored in a data registry? Or how about something
that smells more like a "results" container that you share, and have others run
the container (possibly with their own private data bound to the host) and then
write a result file into an organized namespace? I can imagine all of these things! 

I believe the idea is powerful because we are able to keep data and 
interact with it without needing an operating system. Yes, you can have your data
and eat it too!

<div style="padding:20px">
<img src="https://raw.githubusercontent.com/vsoch/cdb/master/docs/assets/img/logo/logo.png">
</div>

Combined with other metadata or data organizational standards, this could be
a really cool approach to develop data containers optimized to interact
with a particular file structure or workflow. How will that work in particular?
It's really up to you! The `cdb` software can take custom functions
for generation of metadata and templates for generating the GoLang script
to compile, so the possibilities are very open.

## What are next steps

I'd like to create examples for some real world datasets. Right now, the library
extracts metadata on the level of the file, and I also want to allow
for extraction on the level of the dataset. And I want you to be a part of this!
Please [contribute](https://github.com/vsoch/cdb) to the effort or view the
<a href="https://vsoch.github.io/cdb" target="_blank">container database</a>
site for detailed examples! I'll be slowly adding examples as I create them.
