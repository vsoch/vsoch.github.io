---
title: "Git Tricks"
date: 2019-04-08 11:30:00
---

I'm convinced that git is the greatest software of all time. Not only does it give
you tracking of changes for your files (version control) and a collaborative platform
for working on code, it also serves any kind of creative purpose that you can think of!
For example, I'm finishing up a tool called [watchme](https://www.github.com/vsoch/watchme) 
that uses git as a temporal database. I'm calling this "reproducible monitoring" - the 
user can configure a repository (called a watcher) to regularly run one or more tasks 
(using cron) and then save the organized results to a git repository, along with the configuration
parameters to run it in the first place. Although the repository might just (superficially) show
one result file at one timepoint, with git I can do some tricks to turn the repository
into a temporal database that can export results over time! This means saving a series
of git commits, dates, and result content. While I won't go into the details of watchme in this post 
(See the [documentation](https://vsoch.github.io/watchme) for details) I *do* want to 
review some of the awesome git commands that drive the watchme tool.

## Commits

A lot of indexing in git is based on commits. It follows that it would be super user to get an entire
list of commits, or commits after a particular index. Let's start with a simple way to get <strong>all the commits</strong>:

```bash
$ git log --all --oneline --pretty=tformat:"%H"
```

### Earliest and latest commits

What about if we wanted to get the <strong>earliest commit</strong>? That might look like this:

```bash
$ git rev-list --max-parents=0 HEAD
b74ae5368a7dd2d30efce0c009a2b10de2c0ddc1
```

And what about the <strong>latest commit</strong>?

```bash
$ git log -n 1 --pretty=format:"%H"
613a9eedaa1133fac6fd3325e5ed04e25d7bd025
```

### Range of commits

Finally, you can get a list of commits between some range.

```bash
$ git log --all --oneline --pretty=tformat:"%H" fcddec
d88839c5e5eaa17ae74abab93ec97511be..
613a9eedaa1133fac6fd3325e5ed04e25d7bd025
1c041af537ad4da901725e55aea63a4cbf497621
5cc829fcb47d4f7cb2ef5217171842e3c8c3c69f
75b688717d08d9364b93a4776d7f803b42cd0727
218a1f8c7f222f3b5479f2c2d868680947c88e03
25c26df2b5de776fd9347b47fdeaa34deb00b9b4
e77cef0da7db7e95fb80ce7fe301ab7b3cdf4ad3
```

I added formatting to remove extra text and format on one line with the full commit for the purpose that I
want to pipe this into other commands that just use the commit. You can of course [check out the documntation](https://git-scm.com/docs)
to see the gazillion and a half options and arguments and cheeznos that you can use to customize it for your need.

### Search commit messages

Okay this is the coolest function - you can search for commits with regular expressions (grep!). For example,
here is an (unfortunate) string that I use sometimes...

```bash
$ git log --all --oneline --pretty=tformat:"%H" --grep "oups"
8d7e5a20d16fe739726939d9050b8ba9cc8af397
```

Okay not too bad, only one "oups" in this particular repo. But I assure you that there
are others out there...


## Dates

What about dates? You can get the date of your last commit like this:

```bash
$ git show -s --format=%ci HEAD
2019-03-26 16:31:30 -0400
```

The last bit (-040) is the timezone offset. Don't believe it? Take a look at `git log` to verify (the one at the top):

```bash
$ git log
commit 613a9eedaa1133fac6fd3325e5ed04e25d7bd025
Author: Vanessa Sochat <vsochat@stanford.edu>
Date:   Tue Mar 26 16:31:30 2019 -0400

    updating post
```

If you want to look at a specific commit, just change HEAD to that commit. For example:

```bash
$ git show -s --format=%ci 75b688717d08d9364b93a4776d7f803b42cd0727
2019-03-25 13:17:47 -0400
```


## Export Content

This is the function that makes it possible to turn a tiny git repository into a temporal database,
and this drives the [export function](https://vsoch.github.io/watchme/getting-started/index.html#how-do-i-export-data) of the watchme tool.
Here is what that looks like. Seriously, this is so easy and simple it's going to be your favorite command!

```bash
# git show                                 <commit>:<filename>
$ git show 75b688717d08d9364b93a4776d7f803b42cd0727:Gemfile
source "https://rubygems.org"

#gem "rails"
gem 'github-pages'
gem 'jekyll'
```

Yep, it just splots it out into the terminal. You can do whatever you like with it.

## All Together Now!

First, I'll show you what an application can do to put these commands together. As an example with 
watchme, there is an easy way to export temporal data from a git repository. For each entry, there is a commit,
 a date, and then the content. The example below only shows two commits (entries). You can
tell that the task is set to run on the hour.

```bash
# watchme export <watcher>   <task>           <filename>
$ watchme export system task-memory vanessa-thinkpad-t460s_vanessa.json --json
```
```python
{
    "commits": [
        "02bccc9b0dbbd885125ae653fa5034dbf1d15eb4",
        "d98aaaae49c2c5106393beff5ebb51225eba8ac6",
        ...
    ],
    "dates": [
        "2019-04-07 15:00:02 -0400",
        "2019-04-07 14:00:02 -0400",
       ...
    ],
    "content": [
        {
            "virtual_memory": {
                "total": 20909223936,
                "available": 6038528000,
                "percent": 71.1,
                "used": 13836861440,
                "free": 201441280,
                "active": 16094294016,
                "inactive": 3581304832,
                "buffers": 3842781184,
                "cached": 3028140032,
                "shared": 736833536
            }
        },
        {
            "virtual_memory": {
                "total": 20909223936,
                "available": 6103392256,
                "percent": 70.8,
                "used": 13769531392,
                "free": 202334208,
                "active": 16014094336,
                "inactive": 3663310848,
                "buffers": 3859390464,
                "cached": 3077967872,
                "shared": 755183616
            }
        },
        ...
    ]
}
```

But let's walk through how you can do simple, fun things on the command line.

### Export List of Dates

Here is how you could export all the dates for your commits:

```bash
for commit in $(git log --all --oneline --pretty=tformat:"%H")
   do git show -s --format=%ci $commit
done

2019-04-08 11:00:02 -0400
2019-04-08 11:00:02 -0400
2019-04-08 11:00:02 -0400
...
```

### Export Temporal Data

Or you could do the same, but dump results for each (be careful doing this that
you don't overwrite data files.


```bash
mkdir -p history
for commit in $(git log --all --oneline --pretty=tformat:"%H")
   do git show $commit:README.md > history/$commit.txt
done
```
```bash
$ ls history/
0e153d64368a1f9ba55f4c406ae0b0dcd6e55a8f.txt
10dfc058c461152dc4588417a1ee1311423c8dd4.txt
1109ddd7d94051e1e3af3628b09ed2c30bc70696.txt
...
```

There you go! Your little git repo has now served as a database for (whatever your
special files happen to be) and you can go to town doing some analysis with them.


As another quick mention (and final note) a developer that I admire, [@cyphar](https://github.com/cyphar),
created a [nice demonstration](https://asciinema.org/a/Cfl6HLqYxpcUfRbBli6SbF5Gg) of how to 
rebase and squash commits. This was another thing that I wasn't aware was so easy 
to do on the command line. Thanks Aleksa!
