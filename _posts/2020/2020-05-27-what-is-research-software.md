---
title: "What is Research Software?"
date: 2020-05-27 17:30:00
---

> A community proposal for a framework to define research software

We all have questions that keep us up at night. What is the meaning of life? Or
should I really have eaten that indian food for dinner? For me, I've been
pondering definitions around research software engineering for some time.
What is a research software engineer? What is research software? For the first,
this pondering led to the creation of <a href="https://us-rse.org/rse-stories" target="_blank">RSE Stories</a>, 
I didn't think any single person or group of experts could define what a research 
software engineer could be, so I decided to let the people speak for themselves. 
But for the second, what is research software? This is still a really hard question. 
And thinking about this last night prompted me
to start writing today, and now at the end of the day, I want to share an early
early draft for this work. So without further adeiu, here is "What is a research
software engineer: a community proposal for a framework to define research software."
You can listen here, read more below, or jump <a href="https://docs.google.com/document/d/1wDb0udH9OrFWrMBsAVb8RrUMCKKRHoyEep7yveJ1d0k/edit?usp=sharing" target="_blank">right into contributing</a>
to the document. I want this to be a community effort, and so I invite you to comment
and suggest changes. We will figure out the right place to put this, and proactively
proceed with <a href="#next-steps">next steps</a>.

<iframe width="100%" height="166" scrolling="no" frameborder="no" allow="autoplay" src="https://w.soundcloud.com/player/?url=https%3A//api.soundcloud.com/tracks/829419856%3Fsecret_token%3Ds-zZjs2pmGiku&color=%23ff5500&auto_play=false&hide_related=false&show_comments=true&show_user=true&show_reposts=false&show_teaser=true"></iframe><div style="font-size: 10px; color: #cccccc;line-break: anywhere;word-break: normal;overflow: hidden;white-space: nowrap;text-overflow: ellipsis; font-family: Interstate,Lucida Grande,Lucida Sans Unicode,Lucida Sans,Garuda,Verdana,Tahoma,sans-serif;font-weight: 100;"><a href="https://soundcloud.com/vsoch" title="vsoch" target="_blank" style="color: #cccccc; text-decoration: none;">vsoch</a> · <a href="https://soundcloud.com/vsoch/what-is-research-software-a-community-proposal-for-a-method-to-derive-definitions/s-zZjs2pmGiku" title="What is Research Software? A Community Proposal for a Method to derive definitions" target="_blank" style="color: #cccccc; text-decoration: none;">What is Research Software? A Community Proposal for a Method to derive definitions</a></div>

## What is Research Software?

When you encounter a bear in the woods, you can be pretty sure that it’s a bear. You might recognize features from childhood stories, the Discovery channel, or maybe even previous encounters. But then, what if someone asks you to sit down, and write a definition for a bear? How might you start? Well, you might be somewhat confident that it’s a mammal, so you start with those features: having hair or fur, teeth, what were the other ones again? We don’t need to work very hard because a lot of work has already gone into defining the features of a mammal. Without listing them all, the creature in question also needs to have sweat and mammary glands, three middle ear bones, a neocortex, and a four chambered heart. Now, even if we could make our bear friend transparent and see into him to answer these questions, we are again left with the same conundrum when we step up to the next level of evaluation - what makes a bear different from any other animal? What features are especially beary?

The same conundrum exists for research software. We have a pretty strong sense of what constitutes software - it is some kind of compiled or interpreted program that is run by a computer. But then, what distinguishes “research software” from all other software? And further, do we really care about a set of exact attributes, or are we interested in amassing some significant number of general features? To return to our previous example with bears, I might step back and decide that I care less about identifying the bear, but rather, identifying a creature that might present some danger to me. This changes our way of thinking entirely because instead of thinking about ear bones and mammary glands, we start to consider size, aggression, presence of teeth, and arguably much more useful features in the context of our use case. 

This brings us to the idea that context is important. If I care about finding an animal to train for a honey commercial, my criteria will be very different than if I care about identifying a beast that might eat me for dinner. This kind of context is equally important when we discuss research software, as the needs of a group or individual clearly frame any subsequent evaluation. Thus, instead of trying to provide a single definition for research software, we instead need a method or framework to go about evaluating some software in the context relevant to our needs. While our personal choice of some threshold or subset of categories to use for our needs is subjective, the criteria and categorization provided by this framework should not be. Discussion of how to develop these criteria and categories as a base to define research software is the goal that this document aims to address. 

## Who needs to define research software?

There are several contexts under which we might find ourselves in a position of needing to define a piece of software as research software (or not):

### Funding bodies 

If a funding body is possibly evaluating software to determine who gets the goods, they would clearly need to have a definition. There cannot be any gray area about what constitutes research software, and what does not.

### Journals

Journals have traditionally been the means to share academic progress, and by way of being intimately related to academia and having many research software engineers grow from that space, it is logical that we now see journals or sections of journals explicitly for research software. However, whether it’s conscious or not, most journals likely have some non-trivial or (externally appearing) subjective way to classify something as research software or not. The journals need to have transparency is these criteria, and the scope of research software they intend to include.
People: In that developing research software is a core part of many individuals’ identities, having a definition is important to them.

There are clearly many parties that care a lot about research software. We need to give them an explicit framework or algorithm to assess a piece of research software, and then allow filtering of criteria points or categories for each of the use cases discussed above. The following sections will address each of these goals separately:

<ul class="custom-counter">
<li>Definition of criteria for research software</li>
<li>A taxonomy of research software</li>
<li>A proposed framework to define research software</li>
<li>Tools and data to support the research software definition</li>
<li>A community initiative to derive a robust collection of these categorizations</li>
<li>Interfaces to make it easy to explore, threshold, and otherwise filter</li>
</ul>

<br><br>

# HOW DO WE DEFINE CRITERIA FOR RESEARCH SOFTWARE?

I learned when I was younger that when I didn’t understand something, a good approach was to ask more questions about it. So in preparing to think about some scoped criteria for assessment, we will start by asking more questions.

## What is software?

We can easily define software by using the Oxford Language Dictionary. Software is

> The programs and other operating information used by a computer.

So then research software must be a subset of that.

## What is research software?

We might start very simply and say that research software is a subset of software developed by a research software engineer (RSEng). This strategy is attempting to find a definition for research software based on its creator. If we have somewhat solid definitions for RSEng, we can bootstrap off of those and declare that the outputs of the RSEng are typically research software. The problem, however, is that our definitions are not solid, and further, it’s completely reasonable that a RSEng might work on software that isn’t research software. So we cannot answer this question for now, but we can continue asking more questions.

## Is all research software a subset of software?

We need to step back again, and first consider research software in the space of all software. I want to venture to say “Yes” to this question - it would be hard to identify a piece of research software that isn’t also software. Disregarding the scale or relative sizes of the circles, we can fairly confidently say that research software exists as a subset of software (Figure 1).

<div style="padding:20px">
<a target="_blank" href="https://raw.githubusercontent.com/vsoch/vsoch.github.io/master/assets/images/posts/rseng/research-software.png"><img src="https://raw.githubusercontent.com/vsoch/vsoch.github.io/master/assets/images/posts/rseng/research-software.png"></a>
</div>
<italic>Figure 1: Research software is a subset of software.</italic>

## Does research software have to be used only by researchers?

Let’s take the opposite approach of trying to find definition via creator, and instead look for definition via users. Can it be the case that research software is used by someone that isn’t a researcher? Of course it can! Although there are probably small, lab-grown libraries that technically have only been used by researchers, to say that it is invalidated as research software if someone not considered a researcher gives it a spin would not be logical.

## Does research software have to be used by at least one researcher?

On the other hand, we might rely on the definition of a researcher (as we attempted to do for the definition of research software engineer) to determine if something is research software. I would venture to say that research software must be used by at least one researcher.

## Does research software need to be open source?

Open source, meaning that the code is readily available and typically licensed permissively for others to use, ensures transparency and reproducibility, and thus is a much more common and useful box for research software to check. However, software being open source does not guarantee that it’s research software, and research software is not required to be open source. For example, many proprietary scripts likely exist at private research institutions and national labs that would strongly be considered research software. We might say, then, that being open source is great for research software, but is not strongly enough tied to be considered a criteria.

## Does research software need to be associated with a particular domain?

While tools that are specific to their domain (e.g., biology, genetics, chemistry, etc.) smell very strongly of research software, we cannot discount an entire domain of general tools that are useful across domains. Obvious examples are workflow managers, tools for reproducibility, or databases. Thus, research software does not need to be associated with a particular domain.

## Should research software require citation?

Many might give the argument that if software is research software, it would truly be cited in a paper by an academic researcher. This opinion likely stems from the fact that many research software engineers come from academia, and in academia the model of communication and validation of worth is the publication. However, there are several issues with this approach. The first is the obvious realization that publication is dated, and some might argue it a broken system. It can be fairly subjective what a researcher decides to cite, and he or she may favor a known, small network of colleagues. To place the entire bearing of identity on the trivial decision of a third party to have awareness to add a citation is a poor strategy for definition. Although publication to create a digital identifier for others to cite for software is a good strategy to get the word out about your software to researchers, it simply cannot be the only means to its worth and definition. Yes, if software is cited by many researchers, that is positive evidence that it is research software. However, not being cited by many researchers does not say that it is not. It could be that software is so well known and used that researchers don’t think twice about it. We need to do better.

## Can we derive a definition based on absence?

A strong contender for giving definition to research software is focused around the idea of thinking about what would happen if a piece of software were taken away. More explicitly, would researchers’ ability to do their research be negatively impacted? If the answer to this question is yes, then we simply must consider that the software in question is some kind of research software. This definition is much more rich than the previously discussed ideas because it opens up the space to also include databases, version control, and tools for reproducibility. 
But then, what about Linux? Or git? Would we call these research software? Both are fundamental ingredients to the research lifecycle, and if either was removed the flow of research would stop like a clogged pipe. To address these cases, we need to talk about intention.

## Is research software created with the intention to be used for research?

If we approach Linux Torvalds and asked him why he created Linux or git, we might hear an answer that the alternative tools weren’t to his liking, either because of affordability or general design. We would very quickly learn that although Linux and git are essential for modern researchers, they were not created with that purpose in mind. If we must be stringent about a definition of research software, we need to take this into account. Research software, although it doesn’t need to be made explicitly for research, must be intended for it to some degree. The creator of such software must affirm that it was created to help with research.

## Summary of Criteria

We can summarize the discussion above as the following:

<ul class="custom-counter">
<li>Research is a subset of software</li>
<li>Research software must be used by at least one researcher</li>
<li>It might be developed by a research software engineer, but doesn’t have to be</li>
<li>It doesn’t necessarily have to be intended for a particular domain</li>
<li>Absence of citation does not disqualify it, but presence strengthens it</li>
<li>Taking it away would be a detriment to research</li>
<li>It was created with intention to be used for research</li>
</ul>

<br><br>

# A TAXONOMY OF RESEARCH SOFTWARE

If it’s the case that we have a general definition for research software that is based on its intention, users, and impact on the research space, we need to allow for a user of the definition to scope his or her definition to some subset. We need to be able to further break research software into sub-groups, and thus empower people to refer to some subset. We need a taxonomy of research software. First, we can define the top level categories:

```
Software to directly conduct research
    Domain specific software
    General software
Software to support Research
    Explicitly for research
    Used for research, but not explicitly for it
    Incidentally used for research (this is generally not considered research software)
```

## The Taxonomy

And here is a flattened taxonomy to emphasize the examples within. Note that a piece of software that ultimately might not be considered research software (e.g., our Linux or git examples) can still be classified here, as it is incidentally used for research.

### Software to directly conduct research -> Domain specific software:

- Domain-specific hardware (e.g., software for physics to control lab equipment)
- Domain-specific optimized software (e.g., neuroscience software optimized for GPU)
- Domain-specific analysis software (e.g., SPM, fsl, afni for neuroscience)


### Software to directly conduct research -> General software:

- Numerical libraries (includes optimization, statistics, simulation, e.g., numpy)
- Data collection (e.g., web-based experiments or portals)
- Visualization (interfaces to interact with, understand, and see data, plotting tools)

### Software to support research -> Explicitly for research:
- Interactive development environments for research (e.g., Matlab, Jupyter)
- Workflow managers
- Provenance and metadata collection tools

### Software to support research -> Used for research, but not explicitly for it
- Databases
- Application programming interfaces
- Frameworks (to generate documentation, content mangement systems, etc.)

### Software to support research -> Incidentally used for research
- Operating Systems
- Scheduling and task management (for people)
- Version Control
- Text Editors

### Communication tools or platforms (e.g., email, slack, etc.)

From the taxonomy above, we can take any piece of software, and classify it into one or more buckets. We can then combine this classification with a score based on some criteria (answering questions as we did above) to come to some kind of finalized answer specific to our use case.

<br><br>

# A PROPOSED FRAMEWORK TO DEFINE RESEARCH SOFTWARE

>  Proposal: Research software definition based on categories and criteria

Arguably, a definition of research software needs to be catered for its intended use. A journal that wants to publish a specific kind of research software will have different needs and thus criteria than a funding body that wants to support tools for research infrastructure. As stated previously, we need a non-subjective set of criteria and categories that can then be catered for these different use cases. We start with the premise that research software, even if incidentally so, can be categorized into one or more buckets described in a research software taxonomy. After this classification, we can answer a set of yes/no questions about the work. We can then, depending on our needs, choose:

<ul class="custom-counter">
<li>A threshold to quality something as research software</li>
<li>A subset of categories in the taxonomy that we will consider.</li>
</ul>

For example, if I do not want to consider software that is service oriented, I might declare that my criteria do not include one or more sub categories from the “Software to support research -> Used for research, but not explicitly for it” group. This would mean that a high scoring application programming interface, for example, would not fall under my definition of research software. The emphasis is placed on my because the application programming interface could still be considered research software by its creator, and there could be clear conversation about the explicit filtering done for the criteria. I might also set a higher threshold to call only the highest scoring pieces research software. For example, if I require all questions to be “yes” for my journal, while a database that serves an application programming interface might have been created with the intention for research and strongly considered research software by some, because it is not intended for a particular scientific domain, I would not call it research software. The important note here is that we explicitly recognize that although our personal criteria for some use cases are somewhat subjective in applying a threshold and a subset of categories, the original categorization and scoring is not. This is badly needed in our current landscape where the entire definition is completely subjective, and often opaque. We need to be able to clearly communicate our definitions and criteria, and practice complete transparency. 

## Criteria and Taxonomy
From our criteria discussion in the first section, we can derive the following questions:

<ul class="custom-counter">
<li>Is it software (all research software must be software)    (yes/no)</li>
<li>Is it used by at least one researcher?                     (yes/no)</li>
<li>Is it developed by a research software engineer?           (yes/no)</li>
<li>Has it been cited in a research context                    (yes/no)</li>
<li>Is it intended for a particular scientific domain?         (yes/no)</li>
<li>Would taking it away be a detriment to research?           (yes/no)</li>
<li>Was it was created with intention to be used for research? (yes/no)</li>
</ul>


At the end of this procedure, for each piece of software we have a score based on the criteria (ranging from 0 to N, where N is the maximum number of criteria), and a grouping in the taxonomy. An individual or group should then singly or holistically consider the two points mentioned above, namely applying a point threhold for criteria, and possible filtering down to a subset of categories. The resulting pieces of software, namely those that are at or above the criteria needed and within the scope of interest, are then classified as research software. Importantly, they are classified as research software in the context of the use case. This simple method of defining criteria and a taxonomy, and then collaboratively creating data and tools around that, empowers us to make decisions about whether or not the software is research software for our particular use case.

<br><br>

# TOOLS AND DATA TO SUPPORT THE DEFINITION

As a research software engineer, many of us are proponents that while ideas are good (e.g., this document), it’s much more useful to implement the ideas into solutions that can be directly impactful. Thus, we propose the following community initiative to generate data, criteria, and classifications for research software:

<ul class="custom-counter">
<li>Community criteria and taxonomy: These criteria and an original taxonomy should be developed with this initial document. Upon completion of a first draft, they should be put into version control, both for programmatic usage, and continued development.</li>
<li>Database of research software: While it would not be possible to collect a comprehensive list, it would be possible to start a simple spreadsheet to collect research software, and answers to the criteria questions and location(s) in the taxonomy.</li>
<li>Interfaces to explore: For each of the databases (spreadsheet) and developed taxonomy, we would want interactive web interfaces to explore the taxonomy, the criteria, or some combination of the two. The interface should allow a researcher to submit new software, or apply a custom filter.</li>
<li>Data Sciences: Having the data will allow us to pursue next steps, namely deriving more detailed features that are strongly associated with research software. For example, having links to source code could help us determine if it’s the case that “more strongly” research software has more contributors, is older, in a particular language, with great documentation, etc. The database opens up a whole new means to better understand research software.</li>
</ul>

<br><br>

# CONCLUSION

In this paper, we’ve discussed criteria for research software, a taxonomy to define it, and a general framework and tools for creating a definition useful for a particular context. We’ve learned that asking questions can be useful for the development of criteria, and that like many things, there isn’t a one-size-fits-all answer. Despite this quality, we still need to be able to make classifications that drive life decisions. The definition of research software is, somewhat ironically, not a clear definition that you write on a single page, but rather a gradient of features that can be filtered and viewed based on the context they are viewed. The definition of research software is subjective on the level of a use case, but not subjective in terms of its overall assessment. Although we might never come to an agreed upon definition, we can be somewhat confident in our ability to ask a series of questions about some piece of software, and then have confidence that the more “yes” answers we get, the more strongly we are sure it is research software. We can be confident that although we might not completely understand research software, by starting a simple taxonomy and criteria, we can further develop machine learning or other data science projects to improve our understanding. This kind of work will not only support researchers that use research software, but also empower the research software engineers that create it.

<a id="next-steps"></a>
Now, I'm currently the only author, because this has been dumped directly from my brain
into this markdown, but I want this to be a work of our community. This includes research software
engineers from all domains, all kinds of institutions, and all countries. With this post, I'll share
a link to a Google Document where I'd like you to share your thoughts, add yourself as an author,
and come to decide upon some of these criteria and the taxonomy together. I don't know where the
ultimate resting place will be, because I feel rather allergic to publication recently, but I do
think we will find a good spot for it. Thanks for listening, and I look forward to hearing your feedback
and seeing the contributions come in. <a href="https://docs.google.com/document/d/1wDb0udH9OrFWrMBsAVb8RrUMCKKRHoyEep7yveJ1d0k/edit?usp=sharing" target="_blank"> Here is the document</a>.
If you are reading this still, it must be important to you. You should be a part of this.
