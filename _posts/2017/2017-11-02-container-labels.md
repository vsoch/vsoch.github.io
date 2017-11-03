---
title: "Adding Container Labels Dynamically"
date: 2017-11-02 9:41:00
---

Here is a quick snippet for how to dynamically add labels to your Singularity Container at build time, which are then exposed when you inspect it. First, here is the recipe:

<script src="https://gist.github.com/vsoch/6b9fb12876dab7d9fdb2bcf243572909.js"></script>

We are basically copying the Python helpers from Singularity into the image (in `%setup`), and then using them in `%post` to add a dynamic label with key `AVOCADOS` and value `NOMNOM`. Note that this is using Singularity version 2.4. To build our image from this recipe, we can do that in one line:

```
sudo singularity build labels.simg Singularity.labels
```

And now we can inspect the container to see the labels:

```
singularity inspect test 
{
    "org.label-schema.usage.singularity.deffile.bootstrap": "docker",
    "org.label-schema.usage.singularity.deffile": "Singularity.labels",
    "org.label-schema.schema-version": "1.0",
    "org.label-schema.build-size": "1308MB",
    "org.label-schema.usage.singularity.deffile.from": "ubuntu:16.04",
    "org.label-schema.build-date": "2017-11-03T09:29:43-07:00",
    "AVOCADOS": "NOMNOM",
    "org.label-schema.usage.singularity.version": "2.4-enh/scif.ge62d0fa"
}
```

Houston, we have Avocados! This is a really cool way that you can dynamically add labels to your image, perhaps including some metrics about the build environment, or just variables or a flag for an intended application that needs to identify the container. I would encourage users to use an already developed standard schema, to contribute to an already developed schema, or just to get the conversation going about labeling containers. One thing we know for sure - it's always good conversation when a container dumps out his life story (in neatly packaged key:value pairs, of course)! :P
