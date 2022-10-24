---
layout: post
title: "Multiprocessing for Faster Downloads"
description: "Testing different ways to download streaming layers in Python."
date: 2017-04-23
comments: true
keywords: ""
---

Has this ever happened to you? Today I woke up and wanted to know if I could download a file faster. Specifically, this would be for the <a href="https://singularityware.github.io" target="_blank">Singularity</a> back end Python API that does the simple streaming of Docker layers to the user's cache. As a cautionary note, my expertise in "parallel processing" is typically running jobs at scale in a high performance compute (HPC) cluster environment. I'm only aware of Python's <a href="">multiprocessing</a> library

## Running in Parallel?
A lot of people talk about things running "in parallel" and this might actually be referring to different things, but getting at the same idea - finding an efficient way to manage resources to make a task complete faster. 


### "Parallel" in Clustering Computing
In the researcher world where I come from, running in parallel usually means not terribly efficient code run at scale by way of a cluster environment. Even if my script isn't optimized, it you can run it 1,000 times at once on pretty decent machines with substantial memory, it's going to get the job done. This bias comes from my own experience, along with the observation that it's really hard to be a good programmer and a good scientist at the same time. I remember when I was first getting my feet wet... ok let's not talk about that :)

### Parallel on one System
Truly parallel goes one level deeper than running at scale, and also takes the local machine into account. This means memory and CPU, and for this post we are primarily going to be looking at CPU (and assume that we aren't doing memory intensive things). So the question of the hour...



>> What does it mean to run in parallel?



There is a <a href="https://code.tutsplus.com/articles/introduction-to-parallel-and-concurrent-programming-in-python--cms-28612" target="_blank">good post here</a> that walks through the differences, but generally when one talks about "running in parallel" on a single machine, they mention processes and threads.



>> What is the difference between processes and threads?



I think of it like this. A process is a program. Your computer is running a gazillion at once (type top in the terminal). Processes are like separate programs, and threads are akin to little workers that efficiently use the same process. I'm going to steal Bogdan's beautiful table (and <a href="https://tutsplus.com/authors/george-bogdan-ivanov" target="_blank">give him credit for it</a>) to show the difference, in a nutshell:

  <table>
    <thead>
      <tr>
        <th>PROCESSES<br/></th>
        <th>THREADS<br/></th>
      </tr>
    </thead>

    <tbody>
      <tr>
        <td>Processes don't share memory<br /></td>

        <td>Threads share memory<br /></td>
      </tr>

      <tr>
        <td>Spawning/switching processes is expensive<br /></td>

        <td>Spawning/switching threads is less expensive</td>
      </tr>

      <tr>
        <td>Processes require more resources<br /></td>

        <td>Threads require fewer resources (are sometimes called lightweight
        processes)<br /></td>
      </tr>

      <tr>
        <td>No memory synchronisation needed<br /></td>

        <td>You need to use synchronisation mechanisms to be sure you're correctly
        handling the data</td>
      </tr>
    </tbody>
  </table>


You can imagine there a good use cases for both, and if you want to dig in a bit deeper you should read about the <a href="https://wiki.python.org/moin/GlobalInterpreterLock" target="_blank">Gil</a>. 

The author of the table above also nicely makes the distinction between parallel and concurrent. I'll explain my understanding by way of a metaphor. Let's say you have a piece of code making a cake. The two things to be done are preheating the oven, and then making the batter. Parallel means that you have two different people (processes), each one responsible for a contained task. Person A turns on and watches the oven, and Person B starts making the batter. Now let's bring in Person C. He is concurrent. He is a bit of a control freak, so he schedules everything to be run as efficiently as possible. He watches Person A and B, and thinks it's inefficient to have both of them, or to have one of them preheat the oven, wait, and then make the batter. Instead, he preheats the oven, and while it's waiting for it to heat up, executes making the batter. Even though Person C is just one process, by way of scheduling one task to run while the other is waiting, his cake is baked faster in the end.



## Defining a Base Case
Before we test multithreading, we need a base case. The base case is doing everything in serial. There is one process, and one thread, like tic-tacs following out of a box. First I'm going to do a bit of setup, which includes importing Python functions, as well as setting up a test case for the Singularity API client.

```python
from glob import glob
import multiprocessing
import itertools
import time
import os

# Let's clear cache between each one
# cd libexec/python --> ipython

from sutils import get_cache
cache = get_cache('docker')

# Function to clean cache
def clean_cache(cache=None):
    if cache is None:
        cache = get_cache('docker')
    files = glob("%s/*" %cache)
    [os.remove(filey) for filey in files]

# Here is the Singularity Python API client
from docker.api import DockerApiConnection
client = DockerApiConnection(image="ubuntu:latest")
images = client.get_images()

# We will give the multiprocessor a function to download a layer
def download_layer(client,image_id,cache_base,prefix):
    targz = client.get_layer(image_id=image_id,
                             download_folder=cache_base,
                             prefix=prefix)
    client.update_token()
    return targz
```

Great! Now let's write a quick function to test our serial download. We can then just run it maybe 10 times, clearing the cache between runs, and see how long it takes.

```
def test_serial_download():
    clean_cache()
    layers = []
    for ii in range(len(images)):
        image_id = images[ii]
        targz = "%s/%s.tar.gz" %(cache,image_id)
        prefix = "[%s/%s] Download" %((ii+1),len(images))
        if not os.path.exists(targz):
            targz = download_layer(image_id=image_id,
                                   client=client,
                                   cache_base=cache,
                                   prefix=prefix)
            layers.append(targz)
    return layers
```

And here is running our test:

```python
serial_times = []
for ii in range(0,10):
    print("STARTING SERIAL TIMING: ITERATION %s" %(ii))
    start_time = time.time()
    layers = test_serial_download()
    end_time = time.time()
    final_time = end_time - start_time
    print("Serial download time:", final_time)
    serial_times.append(final_time)

# E.g.: 
# Serial download time: 42.460509061813354
```

How did we do?

```
serial_times
# [40.7736291885376,
#  40.60954689979553,
#  40.79848909378052,
#  39.37337779998779,
#  39.85921502113342,
#  40.12239909172058,
#  40.35327935218811,
#  40.116194009780884,
#  40.140629053115845,
#  39.861605644226074]
```

Just to note, this is easily 7-9 seconds faster than I observed on my apartment connection. I'm actually testing on a dinky Google Compute instance. It only has two cores, but it's still destroying my laptop with a Comcast wireless crappy plan.


## Multiprocessing
I didn't have any good rationale for the number of workers, but I had seen 2 times the number of CPU around, so that makes sense to try. In this case, we are going to use <a href="https://docs.python.org/2/library/multiprocessing.html#using-a-pool-of-workers" target="_blank">multiprocessing Pool</a>, where a pool is referring to a pool of workers.

```python
# Define number of workers to be 2*CPU
NUM_WORKERS = multiprocessing.cpu_count()*2
```

In the link above, I saw that I could use `pool.map` or `pool.apply` or `pool.apply_async`. I chose to use `pool.map` because it would wait for execution to finish, and I would be guaranteed the order of my commands was maintained. Both apply the same function to multiple arguments, so I suppose this is the main difference. Toward that, I would need to put together a list of arguments, each just being a dictionary of key,value pairs. If you remember from above, images is just a list of the Docker image (sha256) identifiers that the `download_layer` function is expecting.

```python
tasks = []
for ii in range(len(images)):
    image_id = images[ii]
    targz = "%s/%s.tar.gz" %(cache,image_id)
    prefix = "[%s/%s] Download" %((ii+1),len(images))
    kwargs = {'image_id':image_id,'prefix':prefix,'client':client,'cache_base':cache}
    tasks.append(kwargs)
```

I ran into this weird issue of needing the arguments to be dumped out of this form, but from within the map function. We can use a function to do that:

```
def run_wrapper(args):
   return download_layer(**args)
```

Here we go!

```python
# Add the calls to the task queue
multi_times = []
for ii in range(0,10):
    clean_cache()
    print("STARTING MULTI TIMING: ITERATION %s" %(ii))
    start_time = time.time()
    with multiprocessing.Pool(processes=NUM_WORKERS) as pool:
        results = pool.map(run_wrapper,tasks)
    end_time = time.time()       
    final_time = end_time - start_time 
    print("Multiprocessing time:", final_time)
    multi_times.append(final_time)
```

And woot! The results were definitely faster

```
# [38.58448839187622,
#  36.93542289733887,
#  36.940842390060425,
#  36.46030259132385,
#  36.53814649581909,
#  36.838619232177734,
#  38.17390704154968,
#  36.28799319267273,
#  35.855493783950806,
#  39.255677461624146]
```

Now I started to think about how to integrate this into Singularity. Since we have many things happening at once, we would lose the nice download progress bar. Is this slight increase in speed worth the change in user experience? This is one of those questions that I'm not sure has a great answer. Typically, when a user downloads layers, even if the time is trivially more, there is some comfort in seeing the progress. Also, typically layers only need to be downloaded once before they are cached and re-used, meaning that the inefficiency (whether it is speed or communication with the user) only happens once. On the other hand, given many or big layer downloads, the small increase in speed could really scale given a setup that optimizes the number of workers (pools) for a particular cluster.

I will conclude for now that we should try to optimize for both. This means integrating multiprocessing, and adding a (likely higher level) progress bar that keeps the user aware of progress, albeit not at the level of detail that we used to have.



## How many workers?
I then wondered, but how many workers is really best? I decided to do another test on my dinky instance. First, I turned the code above into the start of a class.


```python
class SingularityMulti(object):

    def __init__(self, workers=None):
        '''initialize a worker to run a function with some arguments 
        '''
        if workers is None:
            workers = 4
        self.workers = workers

    def _wrapper(self,func_args):
        function, args = func_args
        return function(*args)

    def _package(self,func, args):
        return zip(itertools.repeat(func), args)

    def run(self,func,tasks):
        start_time = time.time()
        with multiprocessing.Pool(processes=self.workers) as pool:
            results = pool.map(self._wrapper,self._package(func,tasks))
        end_time = time.time()       
        self.runtime = end_time - start_time 
        pool.close()
```

I'm not sure if I will eventually regret this, because pickling `Class` or instance kinds of things can lead to trouble, and that's going to be a requirement for multiprocessing.

But I digress! Above I ran into yet another challenge with my original implementation. The `run_wrapper` function (now called `self._wrapper` above) relied upon taking the function as a sort of "global" variable, or at least one defined in the same python class. In the object case, I would want to have this wrapper take a function as an argument. This is probably not the most elegant solution, but I decided to add a third supporting function, `self._package` that takes a function and tasks, and zips them up into an object that is then further split and run by `self._wrapper`. I also added the runtime to be saved to the object, so the user can look at `self.runtime` after using it, and see how long it took. Now we can test the multiprocessing with our function of choice (`download_layers`) and the set of variables to populate it (`tasks`): 

```python
# Add the calls to the task queue
tasks = []
for ii in range(len(images)):
    image_id = images[ii]
    targz = "%s/%s.tar.gz" %(cache,image_id)
    prefix = "[%s/%s] Download" %((ii+1),len(images))
    tasks.append((client,image_id,cache,prefix))
```

I want to note that, because I am no longer using a dictionary, the order of arguments above does matter. This could (and likely will) be changed to use a dictionary with key,values instead (unless that gets in the way of our pickle, because we might want to use tuples!), but again I digress, and I didn't do that above.

```
# Let's test different numbers of workers, range from 1 to 21
times = dict()
for workers in range(1,30):
    dl = SingularityMulti(workers=workers)
    dl.run(func=download_layer,tasks=tasks)
    print("Total time for downloader: %s" %(dl.runtime))
    times[workers] = dl.runtime
```

and **drumroll** the results!

```
{1: 40.8039071559906,
 2: 38.47519087791443,
 3: 34.40912365913391,
 4: 38.89979314804077,
 5: 34.17676758766174,
 6: 37.41979002952576,
 7: 34.263710260391235,
 8: 40.066882848739624,
 9: 34.298012018203735,
 10: 40.8993980884552,
 11: 35.094584941864014,
 12: 39.33171343803406,
 13: 34.322145223617554,
 14: 36.827746629714966,
 15: 34.68627619743347,
 16: 37.022318601608276,
 17: 34.201767921447754,
 18: 37.00613880157471,
 19: 35.72245764732361,
 20: 38.15021276473999,
 22: 37.96261501312256,
 23: 38.173930168151855,
 26: 37.81467294692993,
 28: 38.6854305267334,
 30: 37.872326374053955}
```

This would do better with a plot, but it's getting late so the list will suffice for now. What I see (at least to me) seems obvious - we do a little better with an odd number of pools. This is cool! And nuts! And needs to be tested on different kinds of CPU and for different OS, and then properly plotted (but not tonight). Likely I'll try something like this out for Singularity, and better test how to optimize the number of pools, and how to implement the progress bars.

## Anticipated Challenges Ahead!
I am almost certain that I'm going to have a hard time sticking my fingers into that map to get some kind of update for the user in order to render a progress bar. I also anticipate, that given the need to pickle some of these custom objects, I'm going to run into the standard multiprocessing pickle error, which (and I can't remember the name of it exactly) gets triggered when Python doesn't know how to pickle an instance. I want to jump into this tonight, but likely will get started again tomorrow. Stay tuned!
