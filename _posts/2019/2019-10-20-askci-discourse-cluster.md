---
title: "AskCI Discourse Clustering"
date: 2019-10-20 12:00:00
categories: rse
---

For those interested in data science that might be member or admin for a <a href="https://www.discourse.org/" target="_blank">Discourse</a> community, I wanted to provide something to get you
started with analyzing your content. What kind of questions might you ask?

<ol class="custom-counter">
  <li>How do topics cluster based on content?</li>
  <li>Can we cluster based on tags to see how well we are tagging?</li>
  <li>Is some variable (e.g., likes) associated with views?</li>
</ol>


This comes down to <a href="https://github.com/hpsee/discourse-cluster/blob/master/export_posts.py" target="_blank">exporting posts</a> using the discourse API, creating a container to run a Jupyter notebook for with dependencies
that I need, and then exporting data to json to generate (much better) d3 plots. I wanted to answer these questions for <a href="https://ask.cyberinfrastructure.org/" target="_blank">AskCyberinfrastructure</a>,
and I knew that I didn't have much data, so it would be a first analysis that might
be re-run as the community grows over time. 

> If you have a community with a lot of data, I think you can generate some awesome plots, and should give it a try!


## Reproducibility?

While this was a quick project and the steps for reproducibility aren't perfect, I decided
to organize data exports based on the export date:

```bash
$ tree data/2019-10-19/
...
├── ask.cyberinfrastructure.org-q-a-tags-2019-10-19.json
└── ask.cyberinfrastructure.org-q-a-topics-2019-10-19.json
```

and build (and <a href="https://hub.docker.com/r/vanessa/askci-cluster-gensim/tags" target="_blank">push to Docker Hub</a>) a container that is tagged based on the date as well. If an interested party wanted to reproduce or otherwise
interact with my notebooks, they could pull and run the container. 

```bash
$ docker run -it -p 8888:8888 vanessa/askci-cluster-gensim
```

See the <a href="https://www.github.com/hpsee/discourse-cluster/" target="_blank">repository</a>
for complete instructions. The export script is simple enough (it only requires standard libraries) so I didn't choose to include it inside the container. I'll also note that if you are trying to use the ruby gem to get all your topics, you 
will run into <a href="https://meta.discourse.org/t/discourses-api-get-just-the-number-of-search-results/76548/5" target="_blank">the same issue I did</a>.

## Too Long, Didn't Read

Of the three bullets above, I worked through the first two, and I'll lay out how I would go about
the third for an interested person. If you want to jump to the plots go to 
<a href="https://hpsee.github.io/discourse-cluster/" target="_blank">hpsee/discourse-cluster</a>,
and for the data (to perform your own analysis, and possibly answer question three!)
see <a href="https://github.com/hpsee/discourse-cluster" target="_blank">the repository</a>.

## 1. Clustering of Topics

For the first analysis I wanted to use a library that I was fond of in graduate school for NLP called
<a href="https://radimrehurek.com/gensim/index.html" target="_blank">Gensim</a>. Gensim (in Python) is 
a library for extraction of semantic topics from documents. We are going to use it 
to cluster the extracted topics from AskCI. What does this mean?

<ol class="custom-counter">
  <li>Start with raw text from topics (a topic is made up of smaller posts, we'll combine them)</li>
  <li>Clean up the text (html, links, punctuation, stopwords, etc.)</li>
  <li>Generate embeddings for each using <a href="https://radimrehurek.com/gensim/models/doc2vec.html" target="_blank">Doc2Vec</a></li>
  <li>Cluster embeddings to find semantic structure of posts using TSNE</li>
</ol>

For those not familiar with Discourse terminology, a "topic" is one page of posts by multiple users to answer a question of interest or discuss an idea. In the case of AskCI, we have Question and Answers topics (category Q&A) and Discussion Zone topics, and for the purposes of the analyses here, we combine the page of posts into a single text entry to represent the topic. <a href="https://ask.cyberinfrastructure.org/t/how-do-i-create-a-docker-container-for-openfoam-1-6-ext/989" target="_blank">Here is an example</a> of a topic, and notice that it's made up of multiple posts by different users.
The algorithms we will be using are unsupervised, meaning that we don't need to provide any labels for training.
For TSNE, we choose two dimensions so it's easy to plot. And in a nutshell, <a href="https://hpsee.github.io/discourse-cluster/tsne.html" target="_blank">here is the TSNE result!</a>.

<div style="margin-top:20px; margin-bottom:20px">
   <img src="https://vsoch.github.io/assets/images/posts/askci/tsne.png">
</div>

### What do you see?

As we mentioned above, there isn't much data to work with (N=179 topics total, some with only one post) so
I'm not surprised to see that we only see a straight line to represent the structure of the data. 
The result (I think) is still interesting, because given
that the circles are sized based on view counts, and given that they are colored based on likes, it (maybe?) seems
like the upper left quadrant has topics that are both more well liked and viewed. We could look
at the specific posts (and mouseover or click on them on the live plot) to see exactly the content.

<div style="margin-top:20px; margin-bottom:20px">
   <img src="https://vsoch.github.io/assets/images/posts/askci/details.png">
</div>

It could be that (some of) the posts in the upper left really have some quality that makes
them better. Or it could just be that they are older and thus have more views and likes for that reason.
I'm going to stop here, and give you a chance to look at the data and come to your own
conclusions.

## 2. Clustering by Tags

For the second idea, I wanted to visually see topics clustered by tags, and verify (for myself) if the groups
made sense. A lot of time and energy goes into tag curation, so this is a quick sanity check to see how we are doing.
I proceeded as follows:

<ol class="custom-counter">
  <li>Create a count matrix of topics by tags</li>
  <li>Perform dimensionality reduction on the matrix (ICA) with 1..10 components</li>
  <li>The mix of signals (topics by components) can be visualized again with TSNE</li>
</ol>

I didn't take the time to think about how many components to derive (there are methods, I'm
not sure any or great) so I instead derived a range (1..10) and you can <a href="https://hpsee.github.io/discourse-cluster/index.html" target="_blank">explore on your own.</a>.  Here is a static image of the plot (no you cannot click on this, but try the link!)

<div style="margin-top:20px; margin-bottom:20px">
   <img src="https://vsoch.github.io/assets/images/posts/askci/tags-clustering.png">
</div>

### What do you see?

I think that 3 components has a (sort of?) better grouping, but again, the dataset is just really small.
The top left seems to be somewhat about slurm and schedulers, and there is a cluster in the middle
toward the right with lots of posts about containers. I would again be skeptical that the 
tags themselves are indicative of the number of likes or views - I think there are other variables
not taken into account like how the topics were shared, and who posted.

Another view to look at is with 10 components, and perhaps we might have gone higher given
that this could be meaningful. Roughly, the idea is that if we use N ICA components, we can
capture N clusters. What do we see here?

<ol class="custom-counter">
  <li>The left chunck is all parallel stuff.</li>
  <li>A chunk in the middle doesn't have tags.</li>
  <li>The bottom is heavily slurm</li>
  <li>The bottom right has questions of the week.</li>
  <li>To the right is network and file transfer</li>
  <li>The top right is getting started.</li>
  <li>There are some smaller, more specialized clusters, e.g., computational chemistry, environments)</li>
</ol>

Cool!

## 3. Make Predictions

This is the third idea that I didn't pursue, because this dinosaur has other things
she wants to work on this weekend! But I figured I might share the idea, in the case that
someone wants to give it a try, either with the data here, or their own community.
The idea is that we might want to predict a variable like views to better understand what
makes a topic good. Here is how you could go about that.

### Organize X Data

Organize the input data (X). For example, make a sparse matrix of shape (number of topics, number of unique tags). 
Actually, you can use the <a href="https://scikit-learn.org/stable/modules/generated/sklearn.feature_extraction.text.CountVectorizer.html" target="_blank">CountVectorizer</a> method 
that we used to create the matrix of tag counts, but instead of
tags as input, provide the entire content of the topic.

### Organize Y Data

Organize the output (y) values. This is the list of things that we want to predict, such as views or likes.
You may also consider taking the log (e.g. log(views)) because the distribution seems to have that form.
If you do take the log (numpy.log uses natural log), remember you'll need to take the exponent of the predictions (numpy.exp).

### Train/Test Split

Now it gets hairy because our dataset is small. Ideally we would have a large enough dataset to use a section
for training and another for test, but we don't, so we instead might try some kind of K-fold cross validation (and vary the value of K). If you want a quick and dirty look you can use all of the data for training (ug) but more correctly
you should loop over testing and training sets, and generate some kind of summary metrics for how well you did.

### Train Regressor

Next you'd want to train a regressor on the training set, and I think the functions usually
have a score to look at.

### Evaluation

If you did do some kind of hold out, evaluate to see how you did. You can compare model predictions to actual values,
and then create a scatter plot (x-axis is actual values and y-axis is predictions).

## Another Idea?

An entirely different option is to train using the embeddings that we generated in the first notebook.
Really, the thing I find so hard about this kind of work is that there isn't an exactly right way to do it.
And it's not even clear when you are done. This is why I decided to stop at two bullet points.


## Why?

I've noticed that a lot of communities use Discourse for discussion and general support,
and it's important that those communities are empowered to use their own data to better
understand what constitutes a "good topic" or if the content is organized logically. I can't
say this is the only or even close to a best practices method (I'm a terrible scientist, and data
scientist is included in that), but my hope is to get 
others minimally started with using the API to export data, and then interacting with it.

