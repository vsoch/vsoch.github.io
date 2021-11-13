---
title: "Post Label Container"
date: 2021-11-13 10:30:00
category: rse
---

I had a simple need recently. I wanted to install a bunch of software in a container,
discover information or metadata, and then label the container with it. I also wanted to build
it across a few architectures. Okay, that made it slightly less than simple! Why would I want to do this?
Because of being able to inspect the config of a container (e.g., see <a href="https://crane.ggcr.dev/config/ghcr.io/buildsi/spack-ubuntu-18.04:latest@sha256:01f0fe7f5ed2b67daca4036332b395acf2bbf0db8514ce921293a822ec1c8b66" target="_blank">this config</a>).
With this strategy I could <a href="https://twitter.com/vsoch/status/1458850314166030343" target="_blank">generate matrices of builds for a container</a> based on its contents without needing to pull it.

## Too long didn't read

See the repository <a href="https://github.com/vsoch/post-label-container" target="_blank">vsoch/post-build-container</a> for
how I went about doing this. There are two example workflows - one is a "simple" approach that is intended for one architecture (and seems to work reliably and quickly) and the second attempts to build multiple for different arches, and the speed of that I've seen vary. For this approach I used buildx and a strategy to re-build and label only on push to main, and might try something else better suited to your needs. You also can derive build args (that might feed into environment variables too). I just happened to want labels!

## How does it work?

This is fairly simple, so I don't need a very long post! You basically start with a Dockerfile of
interest. In my case I used <a href="https://github.com/vsoch/post-label-container/blob/main/Dockerfile" target="_blank">spack</a>
 as a dummy example, because it's pretty handy for research around package managers or
 generally scientific software. Okay - so let's say that this is a container base that I want to be able to inspect, and easily discover compilers or packages inside to do more interesting things with. I can do that with labels as we <a href="https://crane.ggcr.dev/config/ghcr.io/buildsi/spack-ubuntu-18.04:latest@sha256:01f0fe7f5ed2b67daca4036332b395acf2bbf0db8514ce921293a822ec1c8b66" target="_blank">saw above</a>,
but how do those labels get there? It's a bit of a catch-22 because you need the labels before the build, but the labels are derived during 
the build.
 
### Build, Label, Build, Deploy!

The solution is that ☝️!


#### Build

We first build the container, that might look like this:

```bash
$ docker build -t the-container .
```

#### Label

Then we might issue some special command to extract a label we want. In the case of spack:

```bash
$ docker run -i --rm the-container spack compiler list --flat > compilers.txt
```
Note that "--flat" is a special flag I have added to a personal branch of spack, and it does
not exist in spack proper. Yes, we probably don't need to dump it into a file, but I find this
easier to do. We then generate our labels environment variable, and save for the next step:

```bash
labels=$(echo $(tr '\r\n' ',' < compilers.txt))
labels="org.spack.compilers=${labels}"
printf "Saving compiler labels ${labels}\n"         
echo "compiler_labels=${labels}" >> $GITHUB_ENV
```

#### Build

And now for the cool part! We now just simply create a new Dockerfile, and build from the image
we just created *and* add the labels.

```bash
$ echo "FROM ${{ env.container }}" > Dockerfile.tmp
$ docker build -t the-container -d Dockerfile.tmp --label ${labels} .
```

Importantly, notice we are using the Dockerfile.tmp generated on the fly. You don't technically
need to re-use/overwrite the container name, but I didn't need it again so I did.

#### Deploy

And then you can push that container!

```bash
# note that "the-container" will obviously not work :)
$ docker push the-container
```

That's it! You can check out the GitHub action in the repository linked above,
or see <a href="https://github.com/vsoch/post-label-container/pkgs/container/spack-ubuntu-20.04" target="_blank">the package generated</a>.
Check out an example <a href="https://github.com/vsoch/post-label-container/actions/runs/1457327677" target="_blank">workflow run</a> if you
are interested.

## Challenges

The above steps (without buildx or different architectures) worked quite easily, however when I added buildx I ran into some issues.
When the build step uses <a href="https://github.com/docker/build-push-action" target="_blank">an action</a> to perform the build, it seemed that when a platform was specified, the image wasn't readily available to use after (e.g., docker images did not show what was just built). I tried with load, but the only thing that seemed to work easily was to just push it. If I gave up the different arches it would have been much easier, but I didn't want to, so my solution is simply to just label and do the final deployment on your merge or workflow dispatch. I suspect there is a way, and please  <a href="https://github.com/vsoch/post-label-container/issues" target="_blank">open an issue</a> if you find it!
