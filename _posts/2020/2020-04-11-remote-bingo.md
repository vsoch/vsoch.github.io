---
title: "Remote Bingo"
date: 2020-04-11 14:15:00
category: rse
---

I've been trying to think of creative ways to have some asynchronous fun, and
when I was planning a research software engineering day (now postponed, for obvious reasons)
for Stanford, one of the activities I thought would be fun is some kind of Bingo.
If it were in person, it would have been easy enough to hand out paper sheets, and have
participants either fill out items while listening to talks, or to take the boards
"home" and complete with their lab over some specified amount of time.  When this was 
no longer possible but the <a target="_blank" href="https://us-rse.org/2020-04-09-virtual-workshop/">US-RSE Virtual Workshop</a>
was being discussed, I jumped at the idea of (still) injecting a little fun with playing Bingo.
I quickly realized it would be much easier for participants to have a virtual (web-based)
game, and I could imagine people playing along while checking off items like:

<ol class="custom-counter">
  <li>Talks about their research cluster</li>
  <li>Tweet shown on slide</li>
  <li>Asks the audience a question</li>
  <li>Slide with all pictures</li>
  <li>Cat walks across the screen</li>
</ol>

It would be so fun! The issue of course, which came up in a conversation with one
of the coordinators for the virtual conference, was that it would be distracting.
And I have to agree, it definitely could be. So while I was disappointed that my 
Remote Bingo idea couldn't be officially done, I realized that it was still a 
great idea! I could create a simple remote bingo game that any remote person 
could play on their own, or in a more multiplayer sort of setting
(conference calls? virtual happy hour? during a remote conference? watching a movie?). In that we can
participate in conferences without wearing pants, or with our pets, what would
stop someone that wants to have fun from playing Bingo? Exactly. I wanted to build
a very general tool that would have many use cases, be easy to customize, and
hopefully afford some fun in these strange times.

## Remote Bingo

I had some fairly simple goals for this application. I wanted:

<ol class="custom-counter">
  <li>A simple board interface with items to click</li>
  <li>A scoring mechanism</li>
  <li>An ability to clear or reset a board with new items</li>
  <li>Choosing to use a new list of items</li>
</ol>

And for all of the above, I wanted it to be easy for the user to fork
the repository, change some text files to have their own updated items,
and deploy on GitHub pages to deploy their own game. Actually, given that you
have a list of items:

```

Item,tags
Seeing where your coworkers live, "remote"
Sorry I've been having networking issues, "remote,conference-call"
Cat walks across the screen,"remote,conference-call"
Rethinking your response to how you are doing, "remote, covid-19"
Oh sorry go ahead, no you go ahead, "remote,conference-call"
Piano starts playing in the background, "remote,conference-call"
Docker automated build fails, "rse"
Ask for help on Slack and you're ignored, "rse"
GitHub goes down!, "rse"
Confuse a child with a pet, "covid-19"
Talk to a pet cat or dog like they are human, "covid-19"
Can you hear me now?, "remote,conference-call"
Outdoor noises during a call, "remote,conference-call"
Child or animal noises during a call, "remote,conference-call"
A Disney themed breathing mask, "covid-19"
Drinks before 3pm, "covid-19"
Attend a virtual happy hour, "covid-19,remote"
A Disney themed breathing mask, "covid-19"
Toilet paper sold out at the store, "covid-19"
Woke up later than 10am, "covid-19,remote"
Netflix asks if you are still watching, "remote,covid-19"
Start a new project, "remote"
Feel overwhelmed with video calls, "covid-19,remote"
Give alcoholism a try, "covid-19,remote"
Start a puzzle, "covid-19,remote"
Bake bread, "covid-19"
Think about toilet paper left, "covid-19"
Do it anyway, "covid-19"
Feel nervous around a package, "covid-19"
Take a nap, hope that dinner is soon, "covid-19,remote"
Overwater your plants, "covid-19"
Develop a super weird routine around getting groceries, "covid-19"

```

The above is the contents of the default "remote-bingo.csv" that the application 
serves on start, you can then create the Bingo instance, add the default list,
and then add other lists for the user to choose from:


```js

$(document).ready(function() {

    var bingo = new Bingo()
    bingo.load_csv("remote-bingo.csv")
    bingo.add_bingo_list("bingo-lists/new-programmer.csv")
    bingo.add_bingo_list("bingo-lists/quarantine-cooking.csv")
    bingo.add_bingo_list("bingo-lists/indoor-activities.csv")
    bingo.add_bingo_list("bingo-lists/virtual-conference.csv")

});
```

Here is the active board!

<div style="padding:20px">
  <img src="https://raw.githubusercontent.com/rseng/remote-bingo/master/img/remote-bingo.png">
</div>


And then the user can change the board to another in the list at the bottom of the page:


<div style="padding:20px">
  <img src="https://raw.githubusercontent.com/rseng/remote-bingo/master/img/choose-list.png">
</div>


The above should give you a hint that I created additional boards for programming
items, quarantine cookie, indoor activities, and (in spirit of the US-RSE virtual conference)
a virtual conference. If you are interested in the implementation, you can see my 
terrible JavaScript skills at the repository, <a href="https://github.com/rseng/remote-bingo" target="_blank">rseng/remote-bingo</a>.
The file with the Bingo instance is <a href="https://github.com/rseng/remote-bingo/blob/master/assets/js/remote-bingo.js" target="_blank">remote-bingo.js</a>. If you want to play bingo, then go straight to 
<a href="https://rseng.github.io/remote-bingo/" target="_blank">https://rseng.github.io/remote-bingo/</a>.


## How do I play?

Generally, you get a bingo notification when you fill in a row, column, diagonal, or
fill the entire board. It's up to you (and your family, friends, or colleagues) how
you want to decide on what constitutes a win, and the context to play in, period.
See the [other ideas for lists](#other-ideas-for-lists) to get some inspiration.
A game of bingo could be played over a night of watching movies, during the duration
of a conference call, or over a longer period of time. Given this choice, you can
decide how is best to declare bingo (for shorter events, saying Bingo! is probably
sufficient, but longer events might need an email with a screen shot of your board).
If I were planning an event, I'd make sure to use a much longer list of items to
increase the variety of boards generated, and to give good prizes to winners.
If you want to play, go to <a href="https://rseng.github.io/remote-bingo/" target="_blank">https://rseng.github.io/remote-bingo/</a>
and again, please contribute to the repository to improve the lists, or add a new list.


## Contributing

If you'd like to contribute, here are a few ideas:

### 1. Create a custom list

I've created a set of good starting lists (see [bingo lists](#bingo-lists) but of course
there is great room for improvement, or even making new lists! 

### 2. Add a color picker

While not essential, it would be fun to allow a user to choose the color to highlight
the squares. It would require adding a color picker (perhaps to the bottom right)
and then storing the chosen color with the Bingo instance. To do this best,
it would be nice to not add additional javascript dependencies.

### 3. Support for Cache

Currently, if the user closes the browser window, the current game and its state
are lost. It would be nice to have an ability to cache a state, and then
refreshing the browser would still keep the state.

### 4. Tags

Currently if you look in the bingo list csv files, there is a second column
for tags that aren't used. I was thinking that it would be nice to be able
to load a very large file of items, and then filter down to some subset of
categories.

### 5. Explosive Congratulations

I think that when the user fills the entire board, there should be a more
explosive congratulations (confetti or small animals dancing across the screen?)
I think this could be done with some kind of simple css animation, again,
with preference to not add additional dependencies.

### 6. Saving Board

For games that aren't done live, it would be good to allow for saving to file
of the screen. I've done this many times, but typically with svg, so I'm open
to ideas for how to best implement this for standard html/css.

## Bingo Lists

The following lists are provided with the current Remote Bingo interface.

### Remote Bingo

The default "remote bingo" includes items that are related to working remotely,
COVID-19, and general conference calls.

<div style="padding:20px">
  <img src="https://raw.githubusercontent.com/rseng/remote-bingo/master/img/remote-bingo.png">
</div>

### Quarantine Cooking

The idea here is that you would play this board long term with friends, and try
to get bingo with funny cooking ideas.

<div style="padding:20px">
  <img src="https://raw.githubusercontent.com/rseng/remote-bingo/master/img/quarantine-cooking.png">
</div>


### Virtual Conference

This board would be fun to play on your own or with a small group while watching
a virtual conference. You might not want to tell the conference that you are playing. :)

<div style="padding:20px">
  <img src="https://raw.githubusercontent.com/rseng/remote-bingo/master/img/virtual-conference.png">
</div>


### Indoor Activities

This is another quarantine related board, but specific to activities. There is a lot
of room for improvement here!

<div style="padding:20px">
  <img src="https://raw.githubusercontent.com/rseng/remote-bingo/master/img/indoor-activities.png">
</div>


### New Programmer

This list is intended for someone learning to program. There could be a lot of 
improvement here as well, I can only do so much on a Saturday!

<div style="padding:20px">
  <img src="https://raw.githubusercontent.com/rseng/remote-bingo/master/img/new-programmer.png">
</div>


### Other ideas for lists

Here are some other ideas that I had for lists - if you'd like to contribute a csv file
with items I'd be happy to add to the interface for you to use with your family and friends!

#### Moving Watching Bingo

If you (remotely) watch a shared TV show or film, you could have a board specific to that.
It could even be scoped to include themed items (e.g., scary movies, romantic comedies, TV series)
and I'd imagine it should also include people's reactions to watching.

## Thank you!

I want to say a quick thank you to [A Game of Dabs](https://codepen.io/nbrombal/pen/JAedG) on Codepen
that I was able to refactor into a Vue.js application to serve a custom board.
I'm terrible at JavaScript and this example was exactly what I needed to get started.
That's all folks! Have fun <a href="https://github.com/rseng/remote-bingo">playing!</a>,
and if you are an #rseng please consider attending the <a target="_blank" href="https://us-rse.org/2020-04-09-virtual-workshop/">US-RSE Virtual Workshop</a>!
