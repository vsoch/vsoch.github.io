---
title: "The Resource Explorer"
date: 2019-09-10 5:22:00
categories: resource
---

I was having a chat with the amazing, the diabolical <a target="_blank" href="https://github.com/griznog">griznog</a>, and he had an idea up his sleeve for some kind of online form where a user could make selections, and filter down to some set of resources. I loved the idea, and decided to give it a shot. 

> Insert struggles with JavaScript frameworks...

This resulted in <strong>*drumroll*</strong>...

<br>
<a href="https://vsoch.github.io/resource-explorer">
<img src="https://raw.githubusercontent.com/vsoch/resource-explorer/master/img/resource-explorer.png">
</a>
<br>

The resource explorer!!

## Show me!

If you don't want to read about it, just <a target="_blank" href="https://vsoch.github.io/resource-explorer">see it here</a> or
<a target="_blank" href="https://www.github.com/vsoch/resource-explorer">use the code</a> for your own group.

## What is this thing? 

It's really quite simple - it allows for interactive selection of a storage, compute, service,
or other resource provided by your group. In the implementation linked here, we use resources and services relevant for research computing. I want to note that while I plan to deploy a version of
this for my group, <strong>this particular instance is for demonstration purposes only and does not fully represent
what we offer!</strong> I need the help of my group to finish up the details, and we will be deploying
a "for realsies" resource explorer likely at <a href="https://stanford-rc.github.io">our documentation portal</a>. For now, let's walk through how it works.

### Resources and Questions

The [resource-explorer.js](https://github.com/vsoch/resource-explorer/blob/master/resource-explorer.js) 
file contains both the script and the data structures that drive it. At the top, you'll see
variables for questions and resources that drive the logic of the interface. The user will be presented
with a series of easy to answer questions, and the selection of resources
will be narrowed down based on the answers. Specifically:

#### Questions

Include multiple-choice, single-choice, boolean, and enumerate (maximum or minumum) choices.

<ol class="custom-counter">
 <li> <strong>multiple-choice</strong> means that the user can select zero through N choices. For example, I might want to select that a resource is for staff, faculty, and students.</li>
 <li> <strong>single-choice</strong>: is a choice question where the user is only allowed to select one answer. If you need to implement a boolean, use a single-choice with two options.</li>
 <li> <strong>minimum-choice</strong>: indicates a single choice field where the choices have integer values, and the user is selecting a minimum. For example, if the user selects a minimum storage or memory size, all choices above that will remain.</li>
 <li> <strong>maximum-choice</strong>: is equivalent to minimum-choice, but opposite in direction. We select a maximum.</li>
</ol>

In the above, an enumerate choice (minimum or maximum) implies there is an ordering to the logic. The user might want a minimum or maximum amount of memory, for example. Each question should be under the questions variable (a list), and have a title, description, required (true or false) and then options. For example, here is a question from the list:

```json
      {
         "title": "Who is the resource for?",
         "id": "q-who",
         "description": "Select one or more groups that the resource is needed for.",
         "required": false,
         "type": "multiple-choice",
         "options": [
            {
               "name": "faculty",
               "id": "who-faculty"
            },
            {
               "name": "staff",
               "id": "who-staff"
            },
            {
               "name": "student",
               "id": "who-student"
            }
         ]
      }
```

For a minimum-* or maximum-* choice, the ids must end in an integer value:

```json
      {
         "title": "What size of storage are you looking for?",
         "id": "q-size",
         "description": "If applicable, give an approximate unit of storage.",
         "required": false,
         "type": "minimum-choice",
         "options": [
            {
               "name": "gigabytes",
               "id": "size-gigabytes-1"
            },
            {
               "name": "terabytes",
               "id": "size-terabytes-2"
            },
            {
               "name": "petabytes",
               "id": "size-petabytes-3"
            }
         ]
      },
```

We do this so we can parse the ids and then rank order them. For a boolean choice, you can just use a single-choice
with two choices:

```json
      {
         "title": "Do you require backup?",
         "id": "q-backups",
         "description": "Some or all of your files will be copied on a regular basis in case you need restore.",
         "required": false,
         "type": "single-choice",
         "options": [
            {
               "name": "backups",
               "id": "backups-true"
            },
            {
               "name": "no backups",
               "id": "backups-false"
            }
         ]
      },
```

Notice that each choice has a unique id associated with it. These will be used as tags associated with each
resource to help with the filtering.


#### Resources

A typical resource looks like this:

```json
      {
         "title": "Nero",
         "id": "nero",
         "url": "https://nero-docs.stanford.edu",
         "attributes": {
           "q-kind": ["kind-compute", "kind-cloud"],
           "q-service": [],
           "q-who": ["who-faculty"], // only faculty allowed
                                     // domain is left out, implying all domains
                                     // size is left out, implying all sizes
           "q-framework": ["framework-kubernetes", "framework-containers"],
           "q-backups": ["backups-true"]
         }
      },
```

Note that we require a title (a user friendly print-able value), an id (for the object in the DOM), a url to
link to, and then a list of attributes. For each attribute, the key corresponds to an id for a question,
and then the list of values is a list of responses that, if chosen by the user, would make 
it a valid choice. Specifically:
  

##### General Logic

 - if a question key is defined but empty, a selection of any field for the key invalidates the resource.
 - if a question key is not defined, making a choice for any field for doesn't impact the resource (it stays or remains hidden).
 - if a question key includes a subset of choices, then the resource is kept only if the user chooses a selection in the list.


##### Example Logic

For the above, this would mean that:

 - if the user selected any kind of "q-service", the Nero option would be hidden.
 - if the user selected kind-compute and/or kind-cloud, Nero would remain.
 - if the user selected any other kind of audience other than faculty (who-faculty) Nero would be hidden.
 - Selecting framework as kubernetnes or containers will keep Nero. Selecting slurm (not in the list) will hide it.
 - Selecting backups-false will hide Nero.

<br>

The <a href="https://github.com/vsoch/resource-explorer">repository</a> serves only as an example, and doesn't reflect the actual state of Stanford resources (but stay tuned, we will make one, as soon as I can get feedback from my colleages!)
