---
title: "Learning GoLang"
date: 2018-02-02 5:41:00
---


<div>
<img src="/assets/images/posts/learning-go/gophercises_jumping.gif" style="float:left" title="Gophercises.com">
</div><br><br>

Learning a new programming language is magic. Since it's such a rare experience, I want to document it. This post is about a ridiculous thing I have in the works, "Salad Fork!"

<br><br>
<a target="_blank" href="https://gophercises.com">gophercises.com</a><br>
<br><br><br><br>

# What motivates someone to learn?
There is a huge catalyst needed to start the chemical reaction of "Want to learn an entire new language!" This catalyst is our underlying motivation that powers us through tricky bugs and sometimes not getting the answer right away. The worst motivation would probably be needing to learn it because it's required for your job, because then you have added expectation. My most common catalyst is seeing repeatedly awesome things that **I must** figure out how to do too. I will immediately fall in love with any language that looks beautiful when rendered in a simple text editor (e.g., gedit is my main other than vim). Here is some goLang in gedit:

<img src="/assets/images/posts/learning-go/gedit.png" style="float:left; width:100%" title="Gophercises.com">

It's beautiful. I could stare that that all day. And I do :)


# How do I learn a new programming language?
I don't learn well from guides or tutorials, because I'm not usually interested in what they are trying to do. I only can get heavily invested when I have a very specific (typically useless) goal of making something fun. This goal determines how I start. For example, this last week one of my colleagues made a <a href="https://www.github.com/GodLoveD/salad" target="_blank">repository</a> called "salad" with nothing written in the README other than something akin to, "If your fork this repo you have a salad." It was brilliant. I had to create something silly and lovely to match it. 

My idea? A command line generator of forks paired with puns. With this goal, I knew I needed to start with a command line client of some flavor. And here we start the journey! If you don't care about the journey, then just check out the <a href="https://www.github.com/vsoch/salad" target="_blank">work in progress [WIP}</a>. There is much more to come, and I have to figure it out as I go (ha, pun!).

## Learning Go
This post reflects only a few days of work, and some on an airplane drifting in and out of sleep. None of it is likely to be wisdom, and I'd bet some is just wrong. It's purpose is to reflect on my learning. I will also note that before this small project, I had done the simple things to install Go and run the hello world example, although I never delved into anything challenging because I haven't found "my motivating project."

### Day One
On day one of my motivating project, most of GoLang looked like Perl (or any other language that I haven't done for 10+ years), and maybe I could readily identify for-loops and if statements. The first 30 minutes or so was spent after a dinner, and browsing through other Go repositories. I finally found a simple entry point example script from <a href="https://github.com/gogits/gogs" target="_blank">gogs</a> and used that as a template. That's a good piece of wisdom,


> Use a simple example as a template to start. First customize, then extend it.

From this simple method I created an (almost equivalent) entry point, but with my own functions. My first finished script, which I also created a Dockerfile for, was one executable called <a href="https://github.com/vsoch/salad/commit/8a135df2cc12192cf6094f403dd16bdd60ae9afc" target="_blank">fork.go</a>, and it included all the functions to select a fork and a pun randomly. The first version <a href="https://asciinema.org/a/159960" target="_blank">looked like this</a>.

### Day Two

#### Including Data
One interesting thing I learned is that package data is more challenging to implement. There is no guarantee the executable will be in the same relative spot, unlike python that maintains it's nice little structure in `site-packages`.

As a work around, I think there are packages that compile the data into the binary. I decided to just create the data (in my case, ascii of forks and spoons, and lists of puns) as structures included in the scripts to be compiled. This seems reasonable for most applications. If something like scientific data is used, it's likely to be something like genomic or brain imaging and would be provided by the user. If it's small enough, it's reasonable to be packaged with the binary. We only run into trouble if we need to include something huge. I bet there are other strategies like creating a predictible application cache, and downloading there on install.

#### Package Names
I had no idea how the scripts in any given folder related to one another, or what they compiled into. I observed that there can be any number of "go" scripts in the top level folder, and the line at the top that declares a package, if it's the one called "main," tells us that script is the executable entry point. The rest of the files must be named according to the repository name. For example, 

```
 /github.com/vsoch/salad
                   salad.go
                   fork.go
```

Let's say that the above `salad.go` has the top line say `package main` - this tells us it's the entrypoint to the application. Since the repository folder is `salad` we would put all other scripts in the `salad` namespace (`package salad`). But on the other hand, if we import a subfolder, we are actually more likely creating a new package.

#### Imports
There are some standard imports that I see a lot (e.g., `os`,`string` and `fmt`) and the rest are assumed to be folders again installed at `$GOPATH`. To install a new package you type `go get` and I would bet doing a `go install` against a script will (along with compiling the package) download other packages that you don't have. I like how the mapping from the repository to the package name and repository is pretty seamless.

The other cool thing about this is that we can thus have **subfolders** in our repository that we add the includes that are, each in themself, akin to submodules in Python. For example:

```
import (
	"os"
	"github.com/urfave/cli"
	"github.com/vsoch/salad/cmd"
	"github.com/vsoch/salad/config"
)
```

The folders "cmd" and "config" are nice organized folders that are for each of package `cmd` and `config`, and just happen to live with the package `salad`. In the same way that the top level folder is called salad and the package and main file are called salad, this is also the case with cmd and config.

#### Strictness
I was terribly sad to learn that Go doesn't like my four spaces over tab. When I format my data, the delimiter of choice is tab:

```
go fmt salad.go
```

I think I can live with this. There are some other checks that are done that, while they ensure better programming, I feel like a lot of developers will just come up with hacks to silence them. For example:

```
if color != "" {
	if val, ok := colors[color]; ok {
		return colors[color]
	}
}
```

I was OK with this, and without an error on compile I would have left it. I was checking if an argument was an empty string, and if it wasn't, I was checking to see if it was a key in the colors map (a map is a dictionary, for all those Python users). If ok evaluates to true, then ok evaluates to true, and the val is the value. Go got angry at me that I didn't use it. So then I thought "well, then I'll use it! And I'll put it nowhere." I did this:

```
	if color != "" {
		if val, ok := colors[color]; ok {
			return colors[color]
		} else {
                        _ = val // declared and not used error
                }
	}
```

But then I had the (obvious) epiphany, "Why didn't I just put it nowhere to begin with?" Derp. I tried this:


```
if color != "" {
        if _, ok := colors[color]; ok {
                return colors[color]
        }
}
```

Hey, I think I just wrote nicer code! I'm learning stuff, woot! Using the simple algorithm of 1. Want to do something, and 2. Hack around until I figured it out, I was able to add different modules for each of fork and spoon, colors, and a simple command line parsing of arguments (largely done by a nice package). Next, I think I'm going to make it serve a simple utensil pun API, because I've heard that is one of the strengths of the language. Here it is!

{% include asciicast.html source='salad-fork-2-02-2018.json' title='Salad Fork' author='vsochat@stanford.edu' %}

## After Day 2
I largely still have no idea what is going on, but I'm starting to recognize patterns. The more I look at scripts with Go, the more I'm able to understand what things mean, and understand the logic of a particular design that I find. The most magical of moments (which can take anywhere from 6 months to 5 years) happens when I can just open up a text editor, start typing, and it's akin to writing this post. I can't say when I'll get there, but I'll have fun on the journey! h

Time to work on other things, don't forget your Salad Fork, friends!
