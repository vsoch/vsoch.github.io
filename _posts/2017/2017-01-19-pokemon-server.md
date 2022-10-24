---
layout: post
title: "Pokemon Server"
description: "Telnet: an old technology that can do amazing things, like catch em' all"
date: 2017-01-19
comments: true
keywords: ""
---

There is a (sort of) old technology called <a href="https://en.wikipedia.org/wiki/Telnet" target="_blank">telnet</a> which is basically a simple messaging protocol that works through sockets. It's not ideal in that the information sent isn't secure, but for a little fun application running on a server that doesn't matter, well, it's quite fantastic. Here is a little fun that I had around 3:00am putting together a few logical pieces to make a Pokemon "Gotta Catch Em' All" command line thing:

{% include asciicast.html hide='true' source='pokemon-server.json' title='Gotta Catch Em All' author='vsochat@stanford.edu' %}


<h2>The Dependencies</h2>
If you are interested in the retarded code I used to make this, <a href="https://github.com/vsoch/pokemon-server" target="_blank">look here.</a> The first I did is install a few dependencies, including a tool `supervisor` that would keep a process running, my <a href="https://github.com/vsoch/pokemon-ascii" target="_blank">pokemon ascii</a> python module, and an `nginx` web server to basically serve a useless `index.html` giving some wandering user the correct command to use `telnet`.

```bash
sudo apt-get update
sudo apt-get -y install python-pip
sudo apt-get -y install nginx
sudo apt-get -y install daemontools #supervise

sudo service nginx start
git clone https://www.github.com/vsoch/pokemon-server
cd pokemon-server
pip install pokemon
```

The `nginx` server by default stores the `index.html` in `/var/www/html`, so you can programmatically generate that file on the fly with `dig`:

```bash
myip="$(dig +short myip.opendns.com @resolver1.opendns.com)"
echo "<h2>telnet ${myip} 5005</h2>" >> index.html
sudo mv index.html /var/www/index.html
```

Before we jump into the serve r itself, I'll briefly touch on the (super simple) way I kept it running. By installing `supervise`, which is included in `daemontools`, you can point the executable at any folder that has a file called `run` that executes some command, and it will keep the process running. So that `run` file looks like this:

```bash
#!/bin/sh
exec python server.py &
```

Note that I was careful to identify the running shell, and also added `exec` to make sure that the process is carried forward. I got some weird error when I didn't do that. So the last command in my setup file looks like this to start the process (and the server):

```bash
supervise $HOME/pokemon-server &
```

Basically, this script runs a file called `server.py` using Python, and that is where the magic happens.


<h2>The Server</h2>
The basic idea here is that we are going to open up a multi-threaded socket, using Python, and send a bunch of Pokemon back to the user. So the imports look like this.

```python
import socket
import threading
from pokemon.skills import catch_em_all
from time import sleep
```

The function `catch_em_all` returns a nice json data structure that has ascii generated for each Pokemon, names, and other battle statistics (not included in this application). I made this a while back because... why not? Now let's look at the server:

```python

class ThreadedServer(object):
    def __init__(self, host, port):
        self.host = host
        self.port = port
        self.pokemons = catch_em_all()
        self.sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        self.sock.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
        self.sock.bind((self.host, self.port))

    def listen(self):
        self.sock.listen(5)
        while True:
            client, address = self.sock.accept()
            client.settimeout(60)
            threading.Thread(target = self.listenToClient,args = (client,address)).start()

    def listenToClient(self, client, address):
        size = 1024
        while True:
            try:
                client.send("Would you like to see pokemon?")
                data = client.recv(size)
                if data:
                    for key,data in self.pokemons.items():
                        client.send(data['ascii'])  # echo
                        client.send("\t%s" %data['name'])  # echo
                        sleep(2)
                else:
                    raise error('Client disconnected')
            except:
                client.close()
                return False

if __name__ == "__main__":
    port_num = 5005
    ThreadedServer('',port_num).listen()
```

What we see is that when the file is called as an executable (the `__main__` bit at the bottom) we define a port, and then generate a `ThreadedServer` object to listen on that port number. Then what does the listen function do?

```python
    def listen(self):
        self.sock.listen(5)
        while True:
            client, address = self.sock.accept()
            client.settimeout(60)
            threading.Thread(target = self.listenToClient,args = (client,address)).start()
```

It listens for clients, accepts the message, and then creates a thread to run the main function to listen to that client (meaning sending them pokemon). This is the way that we are going to allow for multiple people to use the server at once. I tried it without threading, and it only worked for one. Now let's look at `listenToClient`.

```python
    def listenToClient(self, client, address):
        size = 1024
        while True:
            try:
                client.send("Would you like to see pokemon?")
                data = client.recv(size)
                if data:
                    for key,data in self.pokemons.items():
                        client.send(data['ascii'])  # echo
                        client.send("\t%s" %data['name'])  # echo
                        sleep(2)
                else:
                    raise error('Client disconnected')
            except:
                client.close()
                return False
```

This again is pretty simple. We send them a message, asking if they want to receive pokemon. Notice that we don't parse the response `data` for anything in particular, just that it's there. This is where we could ask them a question, or to input something specific, and choose a response based on what they say. We could write to a database, run a machine learning algorithm with their data as input, whatever! I chose to just respond by iterating through my data structure, and sending them back Pokemon Ascii's with a 2 second delay in between each. You'll notice in the Asciicast that the client closes after the timeout. Again, it would be nice to give the client a nice programmatic way for them to type something and then call `client.close()`, but for programming at 3:00am, that's what I came up with. What can I say :)

And this closes another excellent example of how awesome technology is. Thanks for reading!
