---
title: "Pre-signed MultiPart Uploads with Minio"
date: 2020-04-06 16:01:00
category: rse
---

Have you ever stumbled into working on something challenging, not in a "solve this proof"
sort of way, but "figure out the interaction of these systems in the context of this API
and tool" and found it so intoxicatingly wonderful to work on that you can't stop?
This happened to me this previous weekend, actually starting on Friday. I was working
on adding a <a href="https://github.com/singularityhub/sregistry/pull/297" target="_blank">Minio backend for storage</a>
for <a href="https://singularityhub.github.io/sregistry/" target="_blank">Singularity Registry Server</a>
because many users were, despite efforts to use the <a href="https://vsoch.github.io/2018/django-nginx-upload/" target="_blank">nginx-upload</a> module, still running into issues with large uploads. I had recently noticed that the Singularity
<a href="https://github.com/sylabs/scs-library-client/blob/30f9b6086f9764e0132935bcdb363cc872ac639d/client/push.go" target="_blank">scs-library-client</a> 
was pinging a "_multipoint" endpoint that my server was 
<a href="https://github.com/singularityhub/sregistry/pull/283" target="_blank">not prepared for</a>, and the quick
fix there was to add the endpoint and have it return 404 as a message "Sorry, we don't support multipart uploads!"
But as time passed on I wondered - why can't I support them? This led me back to trying to
integrate some kind of <a href="https://github.com/smartfile/django-transfer/issues/9#issuecomment-607976246" target="_blank">nginx helper</a>
to handle multipart uploads, but it proved to be too different than the <a href="https://docs.aws.amazon.com/AmazonS3/latest/dev/mpuoverview.html" target="_blank">Amazon Multipart Upload</a> protocol, which was further challenging because I needed to wrap those functions
in something else to generate the pre-signed urls.

## Minio to the Rescue!

I remembered when I was implementing Singularity Registry Client to have <a href="https://singularityhub.github.io/sregistry-cli/client-s3" target="_blank">s3 support</a> I had used a storage server called <a href="https://min.io" target="_blank">Minio</a>,
and other than having an elegant bird paper clip logo 

<div style="padding:20px">
   <img src="https://vsoch.github.io/assets/images/posts/minio/browser.png">
</div>

(who now is much more badass by the way)

<div style="padding:20px">
   <img src="https://vsoch.github.io/assets/images/posts/minio/badass-bird.png">
</div>

and it provided a really elegant, open source solution to host your own "S3-like" storage (this is my
understanding at least). 

### 1. Adding the Minio Container

I was very easily able to (in just an hour or two) 
<a href="https://github.com/singularityhub/sregistry/pull/297" target="blank"> add a Minio backend for storage</a>,
meaning that the minio Docker container was added to the "docker-compose.yml"

```
minio:
  image: minio/minio
  volumes:
    - ./minio-images:/images
  env_file:
   - ./.minio-env
  ports:
   - "9000:9000"  
  command: ["server", "images"]
```

and notice that it binds a .minio-env file that provides the key and secret, and the
images are bound to our host so if the minio container goes away we don't lose them.
The minio environment secrets are also mapped to the main uwsgi container with the Django application
since we will be instantiating clients from in there.

### 2. Installing mc for management

I quickly found that `docker-compose logs minio` didn't show many meaningful logs.
I found it very useful to shell into the minio container, and install "mc," which
is a command line client for minio:

```bash
$ docker exec -it sregistry_minio_1 bash
wget https://dl.min.io/client/mc/release/linux-amd64/mc
chmod +x mc
./mc --help
```

I was able to add my server as host to reference it as "myminio"
```bash
./mc config host add myminio http://127.0.0.1:9000 $MINIO_ACCESS_KEY $MINIO_SECRET_KEY
Added `myminio` successfully.
```

Verify that it was added:

```bash
./mc config host ls
```
And then leave this command hanging in a window to show output logs.

```bash
./mc admin trace -v myminio
```

This is hugely important for development, you wouldn't know what is going on
with Minio otherwise.

## Singularity Registry Server Views

On the backend, in the configuration for Singularity Registry Server I give the
(developer) user full control over the time to allow signed URLs, using
SSL, and of course the internal and external servers.

```python

MINIO_SERVER = "minio:9000"  # Internal to sregistry
MINIO_EXTERNAL_SERVER = (
    "127.0.0.1:9000"  # minio server for Singularity to interact with
)
MINIO_BUCKET = "sregistry"
MINIO_SSL = False  # use SSL for minio
MINIO_SIGNED_URL_EXPIRE_MINUTES = 5
MINIO_REGION = "us-east-1"
```

> What the heck, internal and external server?

Yes! Remember that the Singularity client sees the minio container as `127.0.0.1:9000` 
(on localhost) but from inside the uwsgi container, we see it as `minio:9000`. You *could*
adopt a solution that adds minio as a hostname to "/etc/hosts" but my preference was not
to require that. For creating the clients, this was actually really quick to do!

```python

from shub.settings import (
    MINIO_SERVER,
    MINIO_EXTERNAL_SERVER,
    MINIO_BUCKET,
    MINIO_REGION,
    MINIO_SSL,
)
from minio import Minio

import os

minioClient = Minio(
    MINIO_SERVER,
    region=MINIO_REGION,
    access_key=os.environ.get("MINIO_ACCESS_KEY"),
    secret_key=os.environ.get("MINIO_SECRET_KEY"),
    secure=MINIO_SSL,
)

minioExternalClient = Minio(
    MINIO_EXTERNAL_SERVER,
    region=MINIO_REGION,
    access_key=os.environ.get("MINIO_ACCESS_KEY"),
    secret_key=os.environ.get("MINIO_SECRET_KEY"),
    secure=MINIO_SSL,
)

if not minioClient.bucket_exists(MINIO_BUCKET):
    minioClient.make_bucket(MINIO_BUCKET)
```

When the server starts, we create one for each of internal and external endpoints, and
also create the bucket if it doesn't exist. This is done entirely with
<a href="https://github.com/minio/minio-py/" target="_blank">minio-py</a>.
And then we can use the external client to generate a presigned PUT url
to return to Singularity:

```python

storage = container.get_storage()
url = minioExternalClient.presigned_put_object(
    MINIO_BUCKET,
    storage,
    expires=timedelta(minutes=MINIO_SIGNED_URL_EXPIRE_MINUTES),
)
```

and do the same thing to retrieve a pre-signed url to GET (or download) it:

```python

storage = container.get_storage()
url = minioExternalClient.presigned_get_object(
    MINIO_BUCKET,
    storage,
    expires=timedelta(minutes=MINIO_SIGNED_URL_EXPIRE_MINUTES),
)
return redirect(url)
```

I'm not showing these calls in the context of their functions - you can look
at the full code in the <a href="https://github.com/singularityhub/sregistry/pull/297" target="blank"> pull request </a> to get this. The main thing to understand is that (a very basic flow) for the legacy upload endpoint is:

<ol class="custom-counter">
   <li>Singularity looks for _multipart endpoint, 404 defaults to <a href="https://github.com/sylabs/scs-library-client/blob/master/client/push.go#L287" target="_blank">the legacy endpoint</a></li>
   <li>In our case, the legacy endpoint now provides a presigned URL to PUT an image file</li>
   <li>The PUT request is done with Minio storage now instead of the nginx upload module</li>
</ol>

And now with Minio, we've greatly improved this workflow by adding an extra layer
of having signed URLs, and having the uploads and GETs go directly to the minio container.
Before we were using the nginx upload module to upload directly via nginx, and then
have a callback that then pings the uwsgi container to validate the upload and finish things up.
We now have a huge improvement, I think, because the main uwsgi django server isn't taking the brunt of load
to upload and download containers, and validation happens before any files are transferred. 
A cluster could much more easily deploy some kind of (separate) and scaled Minio cluster and then still use Singularity Registry
Server. I haven't done this yet, but I suspect that we are allowing for better scaling, hooray!

## FileSystem

On the user filesystem, if we bind the minio data folder (which by the way can 
be more than one) we can see the images that we pushed

```
$ tree minio-images/
minio-images/
└── sregistry
    └── test
        ├── big:sha256.92278b7c046c0acf0952b3e1663b8abb819c260e8a96705bad90833d87ca0874
        └── container:sha256.c8dea5eb23dec3c53130fabea451703609478d7d75a8aec0fec238770fd5be6e
```


## Multipart Upload

The above was quick, but it didn't add multipart uploads. Hey, it was only Friday afternoon!
This is where it got fun and challenging, and took me most of Saturday, all of Sunday, and half of Monday.
A multipart upload would look something like this:

### 1. Singularity Asks for Multipart
Singularity first looks for the `_multipart` endpoint, specifically making a POST
to a URL matching the pattern "^v2/imagefile/(?P<upload_id>.+?)/_multipart?$"
and provides an upload_id (actually this is the id associated with a container
object that is first generated, but we don't need to talk about this detail! The
upload_id is passed around between these various endpoints to always be able
to retrieve the correct container instance. Anyway, here is pseudocode for the steps
that are taken to start an upload. Note that this is a POST to the _multipart endpoint.

```python
def post(self, request, upload_id):
    """In a post, the upload_id will be the container id.
    """
    print("POST RequestMultiPartPushImageFileView")

    # 1. Handle authorization, if the request doesn't have a token, return 403
    # 2. If the config setting MINIO_MULTIPART_UPLOAD is False, return 404 to default to legacy
    # 3. Get the container instance, return 404 if not found
    # 4. get the filesize from the body request, calculate the number of chunks and max upload size
    # 5. Create the multipart upload!
```

For that last step (5), this is the first time we need to interact with another API
for minio. However, minio-py doesn't support generating anything for pre-signed
multipart, so in this case we need to interact with s3 via <a href="https://github.com/boto/boto3" target="_blank">boto3</a>. 
Again, we need to create an internal (minio:9000) and external (127.0.0.1:9000) client:

```python

from boto3 import Session
from botocore.client import Config

from shub.settings import (
    MINIO_SERVER,
    MINIO_EXTERNAL_SERVER,
    MINIO_BUCKET,
    MINIO_REGION,
    MINIO_SSL,
)
import os

MINIO_HTTP_PREFIX = "https://" if MINIO_SSL else "http://"

...

session = Session(
    aws_access_key_id=os.environ.get("MINIO_ACCESS_KEY"),
    aws_secret_access_key=os.environ.get("MINIO_SECRET_KEY"),
    region_name=MINIO_REGION,
)


# https://github.com/boto/boto3/blob/develop/boto3/session.py#L185
s3 = session.client(
    "s3",
    verify=False,
    use_ssl=MINIO_SSL,
    endpoint_url=MINIO_HTTP_PREFIX + MINIO_SERVER,
    region_name=MINIO_REGION,
    config=Config(signature_version="s3v4", s3={"addressing_style": "path"}),
)

# signature_versions
# https://github.com/boto/botocore/blob/master/botocore/auth.py#L846
s3_external = session.client(
    "s3",
    use_ssl=MINIO_SSL,
    region_name=MINIO_REGION,
    endpoint_url=MINIO_HTTP_PREFIX + MINIO_EXTERNAL_SERVER,
    verify=False,
    config=Config(signature_version="s3v4", s3={"addressing_style": "path"}),
)
```

That might look trivial or straight forward in practice, but it was tricky
figuring out that I needed to provide a custom configuration to the clients,
specify the signature version to match minio, and also use "path" (actually
I think it might have worked without this, but I didn't remove it). I am sure,
however, that "addressing_style" as "virtual" didn't work, and "auto" I'm not
sure if it would have defaulted to path. Once we have these clients,
in our view to start the upload, we can generate the request!

```python
# Create the multipart upload
res = s3.create_multipart_upload(Bucket=MINIO_BUCKET, Key=storage)
upload_id = res["UploadId"]
print("Start multipart upload %s" % upload_id)
```

All we really need from there is the uploadID, which we then return to
the calling Singularity client that is looking for the uploadID,
total parts, and size for each part.

```python
data = {
    "uploadID": upload_id,
    "totalParts": total_parts,
    "partSize": max_size,
}
return Response(data={"data": data}, status=200)
```

Singularity then gets a 200 response with this data, and hooray! This means that
the server supports multipart upload, continue!"

## 2. Singularity Asks for Signed URLS

After the 200 response, Singularity dutifully iterates through chunks of the file,
and for each part uses the <a href="https://github.com/sylabs/scs-library-client/blob/5d0614e4bddff1b2231efe79609f9f177bec8014/client/push.go#L473" target="_blank">multipart upload part</a> function to calculate a sha256 sum, and send the part number,
part size, sha256sum, and upload id back to Singularity Registry Server. It's actually the
same endpoint as before (ending in _multipart) but this time with a PUT request.
The reason is because Singularity is saying "Hey, here is information about the part, 
can you give me a signed URL?" And this is where things got tricky.
I first tried generating a signed URL with the same s3 client as I was supposed to do:

```python

# Generate pre-signed URLS for external client (lookup by part number)
signed_url = s3_external.generate_presigned_url(
    ClientMethod="upload_part",
    HttpMethod="PUT",
    Params={
        "Bucket": MINIO_BUCKET,
        "Key": storage,
        "UploadId": upload_id,
        "PartNumber": part_number,
        "ContentLength": content_size,
        },
    ExpiresIn=timedelta(minutes=MINIO_SIGNED_URL_EXPIRE_MINUTES).seconds,
)
```

And that approach, along with maybe 15-20 derivations and tweaks of it, always resulted in
a Signature mismatch error message:

```bash
127.0.0.1 [REQUEST s3.PutObjectPart] 22:59:38.025
127.0.0.1 PUT /sregistry/test/big:sha256.92278b7c046c0acf0952b3e1663b8abb...
127.0.0.1 Host: 127.0.0.1:9000
127.0.0.1 Content-Length: 928
127.0.0.1 User-Agent: Go-http-client/1.1
127.0.0.1 X-Amz-Content-Sha256: 2fc597b42f249400d24a12904033454931eb3624e8c048fe825c360d9c1e61bf
127.0.0.1 Accept-Encoding: gzip
127.0.0.1 <BODY>
127.0.0.1 [RESPONSE] [22:59:38.025] [ Duration 670µs  ↑ 68 B  ↓ 806 B ]
127.0.0.1 403 Forbidden
127.0.0.1 X-Xss-Protection: 1; mode=block
127.0.0.1 Accept-Ranges: bytes
127.0.0.1 Content-Length: 549
127.0.0.1 Content-Security-Policy: block-all-mixed-content
127.0.0.1 Content-Type: application/xml
127.0.0.1 Server: MinIO/RELEASE.2020-04-02T21-34-49Z
127.0.0.1 Vary: Origin
127.0.0.1 X-Amz-Request-Id: 1602C00C5749AF1F
127.0.0.1 <?xml version="1.0" encoding="UTF-8"?>
<Error><Code>SignatureDoesNotMatch</Code><Message>The request signature we...
127.0.0.1 
```

Oh no!! You can imagine I dove into figuring out if the signature algorithm was correct,
if the client was okay, and what headers to use. Early on I figured out that Minio
uses a s3v4 signature, for which the host is included, so this was huge reason that
the external client needed to generate the signed urls and not the internal ones.
You can see my post from the end of the <a href="https://github.com/singularityhub/sregistry/pull/298#issuecomment-609490746" target="_blank">Sunday</a> that links to only some of the resources that I was using
to try and debug.

## 3. Reproducing minio-py

I realized that if the single PUT request detailed above works to generate a signed URL
from inside my Docker container for the outside calling client, perhaps if I replicated
this approach to generate the signature, my multipart pre-signed URLs would work too?
I figured out that I could import "presign_v4" from minio.signers and then use
it to generate the signature:

```python
signed_url = presign_v4(
    "PUT",
    url,
    region=MINIO_REGION,
    credentials=minioExternalClient._credentials,
    expires=str(timedelta(minutes=MINIO_SIGNED_URL_EXPIRE_MINUTES).seconds),
    headers={"X-Amz-Content-Sha256": sha256},
    response_headers=params,
)
```

In the above, the url consisted of the minio (external) base, followed by
the path in storage, something like:

```
http://127.0.0.1:9000/sregistry/test/chonker%3Asha256.92278b7c046c0acf0952b3...
```

The credential I provided from the minioExternalClient to be absolutely sure it
was the same; specifying the region is hugely important because in previous
attempts leaving it out led to another error, and then of course the expires
should be in seconds (and it appears that the function defaults to using a string).
For response headers, this is where I included "uploadID" and "partNumber"
that are needed. You'll also notice that in the example above, I tried
adding the "X-Amz-Content-Sha256" header that was provided by the client (it
still didn't work). Actually, all of my derivations of this call (adding or removing
headers, tweaking the signature) didn't work. I didn't save a record of absolutely
everything that I tried, but I can guarantee you that it was most of Sunday
and a good chunk of Monday. I spent a lot of time reading every post or GitHub
issue on either minio, S3, or Multipart uploads, and posted on several
slacks which turned out to be wonderful rubber duck equivalents!

I decided to look more closely at the parse_v4 function. I noticed something interesting -
that by default, it created an internal variable called <a href="https://github.com/minio/minio-py/blob/f4b20f90d408215dcd51eb102f069b8355c13dc4/minio/signer.py#L96" target="_blank">
content_hash_hex</a> that by default was using a sha256sum for an empty payload.
This seemed off to me, and especially because Singularity was going out of it's way to
provide the sha256sum for each part. What if I added it there? I wrote almost an
equivalent function, but this time exposed that sha256sum as an input variable:

```pythonf
signed_url = sregistry_presign_v4(
    "PUT",
    new_url,
    region=MINIO_REGION,
    content_hash_hex=sha256,
    credentials=minioExternalClient._credentials,
    expires=str(timedelta(minutes=MINIO_SIGNED_URL_EXPIRE_MINUTES).seconds),
    headers={"X-Amz-Content-Sha256": sha256},
    response_headers=params,
)
```

And then returned this signed URL

```python
# Return the presigned url
data = {"presignedURL": signed_url}
return Response(data={"data": data}, status=200)
```

And in a beautiful stream of data, all of a sudden all of the Multipart requests
were going through! This image shows the uwsgi logs for my server (left) and the
minio logs generated by the mc command line client (right).

<div style="padding:20px">
   <img src="https://vsoch.github.io/assets/images/posts/minio/stream.png">
</div>


This was a great moment, because when you've tried getting something to work for days,
and have had infinite patience and attention to detali, when it works you almost
fly out of your shoes and take a trip around your apartment building. 

## 4. Completing the Request

The last step was
just completing the multipart upload, which is done with another 
<a href="https://github.com/sylabs/scs-library-client/blob/5d0614e4bddff1b2231efe79609f9f177bec8014/client/push.go#L537" target="_blank">scs-library-client</a> view that provides an uploadID and list of parts, each part
providing a partNumber and token, but the token is actually referring to what
is called an "ETag." The server can receive this request, parse these
from the body, and then use the internal s3 client to finish the request.

```python
def put(self, request, upload_id):
    """A put is done to complete the upload, providing the image id and number parts
       https://github.com/sylabs/scs-library-client/blob/master/client/push.go#L537
    """
    print("PUT RequestMultiPartCompleteView")

    # 1. Again handle authorization of the request
    # 2. Parse uploadID and completedParts list from the body

    body = json.loads(request.body.decode("utf-8"))

    # Assemble list of parts as they are expected for Python client
    parts = [
        {"ETag": x["token"].strip('"'), "PartNumber": x["partNumber"]}
        for x in body["completedParts"]
    ]

    # 3. Get the container, return 404 if not found

    # 4. Complete the multipart upload
    res = s3.complete_multipart_upload(
        Bucket=MINIO_BUCKET,
        Key=container.get_storage(),
        MultipartUpload={"Parts": parts},
        UploadId=body.get("uploadID"),
        # RequestPayer='requester'
    )

    # Currently this response data is empty
    # https://github.com/sylabs/scs-library-client/blob/master/client/response.go#L97
     return Response(status=200, data={})
```

The above has a lot of pseudo code, but generally you can see that we use the s3
client we created (the internal one) to issue a "complete_multipart_upload" with
the provided list of parts. We then have the containers in our collection:

<div style="padding:20px">
   <img src="https://vsoch.github.io/assets/images/posts/minio/collection.png">
</div>


and these can be viewed in the Minio browser, which was shown at the top of this post.


## Next Steps

I'm not sure if the pull request will be accepted, but I did <a href="https://github.com/minio/minio-py/pull/870" target="_blank">open one</a>
to expose the variable to the presign_v4 function so if others run into my issue, they don't need to rewrite the function.
And the integration is not complete! If you want to test the current pull request, you can find everything that you need
<a href="https://github.com/singularityhub/sregistry/pull/298" target="_blank">here</a>.
Note that we will need to test both setting up SSL (meaning generating certificates for Minio,
something I'll need help with since I don't have a need to deploy a Registry myself)
and also customizing the various environment variables for Minio and the container.
I've done the bulk of hard work here I think, and hopefully interested users can help
me to test and finish up the final documentation that is needed to properly deploy a registry.
You can reference <a href="https://github.com/singularityhub/sregistry/blob/d7420186b03711723e146bf3de1a06040facd722/docs/_docs/install/server.md#storage" target="_blank">this README</a> for documentation that will
be rendered into the <a href="https://singularityhub.github.io/sregistry/docs/install/server" target="_blank">web server and storage</a>
pages.

And that's it! What a fun few days. I hope that users of Singularity Registry Server
can help to test out the endpoints, and adding support for SSL. Happy Monday everyone!
