---
title: Proposal Jekyll Template
date: 2022-02-19 21:30:00
category: rse
---

Would it be possible to make some kind of collaborative proposals interface on GitHub pages?
This last week I was helping to draft proposals, and as they moved from the "rough Google Doc" state
to a "we really would like to have these openly collaborated and worked on" state. At this point, a fiendish question started
to peep into my mind:

> Can we have an automated proposals framework using GitHub?

And so I woke up this morning (rather late mine you because last week was stressful) and decided to jump
to it! To be clear, this is something absolutely nobody will ever ask for or need, but it's reached the state
of "exciting project" for this dinosaur and I couldn't help but not devote the entire day to it.
 I decided that if I could pull this off, I wanted to do it by the end of the day (in under about 14 hours).
I even abandoned the idea of working on three other projects I was excited for in lieu of this.
This post (written in the same night in that time-frame!) is a story of this day. And if y'all are sleeping
and nobody ever reads this that's fine too. There is something to say for being taken with an idea,
running away with it, and learning from that.

## Proposals Jekyll

On a high level, I wanted a template and actions to help you (or me) to collaboratively work on 
markdown documents, which we might say are proposals for something. This means that:

<ol class="custom-counter">
  <li>Opening a pull request updates a draft in a web interface</li>
  <li>Merging a pull request moves it from draft to in progress.</li>
</ol>

And anything that you are working on can be rendered in its current pretty state, and then
have discussion picked up in the pull request. To be fair, the document could really
be about anything that fluctuates between draft and in progress states. In more detail, this means
that new pull requests opened on the repository are considered proposals, and if you open a pull request 
that already has a PR for a proposal open it will not be allowed. A new or updated proposal will always trigger a
workflow to add the draft to the web interface, and then merging a pull request will add 
the draft as a final "approved" or in progress proposal.

The draft proposals in the interface are linked to their last pull request for easy discussion.
Closing or otherwise not continuing a pull request does not delete the last draft. We do this so that drafts stay accessible
for someone else to pick up and work on if desired. If you are interested in deploying your own proposals repository,
<a href="https://vsoch.github.io/proposal-jekyll/docs/getting-started" target="_blank">check out the instructions</a>. Otherwise, keep reading!

## Working with Proposals

Since the site is based on the workflows of adding proposals, I want to walk through those.

#### How do I create the proposals template?

The workflows are able to update an interface while some proposals are still in discussion because we keep
the interface separate on the gh-pages branch. This means after fork or push to your branch, you can run the
Creation workflow to make an initial copy of the site.

#### How do I add a new proposal?

To submit a proposal, you open a pull request to the repository. 

<ol class="custom-counter">
  <li>The markdown file should be added under proposals at the top level.</li>
  <li>The name of the file should correspond to the title.</li>
  <li>You should not write the title or front end matter in the document - it will be added by the automation.</li>
  <li>Merging a pull request will add the draft as a final "approved" state, and remove from drafts.</li>
</ol>

Once you've prepared the markdown file, you can open a pull request to the repository.
If you aren't a contributor, when the workflow is approved it will add the draft to
the site as long as someone else isn't making changes to the same proposal. I was originally implementing
this via checking the files verbatim, but ultimately found it much easier to use the GitHub API. If
the check fails, the error message in the CI will tell you for what PR the file is being worked on.
Here is what a draft looks like, and note the link to the pull request at the top in purple:

<div style="padding:20px">
 <img src="{{ site.baseurl }}/assets/images/posts/proposal-jekyll/proposal-draft.png"/>
</div>

The way I implemented this was fairly straight forward, although it took a few iterations to get right.
I would look for changed files, and given that a changed file was under "proposals" I would copy it to a template
file in a temporary location with added metadata, and pipe in into the next step via an output.
The next step would then find that there are changed files, and update the gh-pages branch (where
the interface is) to show them. Again, we don't touch any previous version of an "approved"
proposal because if a draft goes away and dies, we don't have to have lost the initial approved
version.

#### What happens on merge?

On merge was challenging, because we need to check the gh-pages branch for the draft,
remove it if it exists, and re-deploy to the "approved" directory (where the proposal will
be tagged with inprogress. Here is an example of an approved or in progress proposal:

<div style="padding:20px">
 <img src="{{ site.baseurl }}/assets/images/posts/proposal-jekyll/proposal-inprogress.png"/>
</div>

I tested this workflow a few ways. I wanted to first make it a pull request closed and "merge"
event, but I found I couldn't easily get changed files that way. So instead of adding a link
to the closed pull request on approved proposals, I just didn't. If GitHub ever exposes a discussions API
we could have a new discussion item made for the entry based on the identifier.

#### How do I update an existing proposal?

All proposals live in the `proposals` directory on the main branch. When you want to edit
an existing one, you can simply make changes and open another pull request. By way of having
the same filename, the proposal on the site will be updated to create a draft state.
While you are working on the draft, the previous approved proposal (if applicable)
will not be touched. The reason is because if you close the pull request we wouldn't
want to alter or remove it. And as stated before, you can't work on a proposal with a PR
already open.

#### How do I update the site template?

I would recommend making changes to "docs" in the site main branch, and then pushing
to main and running the update workflow. You can also just clone GitHub pages and work there,
however if you then accidentally run the Update Pages workflow those changes will likely be lost.

#### How do I delete a proposal?

To delete a proposal, simple open a pull request to delete the file
from the main branch. For the sake of caution it won't be deleted on the PR, but when it is merged
into main. You can also ask the maintainer to manually delete the file
from the branch in the UI, which might be easier.


#### What happens if close a pull request?

We actually don't delete a draft on the interface, because if someone is browsing
and finds the idea (and likes it) they can easily find the closed PR and keep working on it.


#### What happens if two pull requests are working on the same file?

By default, we are only allowed one draft in progress at once. If you open
a pull request and the draft is being worked on somewhere else,
the PR will fail. This also applies if you close and re-open the pull request.
You should thus check before you open a PR that there isn't already a draft in progress, or just wait for the CI to tell you!


## Summary

And that's mostly it! Now mind you, this was whipped together in a day and I will do much
more testing when I deploy it to another organization to use for actual proposals, but if you
try it out and run into an issue or have a question <a href="https://github.com/vsoch/proposal-jekyll">please let me know</a>.
I love to think about collaborative workflows that can be enabled with simple GitHub pages and workflows,
and this definitely falls into that bucket!

It's also fun to think about how this basic version could be extended in many ways! I already
mentioned added a discussions link, and I think the more production version of this would be
to make a GitHub app that can respond to commands and different events. But that's probably
overkill to deploy a server - I'm very happy to not do that :)
