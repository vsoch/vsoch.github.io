---
title: "The Dinosaur Debugger"
date: 2018-07-17 3:23:00
toc: false
---

Have you ever worked on something really hard, maybe as a tag team effort, and it was an amazingly fulfilling experience? Why does that happen? Usually it's pretty simple. It happens because you learn something, feel challenged, and sense that a fellow human is in the journey with you. It may be different for developers at companies, but this is a more rare experience for an open source developer, and it has moved me to write. This is a post about the satisfaction of collaborative work, and a bit of dinosaur debugging.

# You Have a Bug

You have a box with software inside, and let's call it a "container." Inside the container is some experiment software, and experiments that you are testing. And then all of a sudden, you see red letters flash across
the screen that say in some manner or form:

> Oh hey, I'm broken. You have a bug!

Either something in the container has changed, or an experiment is to
blame, but something is not working. We start our adventure today after a build routine of this experiment container, and the leading steps of this build routine you can <a href="https://github.com/expfactory/expfactory-testing" target="_blank">find here</a>.


## 1. The Development Environment
Before we start debugging, let's establish that we've thought about the environment that we are working
in. We aren't working willy nilly on our local machines, but rather we have a set up that ensures some
consistency and replicability between time and hosts. In my case, I finished building a container from a <a href="https://docs.docker.com/engine/reference/builder/" target="_blank">Dockerfile</a>. Fwoop!

```bash
docker build -t expfactory-test .
...
Removing intermediate container 586afc7b8843
 ---> c577080944e2
Step 29/29 : EXPOSE 80
 ---> Running in 2652b4651576
Removing intermediate container 2652b4651576
 ---> 573148107121
Successfully built 573148107121
Successfully tagged expfactory-test:latest
```

and I had started the container:


```bash
docker run -d --name stroop -p 80:80 expfactory-test start
```

It's called "stroop" because it deploys a <a href="https://en.wikipedia.org/wiki/Stroop_effect" target="_blank">stroop experiment</a> in the browser. This is the one where you push buttons to indicate the color of a flashed word, and the (actual word itself, e.g., "red") can throw you off.

## 2. You Have Logs

We should also think about the places that the various software are going
to write us messages that could be hints to uncovering the issue. In my case, I had developed
the container to have multiple logs stream to a common location. I don't think this is great practice because it mixes things up, but it's really moreso a lazy dinosaur practice. Thus, I could open my browser to see my server running, and also see the logs in my terminal.

```bash
$ docker logs -f stroop
Database set as filesystem
Starting Web Server

 * Starting nginx nginx
   ...done.
==> /scif/logs/gunicorn-access.log <==

==> /scif/logs/gunicorn.log <==
[2018-07-15 22:27:27 +0000] [1] [INFO] Starting gunicorn 19.9.0
[2018-07-15 22:27:27 +0000] [1] [INFO] Listening at: http://0.0.0.0:5000 (1)
[2018-07-15 22:27:27 +0000] [1] [INFO] Using worker: sync
[2018-07-15 22:27:27 +0000] [35] [INFO] Booting worker with pid: 35
WARNING No user experiments selected, providing all 1
[2018-07-15 22:29:59,777] INFO in general: New session [subid] expfactory/3460e8e5-0415...
[2018-07-15 22:29:59,786] INFO in utils: [router] None --> stroop-task [subid] expfactory/3460e8e5-0415...
[2018-07-15 22:30:03,681] DEBUG in main: Next experiment is stroop-task
[2018-07-15 22:30:03,681] INFO in utils: [router] stroop-task --> stroop-task [subid] expfactory/3460e8e5-0415...
[2018-07-15 22:30:03,682] DEBUG in utils: Redirecting to /experiments/stroop-task
[2018-07-15 22:30:03,702] DEBUG in utils: Rendering experiments/experiment.html
```

<br>

# Debugging the Bug

Our story continues as I navigate in the browser to start the experiment, and click through it to debug. The issue was that when I finished the stroop task, the final step to save data and move on to the next experiment didn't work. When something doesn't happen in a browser that you expect, the first logical place is to look at the <a href="https://developers.google.com/web/tools/chrome-devtools/console/" target="_blank">JavaScript console</a>. If you right click on your browser and click "Inspect" a bar will usually pop up with a bunch of tabs. This is called the "Developer's Console" and has amazing tools for looking at resources, networking, Javascript, styling, and elements on the page. I find something new every time I venture there! This is where the journey of the bugman begins - when I right clicked in the browser to see the JavaScript console I saw an error for a  <a href="https://en.wikipedia.org/wiki/POST_(HTTP)" target="_blank">POST</a> request. A POST means there was an action to send data from the page in front of me to the server, but it didn't work. Let's approach this problem by asking and answering simple questions.


## Where are you Debugging From?

It's usually logical where you want to debug from. In my daily work I encounter a few common types of debugging tasks. 

**Terminal Debugging**

An application might be script or terminal based, meaning interaction is with a command line client. In this case, debugging is usually pretty easy, because I would inspect the error message or stack trace, and then follow it to the location in the script (or scripts) to see if I could figure out the error. In the case of an error that would require interactive exploration, I might interactively step through the program, or write test cases. 

**Remote Debugging**

Any kind of bug that is reported by someone else is really just adding a layer of abstraction. You not only need to ask them for more details about the software, environment, and command, but you then need to figure out how to reproduce their issue. This is sometimes harder than it looks, and unfortunately can lead to a "but it works for me!" sort of deal.

**Application Programming Interface Debugging**

Application Programming Interface (API) debugging is a mix between terminal and browser debugging. It means I'm typically sending requests and getting responses from a web server, but I'm doing it from a terminal. I'm either issuing requests directly with basic libraries like curl, or I'm interacting with a client that is provided for the API endpoint. These are my favorite kind of errors to debug, probably because the data structure returned is commonly <a href="https://www.json.org/" target="_blank">JSON</a> and this dinosaur looooves JSON. :)

**Browser Debugging**

Solely browser debugging isn't something I do terribly often because most of the time there is a backend, but it is quite possible that you might only be interacting with something like JavaScript or similar front end framework In this case, your bread and butter for debugging is the JavaScript console, and pretty much testing things there. It simplifies things a great deal, but on the other hand if you aren't great at Front end technologies, you may not even know where to start!

**Web Applications**

Another common kind of debugging is some flavor of web interface plus application server (e.g., <a href="http://uwsgi-docs.readthedocs.io/en/latest/" target="_blank">uwsgi</a>) plus web server (e.g., <a href="https://www.nginx.com/" target="_blank">nginx</a>).  In this case, you usually start from a weird or broken function in the browser, and logically work back to the server until you again have located the likely location in the code behind it. If you have a database, there is the additional element of thinking about <a href="https://en.wikipedia.org/wiki/Model%E2%80%93view%E2%80%93controller" target="_blank">models</a> and data flowing through them.

The browser is, strangely enough, where the richest source of debugging originated from in our story, because the browser carried all the secrets of our requests and responses, and ultimately we just needed to know where to look. Here is all the information that we had to go by, at least to start. Are you ready for it? 

```javascript
POST http://127.0.0.1/save 400 (BAD REQUEST)
``` 

Ruhroh! That's a <a href="http://www.checkupdown.com/status/E400.html" target="_blank">400 error</a> for a bad request. It may seem obvious to read this out, but sometimes people see red, their brains go blank, and they copy paste the message into a window for someone else to deal with.

> Read your error messages, they are telling you what's wrong!

So what happened? To again review, we had an experiment that was <a href="https://en.wikipedia.org/wiki/POST_(HTTP)" target="_blank">POST</a>ing data to the server, an endpoint directed to `/save`. It used a method ([fetch](https://davidwalsh.name/fetch)) to do the POST, and it wasn't  working.

### Step 1. Hypothesize what might be wrong

A 400 error is typically indicative of a bad request on _your_ part. Here are some reasons this might happen:

<br>

**Errors coming from the view**

It could be the case that the POST is reaching the view in the server, and something about it isn't liked, so the server view (a Python function in this case) returns the 400. This could be any of the following:

<ol class="custom-counter">
<li>Some data is posted, the view doesn't like it, and returns the error.</li>
<li>There is some authentication issue, but instead of a 403 or other, a more general 400 was returned.</li>
<li>The expected format of the request is incorrect.</li>
</ol>

The nice thing about this kind of error is that you can debug it by adding a few lines to the view. I did the following:

<ol class="custom-counter">
<li>I added some printing to server logs so I could confirm that the view was hit (or not).</li>
<li>I added some lines to save variables to a local file for loading and interactive debugging.</li>
</ol>

Of course the last of the above would only work given that the view was hit, and the data saved without error. It could be that the view is hit but the command I wrote is wrong, or that the data is malformed and nothing is saved. So many possible things might go wrong!

<br>

**Errors from the Flask server**

One level up from the view is the server, which in this case is <a href="http://uwsgi-docs.readthedocs.io/en/latest/" target="_blank">uwsgi</a> with <a href="http://flask.pocoo.org/" target="_blank">Flask</a>. If this is the case, I intuited that the errors we are going to see here would be related to issues with <a href="https://flask-cors.readthedocs.io/en/latest/" target="_blank">CORS</a>, or conditions for cross origin resource sharing. Another common error is with respect to csrf, which generally refers to checks for cross request forgery. If this is the error, then we wouldn't see any evidence of the view getting hit, because it wouldn't get there, but we still might get a bad request.

<br>

**Errors from the web Server**

One level up from Flask is <a href="https://www.nginx.com/" target="_blank">nginx</a> (engine X), which would typically return a 500 error if it was forwarding along an issue from the application (e.g., some code has a typo). These errors would typically be found also in nginx logs in `/var/log/nginx`.

<br>

Based on the error that I saw, I hypothesized that we were dealing with something related to the first or second. To get certainty about this, the next step would be to figure out the extent to which we were hitting the application.


### Step 2. Determine Level of Investigation

I next did some typical, simple dinosaur debugging. I traced the endpoint triggering to the error to a view (spot in the Python code) and added a bunch of saves and logging to it to determine if we were reaching it, period. The quick answer was that we were not - there was no indication that the application view was being touched. It's sort of like having a pristine white couch in a bubble, and throwing tomato sauce at it. As soon as you see that the couch isn't tomato-fied, you know you need to focus on the outer bubble. This simple set of first steps was very good, because I knew that it was an issue with the Flask server, and probably that CORS business. If you haven't read about CORS, it's pretty neat because it lets you define conditions for accepting resources. This means locations, methods, origins, and whether or not you require or expose headers or other kinds of credentials. A single missing header, or wrong specification of a Content Type can throw everything off, and likely it was the case that the request we were making had a mistake. Another potential issue is related to the checking for <a href="https://www.owasp.org/index.php/Cross-Site_Request_Forgery_(CSRF)" target="_blank">cross request forgery</a>. One of the checks is that you basically have your server produce and then send itself back a secret (called a csrf_token) through a form field, header, cookie, or similar. If the token wasn't getting through, we might see an error. A user might get an error for an otherwise working application simply from disabling cookies, or uploading a file that is detected as the wrong type.

<br>

**How Informative is the Error Message?**

Sometimes, the error message is spot on - such as if the server sends you back the exact Python message that would have shown up in a terminal. Other times, you work from an error code. And sometimes, you actually get an error code that was incorrectly chosen, or doesn't properly describe the underlying issue. The overall thing to remember is that

> error messages are only as insightful as the person who implemented the check

With that said, I apologize for every error catch I've ever written. :s But then again, some care taken to write checks is better than none at all! Now let's dig into this particular issue, and I'll give you some background to help. This is zooming ahead a bit because the questions that I ask next aren't completely blind, but rather based on what I understand about the application. If you start from knowing nothing, it's of course a lot harder to debug.

<br>

**Is Jquery influencing it?**

The first (original) method of posting with <a href="https://www.w3schools.com/xml/ajax_xmlhttprequest_send.asp" target="_blank">Ajax</a> had an extra dependency of <a href="https://www.w3schools.com/Jquery/default.asp" target="_blank">JQuery</a>, and to maintain support for these experiments I had kept JQuery defined in the header of the html template. This <a href="https://github.com/expfactory/expfactory/blob/master/expfactory/templates/experiments/experiment.html" target="_blank">particular template</a> view had also added an <a href="https://www.w3schools.com/jquery/ajax_ajaxsetup.asp" target="_blank">ajaxSetup</a> to set the header in advance. For those interested, I do this so that any experiment can have the csrf token header added without needing to customize it for the experiment factory apriori. However, if it's the case that I'm not allowed to ask for the csrf token twice (once with the ajaxSetup, and then again via the fetch) the token wouldn't be passed, and we would get an error. I wasn't sure about this, but it seemed like it might be a possibility. To test this, I removed the extra JQuery and AjaxSetup steps, and confirmed that the error happened regardless. Later I was also able to confirm that the same value for the csrf token is passed via both methods, and of course one isn't used. Regardless, one method worked (ajaxSetup) and the other didn't (fetch). So the presence of absence of JQuery, or the extra ajaxSetup, didn't seem to matter.

<br>


**Is it the format of the data or headers?**

It's important to have an understanding of how the data is being POSTed to the server, and if possible, to have a comparison between a working example and a non working example. In my case, I was lucky to have an example of a POST (with Ajax) that my colleague had put together based on an older working experiment using the same experiment view that worked:

```bash
$.ajax({
  type: "POST",
  url: '/save',
  data: { "data": study.options.datastore.exportJson() },
  dataType: "application/json",
  success: function() { console.log('success') },
  error: function(err) { console.log('error', err) }
});
```

I wanted to first try this, for a sanity check. Had it failed, I would have gone back further a step to an older experiment that I knew was working. How did I test random code? Developer tools to the rescue! I right clicked on the browser window, clicked "Inspect," and then went to the "Console" tab. I could then type JavaScript into the bathtub porcelain white window (it really is quite bright...), and proceed to the point in the experiment to have the data ready to post (and trigger the error). I'd be in major trouble if something that was previously reported working was no longer working. Thankfully, the above command with ajax worked! This meant it was definitely something about using fetch. At this point I knew that I had cornered the problem - we would be able to look at the complete record for a working (ajax) vs. not working (fetch) POST, from the same exact view. The functions are "different" but under the hood are performing very similar (if not the same) actions.

<br>


### Step 3. Investigate 
With a working and non-working example, we can look more closely at a few things:

<ol class="custom-counter">
<li>requests from the browser to the server</li>
<li>responses from the server back to the browser</li>
<li>the data being sent</li>
</ol>

By looking at each of these and comparing between the working ajax and non-working fetch, I was hopeful to figure out the issue. Here is an example, first the broken request:

![image](https://user-images.githubusercontent.com/814322/42739205-6cdfa162-8847-11e8-9f11-42059b33da78.png)

and here is the working one, with ajax:

![image](https://user-images.githubusercontent.com/814322/42739195-48631ae4-8847-11e8-9462-87cac679eb54.png)

Notice the red circle at the top, and green circle at the bottom? These kinds of details I love. My colleague and I, once we discovered this build->deploy->inspect routine, had found our strategy for getting to the bottom of the issue. We thought that the answer lied here, and from this point ensued at least 10 iterations of him customizing an experiment export, posting a zip of the contents, me extracting the experiment to a repository, and committing to Github for CircleCI to <a href="https://circleci.com/workflow-run/5a569806-e192-4b4a-8031-d19b02b4795f" target="_blank">produce an automated build</a> (container) that both of us could pull and run. An important note here is that

> we were testing from the same base

of course it could be the case that differences in the browsers we chose to use led to further errors, but thankfully Firefox and Chrome (albeit with some differences) were comparable to render the experiment.

<br>

### Step 4. Incremental Changes

The way that we continued debugging this was to make incremental changes, and test until something worked, or we decided a different approach was necessary.  Importantly, each test with an ajax or fetch request was done from the same browser, and with the same completed experiment data. The continued 400 response (bad request) told us that there was some difference between what what the same test stroop-task was posting internally with fetch, and with ajax. 

### So What Happened?

**We got it!**

After almost 100 <a href="https://github.com/FelixHenninger/lab.js/issues/18" target="_blank">back and forths</a>), we got it! It was an awesome span of work in under a few days, and it was both fun and fulfilling to tackle solving the culmination of many small pieces into one final product. The bug came down to tiny details, and to be fair I had struggled with a similar case <a href="https://github.com/FelixHenninger/lab.js/issues/18#issuecomment-405128185" target="_blank">once before</a>, and then my colleague was able to apply his insight and more advanced JavaScript prowess to update the experiment so that the fetch worked. When the experiment (finally) advanced to the next screen, indicative that the save had worked, I had never seen such a beautiful sight!

![https://user-images.githubusercontent.com/814322/42769332-bf77eee0-88d6-11e8-97e8-6f3e985ddf4f.png](https://user-images.githubusercontent.com/814322/42769332-bf77eee0-88d6-11e8-97e8-6f3e985ddf4f.png)

<br>

**Expfactory <3 LabJS**

Why do we care about this so much? What does it all mean? We are working on making it easier to go from creating a behavioral experiment, in your browser, to having a production-ready reproducible container. If you want an early preview of our work, check out the <a href="https://expfactory.github.io/integration-labjs" target="_blank">LabJS integration page here</a>, and you can expect some beautiful LabJS based documentation to come in the following weeks. This bout of work is awesome and deserves an entire post on its own, but not before I am able to put some time into helping my colleague with LabJS. Stay tuned!


## Should you Share your Solution? (SyS!)

Yes, you should practice this acronym I just made up, SyS, and "Share your Solution!" If you've debugged it once, then no one should ever have to deal with that same bug again. If open source software engineering is sharing your code, then

> open source debugging is sharing your bugs!

And I want all of them! If the error pertains to something about the software (e.g., missing an edge case) then it's important to (in the case of Open Source) minimally file an issue, and maximally report it, fix it, and open a Pull Request (PR) to request changes done to the software. This is one of the reasons that I write such ample and verbose notes when I am working on problems. My mind is in a hyper-focused state, and if I am ever to encounter the issue again, it's much easier to remember when I've written it down!

<br>

**Expfactory Testing**

Another thing you can do is take your notes a step further, and turn them into a guide for others to debug from. This is akin to extending the experiences that I have into documentation or tools that can help a future me, or someone else. After this experience, along with this post, I came up with an <a href="https://github.com/expfactory/expfactory-testing" target="_blank">Experiment Factory</a> testing guide. It's a helper guide for a developer to test either an experiment or the container infrastructure itself.


Overall, this bout of work was awesome! It was awesome because I learned a lot, and it was a tag team effort with my colleague. It was a strong point of evidence that if I ever feel alone as a dinosaur developer, others in the open source community are out there with similar goals, and challenges, and sometimes the best thing to do is just ask for help.
