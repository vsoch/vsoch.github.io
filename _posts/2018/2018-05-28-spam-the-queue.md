---
title: "Spam the Queue"
date: 2018-05-28 00:10:00
toc: false
---

Today I had about 10,000 scripts I wanted to run on a SLURM cluster, and I also have an upper limit of
jobs I'm allowed to run at once. I'm too lazy to wait and monitor the jobs, so I prepared the sbatch
commands in a large file that looks something like this:

```bash

#!/bin/bash
sbatch /scratch/users/vsochat/zenodo-ml/slurm/jobs/run_806345.sh
sbatch /scratch/users/vsochat/zenodo-ml/slurm/jobs/run_1002155.sh
sbatch /scratch/users/vsochat/zenodo-ml/slurm/jobs/run_1245189.sh
sbatch /scratch/users/vsochat/zenodo-ml/slurm/jobs/run_835590.sh
...

```
Normally I can just run this bash script and the number is within the limit (and I'm fine):

```bash

$ /bin/bash run_jobs.sh

```

but today I was way over the limit, and had I done this would have just hit the limit
and found a bunch of error messages when I returned from my afternoon dinosaur frolicking. 
Instead of re-writing the script to generate the commands on demand as space opens up (I've done
this before) I decided to write a script to read in the commands, check the count in the queue,
 and submit jobs when there is an opening.

<br>

<script src="https://gist.github.com/vsoch/7c7aff40c27a0ba35bb91f2299a73171.js"></script>


I can easily check which jobs still need to run by way of the output being organized by the identifier
that is also captured in the script name. If I needed to run this again (and not redo runs) I would
simply check for the existence of this folder, and skip if it's found. 

Yes, I'm spamming the queue, and I'm lazy. I'm really that terrible.
