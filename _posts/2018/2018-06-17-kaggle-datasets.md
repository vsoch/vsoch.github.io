---
title: "Open Source Datasets with Kaggle"
date: 2018-06-17 5:26:00
toc: false
---

Data sharing is hard, but we all know that there is great potential for discovery and reward <a href="https://www.ncbi.nlm.nih.gov/pmc/articles/PMC5723929/" target="_blank">[1]</a>.
A typical "sharing operation" might look like passing around a portable drives, putting compressed archives on some university or cloud server,  or bulk
storing on a secure university cluster (and living in fear it will be purged). Is this an optimal approach? Is it easy enough to do? To answer this question, let's think about the journey that  one of our datasets might take. It looks like this:

```bash
1.               2.            3.            4.                 5.           6.
[generation] --> [process] --> [storage] --> [possible use] --> [upload] --> [shared]
```

This flow of events is often cyclical, because the generation of data is more of a stream, and the only
reason the data stops flowing from steps 1 to 6 is because we decide to stop collecting it. In the
most ideal scenario we would have these steps be totally automated. Step 1 might be generation
of images at the MRI scanner, step 2 might be automated scripts to convert the initial 
file format to the format the researcher desires, 3 is moving to private cluster storage,
4 is use by the research group, and then steps 5 and 6 (if they happen at all) are additional work
to again process and transfer the data to a shared location.

Typically, we stop at step 4, because that's where the lab is content, the analysis is done,
and papers are written. Ironically, it's steps 5 and 6 that would open up a potential firehose of discovery.
But the unspoken word is that if I share my dataset and you publish first, I lose out.
Data is akin to oranges that must be squeezed of all their juice before
giving up for others to inspect, so of course I wouldn't want to do it. But arguably, 
if sharing the dataset itself could produce a paper (or something similar),
and if steps 4 and 5 were easy, we would have a **lot** more data sharing. This is the topic
that I want to discuss today, and while there is no production solution available, I will show how
it's very easy to share your data as a <a href="https://www.kaggle.com/datasets" target="_blank">Kaggle Dataset</a>. 

## Living Data

I've talked about the idea of  <a href="https://vsoch.github.io///2017/reproducible-impossible/#evolution-of-data" target="_blank">living data</a> 
before, and in summary it's the idea that we can update our understanding of the world, the answer to some interesting question, 
as new data comes in. It's the idea that representation of knowledge as a static PDF isn't good enough because it only represents
one point in time. Instead, living data asserts that the knowledge we accumulate to confirm or deny hypotheses is a living and changing thing. 
In order to make this living and changing thing a reality, it needs to be easy to provide that feed. Right now, sharing data is a manual
afterthought of the publication process. Many journals now encourage or require it, and researchers can upload to various platforms
some single timepoint of the dataset. While this practice is better than nothing, I don't think that it is optimal for learning about the world.
Instead of a static article we should have a feed of data that goes into an algorithm and pops out a new answer. We would want the data
sharing to happen automatically as the data is produced, and available to all who want to study it. 
This is probably way too lofty a goal for now, but we can
imagine something in the middle of the two extremes. How about a simple pipeline to automatically generate and share a dataset?
It might look something like this:


```bash
1.               2.            3.                           
[generation] --> [process] --> [storage]    -->         ...     
                               [continuous integration] -->  [shared]
```

Steps 4 through 6 still happen (the researchers doing analyses) but instead of one group coveting the data, it's available
to thousands. The change is that we've added a helper, continuous integration, to step 3 to make it easy to process and share the data. 
We typically think of continuous integration (CI) for use in testing or deployment, but it also could be a valuable tool for data 
sharing. Let's just call this idea "continuous data," because that's sort of what it is. 
Once the data is processed and plopped onto storage for the research group, it also might
have this continuous data step that packages it up for sharing. <br>


# TLDR

We need to incentivize data sharing at the step of storage, and provide support for researchers to do this. 
Institutions must staff a missing layer of data engineers, and prioritize the development of organizational standards and tooling for this task. In the meantime,
small research computing groups can help researchers achieve this goal. Researchers should reach out to get help to share their datasets.


## Kaggle API

While a larger, institutional level effort would be ideal, in the meantime we can take advantage of open source, free to use resources 
<a href="https://www.kaggle.com" target="_blank">like Kaggle</a>. I think that Kaggle has potential to do what Github did for early scientific reproducibility.
If it's easy and fun to share datasets, and if there is potential reward, Kaggle can have an impact on scaled discovery and collaboration. But we have
to start somewhere! I decided to start with showing that I can use the <a href="https://github.com/Kaggle/kaggle-api" target="_blank">Kaggle API</a> 
to upload a dataset.  It's fairly easy to do in the web interface, and it's also easy to do from the commnd line. In a nutshell, 
all we need is a directory with data files and a metadata (json file) that 
we can point the API client to. For example, here is one of my datasets that I uploaded:

```bash

ls /tmp/tmp3559572b/
c.tar.gz    cs.tar.gz   cxx.tar.gz        f90.tar.gz   java.tar.gz  m.tar.gz    py.tar.gz   xml.tar.gz
cc.tar.gz   css.tar.gz  dat.tar.gz        go.tar.gz    js.tar.gz    map.tar.gz  r.tar.gz
cpp.tar.gz  csv.tar.gz  datapackage.json  html.tar.gz  json.tar.gz  md.tar.gz   txt.tar.gz
```

The `datapackage.json` just describes the content there that is being uploaded.

```bash

{
 "title": "Zenodo Code Images",
 "id": "stanfordcompute/code-images",
 "licenses": [
  {
   "name": "other"
  }
 ],
 "keywords": [
  "software",
  "languages"
 ],
 "resources": [
  {
   "path": "cs.tar.gz",
   "description": "cs.tar.gz, part of Zenodo Code Images Dataset, 6/2018, MIT License"
  },
  {
   "path": "m.tar.gz",
   "description": "m.tar.gz, part of Zenodo Code Images Dataset, 6/2018, MIT License"
  },
  {
   "path": "js.tar.gz",
   "description": "js.tar.gz, part of Zenodo Code Images Dataset, 6/2018, MIT License"
  },
...

  {
   "path": "cxx.tar.gz",
   "description": "cxx.tar.gz, part of Zenodo Code Images Dataset, 6/2018, MIT License"
  }
 ]
}


```

So how hard is it to share your datasets for others to use and discover? 
You download a <a href="https://github.com/Kaggle/kaggle-api#api-credentials" target="_blank">credential file</a>
to authenticate with the service.  Then you put files (.tar.gz or .csv) in a folder, create a json file, and point the tool at it. 
It is <strong>so</strong> easy, and you could practically do all these things without any extra help. It would be so trivial
to plug a script like this into some continuous integration to update a dataset as it is added to storage.


## Tools for You!

I put together a <a href="https://hub.docker.com/r/vanessa/kaggle/" target="_blank">Docker container</a> serving
a brief example <a href="https://github.com/vsoch/kaggle" target="_blank">here</a> that I used to interact with the 
Kaggle API and generate a few datasets. I'll walk through the basic logic of the scripts here. The `kaggle` command
line client does a good job on its own for many tasks, but as a developer, I wanted much more control over things like
specification of metadata and clean creation of files. I also wanted it Dockerized so that I could do a create operation mostly
isolated from my host.


### Build the container

The image is provided on <a href="https://hub.docker.com/r/vanessa/kaggle/" target="_blank">Docker Hub</a> but you
can always build it on your own:

```bash

docker build -t vanessa/kaggle .

```

I didn't expose the create script as an entrypoint because I wanted the interaction to be an interactive 
"shell into the container and understand what's going on." You can do that like this. 

```bash
docker run -v $HOME/.kaggle:/root/.kaggle -v $HOME/code-images:/tmp/data -it vanessa/kaggle bash
```

Notice that we are binding our kaggle API credentials to root's home so they are discovered by the client,
and we are also binding some directory with data files (for our dataset upload) by way of specifying volumes (`-v`):
The dataset in question is a <a href="https://vsoch.github.io/datasets" target="_blank">Dinosaur Dataset</a>
called <a href="https://vsoch.github.io/datasets/2018/zenodo/" target="_blank">Zenodo ML</a>, 
specifically a sample of the data that converts the numpy arrays to actual png
images. For those interested, the script I used to reorganize and generate the data
subset is <a href="https://github.com/vsoch/zenodo-ml/blob/master/preprocess/2.organize_by_language.py" target="_blank">
provided here</a>. The original rationale for doing this was because I simply couldn't share the entire
dinosaur dataset on Kaggle (too big!). My idea was that sharing a subset would be useful,
and those interested could then download the entire dataset. If you are interested, the finished dataset
<a href="https://www.kaggle.com/stanfordcompute/code-images" target="_blank">stanfordcompute/code-images is here</a>.


### Create a Dataset


The script <a target="_blank" href="https://github.com/vsoch/kaggle/blob/master/create_dataset.py">create_dataset.py</a> 
is located in the working directory you shell into, and the usage accepts the arguments you would expect to generate 
a dataset. You can run the script without arguments to see details,

```bash

$ python create_dataset.py 

```

And for this post, it's easier to just see an example. I had my data files (.tar.gz files) in `/tmp/data/ARCHIVE`,
so first I prepared a space separated list of fullpaths to them:

```bash

# Prepare a space separated list of fullpaths to data files
uploads=$(find /tmp/data/ARCHIVE -type f | paste -d -s)

# /tmp/data/ARCHIVE/cs.tar.gz /tmp/data/ARCHIVE/m.tar.gz /tmp/data/ARCHIVE/js.tar.gz /tmp/...

```

and I wanted to upload them to a new dataset called `vanessa/code-images`. My command would look like this:

```bash

python create_dataset.py --keywords software,languages \
                         --files "${uploads}" \
                         --title "Zenodo Code Images" \
                         --name "code-images" \
                         --username stanfordcompute

```

The arguments above are the following:

 - **keywords** comma separated list of keywords (no spaces!)
 - **files** full paths to the data files to upload
 - **title** the title to give the dataset (put in quotes if you have spaces)
 - **name** the name of the dataset itself (no spaces or special characters, and good practice to put in quotes)
 - **username** your kaggle username, or the name of an organization that the dataset will belong to

It will generate a temporary directory with a data package:

```bash
Data package template written to: /tmp/tmp3559572b/datapackage.json
```

And add your files to it, for example, here is how my temporary folder was filled:


```bash

$ ls /tmp/tmp3559572b/
c.tar.gz    css.tar.gz  datapackage.json  java.tar.gz  map.tar.gz  txt.tar.gz
cc.tar.gz   csv.tar.gz  f90.tar.gz        js.tar.gz    md.tar.gz   xml.tar.gz
cpp.tar.gz  cxx.tar.gz  go.tar.gz         json.tar.gz  py.tar.gz
cs.tar.gz   dat.tar.gz  html.tar.gz       m.tar.gz     r.tar.gz

```

In retrospect I didn't need to copy the files here too, but I did this because I don't
typically like to do any kind of operation on raw data (in case something goes awry).
The tool will then show you the metadata file (the one we have already shown above) and then
start the upload. This can take some time, and it will show a URL when finished! 

```bash

Starting upload for file cs.tar.gz
100%|███████████████████████████████████████| 49.3M/49.3M [01:13<00:00, 708kB/s]
Upload successful: cs.tar.gz (49MB)
Starting upload for file m.tar.gz
...
Upload successful: cxx.tar.gz (57MB)
The following URL will be available after processing (10-15 minutes)
https://www.kaggle.com/stanfordcompute/code-images

result
https://www.kaggle.com/stanfordcompute/code-images

```

Hugely important! There is some kind of post processing that happens, and this can take many additional hours
(it did for me given the size of my uploads). My dataset did not actually exist at the URL given until the following morning, and so
you should be patient. Until it's done you will get a 404. You can go for a run, or call it
a day. Since there is a lot of additional metadata and description / helpers needed on your
part for the dataset, it's recommended to go to the URL when it's available
and do things like add an image, description, examples, etc. The upload is done (by default with my tool)
as private so that the user can check things over before making public. Is this manual work? For the first upload,
yes, but subsequent versions of your dataset don't necessarily require it. It's also the case
that the tooling is growing and changing rapdily, and you should (likely) expect exciting changes!

## Vision for Reproducible Science

Institutions need to have data as a priority, and help researchers with the burden of managing their own data.
A researcher should be able to get support to organize their data, and then make it programmatically accessibility.
This must go beyond a kind of "archive" that is provided by a traditional library and delve into APIs, notifications,
and deployments or analyses triggers. While we don't have these production systems, it all starts with 
simple solutions to easily create and share datasets. The vision that I have
would have a strong relationship between where the compute happens (our research computing clusters) and where
the data is stored (and automatically shared via upload or API). It looks like this:

```bash

[generate data] --> [process / organize] -->  [storage]
                                              -->  [API access]                                                   
                                              -->  [Kaggle upload]                                                   
                                              -->  [notifications]  
```

Notifications can range anywhere from 1) going into a feed to alert another researcher of new
data, 2) triggering a CI job to re-upload from storage to a shared location, or 3) triggering a
build and deployment of a new version of some container that has the data as a dependency.

> We need data engineers

An institution needs to allocate resources and people that solely help researchers with data.
It shouldn't be the case that a new PI needs to start from scratch, every time, to set up his or
her lab to collect, organize, and then process data. The machines that collect data should collect
it and send it to a designated location based on a standard format.

> We need collaborative platforms

I believe that there is some future where researchers can collaborate on research together, leading to some
kind of publication, with data feeds provided by other researchers, via a collaborative platform. It feels like
a sort of "if you build it, they will come" scenario, and the interesting question is "Who will build it?" 

> Right now, our compute clusters are like the wild west!

Sure, we have local law enforcement to prevent unwanted cowboys from entering the wrong side of
the wild desert (file and directory permissions), but it's largely up to the various groups to decide how to organize
their files. As a result, we see the following:

<ol class="custom-counter">
  <li>We forget where things are</li>
  <li>We forget what things are</li>
  <li>Data and scripts used for papers gets lost and forgotten</li>
  <li>Every space looks different</li>
</ol>

We've all been here - we have some new dataset to work with, but we have run out of space, and so we 
email our research computing to ask why (Can I have more?) and then send an email out to our lab
to "clean up those files!" and then wind up deleting some set of data that (a few years earlier) we deemed as
highly important, but it can't be important anymore because "Ain't nobody got disk space for that."<br>

<div>
<img src="https://i.imgflip.com/2cimyw.jpg">
</div><br>


Imagine a new reality where the researchers themselves aren't totally responsible for the organization,
care, and metadata surrounding their data. They get to focus on doing science.
They get help from a data engineer to do this, and it's done
with a ridiculous amount of detail and concern for metadata that no normal human would have. 
The cost of <strong>not</strong> doing this is insurmountable wasted time losing and finding things,
not being able to reproduce work, or easily get from point <strong>[get data]</strong> to point <strong>[working with data]</strong>.


## Remaining Challenges

There are still several challenges that we need to think about.

> Where is the connection to academic publishing?

I'm going to focus on Kaggle because I haven't found a similar, successful platform for working on datasets together.
The feel that I get for Kaggle is one of "Let's have fun, learn, and do machine learning" or "Let's
compete in this competition for a prize." I see a graduate student wanting to try a competition in his or
her spare time to win something, or to learn and have fun, but not to further his or her research.
As I understand it now, Kaggle doesn't have a niche that the academic researcher fits into. But when
I think about it, "competition" isn't so different from "collaboration" in that many people are working 
at once to solve a similar problem. Both have questions that the challenge aims to answer, and metric(s)
that can be assessed to evaluate the goodness of a solution. The interesting thing here is that Kaggle, like Github,
is a relatively unbiased platform that we could choose to use in a different way. Academic researchers could choose
to make a "competition" that would actually encompass researchers working together to answer a scientific question.
The missing piece is having some additional rules and tooling around giving particpants and data providers 
avenues to publish and get credit for their contributions. 

If we want to create incentive to share data and thus drive discovery, we need to address this missing
incentive piece. It should be the case that a graduate student or researcher can further his or her career 
by using a platform like Kaggle. It should be easy, and it should be fun. Let's imagine if a competition wasn't a competition at
all, but in fact a collaboration. A graduate student would go to his or her PI, say "Hey I found this Kaggle
dataset that is trying to solve a similar problem, why don't I try this method there?" The PI would
be OK with that because it would be the same as the student solving the problem independently, but with
a leg up having some data preprocessing handled, and others to discuss the challenge with. The graduate
student would enter his or her kernel entry to (still) optimize some metric(s), and efforts 
would be automatically summarized into some kind of publication that parallels a paper. 
The peer review would be tied into these steps, as the work would be completely open.
All those who contributed, from creating the initial dataset, to submission to discussing solutions, would
be given credit as having taken part in the publication. If it's done right, the questions themselves would
also be organized, conceptually, so we can start mapping the space of hypotheses.

> How can we start to get a handle on all these methods?

Methods are like containers. Currently in most papers, they aren't substantial to reproduce the work.
It would also be hard to derive a complete ontology of methods and their links to functions from text alone (yes, I
actually started this as a graduate school project, and long since abandoned it in favor of projects that my 
committeees would deem "meaningful".) But given that we have code, arguably the methods could be automatically derived
(and possibly even linked to the documentation sources). Can I imagine a day when the code is so close
to the publication that we drastically cut down the time needed to spend on a methods section? Or
the day when a methods section actually can reproduce the work because it's provided in a container? Yep.

> What about sensitive information in data?

Taking care for removing sensitive information goes without saying. This is something that is scary to think about, 
especially in this day and age when it seems like there is no longer any such thing as privacy. Any data sharing initiative or pipelines must
take privacy and (if necessary) protocol for deidentification (and similar) into account.

> Where is the incentive for the institution?

This is an even harder question. How would an institution get incentive to put funding into
people and resources just for data? From what I've seen, years and years go by and people make committees
and talk about things. Maybe this is what needs to happen, but it's hard to be sitting in Silicon Valley
and watch companies skip over the small talk and just get it done. Maybe it's not perfect the first time,
but it's a lot easier to shape a pot once you have the clay spinning.

## Summary

These are my thoughts on this for now! We don't have a perfect solution, but we have ways to share our
data to allow for others to discover. I have hopes that the team at Kaggle will get a head start
on thinking about incentives for researchers, and this will make it easy for software engineers in academia
to then help the researchers share their data. These are the steps I would take:

<ol class="custom-counter">
  <li>Create simple tool / example to share data (this post)</li>
  <li>Create incentive for sharing of academic datasets (Collaborative, open source publications?)</li>
  <li>Support a culture for academics to share, and do some test cases</li>
  <li>Have research software engineers help researchers!</li>
</ol>

And then tada! We have open source, collaborative sharing of datasets, and publication. Speaking of the last point,
if you are a researcher with a cool dataset (even if it's messy) and you want help to share it, please 
<a href="https://www.github.com/vsoch/datasets/issues" target="_blank">reach out</a> and I will help you. IF you
have some ideas or thinking on how we can do a toy example of the above, I hope you reach out too.

Are you interested in a dataset to better understand software? Check out the 
<a href="https://www.kaggle.com/stanfordcompute/code-images" target="_blank">Code Images<a> Kaggle Dataset that
can help to do that. If you use the dataset, here is a reference for it:

[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.1286417.svg)](https://doi.org/10.5281/zenodo.1286417)
