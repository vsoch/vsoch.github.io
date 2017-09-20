---
title: "The Docker APIs in Bash"
date: 2016-9-18 6:24:00
---

Docker seems to have a few different APIs, highly under development, and this state almost guarantees that mass confusion will ensue. The documentation isn't sparse (but it's confusing) so I want to take some time to talk through some recent learning, in the case it is helpful. Some warnings - this reflects what I was able to figure out, over about 24 hours of working on things, and optimizing my solutions for time and efficiency. Some of this is likely wrong, or missing information, and I hope that others comment to discuss things that I missed! While Python makes things really easy, for the work that I was doing, I decided to make it more challenging (fun?) by trying to accomplish everything using bash. First, I'll briefly mention the different APIs that I stumbled upon:


- <a href="https://docs.docker.com/engine/reference/api/docker_remote_api" target="_blank">The Docker Remote API</a>: This seems to be an API for the client to issue commands via the Docker Daemon. I have no idea why it's called "remote." Maybe the user is considered "remote" ? This might be where you would operate to develop some kind of desktop application that piggy backs on a user's local Docker. Please correct me if I am messing this up.
- <a href="https://docs.docker.com/v1.6/reference/api/docker-io_api" target="_blank">The Docker Hub API</a>: A REST API for Docker Hub. This is where (I think) a developer could build something to work with "the images out in the internet land." I (think) I've also seen this referred to as the "Docker HUB registry API" (different from the next one...)
- <a href="https://docs.docker.com/registry/spec/api/" target="_blank">Docker Registry API</a>: Is this an interface between some official Docker registry and a Docker engine? I have no idea what's going on at this point.

I found the most helpful (more than the docs above) to be the comments on <a href="https://github.com/docker/docker-registry/issues/517" target="_blank">this Github issue</a>. Specifically, `@baconglobber`. You're the man. Or the `baconglobber`, whichever you prefer. Regardless, I'll do my best to talk through some details of API calls that I found useful for the purpose of getting image layers without needing to use the Docker engine. If that task is interesting to you, read on.


## The Docker Remote API
Docker seems to work by way of an API, meaning a protocol that the engine can use under the hood to send commands to the Hub to push and pull images, along with do all the other commands you've learned to appreciate. If you look at docs for the <a href="https://docs.docker.com/engine/reference/api/docker_remote_api" target="_blank">remote API</a>, what seems to be happening is that the user sends commands to his or her Docker Daemon, and then they can interact with this API. I started to test this, but didn't read carefully that my curl version needs to (not) be less than 7.40. Here (was) my version:

```
      curl -V
      curl 7.35.0 (x86_64-pc-linux-gnu) libcurl/7.35.0 OpenSSL/1.0.1f zlib/1.2.8 libidn/1.28 librtmp/2.3
      Protocols: dict file ftp ftps gopher http https imap imaps ldap ldaps pop3 pop3s rtmp rtsp smtp smtps telnet tftp 
      Features: AsynchDNS GSS-Negotiate IDN IPv6 Largefile NTLM NTLM_WB SSL libz TLS-SRP 
```

Oups. To upgrade curl on Ubuntu 14.04 you can't use standard package repos, so <a href="https://gist.github.com/fideloper/f72997d2e2c9fbe66459" target="_blank">here is a solution that worked for me</a> (basically install from source). Note that you need to open a new terminal for the changes to take effect. But more specifically, I wanted a solution that didn't need to use the Docker daemon, and I'm pretty sure this isn't what I wanted. However, anyone wanting to create an application that works with Docker on a user's machine, this is probably where you should look. There are a LOT of versions:

<div>
    <a href="/assets/images/posts/dockerapi/versions.png" target="_blank"><img src="/assets/images/posts/dockerapi/versions.png" style="width:300px"/></a>
</div><br>

and you will probably get confused as I did and click "learn by example" expecting the left sidebar to be specific to the API (I got there via a Google search) and then wonder why you are seeing tutorials for standard Docker:

<div>
    <a href="/assets/images/posts/dockerapi/example.png" target="_blank"><img src="/assets/images/posts/dockerapi/example.png" style="width:1000px"/></a>
</div><br>

What's going on?! Rest assured, probably everyone is having similar confusions, because the organization of the documentation feels like being lost in wikiland. At least that's how I felt. I will point you to the <a href="https://docs.docker.com/engine/reference/api/remote_api_client_libraries" target="_blank">client API libraries</a> because likely you will be most diabolical digging directly into Python, Java, or your language of choice (they even have web components?! cool!) For my specific interest, I then found the <a href="https://docs.docker.com/v1.6/reference/api/docker-io_api" target="_blank">Docker Hub API</a>.


## Docker Hub API
This is great! This seems to be the place where I can interact with Docker Hub, meaning getting lists of images, tags, image ids, and all the lovely things that would make it possible to work with (and download) the images (possibly without needing to have the Docker engine running). The first confusion that I ran into was a simple question - what is the base url for this API? I was constantly confused about what endpoint I should be using at pretty much every call I tried, and only "found something that worked" by way of trying every one. Here are a handful of the ones that returned responses sometimes, sometimes not:

- https://registry.hub.docker.com/v1/
- https://registry.hub.docker.com/v2/
- https://registry-1.docker.io/v1/
- https://registry-1.docker.io/v2/
- https://cdn-registry-1.docker.io/v1/

The only thing that is (more intuitive) is that if you know <a href="http://www.webopedia.com/TERM/C/CDN.html" target="_blank">what a `cdn` is</a>, you would intuit that the `cdn` is where images, or some filey things, might be located. 

So we continue in the usual state of things, when it comes to programming and web development. We have a general problem we want to solve, or goal we want to achieve, we are marginally OK at the scripting language (I'm not great at bash, which is why I chose to use it), and the definition of our inputs and resources needs to be figured out as we go. But... we have the entire internet to help us! And we can try whatever we like! This, in my opinion, is exactly the kind of environment that is most fun to operate in.


#### The organization of images
Before we jump into different commands, I want to review what the parameters are, meaning the terms that Docker uses to describe images. When I first started using Docker, I would see something like this in the Dockerfile:

```
     FROM ubuntu:latest
```

and I'm pretty sure it's taken me unexpectedly long to have a firm understanding of all the possible versions and variables that go into that syntax (and this might make some of the examples in the API docs more confusing if a user doesn't completely get it). For example, I intuited that if a "namespace" isn't specified, the default is "library?" For example, this:

```
      library/ubuntu:14.04
```

is equivalent to:

```
      ubuntu:14.04
```

where "library" is considered the namespace, "ubuntu" is the repo name, and "14.04" is considered the "tag." Since Docker images are basically combinations of layers, each of which is some tar-guzzed up group of files (does anyone else say that in their head?), I'm guessing that a tag basically points to a specific group of layers, that when combined, complete the image. The tag that I'm most used to is called "latest", so the second thing I intuited is that if a user doesn't specify a tag:

```
      library/ubuntu
```

that would imply we want the latest, e.g.,

```
      library/ubuntu:latest
```

## Getting repo images
My first task was to find a list of images associated with a repo. Let's pretend that I'm interested in ubuntu, version 14.04.

```
namespace=library
repo_name=ubuntu
repo_images=$(curl -si https://registry.hub.docker.com/v1/repositories/$namespace/$repo_name/images)
```

It returns <a href="https://registry.hub.docker.com/v1/repositories/library/ubuntu/images" target="_blank">this page</a>, a list of things that looks like this:

```
{ 
   "checksum": "tarsum+sha256:aa74ef4a657880d495e3527a3edf961da797d8757bd352a99680667373ddf393",
   "id": "9cc9ea5ea540116b89e41898dd30858107c1175260fb7ff50322b34704092232"
}
```

If you aren't familiar, a `checksum` is a string of numbers (<a href="https://en.wikipedia.org/wiki/Checksum" target="_blank">more</a>) you can generate on your local machine using a tool, and "check" against to ensure that you, for example, downloaded a file in it's entirety. Also note that I found the (old?) registry endpoint (verison 1.0) to work. What I was interested in were the "id" variables. What we've found here is a list of image layer ids that are associated with the ubuntu repo, in the library namespace (think of a namespace like a collection of images). However, what this doesn't give me is which layers I'm interested in - some are probably for 14.04.1, and some not. What I need now is some kind of mapping from a tag (e.g., `14.04.1`) to the layers that I want.

## Which layers for my tag?
Out of all the image layers belonging to "ubuntu," which ones do I need for my image of interest, 14.04.1? For this, I found a slight modification of the url would provide better details about this, and I'm including an if statement that will fire if the image manifest is not found (a.k.a, the text returned by the call is just "Tag not found".) I'm not sure why, but this call always took a long time, at least given the amount of information it returns (approximately ~22 seconds):

```
# Again use Ubuntu... but this time define a tag!
namespace=library
repo_name=ubuntu
repo_tag=14.04.1

layers=$(curl -k https://registry.hub.docker.com/v1/repositories/$namespace/$repo_name/tags/$repo_tag)

# Were any layers found?
if [ "$layers" = "Tag not found" ]; then
    echo "Ahhhhh!"
    exit 1
fi
```

When it works, you see:

```
echo $layers
[
 {"pk": 20355486, "id": "5ba9dab4"}, 
 {"pk": 20355485, "id": "51a9c7c1"}, 
 {"pk": 20355484, "id": "5f92234d"}, 
 {"pk": 20355483, "id": "27d47432"}, 
 {"pk": 20355482, "id": "511136ea"}
]
```

If the image tag isn't found:

```
Tag not found
```

There is a big problem with this call, and that has to do with the tag "latest," and actually versioning of tags as well. If I define my tag to be "latest," or even a common Ubuntu version (14.04) I get the "Tag not found" error. You can get all of the tag names of the image like so:

```
namespace=library
repo_name=ubuntu
tags=$(curl -k https://registry.hub.docker.com/v1/repositories/$namespace/$repo_name/tags)

# Iterate through them, print to screen
echo $tags | grep -Po '"name": "(.*?)"' | while read a; do

    tag_name=`echo ${a/\"name\":/}`
    tag_name=`echo ${tag_name//\"/}`
    echo $tag_name

done
```

There isn't one called latest, and there isn't even one called 14.04 (but there is 14.04.1, 14.04.2, and 14.04.3). Likely I need to dig a bit deeper and find out exactly how a "latest" tag is asserted to belong to the (latest) version of a repo, but arguably as a user I expect this tag to be included when I retrieve a list for the repo. It was confusing. If anyone has insight, please comment and share!

## Completing an image ID
The final (potentially) confusing detail is the fact that the whole image ids have about 32 characters, eg `5807ff652fea345a7c4141736c7e0f5a0401b30dfe16284a1fceb24faac0a951` but have you ever noticed when you do `docker ps` to list your images you see 12 numbers, or if you look at the ids referenced in the manifest above, we only have 8?  

```
{"pk": 20355486, "id": "5ba9dab4"}
```

The reason (I would guess) is because, given that we are looking at layer ids for a single tag within a namespace, it's unlikely we need that many characters to distinguish the images, so reporting (and having the user reference just 8) is ok. However, given that I can look ahead and see that the API command to download and get meta-data for an image needs the whole thing, I now need a way to compare the <a href="https://registry.hub.docker.com/v1/repositories/library/ubuntu/images" target="_blank">whole list for the namespace</a> to the layers (smaller list with shorter ids) above.

## Matching a shorter to a longer string in bash
I wrote a simple loop to accomplish this, given the json object of layers I showed above (`$layers`) and the result of the images call (`$repo_images`):

```
echo $layers | grep -Po '"id": "(.*?)"' | while read a; do

    # remove "id": and extra "'s
    image_id=`echo ${a/\"id\":/}`
    image_id=`echo ${image_id//\"/}`
    
    # Find the full image id for each tag, meaning everything up to the quote
    image_id=$(echo $repo_images | grep -o -P $image_id'.+?(?=\")')
    
    # If the image_id isn't empty, get the layer
    if [ ! -z $image_id ]; then

        echo "WE FOUND IT! DO STUFF!"

    fi

done
```

## Obtaining a Token
Ok, at this point we have our (longer) image ids associated with some tag (inside the loop above), and we want to download them. For these API calls, we need a token. What I mean is that we need to have a curl command that asks the Docker remote API for permission to do something, and then if this is OK, it will send us back some nasty string of letters and numbers that, if we include in the header of a second command, it will validate and say "oh yeah, I remember you! I gave you permission to read/pull/push to that image repo. In this case, I found two ways to get a token. The first (which produced a token that worked in a second call for me) was making a request to get images (as we did before), but then adding content to the header to ask for a token. The token is then returned in the response header. In bash, that looks like this:

```
namespace=library
repo_name=ubuntu
token=$(curl -si https://registry.hub.docker.com/v1/repositories/$namespace/$repo_name/images \
             -H 'X-Docker-Token: true' | grep X-Docker-Token)
token=$(echo ${token/X-Docker-Token:/})
token=$(echo Authorization\: Token $token)
```

The token thing looks like this:

```
echo $token
Authorization: Token signature=d041fcf64c26f526ac5db0fa6acccdf42e1f01e6,repository="library/ubuntu",access=read
```

Note that depending on how you do this in bash, you might see some nasty newline (^M) characters. This was actually for the second version of the token I tried to retrieve, but I saw similar ones for the call above:

<div>
    <a href="/assets/images/posts/dockerapi/newlines.png" target="_blank"><img src="/assets/images/posts/dockerapi/newlines.png" style="width:1000px"/></a>
</div><br>

The solution I found to remove them was:

```
token=$(echo "$token"| tr -d '\r')  # get rid of ^M, eww
```

I thought that it might be because I generated the variable with an echo without `-n` (which indicates to not make a newline), however even with this argument I saw the newline trash appear. In retrospect I should have tried `-ne` and also `printf`, but oh well, will save this for another day. I then had trouble with double quotes with curl, so my hacky solution was to write the cleaned call to file, and then use cat to pipe it into curl, as follows:

```
echo $token > somefile.url
response=$(cat somefile.url | xargs curl)

# For some url that has a streaming response, you can also pipe directly into a file
cat somefile.url | xargs curl -L >> somefile.tar.gz

# Note the use of -L, this will ensure if there is a redirect, we follow it!
```

If you do this in Python, you would likely use the <a href="http://docs.python-requests.org/en/master/" target="_blank">requests module</a> and make a requests.get to GET the url, add the additional header, and then get the token from the response header:

```
import requests

repo_name="ubuntu"
namespace="library"

header = {"X-Docker-Token": True}
url = "https://registry.hub.docker.com/v1/repositories/%s/%s/images" %(namespace,repo_name)
response = requests.get(url,headers=header)
```

Then we see the response status is 200 (success!) and can peep into the headers to find the token:

```
response.status_code
# 200

response.headers
# {'x-docker-token': 'signature=5f6f83e19dfac68591ad94e72f123694ad4ba0ca,repository="library/ubuntu",
    access=read', 'transfer-encoding': 'chunked', 'strict-transport-security': 'max-age=31536000', 
   'vary': 'Cookie', 'server': 'nginx/1.6.2', 'x-docker-endpoints': 'registry-1.docker.io', 
   'date': 'Mon, 19 Sep 2016 00:19:28 GMT', 'x-frame-options': 'SAMEORIGIN', 'content-type': 'application/json'}

token = response.headers["x-docker-token"]
# 'signature=5f6f83e19dfac68591ad94e72f123694ad4ba0ca,repository="library/ubuntu",access=read'

# Then the header token is just a dictionary with this format
header_token = {"Authorization":"Token %s" %(token)}

header_token
# {
   'Authorization': 'Token signature=5f6f83e19dfac68591ad94e72f123694ad4ba0ca,
   repository="library/ubuntu",access=read'
}
```

And here is the call that didn't work for me using version 2.0 of the API. I should be more specific - this call to get the token did work, but I never figured out how to correctly pass it into the version 2.0 API. I read that the default token lasts for 60 seconds, and also <a href="https://docs.docker.com/registry/spec/auth/token/" target="_blank">the token should be formatted as</a> `Authorization: Bearer: [token]` but I got continually hit with

```
{
  "errors":[{"code":"UNAUTHORIZED","message":"authentication required",
  "detail":[{"Type":"repository","Name":"ubuntu","Action":"pull"}]}]
}
```

The interesting thing is that if we look at header info for the call to get images (which uses the "old" registry.hub.docker.com, e.g, `https://registry.hub.docker.com/v1/repositories/library/ubuntu/images` we see that the response is coming from `registry-1.docker.io`:

```
In [148]: response.headers
Out[148]: {'x-docker-token': 'signature=f960e1e0e745965069169dbb78194bd3a4e8a10c,repository="library/ubuntu",access=read',
           'transfer-encoding': 'chunked', 'strict-transport-security': 'max-age=31536000', 'vary': 'Cookie', 
           'server': 'nginx/1.6.2', 'x-docker-endpoints': 'registry-1.docker.io', 'date': 'Sun, 18 Sep 2016 21:26:51 GMT', 
           'x-frame-options': 'SAMEORIGIN', 'content-type': 'application/json'}
```

When I saw this I said "Great! It must just be a redirect, and maybe I can use that (I think newer URL) to make the initial call." But when I change `registry.hub.docker.com` to `registry-1.docker.io`, it doesn't work. Boo. I'd really like to get, for example, the call `https://registry-1.docker.io/v2/ubuntu/manifests/latest` to work, because it's counterpart with the older endpoint (below) doesn't seem to work (*sadface*). I bet with the right token, and a working call, the tag "latest" will be found here, and resolve the issues I was having using the first token and call. This call for "latest" really should work :/

<div>
    <a href="/assets/images/posts/dockerapi/expectation1.png" target="_blank"><img src="/assets/images/posts/dockerapi/expectation1.png" style="width:1000px"/></a>
</div><br>


## Downloading a Layer
I thought this was the coolest part - the idea that I could use an API to return a data stream that I could pipe right into a .tar.gz file! I already shared most of this example, but I'll do it quickly again to add some comment:


```
# Variables for the example
namespace=library
repo_name=ubuntu
image_id=511136ea3c5a64f264b78b5433614aec563103b4d4702f3ba7d4d2698e22c158 # I think this is empty, but ok for example

# Get the token again
token=$(curl -si https://registry.hub.docker.com/v1/repositories/$namespace/$repo_name/images \
             -H 'X-Docker-Token: true' | grep X-Docker-Token)
token=$(echo ${token/X-Docker-Token:/})
token=$(echo Authorization\: Token $token)

# Put the entire URL into a variable, and echo it into a file removing the annoying newlines
url=$(echo https://cdn-registry-1.docker.io/v1/images/$image_id/layer -H \'$token\')
url=$(echo "$url"| tr -d '\r')
echo $url > $image_id"_layer.url"
echo "Downloading $image_id.tar.gz...\n"
cat $image_id"_layer.url" | xargs curl -L >> $image_id.tar.gz
```

I also tried this out in Python so I could look at the response header, interestingly they are using AWS CloudFront/S3. Seems like everyone does :)

```
{
  'content-length': '32', 'via': '1.1 a1aa00de8387e7235a256b2a5b73ede8.cloudfront.net (CloudFront)',
  'x-cache': 'Hit from cloudfront', 'accept-ranges': 'bytes', 'server': 'AmazonS3', 
  'last-modified': 'Sat, 14 Nov 2015 09:09:44 GMT', 'connection': 'keep-alive', 
   'etag': '"54a01009f17bdb7ec1dd1cb427244304"', 'x-amz-cf-id': 'CHL-Z0HxjVG5JleqzUN8zVRv6ZVAuGo3mMpMB6A6Y97gz7CrMieJSg==', 
   'date': 'Mon, 22 Aug 2016 16:36:41 GMT', 'x-amz-version-id': 'mSZnulvkQ2rnXHxnyn7ciahEgq419bja', 
   'content-type': 'application/octet-stream', 'age': '3512'}
```


# Overall Comments
In the end, I got a working solution to do stuff with the tarballs for a specific docker image/tag, and my strategy was brute force - I tried everything until something worked, and if I couldn't get something seemingly newer to work, I stuck with it. That said, it would be great to have more examples provided in the documentation. I don't mean something that looks like this:

```
    PUT /v1/repositories/foo/bar/ HTTP/1.1
    Host: index.docker.io
    Accept: application/json
    Content-Type: application/json
    Authorization: Basic akmklmasadalkm==
    X-Docker-Token: true

    [{"id": "9e89cc6f0bc3c38722009fe6857087b486531f9a779a0c17e3ed29dae8f12c4f"}]
```

I mean a script written in some language, showing me the exact flow of commands to get that to work (because largely when I'm looking at something for the first time you can consider me as useful and sharp as cheddar cheese on holiday in the Bahamas).  For example, if you do anything with a Google API, they will give you examples in any and every language you can dream of! But you know, Google is amazing and awesome, maybe everyone can't be like that *smile* :)

I'll finish by saying that, after all that work in bash, we decided to be smart about this and include a Python module, so I re-wrote the entire thing in Python. This let me better test the version 2.0 of the registry API, and unfortunately I still couldn't get it to work. If anyone has a concrete example of what a header should look like with Authentication tokens and such, please pass along! Finally, Docker has been, is, and probably always will be, awesome. I have a fiendish inkling that very soon all of these notes will be rendered outdated, because they are going to finish up and release their updated API. I'm super looking forward to it.
