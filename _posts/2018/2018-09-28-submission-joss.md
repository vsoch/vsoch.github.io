---
title: "Validation for Journal of Open Source Software"
date: 2018-09-28 3:20:00
toc: false
---
 
I am absolutely taken with the <a href="http://joss.theoj.org" target="_blank">Journal of Open Source Software</a>. 
It's easy to submit to, and all under version control. Interaction is driven by the eternally
adorable <a href="https://github.com/openjournals/whedon" target="_blank">Whedon bot</a>, 
and submitting a paper has gone from arduous and annoying to fun and easy. I'll leave it up to you to explore more 
via their new <a href="https://joss.readthedocs.io/en/latest/index.html" target="_blank">documentation base</a>.

> What makes JOSS so important?

I'm not taken with it because of using Github or Whedon, I believe in my deepest
of dinosaur feelings that this is how peer review should be. It's completely open,
and here I have received both (ironically) the highest quality and quickest review of my work.
I've been a reviewer several times, and the process is clearly stated with checklists
and easy back and forth. It's also a living publication in that the code and paper
continue to be active as Github repositories. If a change is warranted in the codebase,
the paper is still in reference to a timepoint, but we can move forward from there.
This kind of setup allows for more of a 
<a href="https://vsoch.github.io/2017/reproducible-impossible/" target="_blank">living publication</a> than
any old crusty online journal might. Do you have any idea how hard it is to take something
that is almost historic, and a bit dry, and not only improve it, but make it fun?
I don't doubt that a lot of care has been put into developing the open journals.

For scientists, it's important for you to note that this mechanism of publication is the
strongest way to ensure reproducibility of your method and code. The entire generation of the paper,
and (since these are software submissions) testing of the software is also documented and
under version control. It generates a DOI for you and has all the components to make
a reproducible product.

# How could I help?

As an early user, I noticed that many aspects of the checklist I could potentially
check programatically. For example (but not limited to):

<ol class="custom-counter">
<li>Checking for an acceptable word count</li>
<li>Validating the references in the paper.bib</li>
<li>Generating a PDF to preview (before you submit!)</li>
<li>Checking for an open source license</li>
<li>Checking for a CONTRIBUTING.md</li>
</ol>

Toward this goal, I'm happy to share with you something the <a href="https://openbases.github.io/bases" target="_blank">openbases</a> team has been working on!

<br>

# Submission to the Journal of Open Source Software

The <a href="https://github.com/openbases/submission-joss" target="_blank">submission-joss</a>
template provided by the <a href="https://openbases.github.io/bases/" target="_blank">openbases</a> organization
will do these things for you! You simple can:

<ol class="custom-counter">
<li>Fork the repository, add your paper, and connect to CircleCI and Github Pages</li>
<li>The paper markdown and bibliography are <a href="https://openbases.github.io/openbases-python/html/usage.html#validation" target="_blank">tested and validated</a></li>
<li>When passing, a rendered preview is available as a <a href="https://circleci.com/docs/2.0/artifacts" target="_blank">
build artifact</a> or <a href="https://openbases.github.io/submission-joss/" target="_blank">live paper</a></li>
</ol>
 
And then you get a Github repository with a tested paper.md and paper.bib, and one
that renders a <a href="https://openbases.github.io/submission-joss/" target="_blank">beautiful preview</a> of your JOSS paper!

<div>
<img src="https://github.com/openbases/submission-joss/raw/master/img/joss.png" style="padding-top:20px; padding-bottom:20px">
</div>

And are you worried about making changes to your pdf, and then losing the intermediate
versions? If you peep into your 
<a href="https://github.com/openbases/submission-joss/tree/gh-pages" target="_blank">Github Pages</a>
branch, guess what? You find that the openbase template generates an archive named by commit for each one.

<br>

## What submission-joss is not

To be clear - this will <strong>not</strong> submit the paper for you, and it does not
replace the work of our beloved Whedon to drive the interaction. It's a tool that you
can use before your submission to test and validate, preview, and then make the submission
a little less errored than it might have been. This will also not check the important
"human" components of the submission - reading the text of the paper and checking
for its quality and content, etc.

<br>

## What Criteria Are Checked?

The criteria come by way of the <a href="https://openbases.github.io/openbases-python/html/usage.html#validation" target="_blank">openbases python</a>
validator, and you can take a look <a href="https://github.com/openbases/openbases-python/blob/paper/validation/openbases/main/validate/criteria/paper.yml#L31" target="_blank">here</a>. Basically, we check for the easy things like
length and formatting. If you want to contribute to the validation, please file an issue or pull request to
<a href="https://www.github.com/openbases/openbases-python" target="_blank">openbases-python</a>.

<br>

# Openbases

The <a href="https://openbases.github.io/bases/" target="_blank">openbases</a> are really cool
because they are put together in a modular fashion. Even the badges are generated by one! We have builders,
paper and experiment generators, and robots. Each is a little fun, and generates something useful
and reproducible for science. For example, this tool is a combination of:

<ol class="custom-counter">
<li>extracting metadata from a markdown file</li>
<li>validating the markdown based on some criteria</li>
<li>generating a random (or in this case, regular expression matched) icon from a static API</li>
<li>buiding a PDF</li>
</ol>

And with the continuous integration recipes we can plug all of the above into a template. For you,
it's just a matter of forking the repository with the template, and adding your customizations.
If you wanted to do all this for a single paper, experiment, etc., it would be a bit burdensome. 
This is the goal of the openbases - to be <strong>useful, reproducible, and fun templates for research</strong>.
The <strong>open</strong> is important because we are an open source group. The term <strong>bases</strong>
is also important because each base can be put together in a modular fashion to create something greater.
Without your paper, or your experiment, it's just a base waiting for life. With the content provided by the
user, it's much more.

This means that you can start with something as simple as a paper.md file (a markdown file where you wrote a blob of text, your paper) and then add it to version control, connect to a continuous integration service (CircleCI)
and in a few clicks get multiple levels of testing, building of containers, and rendering
of beautiful web pages for your work along with your version control. Just for the 
<a href="https://github.com/openbases/submission-joss" target="_blank">openbases/submission-joss</a>
template here, we use the following openbases:


### openbases/openbases

<a href="https://openbases.github.io/openbases-python/html/docker.html" target="_blank">openbases/openbases</a> 
python is a command line (or linked here) Docker image that serves entry points to validate your markdown (`ob-validate`) 
and references, along with the binary to generate the icons (`ob-icons`), badges (`ob-badges`), and even
extract values from the markdown easily from the command line (`ob-paper`)


<br>

### openbases/openbases-pdf

But these bases won't generate the <a href="https://openbases.github.io/submission-joss/" target="_blank">web
interface</a> for you with the PDF rendering. This is actually done by the 
<a href="https://www.github.com/openbases/openbases-pdf" target="_blank">openbases/openbases-pdf</a> 
container. You could run these Docker commands locally to generate
your PDF preview. But remember the value of version control, friend! :)

<br>

### openbases/builder-pdf

But what if you want to remove the JOSS branding, and skip the specific vaidation, and just generate 
the PDF? If you want a similar repository template to **just** do that, then you
want the <a href="https://www.github.com/openbases/builder-pdf" target="_blank">openbases/builder-pdf</a>, 
which will also choose a cute icon instead of the joss logo <a href="https://openbases.github.io/builder-pdf/" target="_blank">like this</a>.


<div>
   <img src="https://github.com/openbases/builder-pdf/raw/master/img/preview.png" style="padding-top:20px; padding-bottom:20px">
</div><br>


### openbases/openbases-icons

But forget about the papers and science, just give me icons! Well, if you have a set of png (or other)
images that you like, and have always wanted to serve a static API to retrieve them (as we do for the 
images in the papers above), then check out the 
<a href="https://openbases.github.io/openbases-icons/preview" target="_blank">openbases-icons</a>.
That's generated from a static Github repository, all via the same methods we just talked about!

And then you interact with the API like this:

```bash

# via docker
$ docker run openbases/openbases icons

# pip install openbases
$ ob-icons --help
$ ob-icons
```

This is the vision of the <a href="https://github.com/openbases" target="_blank"> open research bases</a> organization,
to build and work together to make open source bases and templates for the reproducible workflows, publications, and software!
Please join, and reach out to me with any ideas, questions, or desires for collaboration!

I'll leave it at that! For detailed instructions on using the template and connecting to Circle,
please see the README in the <a href="https://github.com/openbases/submission-joss" target="_blank">openbases/submission-joss</a>. And to the maintainers of JOSS, the open journals, and Numfocus that supports them, we salute you.
Keep up your good work, the community needs you, values you. You have supported us, and we want to be here to support you too.
