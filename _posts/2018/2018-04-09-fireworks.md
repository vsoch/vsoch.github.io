---
title: "Fireworks"
date: 2018-04-09 8:30:00
toc: true
---

This post comes after some initial fun to work on 
[interval scheduling](https://vsoch.github.io/2018/interval-scheduling/), and it's
a good example of how you can start working on some initial problem, and creativity
and curiousity takes you in an entirely different, fun direction! My
idea was that, given that I could generate an interval randomly within some start 
and end time, what if I did that but updated the times to be within the range of
the last generated set? It would mean generating a set of nested intervals. This
design, I decided, was a bit like fireworks! But not just any kind of firework... it
was a _nested firework_, and they come out beautiful:

<div style="padding-top:10px; padding-bottom:20px">
   <img src="/assets/images/posts/fireworks/firework.png" width="50%" style="margin:auto; display:block">
</div>

*TLDR* I wound up going in a different and fun direction!
If you want to see this post in action:

```bash
docker run -it vanessa/algorithms:fireworks
```

or forget an entire show, just generate one random "boum"

```bash
docker run -it vanessa/algorithms:fireworks --boum
```

That will automatically select between complex and simple designs. To force a simple 
or a complex design:

```bash

docker run -it vanessa/algorithms:fireworks --boum --simple
docker run -it vanessa/algorithms:fireworks --boum --complex

```

You can also control the firework size:

```bash
docker run -it vanessa/algorithms:fireworks --boum --simple --size 5
```

Or the specific kind of `--complex` design (try a random integer!):

```bash
docker run -it vanessa/algorithms:fireworks --boum --complex --design 5
```

or generate an entire fireworks show with one kind of complex design:

```bash
docker run -it vanessa/algorithms:fireworks --complex --design 5
```

Or watch (one of the infinitely possible) final shows!

<script src="https://asciinema.org/a/176227.js" id="asciicast-176227" async></script>

First I want to review my algorithmic journey, because it was awesome and fun!
If you are interested in adding fireworks to your clusters or code, skip to the
[Using Fireworks](#using-fireworks) section, or jump to the end to 
see [what I learned](#what-i-learned). 

<br>

# Recursive Internal Events
To be clear, this original idea did not turn out to be the final implementation, and I'll
comment on that later. It's important that I describe my entire development process,
and that starts with this first method. I summarized the problem as follows:

Let's say that you start with a start value (a time in seconds, likely
we would start at time 0.0) and end some N seconds later. This forms a range from
0 through N, and we would want to create some kind of fireworks display so that 
the fireworks come on gradually starting at time zero, climax in the middle,
and then fade out. We would want nested events, and it might look something
like this (s=start,e=end, and the number indicates the firework number!):

```
[start]  [s1] [s2] [s3] [sN] .. [eN] [e3] [e2] [e1]  [end]

```

I decided that I wanted to generate an algorithm to do the following:


<ol class="custom-counter">
  <li>start with a number of fireworks, a start and end time</li>
  <li>randomly generate a firework, meaning design and size</li>
  <li>calculate trigger times for a firework depending on increasing size.</li>
  <li>create an event loop to trigger the fireworks.</li>
</ol>
<br>

Thanks to the magic of version control, you can see the first effort <a href="https://github.com/vsoch/algorithms/commit/b0d447b124647bf6b78c7535833c10b91f34f43b" target="_blank">here</a>. 

## Async.io for Asyncronous Events
I thought that I could build up intensity by adding more fireworks to be fired toward the
"finale" of the show. Specifically, I had a Fireworks
class that would let me generate multiple fireworks, each having a start time, end time, 
a design (color, character, size) and a calculated duration. The main function
to run the show would then use <a href="https://docs.python.org/3/library/asyncio.html" target="_blank">async.io</a>
 to create an event loop

```python

import asyncio
import time

def fireworks_show(fireworks):
    '''create the loop of tasks to start the fireworks show!
       
       Parameters
       ==========
       fireworks: the schedule of fireworks!

    '''
    print('Starting the show!')
    loop = asyncio.get_event_loop()
    start=time.time()
    tasks = [asyncio.ensure_future(booms(firework, start)) for firework in fireworks ]
    loop.run_until_complete(asyncio.wait(tasks))
    loop.close()
```

The above took me a long time to do, because the concept of an 
<a href="https://en.wikipedia.org/wiki/Event_loop" target="_blank">event loop</a> is completely
new to me. I would then schedule each firework in the function called "booms" that you can see is
handed to the loop as a task. The function would start a counter, and start printing
the firework only after we had reached the start time or later:

```python

@asyncio.coroutine
def booms(firework, start_time):

    # Time passed since starting the show
    progress = time.time() - start_time

    # Sleep and hand off to other fireworks if not time to start
    while progress < firework.start:
        yield from asyncio.sleep(firework.frequency)
        progress = time.time() - start_time

    # When we are over the start time, calculate ending 
    ending = time.time() + firework.duration

    # Keep firing until we reach the ending time
    while time.time() < ending:
        firework.boum()
        yield from asyncio.sleep(firework.frequency)

```

The cool thing about async.io is that with the expression `yield from asyncio.sleep`
I am able to hand control to other processes in the loop, so one particular firework
doesn't dominate control and not let others run. Although the above wasn't
perfect (I might have used the loop's time instead of `time.time()` it achieved the
asyncronous quality that I was looking for. My fireworks were nothing to call
home about (just a line of a randomly selected character and color) but 
the result looked like this:

<script src="https://asciinema.org/a/175710.js" data-speed="3" id="asciicast-175710" async></script>

If you had patience to watch the above for more than 30 seconds, other than being
bored, you would realize that it does a poor job of actually modeling fireworks.
Other than the visual representation being off, the timing is wrong too. No fireworks show 
that I've ever seen has a climax and then gradually comes back down. I think there are other
real world things that follow this design, but fireworks aren't one of them. And I was 
set on making fireworks! The more correct fireworks model looks like this:

```
[start]  [s1]   [s2]  [s3]  [s4] [s5][s6][sN] [end]
```

Notice the build up, represented by an increasing frequency? I needed to do that.

### Fireworks in Ascii
But first, I wanted to deal with those epically ugly fireworks. I came up with a
very simple algorithm to generate a design! The changes that I made <a href="https://github.com/vsoch/algorithms/commit/0fbf4b69eccbaaceba1404bfc90b0fabdac0191a" target="_blank">are here</a>. Overall, 
the algorithm was again pretty simple. Given some randomly selected characters 
and colors, along with a size and offset, I generated a design that is 
essentially two half circles. The function had a few different
versions, but the more final one looked like this:

```python

        design = ''

        # Slightly different ranges determine top and bottom of shape
        top_range = range(2, size, 2)
        bot_range = range(size, 2, -2)
        ranges = itertools.chain(top_range, bot_range)

        for i in ranges:
            if i == size: i = size - 1
            padding = " "*(size-i + offset)
            design += '\n' + padding + i*("%s%s" %(char1,char2))
            
        return design
```

In the above, I'm going from 2 up to the randomly chosen size, and then back again,
and adding a design character at some offset to form a circle with a bit of edge chopped off. This
did slightly better at modeling something that is orby, but it still looked more like
scrolling bubbles than any kind of firework. And when I added background colors to the random generation and a more consistent way to vary the speed, I got the following:

<script src="https://asciinema.org/a/175892.js" id="asciicast-175892" data-speed="3" async></script>

This looked really cool, but it wasn't my goal to create scrolling bubbles and
call them fireworks. It was in thinking about an algorithm to generate
firework designs when things got fun :)


## Firework Generation Algorithm
We needed a fireworks generating algorithm! I had two options here. I could generate
ascii designs a priori and then modify the color (like I did with my 
<a href="https://vsoch.github.io/2018/learning-go/" target="_blank">salad fork</a> 
generator) easier, but less challenging) or come up with an algorithm to 
generate them for me. I spent the entirety of an evening with <a href="https://www.github.com/tabakg" target="_blank">tabakg</a> obsessively using and testing this beautiful (and terribly documented) function:

```python

import numpy as np

def ascii_flower(char='O', n1=15, n2=15, inner=5, outer=15):
    S = ''
    for i in range(outer*2):
        for j in range(outer*4):
            x,y = i-outer,(j-outer*2)/2
            angle = np.arctan2(x,y)
            Z = min((angle*n1/np.pi)%2., (-angle*n2/np.pi)%2.)
            r = np.sqrt(x**2 + y**2)
            if r-inner < Z*(outer - inner):
                S += char
            else:
                S += ' '
        S += '\n'
    return S
```

When we made `n1` == `n2`, we got some beauuuuutiful designs. Like seriously,
this possibly beats my entire graduate education.

<script src="https://asciinema.org/a/175907.js" id="asciicast-175907" async></script>


### Humanizing the Algorithm
Here is where it would have been easy to use the above, and stop there. Unfortunately
I'm someone that has a learning requirement of huge verbosity (can you tell?). There is no way I 
could come back to the above code the next day, let along a long time from now,
and know what the heck is going on. So I spent most of an early morning 
<a href="https://github.com/vsoch/algorithms/commit/24f08157ac197600e6f5529cac5851563c0568ef" target="_blank">rewriting
the function</a> to be "future Vanessa friendly."


```python

 def choose_shape(self, char='O', n1=15, n2=15, inner=5, outer=15):
        '''generate a firework design based on inner and outer lengths,
           and variables n1 and n2 to control the angles.
           Parameters
           ==========
           outer: a multiplier for the outer radius. 
           inner: a set inner radius "cutoff" to determine printing the char
        '''
        design = ''

        # This is the (inside portion) of the outer circle (diameter)
        # [-----][-----]

        for i in range(outer*2):

            # This is the (outer portion) of the same circle (diameter)
            # [-----][-----][-----][-----]

            for j in range(outer*4):

                # We are scanning over values of x and y to define outer circle
                x,y = (j-outer*2)/2,i-outer

                # For each pair of x and y values we find the angle and radius. 
                #   arctangent returns radians, and reflects quadrant.
                #   A circle goes from 0 to 2pi radians
                angle = math.atan2(y,x)
                radius = math.sqrt(x**2 + y**2)

                # We want a function of the angle to zig zag up and down.
                #   We multiple the angle above by some factor (n1 or n2)
                #   divide by pi and 2 so the result goes from 0 to 1
                zigzag = min((angle*n1/math.pi)%2., (-angle*n2/math.pi)%2.)
                

                # Then from the angle we figure out the cutoff radius - 
                #   some value between inner and outer based on the zigzag
                #   that we want. 
                cutoff = zigzag*(outer - inner) + inner

                # (outer-inner) is the distance between outer and inner that 
                # ranges from 0 (when zigzag is 0) to outer (when zigzag is 1). 
                # This means that when zigzag is 0 it's scaled to none of the 
                # distance, and when zigzag is 1 it's scaled to the entire 
                # difference.

                # Compare the actual radius to the cutoff radius. 
                #   If actual radius is < cutoff radius --> fill in
                #   otherwise put a blank space.
                if radius < cutoff:
                    design += char
                else:
                    design += ' '

                # - At the end of a row, add a newline
            design += '\n'

        return design

```

You can read through the comments in the function and decide if I did a good job
explaining it. Is it overkill? Maybe. I don't think so. It may be the case that the computer
is indifferent to the two versions, but for the human there are small changes so that it flows
logically. For example:

<ol class="custom-counter">
  <li> I found that Arctan2 is <a href="https://www.medcalc.org/manual/atan2_function.php"
target="_blank">defined for values y and x</a>. The ordering technically doesn't matter (it's an angle between x and y) but I wanted to be consistent with the definition, and changed it.</li>
  <li>As a reader, it's natural to have basic variables defined before any more complex steps. I moved the definition of `radius` to before `zigzag` (original variable `Z`).</li>
  <li>It wasn't totally intuitive what `if r-inner < Z*(outer - inner)` was doing. By rearranging the variables and defining one ahead of time (`cutoff=zigzag*(outer - inner) + inner` I was able to use the code to tell the user that the value was for a cutoff, and that the if condition was comparing it to the radius (`if radius < cutoff:`)</li>
  <li>I did not allow for any line to go unexplained. I challenged myself to justify every little thing, and it was a great learning experience.</li>
</ol>

This was very challenging for me, putting the entire thing into the right words. It taught me a valuable lesson
about general programming:

> The program runtime may be dependent only on the machine's ability to "read" it, but it's future development relies also on human digestability.


### Animation
At this point I was going nuts, I was so excited. I was also unhappy with the "flowing bubbles" effect that
was being used to model the fireworks. I had great excitement to figure out the right character to use to 
<a href="https://github.com/vsoch/algorithms/commit/29f591b53650109419e3482356c2781f843d3c23#diff-ba47e3ecc231ea5708d2dae24a5550cfR114" target="_blank">clear the terminal</a>! This meant that I could clear the terminal between single fireworks, and have more of an "increasing in size and exploding"
effect. This was another change to the algorithm. I had orginally generated the design to be "hard coded" and stored
with the Fireworks object, but realized that I needed to generated it on the fly, given some pre-determined 
variables like color and overall shape, and then vary the size. I also decided to use my "bubble" design as an center overlay on the more firework-y design:

<script src="https://asciinema.org/a/176100.js" id="asciicast-176100" data-speed="2" async></script>

Nothing anything weird? The center is kind of skewed. Unfortunately I spent a few hours trying to get this right,
and ultimately decided it was simpler to keep the two shapes separately. My strategy was, instead of generating
a long design string with newline characters, to put each full bytes sequence (the color and then off sequence) into
a list of lists (a matrix) and then combine the two based on the center. The issue wound up being that, after the 
merge, the length of the byte sequences were slightly different (depending on the random generation) and didn't line
up perfectly as actual characters. 

I also realized that the result was beautiful without the more complicated overlay, and 
by removing the asyncronous loop and just using a standard for loop, the fireworks 
looked **much** more like fireworks. And then I deleted a 
<a href="https://github.com/vsoch/algorithms/commit/29f591b53650109419e3482356c2781f843d3c23#diff-ba47e3ecc231ea5708d2dae24a5550cfL396" target="_blank">LOT</a> of code! Here was another important lesson:

> Simplicity is sometimes the best strategy.

In this case, I easily gave up many hours of work, and the result is a lot less code and a result
I'm much happier with.


# Using Fireworks

We can start with a container and shell in to interact with the scripts (you 
can also use a Singularity container).

```
docker run -it --entrypoint ipython vanessa/algorithms:fireworks
```
```
singularity exec docker://vanessa/algorithms:fireworks ipython
```

or we can just clone the repository and use our own python. I tried to reduce
dependency modules to not include any outside of Python 3 so this might work for
you without a container, at least for now :)


```bash

git clone https://github.com/vsoch/algorithms
cd algorithms/fireworks
ipython

```

## Single Firework Generation
Here is an example to create and explode a basic firework. Import the
Firework class, instantiate it, and give it a start and ending time.

```python

from main import Firework

start = 0
end = 200
firework = Firework(start=start, end=end)

```

He speaks...

```python

firework.speak()
Baby I'm a Firework (00000:00200)!

```

Then what are you waiting for? Explode it!

```python
firework.boum()
```

You can customize your firework as you like:

```python
firework = Firework(end=200, simple=False, thresh=13)
```

or use `randomize` to come up with a new design for the current firework.

```python
firework.randomize()
firework.boum()
```

## Multiple Firework Generation
You could obviously put them in a loop:

```python

# Or more fun...
for i in range(0,10):
    firework.randomize()
    firework.boum()

```

And even set a specific design:

```

for i in range(0,10):
    firework.randomize()
    firework.thresh = 5   # star
    firework.boum()

```

But you can also have finer tuned control by using the firework's internal generator,
the functions that are used behind `boum()`. Here we will ready the explosion first,
and then iterate through the stages. The boum function adds a command to
clear the terminal, but if you don't you get a different kind of experience:

```python

import time

show = firework.ready()
for design in show:
    print(design)
    time.sleep(0.1)

'''

                          kkkkk  
                     kkkkkkkkkkk 
                     kkkkkkkkkkkk
                      kkkkkkkkkkk
                     kkkkkkkkkkkk
                     kkkkkkkkkkk 

                                     
                        kkkkkkkkkkk  
                       kkkkkkkkkkkkk 
                      kkkkkkkkkkkkkkk
                      kkkkkkkkkkkkkkk
                      kkkkkkkkkkkkkkk
                       kkkkkkkkkkkkk 
                        kkkkkkkkkkk  

                                         
                           kkkkkk        
                         kkkkkkkkkkkkkk  
                        kkkkkkkkkkkkkkkk 
                      kkkkkkkkkkkkkkkkkk 
                      kkkkkkkkkkkkkkkkk  
                      kkkkkkkkkkkkkkkkkk 
                        kkkkkkkkkkkkkkkk 
                         kkkkkkkkkkkkkk  
                           kkkkkk        

...

                                                                     
                                      k                              
                                     kkkkk                           
                                    kkkkkkkk                         
                                    kkkkkkkkk                        
                                    kkkkkkkkkkk            kkkkkk    
                                    kkkkkkkkkkk      kkkkkkkkkkk     
                                     kkkkkkkkkkk  kkkkkkkkkkkkkk     
                                     kkkkkkkkkkkkkkkkkkkkkkkkkk      
                                      kkkkkkkkkkkkkkkkkkkkkkkk       
                            kkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkk         
                        kkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkk           
                      kkkkkkkkkkkkkkkkkkkkkkkkkkkkkkk                
                        kkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkk           
                            kkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkk         
                                      kkkkkkkkkkkkkkkkkkkkkkkk       
                                     kkkkkkkkkkkkkkkkkkkkkkkkkk      
                                     kkkkkkkkkkk  kkkkkkkkkkkkkk     
                                    kkkkkkkkkkk      kkkkkkkkkkk     
                                    kkkkkkkkkkk            kkkkkk    
                                    kkkkkkkkk                        
                                    kkkkkkkk                         
                                     kkkkk                           
                                      k                              

                                                                         
                                       kk                                
                                      kkkkk                              
                                      kkkkkkk                            
                                      kkkkkkkkk                          
                                     kkkkkkkkkkk                         
                                     kkkkkkkkkkkk         kkkkkkkkkk     
                                      kkkkkkkkkkkk    kkkkkkkkkkkkkk     
                                      kkkkkkkkkkkk  kkkkkkkkkkkkkkk      
                                       kkkkkkkkkkkkkkkkkkkkkkkkkkk       
                                        kkkkkkkkkkkkkkkkkkkkkkkk         
                            kkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkk           
                        kkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkk             
                      kkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkk                  
                        kkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkk             
                            kkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkk           
                                        kkkkkkkkkkkkkkkkkkkkkkkk         
                                       kkkkkkkkkkkkkkkkkkkkkkkkkkk       
                                      kkkkkkkkkkkk  kkkkkkkkkkkkkkk      
                                      kkkkkkkkkkkk    kkkkkkkkkkkkkk     
                                     kkkkkkkkkkkk         kkkkkkkkkk     
                                     kkkkkkkkkkk                         
                                      kkkkkkkkk                          
                                      kkkkkkk                            
                                      kkkkk                              
                                       kk                                

...
                                                                                     
                                           k                                         
                                           kkkk                                      
                                          kkkkkkk                                    
                                          kkkkkkkkk                                  
                                          kkkkkkkkkk                                 
                                         kkkkkkkkkkkk                                
                                          kkkkkkkkkkkk                kkkkkkkkk      
                                          kkkkkkkkkkkkk          kkkkkkkkkkkkkk      
                                          kkkkkkkkkkkkkk      kkkkkkkkkkkkkkkk       
                                           kkkkkkkkkkkkk   kkkkkkkkkkkkkkkkkk        
                                            kkkkkkkkkkkk  kkkkkkkkkkkkkkkkkk         
                                             kkkkkkkkkkkkkkkkkkkkkkkkkkkkk           
                                  kkkkkkkkk   kkkkkkkkkkkkkkkkkkkkkkkkkk             
                            kkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkk               
                        kkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkk                  
                      kkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkk                        
                        kkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkk                  
                            kkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkk               
                                  kkkkkkkkk   kkkkkkkkkkkkkkkkkkkkkkkkkk             
                                             kkkkkkkkkkkkkkkkkkkkkkkkkkkkk           
                                            kkkkkkkkkkkk  kkkkkkkkkkkkkkkkkk         
                                           kkkkkkkkkkkkk   kkkkkkkkkkkkkkkkkk        
                                          kkkkkkkkkkkkkk      kkkkkkkkkkkkkkkk       
                                          kkkkkkkkkkkkk          kkkkkkkkkkkkkk      
                                          kkkkkkkkkkkk                kkkkkkkkk      
                                         kkkkkkkkkkkk                                
                                          kkkkkkkkkk                                 
                                          kkkkkkkkk                                  
                                          kkkkkkk                                    
                                           kkkk                                      
                                           k                                         


```

Given the way that I've implemented "ready" the first design will actually be
the finished firework. This both adds to the explosion effect, and presents
the final firework first if the user wants it. You can change the implementation
of the `ready()` function to change this.

If you want to add the same clearing of the terminal, do it like this:

```python

show = firework.ready()
for design in show:
    print(design)
    time.sleep(0.1)
    print('\033c')  # (-- how to clear the terminal

```

The ready function just generates an iterator over this function, you could
change that too:

```python

    def ready(self):
        '''prepare the show! This is an interator to reveal slowly increasing
           in size fireworks. boum!
        '''
        number = self.count_designs()
        delta = self.size / number
        inner = self.inner + delta

        for size in range(number):
            inner = self.inner - delta
            yield self.generate_design(size=size, inner=inner)
```

So arguably you can scrap the above and just call this function to generate a 
design!

```python

design = firework.generate_design(size=20, offset=20, simple=False)
print(design)

```

The sky is really the limit in terms of how you want to use this tiny script.
Have fun! Keep reading for a story of developing the algorithms. Thinking about
creative problems like this is one of my favorite things to do, after building
things :)


# What I learned
While this originally was a project where I wanted to focus on learning about asyncronous event loops in Python,
it turned out to not use the library at all. I'm okay with this! There were some subtle challenges and learnings 
that I would like to highlight (again in a few cases!).

<strong>Favor Simplicity</strong>

It's sometimes easy to get caught up in wanting to use a new technology that you are just learning about,
or that seems to be trending. It's sometimes thought of as a more rare skill to be able to press your delete key.
Yes, that means pruning down the code to favor simplicity, and maybe do one thing really well. This fireworks
algorithm isn't perfect, but I found myself doing this at least twice, and I like the result better for it. 
This general way of thinking should be applied to more things. Before jumping into the newest trend, you 
might step back and ask yourself, "why?"

<strong>Consider Humans</strong>

I'm clearly not one of those developers that goes for the "one line solution." While we obviously need
to consider runtime optimization to some extent, I am a huge proponent of documentation and commenting
being a standard in writing programs. If you do a thing twice, write a function and explain the inputs
and what it does. This makes the code more likely to be used, run, and appreciated at some later date!

<strong>Consider Dependencies</strong>

One of the reasons it took me a long time to do simple things like combining matrices and calculations
is because I didn't want to introduce any large dependencies beyond what is offered in standard Python 3.0.
This means instead of using a library like numpy, I opted for the <a href="https://docs.python.org/3/library/math.html" target="_blank">math module</a>
or operations on lists instead of traditional numpy arrays. Of course, things like this are always troubling:

<div style="padding-top:10px; padding-bottom:20px">
   <img src="/assets/images/posts/fireworks/python-why.jpg" style="margin:auto; display:block">
</div>

> Python why do you do this to me?


<strong> Exposure of Variables</strong>

The decision about what variables to expose to the user is not one to be taken lightly! I had 
originally exposed the `start_time` as a function variable, and this made sense given
that fireworks were generated in the "internal recursive" way I first imagined. However, 
once I changed the algorithm and realized that, for the purposes of this little ditty, it would
be the case 99% of the time to have a start time at time zero, so I removed the exposure from
 command line exposure. It's one less thing for the user to be confused about.

<strong>Challenge Yourself</strong>

You (and by you I mean <strong>I</strong>) don't stop learning just because you have finished school. 
I never learned much during those times anyway, in college it was all about World of Warcraft, and I loved
graduate school but didn't take away much from attending lectures. On the other hand, I know that I learn
really well by trying to do something, and stumbling around until I figure it out. This way, I can almost
be guaranteed that if I challenge myself with interesting problems, life is going to be very rich! Or
at least if I don't, I tend to get bored :)

<strong>What next?</strong>

If you are administrator of a cluster resource, you could use a Singularity container
to play some customized (or random) fireworks when they log in to your resource(s) on the
Fourth of July. You might want to take a stab at overlaying fireworks for even cooler designs
(note that I set you up to do this! You can add a `matrix=True` to either of `generate_shape` or
`generate_center` to return the same context in a list of lists (a matrix). You would want to accomplish 
this without numpy.

Overall, I continue to be astounded by what relatively simple ideas plus some programming can come up with.
This is what makes the practice such a rewarding thing to do. That's all for now, have fun! Rawr!
