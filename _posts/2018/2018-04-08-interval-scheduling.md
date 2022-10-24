---
title: "Interval Scheduling"
date: 2018-04-08 8:30:00
toc: true
---

To put it plainly, sometimes I get bored. Data structures and infrastructure are my
most favorite of things to think about, but sometimes the problems at hand aren't
particularly challenging, and my brain just wants to chew on something a bit more
substantial. After college I started doing some Project Euler algorithms, and this
time I think I'll (still) do implementations of random algorithms. 
This time, however, I want to apply a bit more personality to what I am doing.
I want to put these little implementations under similar scruity that I might 
something I'm working on. I also want to add an element of fun. Fun is sort of 
uncommon when I look around the interwebs for implementations and examples.
Let's start with the idea of [interview scheduling](https://en.wikipedia.org/wiki/Interval_scheduling).
The <a href='https://github.com/vsoch/algorithms/tree/master/interval-scheduling' target="_blank">code is here</a>
 if you are interested. Or just skip everything and run the thing with Docker:

```bash
# Random selection of N
docker run vanessa/algorithms:interval-scheduling

# Choose N to be 6 for 6 contender events
docker run vanessa/algorithms:interval-scheduling 6
------------------------------------------------------------------------------
Generating random 6 intervals...

------------------------------------------------------------------------------
New Activity (0419:0728) purple-staircase-airing-8988
New Activity (0048:0394) purple-nalgas-stoning-0425
New Activity (0306:0767) conspicuous-sundae-circus-1586
New Activity (0824:0871) boopy-milkshake-burping-3169
New Activity (0339:0758) red-peas-cooking-4518
New Activity (0503:0750) eccentric-animal-trick-or-treating-8623
------------------------------------------------------------------------------
Chooosing greedy intervals...
------------------------------------------------------------------------------
Step 1 added Activity (0048:0394) purple-nalgas-stoning-0425
Step 2 added Activity (0419:0728) purple-staircase-airing-8988
Step 3 added Activity (0824:0871) boopy-milkshake-burping-3169
Total steps taken: 3
------------------------------------------------------------------------------

We have a final set of 3 activities!
------------------------------------------------------------------------------
Chosen Activity (0048:0394) purple-nalgas-stoning-0425
Chosen Activity (0419:0728) purple-staircase-airing-8988
Chosen Activity (0824:0871) boopy-milkshake-burping-3169
```


## Interval Scheduling

> Given N activities with their start and finish times. Select the maximum number of activities that can be performed by a single person, assuming that a person can only work on a single activity at a time.

If you were an overbooked teacher with 25 student events on your schedule, you could plop
them into this greedy algorithm and get back a schedule that doesn't have any overlaps.
It comes down to the following steps. You keep doing these steps until your original
list is empty.

<ol class='custom-counter'>
   <li>Sort the activities by soonest finishing</li>
   <li>Remove the first (the soonest to finish) from the list, and add to your chosen</li>
   <li>Remove remaining events from list with start times before the recently chosen end</li>
</ol>

This is not complicated because you could do it in few lines of code. I decided to have a bit
more fun, and make an `Activity` object, along with supporting functions, and verbose
printing. I first want to talk about my choices for the implementation, followed by a fun
exercise to assess the optimality of this greedy approach.

## Activity
As is indicated below, an Activity is an object to hold a start and end time, along
with a name for the activity. There are supporting functions for printing these
things to the user, and one external function is used to generate a tuple range 
for the start and end time (in the format `(start, end)`). I will break up the
(contiguous) code into sections below to show the different components.

```python

class Activity(object):

    def __init__(self, start_time=0, end_time=1000):
        '''an Activity is a named event with a start and end time. The start
           and end times are randomly generated on a uniform scale

           Parameters
           ==========
           start_time: the starting time of the interval to select from        
           end_time: the ending time of the interval to select from        

        '''
        self.start, self.end = get_interval_time(start_time, end_time)
        self.name = namer.generate()
        self._action("New")

```
The first set of helpers are for printing. These are python class (default)
functions used when an object or its representation isprinted to the console.
In my case, if someone were to create an Activity and then type it into the 
terminal, I want the response to be informative. This is what these functions 
do:

```python

    # Printing Functions

    def __repr__(self):
        return self.__str__()

    def __str__(self):
        return "Activity (%04d:%04d) %s" % (self.start,
                                            self.end,
                                            self.name )
```

These are just printing helpers. If my entire Activity class is only intended
to be chosen and then announce that, I'm going to have a function "choose"
that does exactly that. 

```python

    def choose(self):
        '''run the activity! This will basically print the start,
           activity name, and end time to the console
        '''
        self._action("Chosen")


    def _action(self, action=""):
        '''Print the event name, start and end times, prepended with action

           Parameters
           ==========
           action: the name of the action to prepend.

        '''
        print('%s %s' %( action, str(self)) )
```

This is a good example for how I think about classes:

> classes are generic holders for a set of variables, with functions to expose them in the way that is most meaningful for the intended use.

When you create an activity, it might look like this:

```python

activity = Activity()
New Activity (0415:0667) hairy-soup-celebration-4046

activity.start
415

activity.end
667

actiity.name
hairy-soup-celebration-4046'

```

## Intervals
Where do the start and end times come from? This function!

```python

def get_interval_time(start_time=0, end_time=1000):
    '''get a random interval time between start time and end time.
       Start time and end time should be in integer units

       Parameters
       ==========
       start_time: the starting time of the interval to uniformly select from        
       end_time: the ending time of the interval to uniformly select from        

    '''
    if end_time <= start_time:
        print('end time %s cannot be at or before start %s' %(end_time,
                                                              start_time))

    # Select randomly from a range between start:end
    start = random.randint(start_time, end_time)

    # Do the same, but update range to start at start :)
    end = random.randint(start, end_time)

    # If we hit edge case of start=end, just do it over with defaults :)
    if start == end:
        return get_interval_time()

    return (start, end)

```

The units of time are generic, and done so for this exercise. If the implementation
was for a particular unit of time, then the user could either specify these defaults
in this function to generate the range, OR (better solution) would be to
define or carry them through the Activity object. 

_What would need to change as is currently?_ 

The format string for the activity, specifically the number of leading zeros should be taken into account, along with
the fact that we generate random *interval* times. If decimal times were desired,
both the format string would need to adjust to be for decimal, and the random selection
to use `random.uniform` multiplied by some scale.

_Why did I do it like this?_ 

I chose integer and constraints to ensure non-overlapping start and end times. For
the input `start_time` and `end_time` I did a direct check, and then upon completion
I do one more check and run the function again if we hit the same weird case of
an event with zero length. This could get even more complicated - if this function
were used beyond a single example with defaults we would want to save the values for
`start_time` and `end_time` chosen by the user, and pass them forward to the next
try.  Actually, this brings up a fun idea... for another post :)

## Scheduling
Now that we have an Activity object that includes a randomly selected 
interval, we need to do the scheduling and ensure that we choose a subset of
these Activities that don't overlap! Let's take a look at the function to
do that. It's again pretty straight forward, with way more commenting and
extra verbosity than is needed. I can't help it if my programming and writing
styles are similar :)

```python
def interval_schedule(activities):
    ''' Given N activities with their start and finish times. Select the maximum 
        number of activities that can be performed by a single person, assuming 
        that a person can only work on a single activity at a time.

        Strategy: choose activities just by always selecting the one that ends
                  soonest. Then dump other ones with starting times before that.

        Parameters
        ==========
        activities: a list of tuples of (start,end) time for activities

    '''
    chosen = []
    step = 0

    # Sort activities so by soonest ending
    activities = sorted(activities, key=lambda act: act.end)    

    while len(activities) > 0:

        step+=1
        
        # Choose the earliest end time, tell the user
        activity = activities.pop(0)
        activity._action('Step %s added' % step)

        # Add activity to start always, since earlier are added later
        chosen.append(activity)
        
        # Keep track of some removed metrics for the user
        keep_removing = True

        # Remove (pop) other activities with start times earlier than the start
        while keep_removing and len(activities) > 0:
            next = activities[0]
            if next.start < activity.end:
                _ = activities.pop(0)
            else:
                keep_removing = False


    print('Total steps taken: %s' %step)

    # Return... the chosen ones!
    return chosen
```

Let's break this down. The first thing that we do is sort our activities
based on the soonest ending:

```python

# Sort activities so by soonest ending
activities = sorted(activities, key=lambda act: act.end)    

```

The "key" variable tells sorted what to sort by. Using lambda is a Python way
(I believe requested by Lisp?) to specify a "function on the fly" that you
intend to use once and expose of. The function above says that, for each
activity (act) in activities, return the attribute "end" and use that as the
key to sort. I had originally put this inside the while loop, however this would increase
the complexity of the algorithm to `O(n^2)` because for N points, we were
doing a sort that required going through all N each time. I had some 
<a href="https://github.com/vsoch/algorithms/issues/2" target="_blank">help</a> 
to properly fix this, and the advice is so beautifully written I'll share it
here:

> The current complexity is O(n^2) because whenever we are looking for overlaps against a given task we check against all remaining tasks. By keeping track of the chronological order of when the tasks start, we can ensure overlapping tasks with the task that ends soonest always come first. This way we don't have to check all tasks for overlaps, but instead iterate until either there are no more tasks or the next task doesn't overlap (since none of the following tasks would overlap either). This reduces the runtime complexity to O(n logn) because of the required sorting steps.

Boum! The next part says that we are going to go through the list of activities 
until there are none left. These are "unchosen" activities, of course.

```python

while len(activities) > 0:

```

The logic inside the loop is simple. We pop off the first and add it to our chosen
list (knowing that it has the earliest ending time) 

```python

# Choose the earliest end time, tell the user
activity = activities.pop(0)
activity._action('Step %s added' % step)

```

The `_action` function just prints a pretty message to the user.

```python

Chosen Activity (0639:0759) quirky-kitty-sneezing-4672

```

We then add <a href="https://www.youtube.com/watch?v=N4Qaz2gKptw" target="_blank">the chosen one...</a> err activity to our list of chosen!

```python

# Add activity to start always, since earlier are added later
chosen.append(activity)

```

and then we use the fact that the list is already sorted to our advantage. 
We can remove others from the list of activities for which the start time is before the
chosen activity end time (meaning there is overlap). This could have been written
out in fewer lines, but I like to use variable names to more easily tell me what's going on.

```python

# Keep track of some removed metrics for the user
keep_removing = True

# Remove (pop) other activities with start times earlier than the start
while keep_removing and len(activities) > 0:
    next = activities[0]
    if next.start < activity.end:
        _ = activities.pop(0)
    else:
        keep_removing = False

```

We break from this second while loop when there are no longer any activities
or keep removing is False (indicating the next activity is not overlapping).
 As we go, we keep track of steps, and report the final number to the user:


```python

print('Total steps taken: %s' %step)

```

The keeping track of steps is just to tell the user what is going on, it's 
not really necessary. I originally put this at the end of the loop, but realized
it was cleaner to report the final number at the end without having to add 1 to 
it. Instead of initializing the variable steps at 1, it was easy enough to start
at 0 and add 1 on the first loop. I use zero indexing, but I generally count 
starting with 1. Then we return the !chosen ones! to the user:

```python
# Return... the chosen ones!
return chosen
```


## RobotNamer
And where do those names come from like `quirky-kitty-sneezing-4672` ? The 
<a href="https://github.com/vsoch/algorithms/blob/master/interval-scheduling/robotnamer.py" target="_blank">RobotNamer</a>, of course! This is one of those little extra fun things that I added.

## Putting it All Together
To put it all together, we run the script and it looks like this:


<script src="https://asciinema.org/a/175080.js" data-speed="3" id="asciicast-175080" async></script>

meaning you call
```python

# Randomly select N
python main.py

# Set N to 15 contender activities
python main.py 15

```

And the above works by putting the commands together like this:

```python

def main():
    '''the entrypoint to the interval-scheduling algorithm example. In
       this function, we:
 
       1. start with a random integer N
       2. generate a list of N activities, each with start, end, and name
       3. greedily choose intervals that don't have overlap

       We keep the user updated as we progress, and print the final schedule.

    '''

    # If the user provides an argument, it's N
    N = random.choice(range(1,15))
    if len(sys.argv) > 1:
        N = int(sys.argv[1])

    section('Generating random %s intervals...\n' %N)

    # Generate activity objects, each with start/end times and name
    activities = [Activity() for x in range(N)]

    # Get the schedule with no overlaps (greedy)
    section('Chooosing greedy intervals...')
    chosen = interval_schedule(activities)

    section("\nWe have a final set of %s activities!" % len(chosen))

    # Tell the user!
    [activity.choose() for activity in chosen]

```

The section function simply prints the pretty lines around a section. You've seen the
rest. That's about it!

## Harder Questions
This wouldn't be fun if I didn't challenge myself to think about harder questions!
For the first, I'm not going to tell you because I already started implementing
something fun around here. Here are some generic (fun) questions to answer
that are along these same lines, maybe you might want to give one a go too and
we can talk about it?

 - What if we ask for the range and/or constraints needed to allow for exactly N activities?
 - What if the selection pool of start/end times wasn't uniformly distributed?
 - What if the selection algorithm was dependent on time?
 - What real world things do all of the above apply to?
 - Just <a href='https://github.com/vsoch/algorithms/tree/master/interval-scheduling' target="_blank">give me code!</a>
