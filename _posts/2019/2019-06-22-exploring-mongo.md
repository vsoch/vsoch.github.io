---
title: "Exploring MongoDB on HPC"
date: 2019-06-22 10:34:00
category: hpc
---

This last weekend <a href="https://techcrunch.com/2019/06/16/millions-venmo-transactions-scraped/" target="_blank">it was reported</a> that over 7 million Venmo transactions
had been openly available, and they were scraped by a computer science student.
And he <a href="https://github.com/sa7mon/venmo-data" target="_blank">put them on GitHub</a>. This wasn't the first time - last year another data scientist scraped over 207 million.

## Why was this possible?

The transactions were available via the Venmo Developer API, which has had little
change between these two events. <a href="https://venmo.com/api/v5/public" target="_blank">Here you go, how's that for privacy?</a> 

<div style="padding:20px">
<a href="https://vsoch.github.io/assets/images/posts/venmo/public-api.png"><img src="https://vsoch.github.io/assets/images/posts/venmo/public-api.png"></a>
</div>

How is this OK? On the one hand, you could argue that a few interesting projects have
resulted, such as <a href="https://www.vice.com/en_us/article/qvmkvx/twitter-bot-venmo-buying-drugs-photo-names">a Twitter bot that listens for drugs transactions</a>. But 
there is no reason that an API with such sensitive information should be public.

## Feeling Helpless

Although I don't think (or at least I hope) that no specific individual can be hurt terribly by this, it's wrong. It's a violation of privacy. I have not used this service myself, but I know many that have. What can I do? I wanted to 
be empowered to know if anyone I cared about had their information compromised. If they had,
I wanted to tell them so that they could be sure to take whatever action might be possible
and necessary, even if it only means making their account private or discontinuing using
the serve. Knowledge is power. At the time I had never really used MongoDB, so I didn't know what
I was doing. Like most things, I jumped in and had faith that I'd figure it out. So this is what we are going to do today.

<ol class="custom-counter">
   <li>Using a Singularity container for MongoDB</li>
   <li>On a high performance computing cluster</li>
   <li>We will learn how to work with this data</li>
   <li>Because knowledge is power.</li>
</ol>

If you are interested in MongoDB and containers but don't care about this particular
venmo dataset, I've created a new repository of 
<a href="https://github.com/singularityhub/singularity-compose-examples" target="_blank">examples</a>
for singularity-compose, and the one called mongodb-pull includes instructions for venmo. If not, read on!

## Feeling Empowered

First let's grab an interactive node on a cluster. We will
ask for more time and memory than we need.

```bash
$ srun --mem 64000 --time 24:00:00 --pty bash
```

Create a folder on scratch to work in

```bash

mkdir -p $SCRATCH/venmo
cd $SCRATCH/venmo

```

The data comes from <a href="https://github.com/sa7mon/venmo-data" target="_blank">this repository</a>.
You have to download it, and yes, it takes a while.

```bash
$ wget https://d.badtech.xyz/venmo.tar.xz
```

Next, extract it.

```bash
tar xf venmo.tar.xz
```

Pull the Singularity container for mongodb.

```bash
$ singularity pull docker://mongo
```

Create subfolders for mongodb to write data on the host. This is very important,
because it means that you can bring the instance up and down, and not lose
any of the data. You'll only need to import it once.

```bash
mkdir -p data/db data/configdb
```

### Enter the container

Shell into the container, binding data to /data, so we have write
in the container (thanks to it being bound to the host).

```bash
$ singularity shell --bind data:/data mongo_latest.sif
```

Start the mongo daemon as a background process:

```bash
$ mongod &
```

Change directory into the "dump/test" folder that was exported (venmo.bson is here)

```bash
$ cd dump/test
```

And restore the data

```bash
$ mongorestore --collection venmo --db test venmo.bson
```

### Query the data

Next, connect to a shell. It's time to query!

```bash
$ mongo
>
```

Display the database we are using

```
> db
test
```

Get the collection

```
venmo = db.getCollection('venmo')
test.venmo
```

Confirm that we have all the records

```
> venmo.count()
7076585
```

You can use "findOne" to see all the fields provided for each datum (shortened to hide information):

```json

> venmo.findOne()
{
	"_id" : ObjectId("5bb7bdce1bed297da9fcb11f"),
	"mentions" : {
		"count" : 0,
		"data" : [ ]
	},
...
	"note" : "🍺",
	"app" : {
		"site_url" : null,
		"id" : 1,
		"description" : "Venmo for iPhone",
		"image_url" : "https://venmo.s3.amazonaws.com/oauth/no-image-100x100.png",
		"name" : "Venmo for iPhone"
	},
	"date_updated" : ISODate("2018-07-26T18:47:05Z"),
	"transfer" : null
}
> 

```

Finally, it's time to query! By looking at the structure above, I can see that I'd
likely want to find someone based on their name. Here is how you could do that.

```
> venmo.find({"payment.actor.last_name": "Roberts"})
```

The database is huge, so a query can take a few minutes. I'm not an expert with MongoDB,
so I'm sure there are ways to index (and otherwise optimize queries) that I haven't learned yet.
I did figure out that it's much easier to look at data (in an editor like vim) once it's
exported to json, and you can do that from the command line as follows:

```bash
> mongo test --eval "db.getCollection('venmo').find({'payment.target.last_name': 'Smith'}).toArray()" > smith.json
```

If you want to increase the size of the result allowed to be printed, add this to the front.

```bash
> mongo test --eval "DBQuery.shellBatchSize = 2000; ...`
```

Another interesting one is to query and search for interesting "notes," which likely correspond
to what the payment(s) were for.

```
> venmo.find({"note": "pancakes"}).count()
50
```

Wow! The good news is that although I did find names that were familiar, there
wasn't enough detail in any of the metadata to make me
overly concerned. The notes for the transactions were actually quite funny, anything
from silly spellings of a word, to an emoticon, to a heartfelt message about missing
or caring for someone.

## Summary

This data exploration gave me confidence that, although it sucks,
the exports aren't so terrible to cause huge harm to anyone's life. It is still
hugely wrong on the part of the service, and (if I used it) I wouldn't
continue to do so. I am tickled that 50 people had transactions related to pancakes. 
There is a silver lining in all things, it seems.
