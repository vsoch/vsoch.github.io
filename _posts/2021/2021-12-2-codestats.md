---
title: "Codestats"
date: 2021-12-02 10:30:00
category: rse
---

I love any opportunity to create a project in Go, so when I saw the <a href="https://github.com/bloodorangeio/oci-stats" target="_blank">bloodorangeio/oci-stats</a> tool, I was inspired! This project uses bash scripts and a Makefile to generate basic health stats for a repository, or basically a record of health files like a Contributing markdown or particular continuous integration recipe. If you have a lot of repos you want to quickly check for common community files presence or absence, it can be a useful tool. I liked the idea and wanted to do something similar,
but provide a library in Go that is generalizable to different repository metrics, and that could easily be piped into an interactive interface.
Note that this isn't a hugely innovative idea, because many people have made these kinds of tools before. This is just a bit of dinosaur fun!

<div style="padding:20px">
  <img src="https://raw.githubusercontent.com/vsoch/codestats/main/docs/codestats-entry.png">
</div>

If you don't care about the process, skip it and just ⭐️ <a href="https://vsoch.github.io/codestats/" target="_blank">check out the interface</a> ⭐️.
It's fairly simple with Bootstrap, Jquery Datatables, and a custom font, and I imagine could be styled much better.

## Codestats

Thus, <a href="https://github.com/vsoch/codestats" target="_blank">vsoch/codestats</a> was born! I always have little pet projects to work
on in evenings and weekends, and this became my interest for the last week or so. For codestats, I wanted to accomplish the following:

<ol class="custom-counter">
  <li>Provide a repository or organization to parse.</li>
  <li>Pair that with a set of metrics, where each metric is some action you can run on the root of a repository</li>
  <li>Extract either single repos or an entire org set to a json structure that renders into an interface.</li>
</ol>

Given that the library provides a pre-determined set of metrics, the user should have the choice to filter down to a custom set, or
(if there is need to add a new metric) to <a href="https://github.com/vsoch/codestats/issues" target="_blank">open an issue</a> and let me know!
Right now the tests are written into the code, but I could totally see adding an ability to specify a custom test in the optional config yaml
for the library.

### How does it work?

Well, first you want to clone and build the library. You'll need Go on your path!

```bash
$ git clone https://github.com/vsoch/codestats
$ cd codestats
$ make
```

This will place an executable, `codestats` that you can interact with. Then, here are examples
for how to run extractions. When we add --outfile that will save to the json file you specify, otherwise
we print to the console.

```bash

# Extract stats for the repository buildsi/build-abi-containers
$ ./codestats repo buildsi/build-abi-containers

# Do the same, but save to a file
$ ./codestats repo buildsi/build-abi-containers --outfile examples/repo.json


# Do the same, but pretty print to the screen (and run with go directly)
$ go run main.go repo buildsi/build-abi-containers --pretty

# Extract stats for an organization on GitHub
$ ./codestats org buildsi

build-notes
build-si-modeling
Smeagle
build-abi-tests
build-abi-containers
build-sandbox
...

# Only include those that match a pattern
$ ./codestats org buildsi --pattern build-abi-containers --pretty


# or again, save to output file:

$ ./codestats org buildsi --outfile examples/org.json
```

What if you want a custom set? You can generate a yaml file with the identifiers
that you want:

```yaml
# List of stats to include
stats:
- has-codeowners
- has-maintainers
- has-github-actions
- has-circle
- has-travis
- has-pull-approve
- has-glide
- has-code-of-conduct
- has-contributing
- has-authors
- has-pull-request-template
- has-issue-template
- has-support
- has-funding
- has-security```
```

I originally had camel case above to match Go, but realized this was way too hard to remember which to capitalize
and opted for the above. Once we have this file, we hand it over to the command!

```bash
$ ./codestats repo buildsi/build-abi-containers --config examples/all-stats.yaml 

# I also created one for GitHub "health files"
$ ./codestats repo buildsi/build-abi-containers --config examples/health-stats.yaml
```

The result of these commands is always a json file, and in a consistent format to include
a list of repositories. Now the next step would be to make this data easy to serach!


### Web Interface

I decided to generate a set for the <a href="https://github.com/spack" target="_blank">spack</a> organization, but not including
spack-search because it's a monster in size. And I tested on the vsoch set, which are a set of files that I think important
for open source projects (although not necessarily spack!). To do this I added a "vsoch-stats.yaml" file to the repository examples:

```bash
$ ./codestats org spack --skip spack-search --outfile examples/spack.json --config examples/vsoch-stats.yaml 
```

<div style="padding:20px">
  <img src="https://raw.githubusercontent.com/vsoch/codestats/main/docs/codestats.png">
</div>

And this is how I generated <a href="https://github.com/vsoch/codestats/blob/main/docs/data.json" target="_blank">this data</a> that renders into the <a href="https://vsoch.github.io/codestats" target="_blank">example interface</a>. As a reminder - a red entry doesn't always indicate bad - for some of these files, they may just not be appropriate for the organization type. For example, spack (shown at the top) could never have a funding.yaml file. But this is one of my vsoch metrics because I think it's good to support
open source maintainers.  

Pretty neat, huh? It uses Jquery Datatables to provide a searchable table, and you can also sort by columns or search within a column.
Since one repository can span multiple rows, I also added header rows (for only the case when the table is sorted by the repository name),
and a summary table at the very top.

### Questions?

So what else would you like to see? Additional stats or interface support? Please <a href="https://github.com/vsoch/codestats/issues" target="_blank">open an issue</a> and let me know! And thanks for stopping by!
