---
title: "The Arden Syntax"
date: 2013-7-21 20:24:08
tags:
  arden-syntax
  curly-brace-problem
  decision-support
  mlm
  mlms
---


### What is the Arden Syntax?

* "A standard for representing clinical and scientific knowledge in an executable format."*

- The goal of the Arden Syntax is to be a standard programming language for the implementation of clinical decision support systems.
- It gets its name from a place called the "Arden Homestead" in New York, where it was prepared in 1989.
- It was first published in 1992 by this group called "The American Society for Testing and Materials," and was later on integrated into HL7.
- It is now maintained by the HL7 organization, which means "Hospital Level 7" because level 7 is the applications layer of the [OSI model](https://en.wikipedia.org/wiki/OSI_model).
- You could use it to create decision support systems that qualify as demonstrating "meaningful use."

 

#### Advantages

- it is an actively developed HL7 standard
- it is made with the goal of being readable by a human
- it has measures for time and duration, important in medicine  (specifically each data item in th syntax has two components, the value and primary time)
- it has nice list handling

 

#### Challenges / Disadvantages

- integration with current hospital systems
- lack of standardized vocabularies and patient data schemas
- difficulties providing actions for clinicians to take
- lack of up to date tutorials and manuals
- **The curly braces problem**: in an MLM, curly braces are used to signify parts of the MLM that are specific to the surrounding health IT system. These fragments would need to be customized for each implementation, and this is why we can't just have a central repository of MLMs for all institutions to use.

 

### How is the code organized?

Into THREE modules, called the "Medical Logic Modules (MLMs) that are each self-contained files.  The execution or "trigger" of these files can be based on data or time-based events, or directly by a person. A MLM can also trigger other MLMs.

 

### What does an MLM look like?

The image below is an example of an MLM, written in Arden syntax, to calculate BMI given an individual's size, weight, and birthdate.

[![](http://ars.els-cdn.com/content/image/1-s2.0-S1532046412000226-gr1.jpg)](http://ars.els-cdn.com/content/image/1-s2.0-S1532046412000226-gr1.jpg)

 

### What kinds of MLMs are there?

There are three categories of MLMs:

- Maintenance: contains metadata about the MLM (author, creation date)
- Library category: background information (references, goals of MLM)
- Knowledge category: contains actual algorithms, database parameters, when the MLM should be triggered etc.  Three sub categores are evoke, logic, and action, i.e., when to evoke, what to do, and what output to produce

 

### How would I use this?

1. You would use an Arden Syntax IDE to write MLMs
2. You would compile with the IDE, producing Java classes out of MLM code
3. You would then use an Arden Syntax Rule Engine to execute the compiled MLMs
4. This rule engine can come by way of an Arden Syntax Server

**What are examples of implementations of Arden Syntax?**

- HEPAXPERT: Checking and interpreting hepatitis A,B, and C serology (meaning studying blood serum) test results, by way of a web interface or an API. They were able to integrate this into several hospital systems, and an expected ipad/iphone app! (Hepaxpert)
- THYREXPERT: interprets thyroid test results
- TOXOPERT: assist in the interpretation of time sequences of toxoplasmosis serology test results
- Moni-ICU: (monitoring of nonsocomial infections in intensive care units): detects and continuously monitors hospital acquired infections
- Reminder Applications: reminder applications (in use in some VA hospitals) include reminders for eye exams,vaccinations, and  mammograms.  A single MLM is associated with each reminder.

 

**The Future?**  libraries of MLM syntax (akin to the Apple App store) for download and use!


