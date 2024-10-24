---
title: "Interactive Docker Builds"
date: 2024-10-24 10:00:00
---

One of my favorite parts of my work are fun brainstorming sessions. Sometimes you are thinking about specific, actually important projects, and other times you go off on tangents and come up with really fun, often experimental ideas that have nothing to do with anything you are "supposed to be" working on. It's this thinking space that tends to be more fun, the "What if..." and it's this space that gets me excited about programming and designing software, even after all these decades! This post is about one of those fun ideas.

## When package managers make us cry

To give another tip of the hat to [one of my favorite talks](https://archive.fosdem.org/2018/schedule/event/how_to_make_package_managers_cry/) (although it's debatable if the package manager software or people are crying in that reference) there is a special scenario when my package manager makes me cry immensely. Yes, it is when I'm building containers. When you use "[spack containerize](https://spack.readthedocs.io/en/latest/containers.html)" and can generate a Dockerfile from a spack.yaml environment with said spack environment building in one line ([here is a recent example](https://github.com/converged-computing/performance-study/blob/f0bd89443d1080be311117254cb5d2c82e686108/docker/google/cpu/amg2023/Dockerfile#L35)) it means building an entire tree of software in one layer. This also means your build can be going for hours and if it fails, you lose the entire thing. I can't tell you how many times this has happened to me - it usually is for builds that have worked before, but then an update to spack breaks something, and I'm not expecting it. I kick myself later. My strategy is often to do the build interactively, meaning shelling into the base container and then issuing the commands one by one, and then committing. That's hard to remember to do every time, hence the tears. But can we do better than that? Can we create a docker builder that will, upon failure, still commit the layer and allow me to shell in to continue working on it?

## Customizing moby/moby

For those not familiar, the docker main code lives at [github.com/moby/moby](https://github.com/moby/moby). Last night was the first time I looked at it, and it was refreshingly easy to follow after months of reading Kubernetes (and especially tracing logic in [the kubelet](https://github.com/kubernetes/kubernetes/tree/master/pkg/kubelet), which I'm doing for a small talk I hope to do soon about containerd and the [SOCI snapshotter](https://vsoch.github.io/2024/container-pulling/)). I found instructions for setting up a development environment [here](https://github.com/moby/moby/blob/master/docs/contributing/set-up-dev-env.md), and TLDR, it comes down to cloning the repository, starting a development container in VSCode, and then you can build and run the daemon with one command:

```bash
hack/make.sh binary install-binary run
```

If you [look in that directory](https://github.com/moby/moby/tree/master/hack/make) you'll see build logic that mirrors the structure of the codebase, and what you likely know about Docker already. We are building a [daemon](https://github.com/moby/moby/blob/master/testutil/daemon/daemon.go) service that will be delivered over the docker socket, along with a frontend proxy that will issue requests to it to list (ps), build, etc. I also found the [builder logic](https://github.com/moby/moby/tree/master/builder) to be nicely organized, where the previous (older?) logic to build from a dockerfile was in "dockerfile" and the newer buildkit is in "builder-next." I haven't looked into build-kit, but you can see where the backend makes a choice [here](https://github.com/moby/moby/blob/5aaceefe5be751d55d0a4e9212ddba04408d1a1c/api/server/backend/build/backend.go#L62-L73), and seems to run some kind of a [solve in a go routine](https://github.com/moby/moby/blob/5aaceefe5be751d55d0a4e9212ddba04408d1a1c/builder/builder-next/builder.go#L428) as opposed to the Dockerfile builder that is dispatching each line [here](https://github.com/moby/moby/blob/5aaceefe5be751d55d0a4e9212ddba04408d1a1c/builder/dockerfile/builder.go#L297) through a function with a massive switch statement for the [directive type](https://github.com/moby/moby/blob/5aaceefe5be751d55d0a4e9212ddba04408d1a1c/builder/dockerfile/evaluator.go#L67-L104) (e.g., RUN, ENV, etc).  This was really easy to trace and understand the logic for - thank you to the Docker developers for that! 🙏

What does this mean for development? What is neat is that you can write your own little scripts that interact with the client, which in turn will make calls to the daemon. It meant that I very easily could write my own [little script](https://github.com/researchapps/moby/blob/debug-interactive-builder/main.go) that would take in custom inputs, run a build, and do other customizations that I wanted. The main logic to make the client and then issue the build request looks like this:

```go

apiClient, err := client.NewClientWithOpts(client.FromEnv)
// check errors here
defer apiClient.Close()

// Create temporary directory for reader (context) to copy the Dockerfile to
tmp, err := os.MkdirTemp("", "docker-dinosaur-build")
if err != nil {
	log.Fatalf("could not create temporary directory: %v", err)
}
defer os.RemoveAll(tmp)

copyFile(*dockerfile, filepath.Join(tmp, "Dockerfile"))
reader, err := archive.TarWithOptions(tmp, &archive.TarOptions{})
if err != nil {
	log.Fatalf("could not create tar: %v", err)
}

resp, err := apiClient.ImageBuild(
	context.Background(),
	reader,
	types.ImageBuildOptions{
		Remove:      true,
		ForceRemove: true,
		Dockerfile:  "Dockerfile",
		Tags:        []string{*target},
		Interactive: *interactiveDebug,
	},
)
```

That is only a partial view of the entire script, so yes, the details are missing. The "InteractiveDebug" flag that is carried forward as to the build is not part of traditional ImageBuildOptions, and what I added for my little feature. To summarize (and you can look at the script to see further) I added this new argument that, when present, will allow the dispatchRun function to fail during the layer build, and still commit the layer. When it returns to the calling function, the error type is checked, and given an "InteractiveError" that I added, although the build will break at that point (no further layers will be attempted), because I've commit that particular layer, the build will finish, give me an image ID, and I can shell in and see that the offending line was partially run. And that's it! Here is an example (immensely simple) Dockerfile:

```dockerfile

FROM ubuntu
RUN touch /opt/i-should-not-exist && false && not-a-command

```

Which will generate the file "/opt/i-should-not-exist" and then immediately issue false (returns 1) and another failed "not a command" (it won't even get there). If you try to build this with regular Docker, it will fail and you won't have an image id, let alone the layer. But when you use my little monster and add the "-i" flag for interactive? You get a different outcome!

```console
# This will fail
./bin/docker-build -t fail -f Dockerfile.fail .

# But with interactive -i, it will work!
./bin/docker-build -i -t works -f Dockerfile.fail .
```

Here is a direct shot of the little monster in action, showing the container complete, and the file exists when I shell inside, despite the line failing:

<div style="padding:20px">
  <a target="_blank" href="{{ site.baseurl }}/assets/images/posts/docker/little-monster.png"><img src="{{ site.baseurl }}/assets/images/posts/docker/little-monster.png"/></a>
</div>

This was fun to develop, because you can run the daemon in one terminal window (and see output) in your development environment, and follow your client in the other. Note that I commented out build kit logic for now. I will want to read that code a little more closely before I tweak it. If you've used build kit, you know those layers are being built in parallel, so the logic is slightly different.

## An actual feature?

I don't have plans at the moment to try to suggest this to be an actual feature - for the time being it was a fun experiment, and I invite others to [look at the PR](https://github.com/researchapps/moby/pull/1) (to my own repository) if interested. That said, I do plan to test this in the future with more substantial builds, and I'm wondering why we don't have something like this anyway? Granted that the build does not become reproducible, this kind of feature would help immensely with debugging. For all of the cases when you do cry because you lose hours of time when your fails during a long layer build, this would be a nice feature to have. Likely you'd want to debug and get it working, and then rebuild without this flag. Let me know what you think! If there is interest we can minimally pursue adding to build kit and engaging with the moby developers about the idea.

