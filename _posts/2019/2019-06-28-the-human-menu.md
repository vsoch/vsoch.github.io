---
title: "The Human Menu"
date: 2019-06-28 9:40:00
---

Humans use lists and suggestions to reduce cognitive load. I find myself doing
this at the end of the day when I move away from my computer and look to see
if there is anything interesting on "the little internet."
My phone offers a limited number of icons for social media, consumer-based, 
and news applications, so I click back and forth, and scroll indefinitely, 
and 15, 20, or 30 minutes of my life passes largely without me noticing.
I am the type of person that goes on Instacart or Amazon to find one thing,
and have the impulsion to review all items in the paginated results to
be sure I've found the best choice. When I was a kid I would be unable to
pick up a magazine without thoroughly reading every page. It sometimes doesn't
even feel like a choice - a stimuli is placed in front of me, and I consume it.
I have a feeling this is the case for a lot of people, but I wonder the extent
to which it is noticed.

## The Digital Attention Economy

I started to realize in college that controlling my behavior came down to 
controlling my environment. This meant everything from buying nutritious foods
that would make me feel good, to avoiding people that consistently made me feel
terrible. I've recently realized that the same is true for our attention. Without
conscious thought, our attention is easily gobbled up by the digital attention
economy. It's not that we don't have other choices, but rather that
we don't have a method for seeing them. Instead of offering a list of YouTube 
videos, endlessly scrolling social media posts, or phone apps, we could
scroll through a human menu?

## The Human Menu

The <a href="https://good-labs.github.io/human-menu" target="_blank">Human Menu</a>
Project is part of the <a href="https://good-labs.github.io/" target="_blank">Good Labs</a>
initiative that aims to use technology for the greater good. It's a simple statement to create awareness that despite technology largely turning us into digital turnips, we can also use it to encourage us to interact with
the real world. The Human Menu provides a prototype for a "human menu," or a selection of items
that contrasts the tendency to mindlessly browse social media or similar
applications.

<div style="padding:20px">
<a href="https://vsoch.github.io/assets/images/posts/human-menu/human-menu.png"><img src="https://vsoch.github.io/assets/images/posts/human-menu/human-menu.png"></a>
</div>

When you click on an item, it's moved into the "done" list, and you can
also refresh the suggestions, add a custom item to the suggestions for later,
or completely reset the list.

<div style="padding:20px">
<a href="https://vsoch.github.io/assets/images/posts/human-menu/done.png"><img src="https://vsoch.github.io/assets/images/posts/human-menu/done.png"></a>
</div>

It uses local storage to keep track of your items suggested, newly added, and completed,
so you can navigate away from the page and come back to where you left off.
The project is inspired by the problems outlined 
by <a href="https://humanetech.com/problem/" target="_blank">The Center for Humane Technology</a>,
specifically that our attentions are captured by addictive "digital slot 
machines" to the detriment of our mental health. While the items in the example
above might not be perfect for you (for example, if you really don't like Puzzles, or
baking, you might not like the list), you can easily fork the repository and edit
the items to your liking. Let's talk in more detail about how you can customize
it for your use case and contribute!

## How do I contribute or customize it?

The suggested items are read in from a <a target="_blank" href="https://github.com/good-labs/human-menu/blob/master/human-menu.csv">human-menu.csv</a>, and if you look at the `index.js` file that drives 
the page, you'll see that creating the menu is a simple matter of instantiating a HumanMenu, and then reading 
from file:

```javascript

var menu = new HumanMenu()
menu.load_csv("human-menu.csv")

```

We then add custom interaction with buttons on the page, such as event listeners
for clicking the reset, refresh, or add new item button. I'm not a front
end developer, so the library and interface are simple. And
for this reason, your contribution (or sharing of your forked customization) 
would be greatly appreciated! What might you do?

<ol class="custom-counter">
   <li>You can add an item to the default list.</li>
   <li>You can use the current list in the web interface, and add your own items interactively.</li>
   <li>You can remove all items and use it as a simple todo list.</li>
   <li>You can create a new interface for the same HumanMenu object.</li>
</ol>

You can make a customized list for someone that you care about (for example, maybe
an older family member with memory issues could benefit from a list of suggested activities?)
or remove the loaded items, and even build an interface that serves as a todo list.
When you've made a contribution, please open a pull request. If you have
any questions or issues, you can <a href="https://www.github.com/good-labs/human-menu/issues" target="_blank">open them here</a>.

[![https://good-labs.github.io/greater-good-affirmation/assets/images/badge.svg](https://good-labs.github.io/greater-good-affirmation/assets/images/badge.svg)](https://good-labs.github.io/greater-good-affirmation)
