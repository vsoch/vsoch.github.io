---
title: "Brain Matrix"
date: 2015-10-01 10:07:11
tags:
  javascript
---


I wanted to make a visualization to liken the cognitive concepts in the [cognitive atlas](http://www.cognitiveatlas.org) to The Matrix, and so I made the [brain matrix](http://vsoch.github.io/brain-matrix/ca.html) ([without branding](http://vsoch.github.io/brain-matrix)). Canvas was the proper choice for this fun project in that I needed to render the entire visualization quickly and dynamically, and while a complete review of the code is not needed, I want to discuss two particular challenges:


### Rendering an svg element into d3
The traditional strategy of adding a shape to a visualization, meaning appending a data object to it, looks something like this:

```
svg.selectAll("circle")
    .data(data)
    .enter()
    .append("svg:circle")
    .attr("cy",function(d,i){ return 30*d.Y })
    .attr("cx",function(d,i){ return 30*d.X })
    .attr("r", 10)
    .attr("fill","yellow")
    .attr("stroke-width",10)            
```

You could then get fancy, and instead append an image:

```
svg.selectAll("svg:image")
    .data(data)
    .enter()
    .append("svg:image")
    .attr("y",function(d,i){ return 30*d.Y })
    .attr("x",function(d,i){ return 30*d.X })
    .attr('width', 20)
    .attr('height', 24)
    .attr("xlink:href","path/to/image.png")
```

The issue, of course, with the above is that you can't do anything dynamic with an image, beyond maybe adding click or mouse-over functions, or changing basic styling. I wanted to append lots of tiny pictures of brains, and dynamically change the fill, and svg was needed for that. What to do?


#### 1. Create your svg
I created my tiny brain in Inkscape, and made sure that the entire thing was represented by one path. I also simplified the path as much as possible, since I would be adding it just under 900 times to the page, and didn't want to explode the browser. I then [added it](https://github.com/vsoch/brain-matrix/blob/master/index.html#L140) directly into my HTML. How? An SVG image is just a text file, so open it up in text editor, and copy-paste away, Merrill! Note that I didn't bother to hide it, however you could easily do that by giving it class of "hidden" or setting the visibility of the div to "none."


#### 2. Give the path an id
We want to be able to "grab" the path, and so it needs an id. [Here is the id](https://github.com/vsoch/brain-matrix/blob/master/index.html#L196), I called it "brainpath". Yes, my creativity in the wee hours of the morning when making this seems like a great idea is, lacking. :)


#### 3. Insert the paths
Instead of appending a "circle" or an "svg:image," we want a "path". Also note that the link for the image ("svg:a") is appended first, so it will be parent to the image (and thus work). 

```
svg.selectAll("path")
    .data(data)
    .enter()
    .append("svg:a")
        .attr("xlink:href", function(d){return "http://www.cognitiveatlas.org/term/id/" + d.id;})
    ...
``` 

I then chose to add a group ("svg:g"), and this is likely unnecessary, but I wanted to attribute the mouse over functions (what are called the "tips") to the group.

```
    ...
    .append("svg:g")
    .on('mouseout.tip', tip.hide)
    .on('mouseover.tip', tip.show)
    ...
``` 

Now, we append the path! Since we need to get the X and Y coordinate from the input data, this is going to be a function. Here is what we do. We first need to "grab" the path that we embedded in the svg, and note that I am using JQuery to do this: 

```
var pathy = $("#brainpath").attr("d")
``` 

What we are actually doing is grabbing just the data element, which is called d. It's a string of numbers separated by spaces.

```
m 50,60 c -1.146148,-0.32219 -2.480447,-0.78184 -2.982912,-1.96751 ...
``` 

When I first did this, I just returned the data element, and all 810 of my objects rendered in the same spot. I then looked for some X and Y coordinate in the path element, but didn't find one! And then I realized, the coordinate is part of the data:

```
m 50,60...
``` 

Those first two numbers after the m! That is the coordinate! So we need to change it. I did this by splitting the data string by an empty space

```
var pathy = $("#brainpath").attr("d").split(" ")
``` 

getting rid of the old coordinate, and replacing it with the X and Y from my data:

```
pathy[1] = 50*d.Y + "," + 60*d.X;
``` 

and then returning it, making sure to again join the list (Array) into a single string. The entire last section looks like this:

```
    ...
    .append("svg:path")
    .attr("d",function(d){
       var pathy = $("#brainpath").attr("d").split(" ")
       pathy[1] = 50*d.Y + "," + 60*d.X;
       return pathy.join(" ")
     })
    .attr("width",15)
    .attr("height",15)
``` 

and the entire thing comes together to be this!

```
svg.selectAll("path")
    .data(data)
    .enter()
    .append("svg:a")
        .attr("xlink:href", function(d){return "http://www.cognitiveatlas.org/term/id/" + d.id;})
    .append("svg:g")
    .on('mouseout.tip', tip.hide)
    .on('mouseover.tip', tip.show)
    .append("svg:path")
    .attr("d",function(d){
       var pathy = $("#brainpath").attr("d").split(" ")
       pathy[1] = 50*d.Y + "," + 60*d.X;
       return pathy.join(" ")
     })
    .attr("width",15)
    .attr("height",15)
``` 



### Embedding an image into the canvas
Finally, for the [cognitive atlas](http://vsoch.github.io/brain-matrix/ca.html) version I wanted to embed the logo, somewhere. When I added it to the page as an image, and adjusted the div to have a higher z-index, an absolute position, and then the left and top coordinates set to where I wanted the graphic to display, it showed up outside of the canvas. I then realized that I needed to embed the graphic directly into the canvas, and have it drawn each time as well. To do this, first I made the graphic an image object:

```
var background = new Image();
background.src = "data/ca.png";
``` 

Then in my draw function, I added a line to draw the image, `ctx.drawImage` where I wanted it. The first argument is the image variable (background), the second and third are the page coordinates, and the last two are the width and height:

```
var draw = function () {
  ctx.fillStyle='rgba(0,0,0,.05)';
  ctx.fillRect(0,0,width,height);
  var color = cacolors[Math.floor(Math.random() * cacolors.length)];         
  ctx.fillStyle=color;
  ctx.font = '10pt Georgia';
  ctx.drawImage(background,1200,150,200,70);   
  var randomConcept = concepts[Math.floor(Math.random() * concepts.length)];
  yPositions.map(functio
``` 

Pretty neat! The rest is pretty straight forward, and you can [look at the code](http://www.github.com/vsoch/brain-matrix) to see. I think that d3 is great, and that it could be a lot more powerful manipulating custom svg graphics over standard circles and squares. However, it still has challenges when you want to render more than a couple thousand points in the browser. Anyway, this is largely useless, but I think it's beautiful. Check it out, in the [cognitive atlas](http://vsoch.github.io/brain-matrix/ca.html) and [blue brain](http://vsoch.github.io/brain-matrix/) versions.
