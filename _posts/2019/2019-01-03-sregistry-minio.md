---
title: "Deploy a Minio Singularity Container Registry"
date: 2019-01-03 3:15:00
---

Happy New Year container monkeys! We are only three days in, so I think it's still okay
for me to say that. Today I'm going to share with you an easy, open source
solution for sharing your containers using a [Minio Server](https://docs.minio.io/docs/minio-docker-quickstart-guide)
as our storage. Minio is an object storage akin to Amazon S3.
The work that I'll show you today will let you easily push Singularity containers
to storage using the [new endpoint for S3](https://singularityhub.github.io/sregistry-cli/client-s3)
added to Singularity Registry Client. Let's get started!

## Docker Compose All The Things

To get us a running start, I've created a [docker-compose](https://github.com/singularityhub/sregistry-cli/blob/master/examples/docker/docker-compose.yml) file to bring up a Minio Server and Singularity Registry Client with
one command. The docker image is from [Docker Hub](https://cloud.docker.com/repository/docker/vanessa/sregistry-cli)
and you should have [docker-compose](https://docs.docker.com/compose/install/) installed.
We will bring up the image in detached (-d) mode. Fwoop!

```bash

wget https://raw.githubusercontent.com/singularityhub/sregistry-cli/master/examples/docker/docker-compose.yml
docker-compose up -d

```

Your images should be up and running when you issue `docker ps`, named `minio` and `sregistrycli`.
If you go to 127.0.0.1:9000 you will see the Minio portal!

<div style="padding:20px; width:100%">
<img src="https://singularityhub.github.io/sregistry-cli/img/aws-minio1.png">
</div>

You can enter the testing username and password from the docker-compose file (minio and minio123) 
to log in to your storage portal.

## Shell Inside

But first, let's put some containers there! An empty storage portal is like
a microwave without your pizza in it. Why would you want to open it?
Here is how to shell in and pull a Docker image.

```bash

$ docker exec -it sregistrycli bash
(base) root@c512453bfeed:/code# 

```

Is it hot in here? Oh right, we are making container pizza!

### Pull from Docker

Pull an image from Docker, we will push this image to our local registry!

```bash

SREGISTRY_CLIENT=docker sregistry pull ubuntu:latest

```

## Push to Minio

The minio and aws credentials for the attached minio server are already exported
with the container, as is the bucket name. S3 is also export as the default client. 
Let's now use the client  to push the image to the minio endpoint.

```bash

sregistry push --name test/ubuntu:latest /root/.singularity/shub/library-ubuntu-latest-latest.simg
Created bucket mybucket
[client|s3] [database|sqlite:////root/.singularity/sregistry.db]
[bucket:s3://s3.Bucket(name='mybucket')]

```

That's it! Let's check out the interface to see our little container:


<div style="padding:20px">
<img src="https://vsoch.github.io/assets/images/posts/minio/minio-browser.png">
</div>


You can also search for him on the command line:

```bash

(base) root@8f0234f80aa2:/code# sregistry search
[client|s3] [database|sqlite:////root/.singularity/sregistry.db]
[bucket:s3://s3.Bucket(name='mybucket')]
Containers
1  test/ubuntu:latest.simg	1-3-2019	

```

or pull him again!

```bash

(base) root@8f0234f80aa2:/code# sregistry pull test/ubuntu:latest.simg
[client|s3] [database|sqlite:////root/.singularity/sregistry.db]
[bucket:s3://s3.Bucket(name='mybucket')]
[container][new] test/ubuntu-latest
Success! /root/.singularity/shub/test-ubuntu-latest.simg

```

And yes, this means that if you actually deploy the Minio server, you can
share your containers with your collaborators. This is good.

## An Actual Deployment

If you want to deploy this <strong>for reals</strong> you can still use the docker-compose
file, but you *must* change the access and secret key.  These guys:

```bash
...
      environment:                         (------- minio
        MINIO_ACCESS_KEY: minio
        MINIO_SECRET_KEY: minio123
...
        AWS_ACCESS_KEY_ID: minio           (------- sregistrycli
        AWS_SECRET_ACCESS_KEY: minio123
```

The two sets of environment variables, the top for the minio container, and the
bottom for the sregistry-cli container, should match. You also should
check out the more <a href="https://singularityhub.github.io/sregistry-cli/client-s3">detailed documentation</a> 
to learn how to customize the storage endpoint or set this up locally. While
you're there, please admire the Minio bird:

<div style="padding:20px">
<img src="https://singularityhub.github.io/sregistry-cli/img/aws-minio2.png">
</div>

So elegant and adorable, at the same time! If you have any questions, issues, dilemas,
doubts, problems, stories, or riddles, please 
<a href="https://github.com/singularityhub/sregistry-cli" target="_blank"> post an issue</a>
and I'll do my best to help.
