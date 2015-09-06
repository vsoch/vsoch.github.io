---
title: "Adding Trend Lines to Barplots in R: watch that x range!"
date: 2014-11-05 23:25:58
tags:
  barplot
  r
  visualization
---


Data visualization is extremely important. I never believe any kind of “significant result” until I’ve visualized it to see that there is some convincing difference or pattern. However, today I ran into some trouble when trying to visualize some of my data with a simple barplot. It’s silly enough that I think others might make the same mistake, and so it’s important that I share. Here I was trying to show “interesting gene probes” in a single brain region defined by being greater or less than 3 standard deviations of the mean (of the same probe across the entire brain) expression:

[![weirdo](http://vsoch.com/blog/wp-content/uploads/2014/11/weirdo.png)](http://vsoch.com/blog/wp-content/uploads/2014/11/weirdo.png)

The red lines on the top and bottom are the three standard deviation thresholds from the mean. The bars themselves represent the differences: above the line is above the mean, below is below. GREEN bars mean that the probe is above the three standard deviation threshold, and BLUE bars mean that the probe is below the three standard deviations. ORANGE bars are a randomly selected set of 100 probes that were not above or below. See any HUGE problem here? Yeah! There are green and red bars that aren’t above/below the line!

This is just NOT complicated. I was tearing out my hair (not really, don’t worry) and SO carefully going through my methods, but I couldn’t find anything wrong. Why was this so strange looking? Then it occurred to me, could it be that plotting a barplot of some size N bars does NOT correspond to x coordinates 1 through N? The answer is YES. When you add additional lines / stuffs to a barplot, you need to give it the x range of the original barplot. Here is how I was doing it before:

 mean","3 standard deviations code

“lines” is how you add a trendline to some plot. NOTICE that I was setting the x values to be a sequence from 1 to the number of data points (the rows of my data frame). That’s totally logical, right? Why would the x range be anything else? Nope! Bad idea! Not the right way to do it! Here is how it should be done:

 mean","3 standard deviations code

NOW notice that I am saving my barplot into a variable “bp,” and setting the x range of the lines to be… that variable. R is smart enough to know I want the sane x axis as was created in my barplo! Here is the fixed plot:

[![fixied](http://vsoch.com/blog/wp-content/uploads/2014/11/fixied.png)](http://vsoch.com/blog/wp-content/uploads/2014/11/fixied.png)

And now I can sleep at night knowing that I didn’t have trouble calculating means and standard deviations. :)​


