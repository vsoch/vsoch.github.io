---
title: "Asciiquarium Docker"
date: 2018-12-18 8:58:00
toc: false
---

![https://raw.githubusercontent.com/vsoch/asciiquarium/master/fish.png](https://raw.githubusercontent.com/vsoch/asciiquarium/master/fish.png)

I didn't know that I could have a pet until I found the [asciiquarium](https://opensource.com/article/18/12/linux-toy-asciiquarium).
It's the pet that I've always wanted! Specifically, I get an entire tank of fish, sharks,
and dolphins, and they can code with me and (importantly) not die! Look at them go!

<a href="https://asciinema.org/a/217511" target="_blank"><img src="https://asciinema.org/a/217511.svg" /></a>

Since the package manager seems most suited for fedora, I created a Docker container.
It's an automated build from [GitHub](https://github.com/vsoch/asciiquarium).
It is giving me great joy, and I want to share that with you!

```bash
docker run -it vanessa/asciiquarium
```

Thank you to the creators of the asciiquarium. It's little finds like these that
are the Star Wars ornaments at the top of our trees.
