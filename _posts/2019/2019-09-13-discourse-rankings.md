---
title: "Discourse Contribution Rankings with Ruby"
date: 2019-09-13 15:00:00
---

We've recently been interested in coming up with ways to improve user interaction
for <a target="_blank" href="https://ask.cyberinfrastructure.org">AskCI</a>. Specifically,
we have a "Question of the Week" that we intended to use to engage users, but historically
it doesn't seem to encourage much participation.

## Groups can grow community

I think we can do better - and it comes down to figuring out how to make the site more fun.
What we really need is to grow a sense of community. How might
we start to do that? It actually comes very easily by way of how our particular site is structured -
we have different categories that correspond to institutions like "Harvard" or "Stanford."
It's then incredibly easy to <a href="https://meta.discourse.org/t/how-to-assign-users-to-groups/41862">create groups</a>,
and in fact have users automatically added based on their email alias. I was able to set 
this up, with one group for each category board, resulting in 9 groups that were institution
specific, in addition to the typical groups based on trust levels and permissions.

<div style="padding:20px">
  <img src="/assets/images/posts/discourse-ranking/groups.png">
</div>

In fact, if you are part of AskCI, you can very easily <a href="https://ask.cyberinfrastructure.org/groups" target="_blank">visit the groups page</a> and join your group(s)!

## Healthy Competition

Once we have these groups, wouldn't it be fun to base a lot of activities on the site,
or incentives for participation, in a competitive context? If we could give our prizes, for
example, for the top group or individual to contribute in some way, that would be really fun.
Having fun is probably the only reason I do anything these days, so this is a good incentive for me.
With that in mind, I decided to explore the <a href="https://docs.discourse.org/" target="_blank">Discourse API</a>,
and very happily found that I could retrieve user and post information with the simple use
of an <a href="https://meta.discourse.org/t/user-api-keys-specification/48536" target="_blank">API token</a>.

## Programmatic Metrics

Of course I would want this to be totally automated. Even navigating through the stats on a weekly
basis to look at specific fields I find arduous. I started to write a Python script to parse
the various endpoints, but decided to have a little more fun by challenging myself to do it with
Ruby. Discourse is implemented in Ruby, so this felt like the right thing to do, in spirit.
I'm obviously not a ruby developer, and would need to figure out the basics from scratch.
It probably took me 10 times as long, but I came up with a simple script! <a href="https://github.com/hpsee/discourse-rankings/blob/master/user-ranking.rb" target="_blank">Here it is</a> if you are interested. Basically we:

<ol class="custom-counter">
  <li>Get credentials from the environment</li>
  <li>Get a listing of groups</li>
  <li>Get a listing of users per group</li>
  <li>Calcuate contributions (posts and replies) for each user, and each group</li>
  <li>(Contributions are limited to the previous month)</li>
  <li>Save results to file (yaml)</li>
</ol>

The above can be run locally, or via a Docker container, if your preference is not to install
dependencies on your host. It basically comes down to exporting credentials:

```bash

export DISCOURSE_API_TOKEN=xxxx
export DISCOURSE_API_USER=myusername
```

and either installing and running locally:

```bash

$ bundle install
$ ruby user-counts.rb
```

or building the container, and running it instead:

```bash

$ docker build -t vanessa/discourse-ranking .
$ docker run -it -e DISCOURSE_API_KEY=${DISCOURSE_API_KEY} \
   -e DISCOURSE_API_USER=${DISCOURSE_API_USER} \
   -v $PWD/data:/code/data vanessa/discourse-ranking


Looking up members by group
Calculating contribution totals for last month...

GROUP: admins
  aculich
  christophernhill
  discourse
  eibrown
...
```

The output folder will have a set of data files, each with a sorted list of users
or groups, with contributions from the last month.

```bash
data/
├── groups-2019-08-13.yml
├── groups.yml
├── users-2019-08-13.yml
└── users-per-group-2019-08-13.yml
```

Complete code is <a href="https://github.com/hpsee/discourse-rankings" target="_blank">is here</a> with the repository,
and the rendered html plot is at <a href="https://hpsee.github.io/discourse-rankings" target="_blank">hpsee.github.io/discourse-rankings</a>.


## Plotting the Result

This is our first test run, and mind you that groups were just generated recently. We have a large
percentage of the user base that hasn't been associated with any particular group, so it's likely to be a bit off.
But here is the group rankings:

<div style="padding:20px">
  <img src="/assets/images/posts/discourse-ranking/rankings.png">
</div>

Notice anything interesting? I'll share what I see.

### Group Memberships

Most of our new groups don't have a large number of members. Take a look at the data - this is users per group:

```yaml
$ cat data/users-per-group-2019-08-13.yml 
---
- - Berkeley
  - 6
- - Brown
  - 12
- - Harvard
  - 11
- - MIT
  - 2
- - Mines
  - 2
- - Northwestern
  - 3
- - Tufts
  - 2
- - Yale
  - 5
- - admins
  - 16
- - moderators
  - 29
- - staff
  - 34
- - stanford
  - 5
- - trust_level_0
  - 100
- - trust_level_1
  - 100
- - trust_level_2
  - 78
- - trust_level_3
  - 75
- - trust_level_4
  - 48
- - twitter
  - 1
```

The largest groups are the discourse defaults related to trust level or permissions (e.g., "trust_level_1", "moderators" or "admins"),
and then the larger of the user boards might have 10-12, and then closer to 5 or fewer.
What this tells us is that 

> user groups are not well defined.

We need to first do a good job to advertise groups to our community,
and have those with non-instituion email addresses self assign themself to the right groups.

### Contributions

While we can't say which institution group is posting the most, we can look at the posts based on
trust level and see some mixed news! It's unfortunately the case that admin and staff tend to be also
included in lower trust levels (e.g., trust_level_0 through trust_level_0) so based on the fact
that we see the largest number of contributions from moderators and admins, it's very likely
the case that most site posting is done by these groups. This means that we really need to do a better
job of encouraging participation on our site - not through artificial means, but genuine interest
and incentive.


## Conclusion

When participation is a bit dry, it usually comes down to incentive. Incentive can be driven by prizes and
fun, but it's hugely driven by a sense of community. If you feel like part of a community, you will
want to participate, because it's important to you. It's as simple as that.
We haven't yet created this sense of community on our site, but I suspect it's something
we will be working on in the near future. And on that note, I hope that you enjoyed this post! 
I had a really fun time today learning some ruby, and writing this up. I realize that ruby plugs
really well into web interfaces, so I might next try generating the plot directly from it.
