---
title: "Hospital Chargemasters"
date: 2019-02-11 7:05:00
categories: rse
---

On January 1st, 2019, the Center's for Medicare and Medicaid Services <a href="https://www.cms.gov/newsroom/fact-sheets/fiscal-year-fy-2019-medicare-hospital-inpatient-prospective-payment-system-ipps-and-long-term-acute-0" target="_blank">Price
Transparency Law</a> went into effect. It mandates that hospital's share
their chargemasters, or a listing of services and prices. I found out via
<a href="https://qz.com/1518545/price-lists-for-the-115-biggest-us-hospitals-new-transparency-law/" target="_blank">this article</a> from Quartz. 
Specifically, the <a href="https://www.cms.gov/Medicare/Medicare-Fee-for-Service-Payment/AcuteInpatientPPS/Downloads/FAQs-Req-Hospital-Public-List-Standard-Charges.pdf" target="_blank">law</a> mandates that the data be "machine readable," or in their own words:

> ...a digitally accessible document but more narrowly defined to include only formats that can be easily imported/read into a computer system (e.g., XML, CSV). A PDF, on the other hand, can be a digitally accessible document but cannot be easily imported/read into
a computer system.

The article caught my attention for two reasons. Firstly, the US healthcare system
is strange and mysterious to me, but my experience with open source software engineering
and science has taught me that openness and sharing, although sometimes against
common cultural standards, tends to lead to good things. The spirit of the law
seems to reflect this as well, describing the law as:

> a final rule to help empower patients through better access to hospital price information, improve the use of electronic health records, and make it easier for providers to spend time with their patients.

I can also put myself in the shoes of the hospital and imagine that this transparency is scary. There are many additional factors that go into calculating actual costs (namely
insurance, services, and eligibility for financial assistance) and not only is it challenging to declare some cost, but it might also interfere with how a hospital
runs its business, period. But this transparency is a big deal, and I want to help.

## A Shared Goal

There is no "Us vs. Them" mentality here. Let's step back, and realize that despite some possible tension, both providers and consumers are striving for the same goals. Providers want to deliver care and maintain their business, consumers want quality care. If transparency can help to change the landscape to support this goal, then it's important. 

This law, and the data that is released, is valuable because of these shared goals. I don't have enough experience in health care finance to have vision for how the data could be used toward this goal, but my intuition is that others do. I'll also note that despite this law, it seems that the data was hard to find on many sites, and even once
found, still challenging to parse. Granted that this is the first time hospitals are having a go at this, I believe that most gave a best effort, and maybe just
need a little help. In this writeup, I'll cover three main areas:

<ol class="custom-counter">
<li><a href="https://www.github.com/vsoch/hospital-chargemaster" target="_blank">The Hospital Chargemaster Dinosaur Dataset</a> (described below) reviews the data.</li>
<li><a href="#how-to-release-a-good-chargemaster">How to Release a Good Chargemaster</a> discusses challenges that I ran into obtaining and parsing the chargemasters.</li>
<li><a href="#open-source-hospital-tools">Open Source Hospital Tools</a> is a question for you. Why can't we bring the power of open source to health care?</li>
</ol>

## The Hospital Chargemaster Dinosaur Dataset

After reading <a href="https://qz.com/1518545/price-lists-for-the-115-biggest-us-hospitals-new-transparency-law/" target="_blank">the article</a>, I decided to harness my superhuman powers of
focus and motivation to do repetitive tasks to help. This meant lots of data parsing in my free time, and it was a great experience for an infinite loop dinosaur like myself. Today I'm releasing the
<a href="https://github.com/vsoch/hospital-chargemaster" target="_blank">Hospital Chargemaster Dinosaur Dataset</a>, one of the 
<a href="https://vsoch.github.io/datasets/2019/hospital-chargemasters/" target='_blank'>Dinosaur Datasets</a> for something I think is interesting that possibly is being overlooked. It's my best effort to obtain and parse as many of the major hospitals across the United States into more of a standard format for interested researchers to learn from. I'm still finishing up a few of the larger folders, but largely it's all there, and I'll update as needed.

### Who are these chargemasters for?

While the law suggests that the data is for
consumers, I don't believe this can be the case. This data is not for some 

> Like, omg! Let's go shopping for PANCREAS; LIVER & SHUNT PROCEDURES, like who has the best deal? 

If the goal is for machines to find the chargemasters, then the release of this data cannot be intended for consumers, but rather for researchers and developers to collaborate and help.  To show you that there is interesting signal in the data, here is <a href="https://www.github.com/vsoch/hospital-chargemaster-analysis" target="_blank">one tiny analysis</a> of building a linear model and using Lasso for feature selection to predict prices based on description terms for one hospital. There is no validation or tuning, but I think the simple notebook in the repository shows that there is signal (and interesting questions) to ask of the data.

Although I originally planned to create a web interface to explore the data, I decided that my intended audience was not the consumer, but rather researchers that could make intelligent conclusions from
the data. If you are interested in the download and parsing, see the 
<a href="https://github.com/vsoch/hospital-chargemaster" target="_blank">README</a>
in the repository. 


### How is the data organized?

Briefly, I'll summarize what you will find:

The main folder "data" has a subfolder, one subfolder per hospital (or hospital site providing several hospital datasets). Within a hospital folder, the subfolders
coincide with dates when the data was obtained. The last obtained is in the "latest"
folder:

```

data/northside-hospital
├── 2019-01-18
│   ├── northwestern-memorial-hospital.xlsx
│   └── records.json
├── data-2019.tsv
├── data-latest.tsv
├── latest
│   ├── northwestern-memorial-hospital.xlsx
│   └── records.json
├── parse.py
└── scrape.py

```

"latest" is a convention that comes from <a href="https://medium.com/@mccode/the-misunderstood-docker-tag-latest-af3babfd6375" target="_blank">containers</a>. 
The basic idea is that future datasets will fit nicely into this organization.
Currently, within each folder there is one script to download (scrape.py) and one script to
parse the data (parse.py) that is ultimately saved to the "data-*.tsv"
files in the folder. What will you find in these data frames?
I wanted to provide minimally an identifier for a charge (charge code), a price in dollars, a description, and the hospital id (the folder) along with the filename
that the data come from:

 - **charge_code**
 - **price**
 - **description**
 - **hospital_id**
 - **filename**

<br>

At some point I realized that there were different kinds of charges, including inpatient, outpatient, DRG (diagnostic related group) and others called
"standard" or "average." I then went back and added an additional column
to the data:

 - **charge_type** 

<br>

can be one of standard, average, inpatient, outpatient, drg, or (if more detail is supplied) insured, uninsured, pharmacy, or supply. This is not a gold standard labeling but a best effort. If not specified, I labeled as standard, because this would be a good assumption.

Finally, I want to stress that this is publicly available data, and is provided in this 
repository with good intention and faith that transparency is important. I make no guarantees, and am not liable for how you might use it. If you find an issue, you are encouraged to help to fix it by opening an issue.

## How to Release a Good Chargemaster

After programmatically downloading and then parsing over one hundred of these
chargemasters, I am in a unique position to give feedback about some suggested
"How to Release a Good Chargemaster" practices, at least from a "is it machine readable"
standpoint. I'll give a quick bulleted list, and provide details for those interested:

<ol class="custom-counter">
<li>Machine readable really means .csv, .tsv, or excel.</li>
<li>Provide direct download links clearly designated on a main page.</li>
<li>Be cautious of exporting formats and encodings that aren't easily readable.</li>
<li>Name columns consistently, don't use abbreviations, or newlines.</li>
<li>Don't add empty lines, or unexpected metadata lines. The first line should be columns headers.</li>
<li>When in doubt, ask a programmer to test programmatically downloading and parsing.</li>
</ol>

<br>

### 1. Machine Readable

Despite the instruction to not use PDF, a few hospitals still chose to release this format. I tried in a few cases to parse the PDF, but it was near impossible to find
consistency between the various documents. Machine readable really means a comma or tab delimited file, and even an excel file, and (worst case) xml.

### 2. Provide Direct Links to Download Files

The easiest way for a file, regardless of format, to be easy to programmatically download
is to provide a direct link to it from a main page. When I say main page, I mean a page that is the fewest number of clicks away from some primary "this is the hospital charge information page." The more forms that I need to fill out, or boxes that I need to check, the harder this task becomes because I have to use a robot scraper (e.g., [selenium](https://www.seleniumhq.org/)) instead of just parsing the static HTML. Many of the interfaces seem to be designed for the user experience with
multiple selections, drop downs, and buttons to push before seeing some filtered view of the data. This does not conform to being machine readable - this is <italic>human</italic> readable. If my machine can't retrieve the file after I've tried all the tricks I know, it's not easy enough.

### 3. Format and Delimiters

For many files, there were issues with encoding (meaning files in latin-1 or other 
encodings that were not readable with utf-8) that I had to either read with
<a href="https://docs.python.org/2/library/codecs.html" target="_blank">codecs</a>
or use <a href="https://linux.die.net/man/1/dos2unix" target="_blank">dos2unix</a> to fix first. 
Specifically, I don't want to see this error message:

```bash

UnicodeDecodeError: 'utf-8' codec can't decode byte 0xa0 in position 17: invalid start byte

```

(insert tiny screams). But let's talk about delimiters. If you have an excel sheet and save to csv, <strong>you cannot have commas in the prices or descriptions.</strong>. I had to resort to some extreme regular expression-fu to parse these files. If you can't be sure that
the data doesn't have commas, then use a tab delimited file. Even saving to an excel
sheet (xls or xlsx) is much better because it's fairly easy to <a href="https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.read_excel.html" target="_blank">read these files</a>. I personally found the excel sheets exported
as xml to be a nightmare, and would advise against that. On the other hand,
here is an excel file that I read in cleanly, and one that has naming
and formatting that make me very happy:

```

   Charge#                Description   Price
0    13144  ROOM CARE SEMI PRIVATE-2T  5181.0
1    13177    ROOM CARE SEMI PRIV- 2S  5544.0
2    13185     R0OM CARE SEMI PRIV-2S  5544.0
3    13193   ROOM CARE SEMI PRIV - 2N  5544.0
4    14050    ROOM CARE SEMI PRIV-SUR  5544.0

```

Great job to this mystery hospital!

### 4. Sheet Organization

If you are using excel, try to put the primary data in the main sheet.
If you have extra metadata to add to an excel file, use an additional sheet (not the first!)
as the reader of the file expects the first row to be column names. Many of these
files were challenging to parse because the creators took anywhere from 1 to 12 columns
to add additional information or metadata about the hospital. Additionally, don't
include additional headers or rows with metadata scattered throughout the data.
The machine reader will not expect headers in the data, and thus parse them as rows of data.

### 5. Columns and Naming

Please give your columns clear names. Don't put newlines in the column names.
If you have multiple files that are delivering different views of the same
kind of data, be consistent in the column names. And use correct spelling. Yes,
there were spelling mistakes across these files. It's okay, we're all human,
but it is good to double check.

As for units, a lot of files were specific to say dollars ($100.00) and then
provide the field as a string. I have mixed feelings about this, because on
the one hand, we can assume a U.S. based hospital is dollars, and then provide
a float number without commas and dollar signs. On the other hand, if there could
be another currency in the mix, it's probably worth the extra parsing.

## Open Source Hospital Tools

As human beings (and dinosaurs) we share this common goal to make the world a better
place. As a software engineer that has been in hospitals way too much, I am
inspired by the impact that <a href="https://www.cbinsights.com/research/report/google-strategy-healthcare/"
target="_blank">technology can have.</a> But I'm also intensely aware of how
the culture of research in healthcare is fundamentally different from many domains
of science. Hospitals are run more like businesses than anything else, and there are
significant challenges to sharing data, and standardization and developing tools. 
Remember the <a href="https://www.nature.com/collections/prbfkwmwvz" target='_blank'>
reproducibility crisis?</a> It led to a cultural shift that has had huge beneficial impact
on our ability to work together to discover. Researchers went from hiding methods,
scripts, and data, to encouraging a culture of openness. With intersection of these two worlds, 
the same has finally started to happen for healthcare, but again, it's usually in a research
context, and not in this world of "hospital businesses." Being naive about these things, I have to ask:

> Why not open source? 

If data and standards lead to development of shared tools, and that leads to discovery,
then this is what I would push for in order for us to work together. 
To the hospitals that provide this data, know that the open source community
is here to help. There are tools like version control (GitHub), continuous integration for testing (CircleCI or TravisCI), and developers like myself that want the
world to be a better place, and can help you to do things like create
a repository for your data. Why, in fact, don't we have a collaborative effort to
do this? A lot of the issues that I outlined above could be helped by <a href="https://en.wikipedia.org/wiki/Linus%27s_Law" target="_blank">lots of eyeballs</a>.

### How can we help?

I'm just one developer, but I want to make a difference. I can tell you straight off that my
brute force strategy doesn't cut it long term. We need better ways to standardize,
share, and collaborate on datasets like these, and tools that might be related to them. If you find this data interesting or useful, please share. If you want help, then I encourage you to reach out to the community.
What does that actually mean? Share something (data, an idea, or a need) that you are able to, put it in a repository,
and tell others what you want to do. Challenge others to help you! It's more fun when
we work together! For this particular dataset, I assure you given it's complexity, and the fact
that only one set of eyeballs have looked over it, that there are issues. Thus, if you have a question or issue, please
post on <a href="https://github.com/vsoch/hospital-chargemaster/issues" target="_blank"> the GitHub issues board</a>. If you find an issue with the data, then the power of
open source compels you! Open a pull request, and make it right.

Finally, I want to encourage all of the hospitals for working hard to release this
data to keep up these kinds of efforts. Technology has a lot of bugs, and definitely a lot of hype. Despite all this, I firmly believe that technology, and working together, can have an overall
positive impact. I believe that small efforts to push for change can have impact,
and to this aim I provide you this tiny dataset. Discover away, friends!

> Happy Birthday Padr! 

I released this on your birthday in a small gesture for you. Because I'll never be a real doctor,
but I want to help too. Look... I'm helping! :)

<div style="padding:20px">
<a href="https://vsoch.github.io/assets/images/posts/hospital-chargemaster/imhelping.gif"><img src="https://vsoch.github.io/assets/images/posts/hospital-chargemaster/imhelping.gif"></a>
</div>
