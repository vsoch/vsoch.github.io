---
title: "Open Source Halloween"
date: 2021-09-25 08:30:00
category: rse
---

Now that we've officially entered Fall, I think it's fair to be thinking about pumpkins,
scary stories, and my favorite holiday... Halloween! Sure, I don't go trick or treating anymore,
and I definitely don't eat any candy, but there is something hugely magical ✨️ about this time
of year. I am drawn to the oranges and purples, the coolness of the air, and the sudden
inundation of candy and festive holiday things at stores (well, at least back when I went to stores before February 2020!). 

## Open Source Halloween?

If you are an open source maintainer, you are likely familiar with <a href="https://hacktoberfest.digitalocean.com/" target="_blank">Hacktoberfest</a>, which I (think) has been around since maybe 2014, and the spirit
of the effort is to get people excited and participating in open source. But in recent years,
Hacktoberfest has been more of a <a href="https://blog.domenic.me/hacktoberfest/" target="_blank">stress</a>
on open source maintainers than anything else. I have high hopes that the issues will be resolved, but in
the meantime I was left to ask myself

> How else can we have fun for Halloween?

This is where I came up with the idea of 🍬️ Open Source Trick or Treating 🍬️.
The idea would be simple - as you visit repositories, if they offer a piece of candy, you
can grab it and go trick or treating, and add to some basket. Now, since I don't control or work at
GitHub and can't add a magical "trick or treat" button, I had to be clever about how to go about this.
This led to my idea for the following:

<ol class="custom-counter">
  <li> Use a candy generator to create a piece of candy for your repository.</li>
  <li> Put it somewhere in your repository named in a way it can be discovered.</li>
  <li> Create a community "treat bag" that discovers and displays the files!</li>
</ol>


The steps above were fairly simple, but it took me a few weekends to get everything in place, because, well,
making web interfaces can be a bit slower than other kinds of programming, and further, creating custom images of candy on the fly is no small task! For the rest of this post, I'll talk about the different steps.

## The Candy Generator

The <a href="https://vsoch.github.io/candy-generator" target="_blank">candy generator</a> is what took me a few evenings to make. It generates pieces of candy that look like this:

<div class="padding:20px">
<img src="{{ site.baseurl }}/assets/images/posts/open-source-halloween/open-source-halloween-2021.png">
</div><br>

Don't worry, not all of the candy is pink! The generator allows you to customize the colors, candy texture, candy shape, and then load a specific repository to load the candy "nutrition facts" and logo. Here is another one:

<br>

<div class="padding:20px">
<img src="https://raw.githubusercontent.com/pydicom/deid/54c8f68fe1fa0ea65371b78b30e265646ccae49d/docs/assets/img/open-source-halloween-2021.png">
</div><br>

### Candy Shape

The candy shape (and editing it on the fly) was something I wasn't sure I could do, but I thought I might figure it out. I first started with a basic process to generate an svg shape. I would start with an actual piece of candy, trace the bitmap in Inkscape, and then tweak the surrounding points to both change and smooth out the shape to my liking. I could then save to this file as an svg with a single color. Then I needed to add it to a web page. I was first experimenting with adding it via an <a href="https://d3js.org/" target="_blank">D3</a> shape, also just using basic javascript to load it and add to the page. That worked okay, but it was fairly hard to interact with further. I then had the insight that all I really needed were the paths, and in fact, d3 was very good at manipulating paths. This is the solution that ultimately worked, because I could create a bunch of candy svgs, and copy paste the paths (and other metadata) into a data structure to load into d3. You can see the data structure (json) <a href="https://github.com/vsoch/candy-generator/blob/main/assets/js/candy.json" target="_blank">here</a>, and an example with annotations is below.

```json
{

  # The name of the candy path is "crunch" and this is the path from the svg
  "crunch": {"paths": ["M 903.641 370.032 C 902.541 369.749 892.344 ... 370.032 Z"],

    # Each candy needed a custom transform to position in the interface
    "transform": "translate(38.130333,-41.091284)",

    # These are extra attributes to add!
    "attrs": [
      [
        "fill",
        "#482f1e"
      ],
      [
        "stroke-width",
        1.33333337
      ],
      [
        "fill-opacity",
        1
      ]
    ],

    # These help with positioning
    "yoffset": 80,
    "xoffset": 100,
    "transform": "translate(6.7638037,-29.309819)",

    # And making sure the size looks okay
    "scale": "0.8"
  },
...
```

With this data structure, I could have a basic formula for the user to select
some preferences in a panel, and then update the svg with the choice. And in fact that is how most of the interface works - we keep an object that has the state of things (colors, shapes, textures) and then change those attributes when you make some new selection. Here is is a snippet that shows mapping a datum like the above to the page as an svg:

```js
this.svg = d3.select(this.divid).append("svg")
    .attr("id", "svg")
    .attr("width", this.width)
    .attr("height", this.height);

this.group = this.svg.selectAll('paths')
    .data(Array(choice))
    .enter()
    .append("g")
    .attr("transform", function(d) {return d.transform})

this.paths = this.group.append('svg:path')
    .attr('d', function(d) {return d.paths})
    .attr('id', "candy-path")
    .attr('transform', function(d) {return "scale("+ d.scale + ")"})
...
```

You can see the entire javascript file <a href="https://github.com/vsoch/candy-generator/blob/main/assets/js/candygen.js" target="_blank">here</a>. It's implemented as a class (the reference to "this") that you can instantiate
with the loaded data:

```js
fetch('assets/js/candy.json')
  .then(response => response.json())
  .then(json => {
     var candygen = new CandyGen(json);
})
```

I had higher aspirations to use Vue.js and include even the html with a component to plug
in anywhere, but about half-way in I had trouble getting d3 and Vue to live side by side.
I think there is <a href="https://alligator.io/vuejs/visualization-vue-d3/" target="_blank">a way to do it</a>
but it involves npm and that is something I just won't touch.

### Candy Texture

I found a lovely <a href="https://riccardoscalco.it/textures/" target="_blank">texture library</a> that
I suspect data scientists will love that allowed me to generate textures on the fly, map them to names for the user to choose, and then to update the interface with a new choice. This is how you can easily click "carrots" and then
see that texture (^) appear. This logic is a pretty long and redundant function you can see <a href="https://github.com/vsoch/candy-generator/blob/main/assets/js/candygen.js#L141-L248" target="_blank">here</a>. It was really very fun coming up with the textures, and if you'd like to generate one and add to the interface please open a pull request!

### Nutrition Facts and Branding

The coolest part is loading a repository by name, and then seeing "nutrition facts" pop up that show the number of stars, subscribers, the repository description, and the repository name and logo. This was <a href="https://github.com/vsoch/candy-generator/blob/main/assets/js/candygen.js#L105-L112" target="_blank">fairly easy to do</a>, and comes down to making a request to the GitHub RestFUL API.

```js
fetch('https://api.github.com/repos/' + uri)
    .then(response => response.json())
    .then(data => {
         console.log(data);
         window.github_data = data;		
    })
    .catch(error => console.error(error));
```

This is another likely source of error - I'm not sure how rate limiting works for un-authenticated requests on GitHub pages, although I suspect that it just uses the un-authenticated endpoint associated with the ip address of the request. If anyone knows, please let me know!

Finally, I decided to write the date (year) on the candy, so if this continues forward into the future, we can distinguish candies from different years. Maybe they will be collectible items, har har. 😄️

### Missing Functionality

I've had experience with saving svg or canvas to file before, but this time around since either fonts were lost
or the exact look of the candy wasn't quite right, I didn't get it working as I wanted, so I opted for the instruction to the user to
"take a screen shot." This of course isn't perfect (and if I had infinite time I might come back to this) but it's definitely missing functionality.

## The Final Page

<div class="padding:20px">
<img src="{{ site.baseurl }}/assets/images/posts/open-source-halloween/candy-generator.png">
</div>
<br>

Tada! That's it! If you haven't yet, check out the <a href="https://vsoch.github.io/candy-generator" target="_blank">candy generator</a>! It was so fun to make. See, you don't need to be an official "frontend" designer to make front end things, even with basic javascript, html, and css.

## Trick or Treat!

After I had the candy generator, I wanted a way to trick or trick. Since I couldn't control GitHub and add a button, I considered making a browser extension, but decided against that because I personally hate installing extra extensions. I also thought about making a GitHub action where a user could add a list of repos with candy to "discover" but ultimately decided that was too much work. I changed my mindset from "How can a user trick or treat" to "How can the entire community Trick or Treat" (and celebrate open source projects) and realized that I could make a single interface that would discover these files! I've had experience doing this for other find-able files with the <a href="https://singularityhub.github.io/singularity-catalog" target="_blank">Singularity Catalog</a> and <a href="https://spack.github.io/spack-stack-catalog/" target="_blank">Spack Stacks</a>, so this was a matter of customizing the script to do a different search, and capture and save a slightly different set of metadata and files to render into a GitHub pages site.  The steps are simple:

<ol class="custom-counter">
  <li> Search GitHub for files named "open-source-halloween-2021.png"</li>
  <li> Clone the repository to find the file to save, and save if we haven't seen the digest yet.</li>
  <li> Save to jekyll data (yaml) and javascript (js) files to load into interface.</li>
  <li> Run a nightly job to update it!</li>
</ol>


The searching and parsing over results was fairly simple and easy, and there was a bit of novelty with checking digests and then generating the interface, discussed next!

### Image digests

I was worried about someone forking a repository with a candy image, and then the image being added twice. The best way to prevent this, I thought, would be to calculate the digests of the images, and skip over those that we've already seen. Yes, this could mean that if for some reason a fork of your repository with the same image is indexed before your repository, you'd see their image and not yours, but ultimately if it's a fork it will lead to your repository, so I'm not hugely worried. In Python it's pretty simple to calculate a digest for an image (or any file really):

```python
def get_digest(filename):
    """
    Don't add repeated images of candy (from forks, etc.)
    """
    hasher = hashlib.md5()
    with open(filename, "rb") as fd:
        content = fd.read()
    hasher.update(content)
    return hasher.hexdigest()
```

So I first load the images that are already present in the repository and data, and then 
calculate digests for all of them, and upon discovery of a new repository, I only add images that
we have not seen anywhere else yet.

### The Interface

The interface is a lot of javascript and styling, and I don't need to go into details, but <a href="https://github.com/rseng/open-source-halloween" target="_blank">check out the source code</a> if you are interested. It will allow you to browse open source candies

<br>

<div class="padding:20px">
<img src="https://raw.githubusercontent.com/rseng/open-source-halloween/main/assets/img/open-source-halloween.png">
</div>
<br>

And for any candy, mouse-over to see it larger, and click to see more metadata and links to explore!

<br>

<div class="padding:20px">
<img src="https://raw.githubusercontent.com/rseng/open-source-halloween/main/assets/img/trick-or-treat.png">
</div>
<br>

I really love all the candies, here is another one!

<br>

<div class="padding:20px">
<img src="https://raw.githubusercontent.com/rseng/open-source-halloween/main/_candy/singularityhub/sregistry/docs/assets/img/open-source-halloween-2021.png">
</div>

### Automate!

It's not hard to automate - we can basically run a nightly GitHub workflow to do exactly that. It will run the script and push updated results. For larger projects I've found that I've hit "secondary rate limits" of the GitHub API, and this worries me because I suspect these are for things that are malicious, but I hope that GitHub realizes I am definitely not that!

## How to contribute?

There are so many ways to contribute or have fun with this project! 

### Make Candy

Obviously the most straight forward thing to do is create open source candy with the <a href="https://vsoch.github.io/candy-generator" target="_blank">candy generator</a>. If you don't want to do it, open a "good first issue" for Hacktoberfest (or not if you aren't participating) asking someone to create and add one to the repository. You don't need to display it at the front of the README, but if you do, it would be a lot of fun, and feel free to link to these tools so others can have fun too.

### Edit the Generator

There could be much improvement to the generator! It would be nice to have a button to save directly to a png (with the correct name) and further ability to customize the candy. Any contributions to <a href="https://github.com/vsoch/candy-generator" target="_blank">the candy generator</a> would be greatly appreciated.

### Design a Trick or Treat Tool!

As I alluded to earlier, there could be other ways to emulate trick or treating - perhaps a browser extension, a GitHub action, or something else I haven't thought of. I would love to see others get excited about Halloween and make a new project to supplement these two. 

## Why should I care?

I think it's easy in our current culture to be a consumer. We consume experiences that others provide for us, and we consume things that we buy. If you look at a typical social media account, it's common for people to re-post, re-tweet, or just mindlessly consume what others have provided for them. I have a slightly different mindset, because I consider myself more of a producer than a consumer. I like building things, or making things, and sharing them. The lesson h ere, if there is any lesson, is that we don't need companies or those in power to provide us with experiences. We can create out own, share it with others to enjoy, and also possibly inspire those others to make them too.

That's all friends! Happy Fall, and happy Halloween season! 🍂️
