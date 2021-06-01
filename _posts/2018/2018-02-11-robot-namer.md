---
title: "The Robot Namer"
date: 2018-02-11 10:33:00
editable: question
---

I was working on a thing, as I usually do. <br>
When a useless inspiration was spawned anew!<br>
Cupcakes are grand, and flying is sweet <br>
But neither one can boop or beep. <br>
I know you aren't programmer or gamer<br>
But I know you'll appreciate the robot namer!<br>
Happy Birthday Padr, from me and noodles-blue <br>
Always know that I love you!<br><br>


[![asciicast](https://asciinema.org/a/162228.png)](https://asciinema.org/a/162228)


<br><br>

## Docker
Here is some usage for Docker

```bash

for i in `seq 1 10`;      
    do     
        docker run vanessa/robotname ; 
done

placid-snack-2602
phat-muffin-7875
bricky-soup-8889
lovable-peas-1308
angry-pot-4343
chunky-lizard-8943
expressive-latke-7268
scruptious-fudge-6476
frigid-hope-0334
anxious-lamp-8583

```

And for Singularity of course! The container is available via both Singularity Hub and Docker Hub.

```bash

singularity pull --name robotname docker://vanessa/robotname
singularity pull --name robotname shub://vsoch/robotname

for i in `seq 1 10`;      
    do     
        ./robotname ; 
done
misunderstood-citrus-5071
tart-rabbit-4716
crunchy-parrot-8250
butterscotch-bike-4263
hello-platanos-0635
dinosaur-soup-0847
tart-noodle-8497
conspicuous-leader-7694
crunchy-earthworm-8153
eccentric-caramel-0830

```

See the full usage at the <a href="https://www.github.com/vsoch/robotnamer" target="_blank">
Github repo</a>, or open a pull request to help the namer grow!
