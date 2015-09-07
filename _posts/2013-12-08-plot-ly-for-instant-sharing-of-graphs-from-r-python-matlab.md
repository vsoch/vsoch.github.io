---
title: "Plot.ly, for instant sharing of graphs from R, Python, Matlab..."
date: 2013-12-08 21:55:37
tags:
  boxplot
  matlab
  perl
  plotly
  python
  r
  rest
---


I have been unbelievably excited to test out [plot.ly](https://plot.ly/api/), specifically the [API](https://plot.ly/api/) that is available for R, Python, Matlab, Julia, Arduino, Perl, and even REST.  As a graduate student that makes many plots, and then saves them as image files for upload somewhere, this instant-online-posting directly from my analysis software is sheer awesomeness.   I'll walk through the relatively simple steps for one application, R:

 

### Get Comfortable with plot.ly Interface

- First you need to sign up for a free account at [plot.ly](https://plot.ly/api/)
- Find your API key.  When you log in, click on "Access Plotly" from the drop-down menu in the upper right

[![step1](http://www.vbmis.com/learn/wp-content/uploads/2013/12/step1.png)](http://www.vbmis.com/learn/wp-content/uploads/2013/12/step1.png)

- Again, click on "Settings" from the drop-down in the upper right.  You will find your API key here!

[![step2](http://www.vbmis.com/learn/wp-content/uploads/2013/12/step2-300x93.png)](http://www.vbmis.com/learn/wp-content/uploads/2013/12/step2.png)

- When you are logged in at [https://plot.ly/plot](https://plot.ly/plot), all of your uploaded charts can be seen by clicking the tiny folder in the upper left

[![plots](http://www.vbmis.com/learn/wp-content/uploads/2013/12/plots-300x150.png)](http://www.vbmis.com/learn/wp-content/uploads/2013/12/plots.png)

 

### Sending plots from R to plot.ly

Plot.ly has it's own library, but I found that with my version of R, it told me that the plot.ly version wasn't supported.  I found it best to install directly from github using devtools.  You can also source the main [plotly script directly from github](https://github.com/cparmer/Plotly/blob/master/API/packages/R/plotly/R/plotly.R), however if you do this you will need to make sure that you have packages "RJSONIO" and "RCurl" installed.  To quickly post a plot from R to plot.ly, I made a little script that I can source, and then use with my data, username, and API key to create the plot:

code

You can then either go directly to the URL to see your plot, or log into plot.ly and click the folder icon in the top left.  This is just one example of using a boxplot - see [https://plot.ly/api/](https://plot.ly/api/) for many other examples and languages.  Feel free to tweak my boxplot script as a starting point for creating your own plots, because much of the code is by way of examples from their documentation.  Here is the finished plot (embedded in this post):

<iframe class="iframe-class" frameborder="0" height="480" scrolling="yes" src="https://plot.ly/~vsoch/0/" width="100%"></iframe>**As a disclaimer, keep in mind that the rules regarding data sharing and posting at your company or institution still apply!  While you can make a plot private, the data that you send to plotly would still be somewhere on their server, which would not be ok.  So - keep this in mind!


