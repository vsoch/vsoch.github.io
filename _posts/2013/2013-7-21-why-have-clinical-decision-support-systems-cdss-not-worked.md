---
title: "Why have clinical decision support systems (CDSS) not worked?"
date: 2013-7-21 20:30:56
tags:
  cds
  cdss
  decision-support
---


This is by no means an all encompassing list, but I wanted to have a place to jot down some ideas for why[ CDSS are largely just mediocre](http://www.ncbi.nlm.nih.gov/pubmed/22751758).  The big picture summary is that there are problems with the models to base the decisions on, access to quality, well organized data, a lack of standards for driving the CDS, and an ability to well integrate them into current hospital systems and workflows.  Specifically:

**Our models of disease aren't good enough:**  
 if we are making decision support for Rx and we still have not identified the correct representation of a disease, how can we predict it?

**The data isn't there / not accessible:**  
 There are privacy issues, or infrastructure of hospital that the system will be used in is not setup to allow for connection and use of relevant data sources

**Lack of communication between developers and users:**  
 leading to a system that doesn't fit in with clinical workflow

**Integration with current hospital systems:**  
 A CDS system can only work in practice when it is wellintegrated with existing medical information systems

**Lack of standards: **  
 Good CDSS are reliant on having standards for data, information models, language, and methods for referencing them. For example,

- Medications: RxNorm
- Information models: HL7
- Patient Data: some virtual medical record? (vMR)
- Approaches for terminology / ontology inferencing (OWL)
- and of course, [Arden Syntax](http://www.vbmis.com/learn/?p=449 "The Arden Syntax") for taking data --> executable model
