---
title: "Hacktoberfest 2018"
date: 2018-10-03 5:30:00
toc: false
---

On the Eve of Hallows Eve, and the last day of Hacktoberfest, it was already
hours after the time I should have gone to sleep. I was, like every technology-chained 
American, reading the endless stream of content on my "little internet,"
or my phone with improperly lit screens to keep me up well beyond what my biological
clock would allow otherwise. This was the time that a series of chained events
- the combination of Github and Digital Ocean's Hacktoberfest, Open Source Spirit, 
Avocados and dinosaur creativity would lead to...

## The 12 Days of Halloweenie

```
$ docker run vanessa/40-avocados
```

Today I will tell you a story written by a container, using a script that is driven by a tested tiny
database of items that add up to $40, currently a reasonably sized set that have been contributed via
Hacktoberfest fun in under 24 hours. This was unplanned, unexpectedly fun, and it 
all came together in under 24 hours! In this post, as you will see, I will tell you how my
Halloweenie came to be.

## The Apple Logo

It was in a Slack from a colleague I learned of this interesting news!

It was an announcement from Apple shared via [Hackaday](https://hackaday.com/2018/10/30/apple-introduces-what-weve-all-been-waiting-for/). The rainbow logo... he's coming back! I've never been a Mac user, 
but I do have memories of being a child and seeing other people's computers, and feeling 
a compulsion to rub the little logo like a genie lamp. Because anything shiny and plastic I
deemed must be a color changing mood ring sort of toy. Apple is likely 
restoring a lot of this legacy happiness by deciding to "bring back" their old school logo.
And it's only available for $40.00 "exclusively at the Flag Park Visitor's Center."

 > Wait, did I hear that right? $40.00 for a T-Shirt? Are you *mad* ?

I was inspired. I suddenly had a need to express my sentiment, and see visual affirmation
of "All of the other ways I could use $40.00." Because you know what I'd rather use $40.00
for, other than a T-shirt? Just about anything else. Especially 
something I can eat. Like [40 avocados](https://vsoch.github.io/40-avocados/avocados).

## 40 Avocados

In a flurry of programming and pushing to Github and connecting to Continuous Integration, in about
an hour I had a simple repository to read in a yaml file of things, links and images to describe them,
and quantities that might be obtained for $40.00. I didn't want to directly state my sentiment, but I made
the comparison pretty apparent because the first two things were these:

```yaml
  avocados:
    - number: 40
    - image: https://vsoch.github.io/assets/images/posts/truelove/avocado.png
    - link: https://vsoch.github.io/2018/truelove/
  apple:
    - number: 1
    - image: https://hackadaycom.files.wordpress.com/2018/10/applerainbowlogoheader.jpg?w=800
    - link: https://hackaday.com/2018/10/30/apple-introduces-what-weve-all-been-waiting-for/
```

What would you choose, dear reader? 40 delicious avocados, or just one T-shirt? You know,
you can get T-shirts for free at a lot of tech conferences or college events. My entire
wardrobe is mostly free T-shirts and stretch pants I got for $6.99 on Amazon.com.


## What Can I get for $40.00?

I then shared my little site, first on Slack where my colleagues didn't say much,
and then on Facebook where a few friends and fish were excited about how easy it was.
To the delignt of one, he could add a link to a picture of a espresso and immediately [get 20 of them](https://vsoch.github.io/40-avocados/espresso/) across the screen. 

<div>
<img src="https://vsoch.github.io/assets/images/posts/40-avocados/espresso.png">
</div><br>


Care for something more savory?
Why you might want a [McChicken!](https://vsoch.github.io/40-avocados/mcchicken/).

<div>
<img src="https://vsoch.github.io/assets/images/posts/40-avocados/mcchicken.png">
</div><br>

I should have stopped there... shame on me for spending this amount of time to make 
something so spurious! I went to bed around 2am, and decided at the last minute to
post a #Hacktoberfest issue on the Github repository. Little did I know when I woke
up the next morning...

## Hacktoberfest 2018

<div>
<img src="https://vsoch.github.io/assets/images/posts/40-avocados/hfest.png">
</div><br>

I was totally bombarded. And it continued throughout the day, until the entire
site had over 25 things, and there are still pull requests for me to review!
I learned a quick few, important things.

By the end of the day (sort of now?) we had:

<ol class="custom-counter">
 <li>A total of 76 pull requests, 50 closed.</li>
 <li>26 contributors, when the day before it was just me.</li>
 <li>People having fun! And of course, <a href="https://vsoch.github.io/40-avocados" target="_blank">the 40-avocados page</a></li>
</ol>

## Poetry Generator

But this isn't the end of the story! I wanted to create something that would live beyond
the repository, and use it, in whatever its current version is. So I build the 
[vanessa/40-avocados](https://hub.docker.com/r/vanessa/40-avocados/) container. 
You can use it to write text to the screen, or markdown.
Here is the text:

```bash

$ docker run vanessa/40-avocados
On the 128 day of Halloweenie my pusheena earthworm gave to me, ... dumplings
On the 60 day of Halloween my stanky despacito gave to me, ... rainbow-glasses
On the 40 day of October my fugly blackbean gave to me, ... avocados
On the 36 day of Hacktoberfest my chunky spoon gave to me, ... kitkats
On the 28 day of Halloween my butterscotch gato gave to me, ... white-bread
On the 26 day of Fall my swampy blackbean gave to me, ... jet-puffed-marshmallows
On the 24 day of Hacktoberfest my strawberry arm gave to me, ... nike-socks
On the 20 day of Halloweenie my peachy egg gave to me, ... espresso
On the 8 day of October my dirty pumpkin gave to me, ... waving-cats
On the 5 day of Hacktoberfest my phat parsnip gave to me, ... canned-unicorn-meat
On the 2 day of Fall my orange house gave to me, ... the-elder-scrolls-online
And arduino-mkr-zero just for me :)

```

and the same, but ask for markdown!

```bash
docker run vanessa/40-avocados markdown
```

<script src="https://gist.github.com/vsoch/741b36153d30388973a9f115ddac9286.js"></script>

Yes, the items are grabbed programmatically from the data file in the Github repo,
and the names of various things programmatically generated. It's in the style of "12 Days of Christmas"
if you don't see that from the structure. As more people contribute to the repository,
this tool can use their "40 things" too. Give it a try!


## Things Learned

My faith in open source, and in the world, has been weak given many recent events.
This was a nice reminder for me that sometimes it's okay to just have fun. The people
that want to have fun are out there. They too want to enjoy with you the magic of chocolate
bars, exploding glitter, and banana phones.

To Apple, for inspiring me with your colored logo, and to 
[all of the contributors](https://github.com/vsoch/40-avocados/graphs/contributors)
I want to say thank you, from the bottom of my dinosaur heart!

As the Halloween-time of present now turns into past <br>
I wanted to make something that would last and last <br>
Avocados, espresso, and whatever be! <br>
This is an expression of what you mean to me <br>

> I choose avocados

Now I really should go and like, eat something. And you should write your Halloweenie
poem! It's really quite fun :)


## Want to Contribute?
I was supposed to use time today to study, or last night to sleep, and I didn't. And now 
it's almost 9pm and I still have yet to make dinner, so if you contribute please expect
some delay in the pull request being reviewed! But I definitely will! And you can 
trust your "N number of things" will then be available to anyone that uses the poetry container.

So what say you, dear reader? What other N things could you get, instead of a T-shirt? [Open a pull request](https://www.github.com/vsoch/40-avocados/pulls)
