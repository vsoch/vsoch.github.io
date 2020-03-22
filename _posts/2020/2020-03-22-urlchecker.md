---
title: "Checking static links with urlchecker"
date: 2020-03-22 14:47:00
category: rse
---

There are common needs across open source or academic projects that sometimes 
continually hit us in the face. They become such regular annoyances, in fact,
that we even stop seeing them. Such an example is the simple task of checking
static links in any kind of documentation or code. You know, given that you
have umpteen pages of docs, how could you easily check that the links aren't
broken?

I can give an example. For the <a href="https://us-rse.org" target="_blank">usrse website</a> one of the original
creators had set it up to use <a href="https://github.com/gjtorikian/html-proofer" target="_blank">html-proofer</a> 
that was using an underlying library called <a href="https://github.com/typhoeus/typhoeus/issues/182" target="_blank">typhoeus</a> 
to implement the checking. For a general request, it worked <strong>most of the time</strong> but as you can see
from the link, since the library has no implementation for a retry, this means that a failing
link is common. It was so common, in fact, that I <a target="_blank" href="https://github.com/USRSE/usrse.github.io/issues/171">started to look into</a> how to go about addressing it. Since I was always one to quickly respond to CI
failures, the burden of re-running these failed checks on merges to master (after
the same commit passed for a pull request) was repeatedly on me.

## URL Checker

At this point I started to keep my eyes open for other tools in the ecosystem that
might be able to provide such an easy service, checking urls in static files.
I also had my eye on the lookout for a tool that would best serve the scientific
community, likely meaning something in Python. It's not to say that other languages aren't
equally good, but rather if something breaks or needs a look in terms of the code,
if the language is something familar, it's easier for the community to adopt (e.g.,
html-proofer is in ruby, which isn't common amongst scientific programmers).
It was after a few months that I stumbled on the <a href="https://github.com/urlstechie" target="_blank">urlstechie</a> organization, 
which was created by <a href="https://github.com/SuperKogito" target="_blank">SuperKogito</a> for this exact purpose.

<div style="padding:20px">
<img src="https://raw.githubusercontent.com/urlstechie/urlchecker-python/master/docs/urlstechie.png">
</div>

I was pumped! I forged ahead to open up issues for the features that I saw important,
and wound up doing a few major pull requests:

<ol class="custom-counter">
  <li><a target="_blank" href="https://github.com/urlstechie/urlchecker-action/pull/17">Adding retry parameter</a></li>
  <li><a target="_blank" href="https://github.com/urlstechie/urlchecker-action/pull/19">Prettify-ing the interface</a></li>
  <li><a target="_blank" href="https://github.com/urlstechie/urlchecker-action/pull/24">Optimizing for GitHub actions (local checkout)</a></li>
  <li><a target="_blank" href="https://github.com/urlstechie/urlchecker-action/pull/30">White listing files</a></li>
  <li><a target="_blank" href="https://github.com/urlstechie/urlchecker-action/pull/36">Refactoring action</a> to use <a href="https://github.com/urlstechie/urlchecker-python" target="_blank">urlchecker-python</a></li>
</ol>

The last one was hugely fun, and I did yesterday. What exactly is urlchecker-python? Let's
talk about that next.

### urlchecker-python

Here's the thing - although the original repository `urlstechie/URLs-checker` was a GitHub action, 
it was sort of a Python module and GitHub action squished into one. This happens sometimes when we 
create small snippets of code intended to run as actions, but then realize we want to extend them
beyond that. Being able to reproduce an action locally using the same exact underlying tooling 
is hugely important for developers to be able to do - if I'm going to run the urlchecker for a GitHub workflow test, 
I want to be able to run it locally to reproduce the same tests. We thus
decided to embark on gutting out the core of the GitHub Action (at that time)
and creating a separate Python library. And tada, <a href="https://github.com/urlstechie/urlchecker-python" target="_blank">here it is!</a>.
You can install it with pip:

```bash
pip install urlchecker
```

And you can now easily check a repository (documentation and code) locally, using the
same parameters that are plugged into the GitHub action:

```bash
urlchecker check .
```

Here is an example run. This is the same action that is run for the <a target="_blank" href="https://github.com/rseng/awesome-rseng/blob/master/.github/workflows/urlchecker.yml">awesome-rseng</a> repository. This command says to check all markdown files,
but skip the files in docs in the present working directory (.).


```bash
urlchecker check --white-listed-files docs --file-types .md .
```

<script id="asciicast-312533" src="https://asciinema.org/a/312533.js" data-speed="2" async></script>

So if you have struggled with checking static links in the past, look no further!
Here is a quick example to get you started:

```yaml
name: URLChecker
on: [pull_request]

jobs:
  check-urls:
    runs-on: ubuntu-latest
    steps:
    - name: Checkout Actions Repository
      uses: actions/checkout@v2
    - name: Test GitHub Action
      uses: urlstechie/urlchecker-action@0.1.7
      with: 
        file_types: .md,.py
        white_listed_files: docs
```

I'm having a lot of fun developing these tools, so please <a target="_blank" href="https://github.com/urlstechie/urlchecker-action/issues">open an issue</a> if you have any questions, feature requests, or just want to say hello! We have
a fabulous <a href="https://urlstechie.github.io/" target="_blank">old school style</a> website
with information about urlstechie. 

<div style="padding:20px">
<img src="https://raw.githubusercontent.com/vsoch/vsoch.github.io/master/assets/images/posts/urlstechie/urlstechie.png">
</div>


If you are interested in contributing, please send
us a note!
