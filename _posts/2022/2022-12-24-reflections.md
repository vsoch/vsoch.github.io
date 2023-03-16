---
title: 2022 Reflections
date: 2022-12-24 12:30:00
---

This is my annual "Reflections" post, and I have a lot to reflect on this year! In no particular order, 
this year I have started to have more awareness about career progression, and how the barriers to success, and even interactions with people,
can have quite a bit of variance depending on whom you are. As I <a target="_blank" href="https://twitter.com/vsoch/status/1480008229811732480">recognized</a> these subtle
inequalities, I also realized there is a tendency to forget to acknowledge people that go against this grain, and are supportive. 

So dear reader, let's reflect! This is a reflection post for 2022 where I want to talk about what I've learned about myself, the challenges around me, and also give whole-hearted
thank yous to people that have shown me kindness and acceptance. Those two things usually come hand in hand. Let me first tell you about my incentive structure. 

## What are my underlying values?

I am someone that had heartbreak early on, and fell back on building self-worth from work. Although I sometimes
wish this didn't happen to me, I am grateful that it was able to push me toward a path of more independence and not
having reliance on others for validation. This means that the core of my underlying values (aside from being a generally
OK human being) are focused around this question:

> What do I need to be fulfilled in my work?

When I think about this question, I realize that it's less about someone providing with me something, and _more_ about being well-matched
to work that I'm interested in and not having people get in the way. I'll explain what I mean by this later, and I'll also say that
a definition of "success" is hugely going to vary by the individual. For me, my focus and flow at this time of my life comes from my
work. To be frank, work has been the most consistent source of feeling valued and a sense of belonging. So as you read these
reflections, understand this is the life experience I'm coming from. 

## Who I am grateful for

Let's start with the people that I'm grateful for! I started writing this list in the early months of the year, and likely
there are more small cases of people that I forgot to add. In no particular order, thank you:

### To Eduardo

For seeing <a href="https://twitter.com/vsoch/status/1478913234136494081" target="_blank">this tweet</a> and reaching out to me, "Hey V, let's have a call and I'll tell you what I'm excited about."
When I started the year I wasn't working on projects that inspired me, and I didn't feel valued. Although it took me a few months to culminate a plan to ultimately be the driver
of my own destiny, this small act of kindness was a message that there are people out there wanting to support me.

### To Todd

For using every possible fiber of his influence to support his colleagues, and more generally being a prominent and positive voice for change in a direction that I think is good. In practice (for me) this means helping to review documents or talk content, and diving into black holes to enable us to do the work we need to do. I didn't come up with this visual, but I have very funny mental imagery of Todd bursting through the wall like the Koolaid main just about anytime that anyone needs him. Does anyone know how he does it? Not really, but I think we are grateful that he does. 

### To James

Or [@wetzelj](https://github.com/wetzelj) on GitHub for his continual support of [pydicom/deid](https://github.com/pydicom/deid/pulls?q=is%3Apr+is%3Aclosed).
This is one of the open source projects I continue to maintain that is explicitly for working with dicom header data, and he doesn't hesitate to
find an issue, report it, and quickly resolve it, often writing the most robust cases I've seen from any contributor.

### To Tim

To go back to a comment from Eduardo's thank you, I started the year not feeling well-matched to the work I was doing.
The realization hit me in the first few months, and by March or April I had decided it was up to me to be accountable for
the future that I wanted to see - no deus ex machina was going to do that for me. I want to touch on this later,
but often it's possible to be vocal about the kind of work you want to do, but it's often hard for others to see and then
support your vision. This means that while we can first default to trusting external entities to listen and respond to our wants, 
in practice we need to take ownership of them. At least this is my experience.

Thus, when I found myself in a place of not being happy with my current assignment and not feeling heard, I took action.
I first embarked on a plan to ensure that my current project was successful. This meant a two-pronged approach. First,
I would <a href="https://github.com/buildsi/smeagle-py" target="_blank">complete software</a> that implemented the exact model that 
was desired. This was a fairly arduous process, as it involved reading a 100+ page PDF document about the System V ABI and writing
rules for register mapping to map to DWARF parsing, but we were successful in this first draft. "We," you say? My partner
in crime was Tim. We would pair program multiple times a week, often for 2-5 hours, and going into the deepest bowels of
DWARF and the System V ABI. Compiler work isn't my cup of tea, but with Tim it was not just tolerable, but fun! Although
it was not computationally feasible to use this model in our ultimate set of experiments (we ran them on GitHub actions to specifically
not use some private compute resource, and the data we would extract for our model was enormous) I am proud that despite everything, we took an almost 
impossible problem, and came up with an implementation in a few months. I was terrified to speak up to voice this desire but
am happy that I did. I am proud of us for taking ownership of the work and coming up with a solution.

The next part of the plan was doing work, albeit simple, that would contribute to the space. Early on I had
ideas about what should be early steps for this kind of work, and believing that I likely didn't know best, I followed
instruction to follow someone else's vision. I realized after the fact that my vision for a step 1 had value,
and further, I was empowered to make it happen. Although I wish I had done this sooner, later is better than never!
When there would be about one year remaining for the project funding, I embarked on a plan to run 
well-defined and scoped experiments that would contribute to the space. 
This meant <a href="https://github.com/buildsi/spliced" target="_blank">writing software</a> and 
automation needed to run them, and then writing up the results into a paper. We were again
<a href="https://arxiv.org/abs/2212.03364" target="_blank">successful</a>, and in a short few months. 
Tim was, during this time, a source of support and fun, and really was the driving force for the final analysis
portion of the paper. I have Tim to thank that my frustration didn't turn into sadness,
because I wasn't entirely alone.

### To Becky

For the times that I felt I wasn't being heard, I sometimes didn't know who to turn to. But then
I remembered Becky. Becky has been someone that listens, and really hears what I am saying. 
I am so grateful to have her as a leader, and someone that I can turn to
when I need help. 

### To Flux Framework

Given my main project was winding down, the second half of my plan was figuring out how to replace that time.
I wanted to explore projects that I cared about, because importantly that's when things are fun and it doesn't feel like work.  
I had a piqued interest in <a href="https://flux-framework.org/" target="_blank">Flux Framework</a> as possibly one of the 
coolest projects going on, but I was disconnected from it. So what does a proactive dinosaur do? 
In late summer I started showing up to various meetings along with associated
projects, and was seeking out ways to help. Even though I'm not a C++ developer, there were many opportunities for
automation, containerization, and working on the Python bindings, and I jumped in. And despite my quirks I felt accepted and 
valued by the team. It was such a quick change of feeling in my day to day that it gave me pause and led me to reflect. I needed to take a more proactive
role in being the primary driver of fostering new collaborations, or more generally, relationships. 
It also made me realize that during times when I didn't feel valued, it possibly wasn't a match in terms of communication
or working style. That doesn't mean necessarily that someone is in the wrong or did something bad, but rather
that change might be good.

My heart was ultimately strongly captured by a vision for (what we are now calling) Converged Computing, 
or combining the best of both worlds between high performance computing and cloud. I jumped on the opportunity to implement the 
<a target="_blank" href="https://github.com/flux-framework/flux-operator">Flux Operator</a>, or in simpler terms a controller for
Kubernetes that creates Flux Framework "mini clusters" to run jobs. It embodies this exact vision of converged computing,
allows me to program in Go and learn enormously, and have regular project meetings with a really fun, diverse
set of collaborators that I have come to care about. I made a Thanksgiving ice cream turkey and shared pictures with them
in chat, and that was OK to do. And I feel like the group is fun. I never thought I'd say this, but I really enjoy
having many hour long coding or "hackathon" meetings to work on complex workflows or debug. We had two hackathon meetings
this week and one meeting, and I legitimately felt sad when the last one ended because I knew we wouldn't meet again until the
new year.

### To Leads that Enable

The same sentiment of belonging and being valued belongs with the teams where I spend the other half my time.
This time is spent working on developer tooling, or more generally, efforts to improve developer productivity and happiness.
I won't name the projects specifically, but I'll say that I've found an environment where my ideas are championed, supported,
and I feel shared excitement in a future vision. While these are early, I've taken the lead on several other (now approved)
<a href="https://github.com/converged-computing/" target="_blank">projects</a> that are in this area of developer tooling or experience.
This is an important area of work for me because it keeps me somewhat connected to the heart and soul of the lab,
the application teams that are doing the science and the developer teams that are supporting them. I am so grateful
to the leaders of these groups that provided me this support, and especially one lead that regularly checks in with me,
"How are you?" Those three words are powerful.

### My Singularity HPC Colleagues

In the beginning of 2021 I started a personal project called Singularity Registry HPC or "shpc."
It was an idea I had for a while, but I hadn't pursued it because nobody was asking for it.
But then, my (now colleague) from Australia reached out to me, and it was exactly what he needed.
I got to work, and what has unfolded over the last two years has been magical. It has been the
quintessential fun, open source experience that I often crave. We get excited about ideas, both
myself and my collaborators jump to work on them, and then we built something cool! At the end
of this year after a round of updates we stepped back and looked
at some work we did and said <a href="https://arxiv.org/abs/2212.07376" target="_blank">Hey, let's
write this up!</a>. It was maybe the first time I was excited to write a paper. It also made me
really excited to start my "second work day" at the end of the work day. I'd often finish official
work and jump right into working on shpc, often into the late evening. It kind of worked because
half my colleagues were in Europe or Australia and it would be morning soon for them. I know some
of you are shaking your heads or rolling your eyes, and I get it. Should I do
this all days, and every day? Of course not. But it's hard to avoid late night programming sessions
when you are excited about something and you have to make time outside the work day.

### My Best Friend

I was a loner for most of my end of college and graduate school. I was a transfer student (and this was possibly a mistake)
and was plopped down into a fairly cold and challenging (to say the least) college culture that was at best lonely.
I was a "tag along" person with random established groups of friends, and probably just invited out of pity.
Things started looking up after I entered the work world and was living independently and finding my love of programming,
but I was still a loner. This continued into graduate school, at least until 2015 when I stumbled on my best friend in
the oval. He offered to walk me home, and eventually walk me to and from campus after several surgeries where I needed a 
little help. We became inseparable, and when my wireless died on a day in early 2016 and I
set up a dinosaur fort under his bed to camp it out, well? I never moved out. It's been 7 years now, and I feel like I have a family.
Is it a bit non-traditional to live with your best friend? Sure, and especially in our society where a guy and girl living
together are assumed to be a romantic couple. But he is my family. He accepts me exactly the way that I am, basically
makes sure that I eat and don't die, and we go on biking and running adventures together. I've never felt this level of
acceptance and comfort from another person. My mental health and continuing to thrive during this pandemic I owe to him.

## What am I grateful for?
 
Now that I've said some thank you's, let's talk about what I'm grateful for! Indeed, there are many things.
I am grateful for my work, and ability to conduct it with general temporal freedom. You can't pay for that. I am grateful
that I'm able to isolate and avoid getting COVID, and live with someone that shares my level of risk tolerance. I'm grateful
that despite a few decades of not-so-lucky health events, I've been healthy and happy living by the mountains.
I'm grateful for the strength of my body and ability to run or bike, and be immersed in that experience of
feeling most alive. I'm grateful to my favorite food, avocados, that help me keep my weight up, my hair shiny,
and feeling happy and full! I'm grateful for superficial fun things - like watching Sandman, Wednesday, and Stranger Things on Netflix. There is nothing better
than immersing in the fantasy world of a TV show and having something you look forward to in the late evenings!
Other superficial things are getting new, colorful and beautiful sneakers that I know will serve me well, and
pretty much anything that lights up. I will forever love colored lights, driving through tunnels, and light shows,
and appreciate my astigmatism that gives the lights beautiful auras when I take off my glasses. I'm grateful for the
small set of songs that I played on repeat this year, 
including <a href="https://open.spotify.com/track/0V3wPSX9ygBnCm8psDIegu?si=3ff9e326f0f04233" target="_blank">Taylor Swift's "Anti Hero"</a> (I feel this song),
and "Blinded by the Light" by the Weeknd. Here I am captured in a moment of pure joy to be going for a run with glow sticks.

<iframe width="560" height="315" src="https://www.youtube.com/embed/ZdhWtPLJj6U" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

I'm grateful for music. Music elevates me consistently to have this level of joy and happiness. Is it hacking my emotions a bit?
Maybe. But really, it's not so bad being able to turn on a song and go into a zone of happiness and (often)
super productivity along with it. 

And finally, I'm grateful to be my authentic self. For so many years I've self-monitored, and tried to be
what I thought others wanted of me. If I tried living with family I felt constantly inadequate or just wrong - I never
put my dishes in the right place, or I used the dining room table for puzzles and computering and it was supposed
to be kept perfectly ready for company at a moment's notice, or I was "Vaness the mess" for leaving socks on the floor.
I never felt quite comfortable enough in my environment to even explore my authentic self, because I knew it was not acceptable.
In traditional social situations I was the one out because the noise of the venue was too much, or to be frank,
I got really bored really quickly with whatever it is people talk about when they socialize. I've felt like
I didn't belong in most places for a lot of my life, and I think this took a turning point when I met my best friend
and realized he didn't judge me for being silly or imperfect, and then this awareness was able to trickle
out into my regular life where (every so often) I share little bits of my happiness - dancing, creative endeavors, 
or just acting silly. I started to realize that my authentic, honest self was not a negative, but a huge positive.
It brings life to people and ideas. It makes the world a little more interesting and fun. This by far has been the best 
part of my early and mid (and now later) 30s. I started to just let go of all of that and be unapolegetically myself.
Instead of spending time wondering "Why am I not good enough for (this person, this job, etc.)" an older, wiser me is realizing I'm OK just the way 
that I am. I am enough, and I am drawn to people that accept and support me, and I don't have to give the time of
day to people that tell me I should make myself smaller (to possibly deal with their own issues around self worth).


## What have I learned?

For all the positives that happened this year, there were a few notable hard times. I won't talk about all
of them, but I do want to share high level ideas that I learned.

### Injury

In Fall of 2021 I increased my mileage, and too quickly. I was on cloud nine - running immensely fast, and being
able to hold it for a long period of time. An unexpected pain in my foot side-lined me for about 7 months. Based on the location
I assumed it was a stress fracture, but after a long period of time when it wasn't recovered I did some more reading and realized
it was plantar fasciitis, something I had never had, and likely resulted because I wasn't wearing appropriate running shoes
(I had these random, clearly not for running Nike shoes). I also have fairly archy feet. Once I started doing the proper stretches and wearing proper
shoes, I healed almost immediately (and felt very dumb for waiting that long). I then got back into running, started
to feel fast and strong again, and then disaster struck again -- I tripped on an apple on the road in the dark. My ankle
not only took all of my body weight, but it had force because I was moving, and it twisted in ways I didn't think were possible. 
I'm a very bendy person, so normally I could twist my ankle and it would just be fine, but this time I was in such immense
pain that I cried out, was a bit in a shock and didn't move from where I fell, and cars were stopping to ask if I was OK. I was more afraid of COVID exposure from
unmasked people than an injury so I would thank them and assure them I would be OK. Ultimately I needed my apartment
mate to carry me home, and I remember just sitting on the kitchen floor with ice and crying,
this time because of the sadness realizing the injury was fairly bad. But I knew I didn't shatter anything or possibly
need to go to the hospital because there wasn't much swelling or visible damage - it was just immensely painful.
That was about 8 weeks ago, and I'm happy to  report that (I think?) it's mostly healed and I'm slowly going back to using it normally. I've added more strength
training and stretching, and I invested in a headlamp and will generally try to avoid running in the dark.
The lesson here is two-fold. First, it was an affirmation that my general risk-aversion is probably a good idea.
E.g., my general sentiment is that it's not a good idea to run outside after it's dark. Secondly, it's another
example of when bad things happen, you make the best of them and focus on self-care to get through it. I love
running. I know I'll be back to running fast, and I'll be more careful.

### Expectations of Support

Now I want to talk about some of the points from <a href="https://twitter.com/vsoch/status/1480008229811732480" target="_blank">this tweet</a>
and alluded to in the beginning of my post. Let's start with an idea around equality. Imagine that you are on equal par with another 
new person at your institution, and you find out that a third party is presenting this other new person with many opportunities. 
It occurs to you that this wasn't something this person ever did for you. You brush it off and assume that you didn't need that kind of support.
However, then you get feedback from this same third party that you are not having enough reach. It's something you need
to work on. You realize in a moment of disappointment that you are not only getting unequal treatment, but either this
third party isn't aware of it, or is setting you up for failure. The underlying reason doesn't matter, because 
either way you are penalized for it.

This is a very real scenario. We expect people to treat us equally. The harsh reality is that
this doesn't always happen, and it often goes under awareness. The lesson we learn (fortunately or unfortunately)
is that we cannot rely on anyone else to provide us with opportunities. We need to do that for ourselves.
I suspect this happens (and under awareness) because it's easy to have more liking for someone that is more like
yourself, and then take more of a special interest in their success. When you look around and there is no one
that looks or thinks like you, you are essentially on your own. I often wonder if this is why we typically
see one particular kind of demographic or personality in positions of leadership. Or when you don't, you know
they had to be twice as excellent or work twice as hard (or more!) to get there.

### Specialty and Interests

Just because you _can_ do something doesn't mean that you have to. E.g., imagine that you
get assigned a project at work, and while you can go through the motions, your heart isn't in it.
You feel unfulfilled. The lesson is that because we can do things does not mean we should.
We are allowed to have a voice (and I believe we should) to express what we want to do, and take
tiny steps toward that vision. If you don't speak up, your career trajectory is essentially like a plastic
bag blowing in the wind. The challenge here, of course, is related to matching. Project groups,
or more generally, communities, vary in communication style and preferences, and it's easy to feel
like a weirdo in one community, and completely accepted by another. This is why not just matching your
interests but also preferences for communication and communication style is important. It shouldn't
be the case that you feel out of place, ignored, or like when you say something it's annoying to others.
When you find a community of people that is a match, you tend to just know. My advice is to inch closer
to the people and communities that make you feel accepted and excited about the shared goals, 
and away from those that don't.


### Being Heard

Articulating yourself regularly and clearly doesn't always equate to being heard. Here is another scenario.
Imagine that you have regular conversations with someone, and you regularly communicate your ideas, vision,
and what you need to be successful. Despite these efforts, you find that not only are you not being heard,
but that the person has applied their expectations for a person similar to themself to you, and it's
actually causing you emotional distress. You don't feel that you have psychological safety, and you
don't know what to do. In these cases, if it's truly the case that talking to the person has not worked,
there are probably two options. If you can identify someone that will hear you - meaning truly listen to what
your are saying and mediate the situation - you can reach out and ask for help. If not, then you are again
on your own. In the short term to assuage the distress, you can choose to cave into this person's expectations.
I don't like this solution because often it means making ourselves smaller, meeker, or pretending to be something
we are not. But this is often a survival tactic that we must consider to make the interactions tolerable, and 
give us time to think about a new strategy. A new strategy could be everything from placing less importance
or frequency on interactions with this person to looking for a new job. During this process we must recognize that
communication is hard and different styles don't always work well. There is always room to grow and have
conversation that can move both parties toward a better place. On the other hand, there are also cases
where no matter what you do, things don't get better. I would strongly advise against remaining in a situation where you are not heard.
You won't be happy, or grow professionally that way.

### Others' Comfort

An unspoken reality I've realized this year is that a lot of behavior is assessed for how comfortable it
makes (or doesn't make) other people. If someone is threatened by your productivity, ideas, or even happiness,
they can go out of their way to try and hurt you. This might mean reporting you under the guise of a community
document for an opinion you shared, giving feedback that your quick work speed was exclusionary to them,
or speaking poorly about you behind your back. In a mature community, the first report would be identified
as ridiculous, because people are allowed to have opinions and disagree. In the second piece of feedback,
a logical first question would be to ask if the person articulated their desire to be involved (and indeed
they likely did not) and for the third, we would hope someone in the conversation would address the comment
and get to the underlying reason for it, which typically is someone's own insecurity. However, in reality
these things don't happen. The report is taken seriously, the feedback is considered valid without question,
and the derogatory gossip flows. There are two things I think we can do here. The first is, if you find
yourself wanting to report someone, step away for a bit and give your emotions some time to settle. Often
knee-jerk reactions aren't our best thoughtful response, and as I've mentioned before, we should choose
communication over accusation. For the second, the answer is again communication. If you felt left out,
well, other people cannot read your mind, and you need to express your wants or needs to contribute. It would
be hugely unlikely for a third party to not include you if you explicitly say you want to help. And finally, if you hear someone talking poorly about
someone else, speak up. 

For all of the above, if you are the person that has been placed responsible for someone else's comfort,
my only advice is to speak up for yourself, and make conscious decisions to step away from people and/or 
communities that are toxic in this way. Take one step away, and one step closer to other people and communities
that will not treat you this way. 

### Society

I understand some people think that the pandemic is over. Or they have stopped wearing masks,
and don't mind getting COVID multiple times. I <a href="http://vsoch.github.io/2022/covid-precautions/" target="_blank">am not in this boat</a>,
and am on the far side of the conservative spectrum. I'm disappointed with how our society has handled this pandemic, as we have
failed to protect the most vulnerable, and people don't seem to want to do things 
<a href="https://www.youtube.com/watch?v=vLyJN9EImoU" target="_blank">that aren't their favorite thing</a> or not be in denail
about the future implications of their choices. The ultimate realization
for me is that my own safety and wellness are entirely up to me, and society is not looking out for me. 
This comes with some sadness because it means my hand is forced -
if there is no way, for example, to travel with assurance of safety, I don't know when the next time I'll see my parents is, nor do
I know if I'll ever be able to foster new relationships or be able to meet my colleagues that I've come to care about.
I was really excited to move to the mountains and possibly meet new people and colleagues, but as I see my 30s pass by,
I'm wondering if this is going to be the reality for the long haul. Maybe I never will foster new relationships, or
strengthen existing ones. It's just sad, and has left me with an aura of disappointment during this holiday season.


## What is the overall theme?

The common thread across what I've learned this year is resilience and scrappiness.
I am somewhat surprised that these ideas still apply as someone further along in their career,
but perhaps my original hopes were too idealistic. We can't always get all the resources or support that we need to be successful at something.
This is when it's time to be scrappy. Instead of placing blame on someone else, we take responsibility
for the successful outcome of the things we care about, and often in the face of challenge,
inequal treatment, or just hard problems, we can be creative to find solutions and ultimately be
successful. We will maybe always have to work many times harder, or be many times more impressive,
to have an "equal" spot at the table. But I like this mindset of taking ownership because it's very easy to feel resentful when you realize you
are treated differently or poorly, and that particular emotion is not particularly productive or useful. This mindset 
places focus on positive, proactive action, and makes these other people trivial. They just don't
matter, and thus they cannot touch you - your mental health or your ultimate professional success.
And of course the flip side of this mindset is expressing gratitude to those that are supportive,
which was my original goal in writing this post today. Because the reality is that you can never please everyone. You can't both be quiet enough and loud enough,
nor can you be advancing your learning and career without rubbing someone's feathers the wrong way.
And I'll close with a <a href="https://vsoch.github.io/2022/wild-one/" target="_blank">post</a> that gave me strength
earlier this year.

    When someone tries to make you feel very small,
    Just remember that you run mountains
    If they really want to touch you,
    they are going to have to keep up. :)
    

What will 2023 hold? I could optimistically say I hope the pandemic gets better, but I don't truly believe that - I think
things can get much worse. So I'll just say onward to continued fulfilling, fun, work, and enjoying it with the inspiring
people that are also along for the ride.
