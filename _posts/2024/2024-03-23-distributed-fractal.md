---
title: "Distributed Applications with gRPC"
date: 2024-03-23 10:00:00
---

I hit a point last weekend when I had reached my limit with LAMMPS, and more specifically, MPI. It's not to say that I won't be using this app or MPI interfaces in extreme depth for the present or remainder of my career, but at least for that moment, I really needed something else. My use case was deploying a distributed set of nodes, and I really just needed to schedule something to run across them.  In fact, the network I had didn't even afford what we needed for MPI. I'm a big fan of Go, and I didn't find a lot of good example simulation or even image generation apps that fit what I wanted, so like any engineer that makes poor choices, I decided to make my own. I went into a deep tangent that resulted in my first distributed, gRPC based application - distributed fractal. In this brief post I'll share what I learned.

## Distributed Fractal

First, let's admire the beauty of this fractal.

<div style="padding:20px">
<img src="https://github.com/converged-computing/distributed-fractal/blob/main/mandelbrot.png?raw=true"/>
</div>

First and foremost, I need to point out that the algorithm was not entirely mine. I found a basic example [here](https://github.com/esimov/gobrot) and had to modify it fairly extensively to work in this distributed environment. 

### 1. Protocol Buffers

Next, I'm learning that for applications of this type, the first thing you typically want to do is make a rough prototype for your communication. What do I mean? The proto of course! A proto (specifically I am using Google protocol buffers or Google protobuf). Protocol buffers [are](https://protobuf.dev/):

> language-neutral, platform-neutral extensible mechanisms for serializing structured data.

Meaning that you can easily render them into server and client endpoints, and for many languages. This has been highly useful for me across projects that involve schedulers (e.g., sidecar services in Kubernetes) or operator interactions (again, sidecars). I figured it might be a good approach for some kind of orchestrated work. You can see the distributed fractal ones [here](https://github.com/converged-computing/distributed-fractal/blob/main/api/v1/node.proto#L32). 

### 2. Entrypoint

This might be overly simplistic, but I then usually direct my thinking to the user interaction, or entrypoint. How is the user going to interact with this application, and what should that look like? In Go that means writing logic in the [cmd](https://github.com/converged-computing/distributed-fractal/blob/main/cmd/fractal/fractal.go) directory that will render into a binary. For my use case, I knew that I wanted a design where I had a central leader and some number of workers to distribute tasks to. The commands might simply come down to:

```console
# Start a leader and two workers
fractal leader --metrics --quiet
fractal worker --quiet
fractal worker --quiet
```

And of course the above would assume running two workers and the leader on the same host. The hostname is a variable. Here is what the entire command (help) looks like:

```


	┏        ┓
	╋┏┓┏┓┏╋┏┓┃
	┛┛ ┗┻┗┗┗┻┗			  

[sub]Command required
usage: fractal <Command> [-h|--help] [--host "<value>"] [-q|--quiet]

               Distributed fractal generator

Commands:

  version  See the version of rainbow
  leader   Start the leader
  worker   Start a worker

Arguments:

  -h  --help   Print help information
      --host   Leader address (host:port). Default: localhost:50051
  -q  --quiet  Suppress additional output

```

And here is what it might look like when you have different hostnames (e.g., this is how I launch under Flux):

```bash
#!/bin/bash

if [[ "${FLUX_TASK_RANK}" == "0" ]]; then
    fractal leader --metrics --quiet --host 0.0.0.0:50051
else
    fractal worker --quiet --host example-0.flux-service.default.svc.cluster.local:50051
fi 
```

There are a few more details to that (for example, the actual generation is started by a curl command) but we can leave it at that for now. And absolutely it makes sense to create the entrypoint first, even if it's empty. That way you can slowly develop and test and have something to run.  I also usually create a [Makefile](https://github.com/converged-computing/distributed-fractal/blob/main/Makefile) that executes the above (locally) with go run, that way my development workflow can simply be two terminals with:

```
make leader
make worker
```

### 3. Leader Kicks Off Work

You usually go from the entrypoint to starting a server somewhere, or a client. In the case of the leader, we match the server to the leader (meaning serving the gRPC) because we are expecting workers to connect to it to receive work. You can see that logic [here](https://github.com/converged-computing/distributed-fractal/blob/main/pkg/core/leader.go). The complexity in this approach came from the need to be selective about when to kick off generation (I wanted to control this, for the most part) and then the tasks would need to be sent somewhere to be picked up. In the original fracal generator that I was looking at, since it was just a single application, it was largely one go routine that could split apart the work and finish. But i needed to distribute that! While this took me most of a weekend evening to figure out, I'll try to describe it here. Let's start with the setup.

<ol class="custom-counter">
<li><a href="https://github.com/converged-computing/distributed-fractal/blob/6f25ba1fcfa8751e76ab25f07cf92c34bf3da817/pkg/core/leader.go#L60-L73">Create the gRPC service first</a> based on parameters from the command line</li>
<li>Generate an <a href="https://github.com/converged-computing/distributed-fractal/blob/6f25ba1fcfa8751e76ab25f07cf92c34bf3da817/pkg/core/leader.go#L77-L85">empty image and color palette</a></li>
<li>Add an <a href="https://github.com/converged-computing/distributed-fractal/blob/6f25ba1fcfa8751e76ab25f07cf92c34bf3da817/pkg/core/leader.go#L97-L114">http endpoint</a> to "/start" and trigger the generation</li>
</ol>

Then when the user sends a request to the "/start" endpoint we trigger the [renderDistributed](https://github.com/converged-computing/distributed-fractal/blob/6f25ba1fcfa8751e76ab25f07cf92c34bf3da817/pkg/core/leader.go#L110) endpoint. This is where I hugely refactored the original logic in the algorithm, because instead of doing the work in a single go routine, instead I calculate a few values at the start (a ratio, set of mins and max for each of x and y) and then iterate through rows of my image (y). [For each row](https://github.com/converged-computing/distributed-fractal/blob/6f25ba1fcfa8751e76ab25f07cf92c34bf3da817/pkg/core/leader.go#L179-L211), I prepare a piece of data I called a MandelIteration, and it includes the max and min values, the Y index, the Width, and the max iterations. I then send it to a work channel.

> Say what? A work channel?

This was also the hard part! I realized that if I want these units of work to be received by available workers, I need to put them somewhere. So I have what I'd call a middleman, a [node gRPC service](https://github.com/converged-computing/distributed-fractal/blob/main/pkg/core/node.go) that serves as a means of communication between the leader and workers. The leader is creating work items, sending them to be stored here, and the worker is going to pick them up from this channel. More specifically:

<ol class="custom-counter">
<li>We had created the <a href="https://github.com/converged-computing/distributed-fractal/blob/6f25ba1fcfa8751e76ab25f07cf92c34bf3da817/pkg/core/leader.go#L70">service here</a></li>
<li>The work request is send to <a href="https://github.com/converged-computing/distributed-fractal/blob/6f25ba1fcfa8751e76ab25f07cf92c34bf3da817/pkg/core/node.go#L71">this channel</a></li>
<li>The worker will pick it up via <a href="https://github.com/converged-computing/distributed-fractal/blob/6f25ba1fcfa8751e76ab25f07cf92c34bf3da817/pkg/core/node.go#L43-L63">assign task</a> (to be discussed next).</li>
</ol>

At this point, let's assume we have a queue of work to be received... somehow. Let's jump over to the workers.

### 4. Workers Receive It!

When we start a worker, we [create a gRPC client](https://github.com/converged-computing/distributed-fractal/blob/6f25ba1fcfa8751e76ab25f07cf92c34bf3da817/pkg/core/worker.go#L25-L35) but it isn't to the leader directly, it's to the node middle man that has tasks waiting for us. I suppose technically it's being run alongside the leader, but that's a detail. The worker node kicks off with [Start](https://github.com/converged-computing/distributed-fractal/blob/6f25ba1fcfa8751e76ab25f07cf92c34bf3da817/pkg/core/worker.go#L67), which is going to first [connect to the stream provided by the gRPC service](https://github.com/converged-computing/distributed-fractal/blob/6f25ba1fcfa8751e76ab25f07cf92c34bf3da817/pkg/core/worker.go#L37-L56). This was the first time I was using stream in gRPC, and you'll see it defined [here](https://github.com/converged-computing/distributed-fractal/blob/6f25ba1fcfa8751e76ab25f07cf92c34bf3da817/api/v1/node.proto#L63). It's a pretty cool design pattern you can read about [here](https://grpc.io/docs/what-is-grpc/core-concepts/#server-streaming-rpc). This means that the "AssignWork" function is going to be delivered in a stream, and each unit that is delivered from the stream can be assigned to any worker. In practice this is really cool to watch, because you see the workers picking up different tasks from the stream, and the entire set of work gets completed (usually faster). Note that this design paradigm assumes that the work units are independent. Within one worker, after we open the stream we start a loop that:

<ol class="custom-counter">
<li><a href="https://github.com/converged-computing/distributed-fractal/blob/6f25ba1fcfa8751e76ab25f07cf92c34bf3da817/pkg/core/worker.go#L80">Requests a unit of work</a> from the stream</li>
<li>Uses the input to <a href="https://github.com/converged-computing/distributed-fractal/blob/6f25ba1fcfa8751e76ab25f07cf92c34bf3da817/pkg/core/worker.go#L90-L102">calculate two vectors</a> of results specific to this row of the image</a></li>
<li>Packages and <a href="https://github.com/converged-computing/distributed-fractal/blob/6f25ba1fcfa8751e76ab25f07cf92c34bf3da817/pkg/core/worker.go#L104-L110">sends the result</a> back to the gRPC node service</li>
</ol>


For this to work, the norms and its need to be an array of values, and in proto we do this with "repeated." What is the "ReportResult" endpoint? It's actually a similar design, but backwards, expecting to receive (not a stream) but a single ping from a worker with a result item, and instead of adding to the WorkChannel, we add the result to the ResultChannel, <a href="https://github.com/converged-computing/distributed-fractal/blob/6f25ba1fcfa8751e76ab25f07cf92c34bf3da817/pkg/core/node.go#L25-L41">here</a>. But hold the phone! Who is receiving these results? Let's jump back to the leader, of course!


### 5. Leader Receives Results

This also took me a hot minute to figure out, but what we do is have the leader running a go routine that is waiting to either finish, or receive something from the "ResultChannel" send from any worker. It will basically unwrap each result object (a row) and then do the final work to map the values to colors, and write the image. You can see [that logic here](https://github.com/converged-computing/distributed-fractal/blob/6f25ba1fcfa8751e76ab25f07cf92c34bf3da817/pkg/core/leader.go#L119-L177). Since we can receive rows out of order, I didn't have a good way to determine being done aside from having a counter for the number of rows (height) that I had received. When I have the total rows (height-1 since we start counting at 0) I write the image, stop the ticker I am running, and then exit from the loop. I actually had some trouble here getting the go routine (and the entire setup) to stop, and since it was late I just did a panic. It's not the right way to do it, but I figured I could catch the exit on the command line with something like "or true". I did try doing this the "right way" by sending a signal to a done channel, but never got it working. If you would like to contribute, I'd love some help here!

I'll also note that (because I was curious) I tried doing this calculation on the level of a pixel (meaning each worker just processes one x/y coordinate. It was WAY too slow, no way that would be a valid approach.

## Demo

Here is a quick demo of distributed fractale!


<iframe width="560" height="315" src="https://www.youtube.com/embed/bncIbxwcTNo?si=g5gQzp7hoiSr_xTc" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>


It was overall really fun to make. I left out the part of the story where I was trying to use a raft (consensus algorithm) state machine to do similar work, but ultimately realized it was the wrong use case. I highly recommend working to music, it's a beautiful state to be in. Even if you don't dance, it feels lovely in your head.

## Summary

In summary, we got ornery about LAMMPS and MPI and made our own distributed application to generate fractal images. I'll likely be making more of these for fun, and more generally, thinking about other paradigms of distributed communication that I can better control and write applications with in Go.
