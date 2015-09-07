---
title: "Flask Banner Image Application"
date: 2015-6-28 00:03:02
tags:
  fun
  projects
---

Two interesting circumstances combined today, and the result was a fun project that, like most things that I produce, is entirely useless. However, it is a Saturday, which means that I can fill my time with such projects that, albeit being useless, are awesomely fulfilling to make.  The two circumstances were **1)** I really like making Flask applications, and **2)** I am highly allergic to pushing around pixels in Illustrator/Inkscape.


### And what happened?

I found myself needing to make a banner graphic. It was a simple style – a text string of my choice hidden inside randomly generated letters. I then realized, to my despair, that this would require at least 10 minutes of using Inkscape. Nothing could be so painful. My creative brain then started up its usual humming. If I could make this svg dynamically, I could add beautiful animations, or minimally, some kind of interactivity to it. I could even make a tool so that, the next time I needed one, I wouldn’t have to start from nothing. This resulted in the “banner-maker.” A few points:

  >> **Fonts**: come by way of [Google Fonts](https://www.google.com/fonts). There are over 600 in the database, and I randomly selected just under 200. All of these fonts are added with a [single css link](https://github.com/vsoch/banner-maker/blob/master/templates/generate.html#L17).

  >> **Input Data:** includes hidden letters inside of a randomly generated list, x and y coordinates, as well as two colors. I wrote a [standalone function](https://github.com/vsoch/banner-maker/blob/master/make_logo.py#L13) to generate such data.

  >> **Application:** is of course flask! We parse the user input from the page, and [update the url](https://github.com/vsoch/banner-maker/blob/master/templates/generate.html#L86), which re-renders the page with a new graphic.

  >> **SVG:** is of course produced with simple [text nodes](https://github.com/vsoch/banner-maker/blob/master/templates/generate.html#L135) a la D3.




The biggest issue is that my button to save the svg image does not render the Google Fonts, and because of this I added a box for the user to copy paste the svg code for his or her application. It’s not perfect, but my original intention was not to generate the tool, but the python code so that I can build a cool interface with more interactive functionality integrated into this banner. It was fun to make, and now I’m ready for a long walk home and a good dinner.

**Banner-maker** [[github](https://github.com/vsoch/banner-maker)] [[demo](http://www.vbmis.com/bmi/project/banner)]

 


