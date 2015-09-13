---
title: "Nifti Drop"
date: 2015-09-13 15:16:11
tags:
  nifti
  image-processing
  javascript
  viewer
---

The biggest challenge with developing tools for neuroimaging researchers is the sheer size of the data. A brain is like a mountain. We've figured out how to capture it with neuroimaging, and then store the image that we capture in a nifti little file format (that happens to be called nifti). But what happens when we want to share or manipulate our mountains in that trendy little place called the internet? That's really hard. We rely on big servers to put the files first, and then do stuff. This is an OK strategy when you have brain images that are big and important (e.g., to go with a manuscript), but it's still not standard practice to use a web interface for smaller things. 

### Drag and Drop Nifti
I want to be able to do the smaller stuff in my web-browser. It's amazing how many posts I see on different neuroimaging lists about doing basic operations with headers or the data, and visualization is so low priority that nobody gives it the time of day. One of my favorite things to do is develop web-based visualizations. [Most of my work](http://www.github.com/vsoch/pybraincompare) relies on some python backend to do stuff first, and then render with web-stuffs. I also tried making a small app to [show local images in the browser](http://www.npmjs.com/package/brain-browser), or as a default [directory view](https://github.com/vsoch/niindex). But this isn't good enough. I realized some time ago that these tools are only going to be useful if they are drag and drop. I want to be able to load, view header details, visualize in a million cool ways, and export different manipulations of my data without needing to clone a github repo, log in anywhere, or do anything beyond dragging a file over a box. So this weekend, I started some basic learning to figure out how to do that. This is the start of Nifti-drop:


<img src="/assets/images/posts/nifti-drop/nifti-drop.png" style="width:100%">
#[DEMO](http://vsoch.github.io/nifti-drop)  
  
  
It took me an entire day to learn about the FileReader, and implement it to read a nifti file. Then I realized that most of those files are compressed, and it took me another day to get that working. My learning resources are an [nifti-js](https://github.com/scijs/nifti-js) (npm), the [nifti standard](http://nifti.nimh.nih.gov/pub/dist/src/niftilib/nifti1.h), [FileReader](http://www.html5rocks.com/en/tutorials/file/dndfiles/), and [papaya](https://github.com/rii-mango/Papaya). It is 100% static, as it has to be, being hosted on github pages!  
  
  
  
#### What I want to add
Right now it just displays header data alongside an embarrassingly hideous histogram. I am planning to integrate the following:

 >> [Papaya Viewer](https://github.com/rii-mango/Papaya): is pretty standard these days, and my favorite javascript viewer, although the code-base is very complicated, and I can barely get my head around it.

 >> [NIDM Export](http://nidm.nidash.org/): meaning that you can upload some contrast image, select your contrast from the Cognitive Atlas, and export a data object that captures those things.

 >> Visualization: Beyond a basic viewer, I am excited about being able to integrate different visuaization functions into an interface like this, so you can essentially drop a map, click a button, get a plot, and download it.

 >> [NeuroVault](http://www.neurovault.org): is near and dear to my heart, and this is the proper place to store statistical brain maps for longevity, sharing, publication, etc. An interface with some kind of nifti-drop functionality could clearly integrate with something like NeuroVault or [NeuroSynth](http://www.neurosynth.org)



#### Feedback
Please post feedback as comments, or even better, as [github issues](https://github.com/vsoch/nifti-drop/issues) so I will see them the next time I jump into a work session.


