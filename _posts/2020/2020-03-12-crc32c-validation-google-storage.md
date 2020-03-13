---
title: "crc32c Validation for Google Storage Objects"
date: 2020-03-12 14:47:00
category: rse
---

I recently was working on <a href="https://github.com/snakemake/snakemake" target="_blank">snakemake</a> and we ran into
the issue where a rule reported an unexpected end of file. Since the files were
obtained with the <a href="https://snakemake.readthedocs.io/en/stable/snakefiles/remote_files.html#google-cloud-storage-gs" target="_blank">Google Storage (GS) remote</a>, this meant that the download had not produced the full
file. We needed to verify the completeness of the file using
a <a href="https://en.wikipedia.org/wiki/Checksum" target="_blank">checksum</a>.
Since this was fun (and likely useful for others) I want to share what I learned
and wound up <a href="https://github.com/snakemake/snakemake/pull/273" target="_blank">implementing</a> here.

## Google Storage Checksums

If you look at the <a href="https://cloud.google.com/storage/docs/hashes-etags#_CRC32C" target="_blank">Google Cloud Storage</a>
page, you'll notice that storage objects are provided with both an md5 and a crc32c checksum. You can 
read a little bit about both at the link provided. Since we are using Python, and the
<a href="https://pypi.org/project/google-cloud-storage/" target="_blank">google storage client</a> 
 exposes this crc32c checksum as an <a href="https://googleapis.dev/python/storage/latest/blobs.html?highlight=checksum#google.cloud.storage.blob.Blob.crc32c" target="_blank">attribute</a>, I figured this
would be fairly easy to do. 

## Google Storage Streaming to File

Okay, so I need to generate a hasher, and then update it with chunks from the file being
streamed to download to the host from Google Storage. We would usually use Python's hashlib,
and that might look something like this (md5 is used in this example, and it's pseudocode):

```python
import hashlib

hasher = hashlib.md5()
for chunk in some_method_to_stream_download():
    # write chunk to file
    hasher.update(chunk)

# Get the final digest for comparison with something provided
assert hasher.hexdigest() == some_provided_checksum
```

But the problem is that the Google Storage client does not provide a streaming
function. They provide functions to write to a filename, or to write to a file
object. And lots of people <a href="https://github.com/googleapis/python-storage/issues/29" target="_blank">seem
to want this feature</a>. Here are the functions that we do have:

```python
from google.cloud.storage import Client

client = Client()
bucket = client.get_bucket('bucket_name')
blob = bucket.blob('the_awesome_blob.txt')

# Download to a file object
blob.download_to_file(file_obj)

# Download to filename
blob.download_to_filename("name_of_file.txt")
```

So how do we stream to file? Well, we could download it using one of the above
methods, and then read it in again (streaming) to update a digest. But doesn't that mean
we need to iterate through the chunks twice? That might work okay for tiny files,
but some of these files are chonkers. What if we tried to wrap the file object and expose
the same needed functions (namely write)...

```python
class Crc32cCalculator:
    """The Google Python client doesn't provide a way to stream a file being
       written, so we can wrap the file object in an additional class to
       do custom handling. This is so we don't need to download the file
       and then stream read it again to calculate the hash.
   """

    def __init__(self, fileobj):
        self._fileobj = fileobj
        self.digest = hasher.md5()

    def write(self, chunk):
        self._fileobj.write(chunk)
        self._update(chunk)

    def _update(self, chunk):
        """Given a chunk from the read in file, update the hexdigest
        """
        self.digest = self.digest.update(chunk)
```

But then added our own little special parsing of the chunk after the standard
write? This is what is shown in the example above - calling write()
writes the chunk to the file object, but then uses the _update()
function we've written with the class to update the digest created on init
with the chunk. But the example above uses md5. We don't want to use md5. 
We want crc32c! Let's figure that out next.

## Choosing a crc32c Library

The <a href="https://github.com/ICRAR/crc32c" target="_blank">crc32c module</a>
was my choice to calculate the hash, and although there wasn't documentation I was able to see
how it's used for binary data in <a href="https://github.com/ICRAR/crc32c/blob/master/test/test_crc32c.py" target="_blank">this test</a>.
The maintainer then was able to give <a href="https://github.com/ICRAR/crc32c/issues/14" target="_blank">speedy and lovely feedback</a> about the library and usage. For example, when we use it we need to import `crc32` from `crc32c` which is confusing,
because `crc32` is technically a <a href="https://stackoverflow.com/questions/26429360/crc32-vs-crc32c" target="_blank">different algorithm</a>. But he clarified the reason for this:

> The package in PyPI is called crc32c, and the module is called crc32c, but it exposes a function called crc32. To be honest this is probably historical baggage -- when this package was first implemented it tried to mimic binascii.crc32 to an extreme, including the function name... Maybe in a later release we could adjust the name

I love learning about history behind some of these choices! Anyway, it turns out
that you can create an equvalent digest, and then update it (providing the previous digest too)
when you are reading some chunk.

```python
digest = 0

# reading in chunks, keep doing this
digest = crc32(chunk, digest)
```

At the end of that process (when the file is finished reading, either from a read
or write) you'll have a digest. But there is still one more step! If we look
at an actual digest from Google Storage vs. what we calculated, the formats are different:

```python
blob.crc32c
# 'nuFtcw=='
digest
# 2665573747
```

Ah, crap! Well, it turns out, the last key to figuring this out was shared in
the <a href="https://cloud.google.com/storage/docs/hashes-etags" target="_blank">original documentation</a>:

> The Base64 encoded CRC32c is in big-endian byte order

Woot! So we needed one more final step to use Python's <a href="https://docs.python.org/3/library/struct.html" target="_blank">struct.pack</a>.
I first used this when I was developing <a href="https://github.com/singularityhub/sif/blob/d4d915a219b9f69d2f95260bd559a061dd837ea9/sif/main/header.py" target="_blank">Singularity SIF in Python</a>, although I was using unpack. The final step
was to do the conversion, and I also converted from bytes, since the Google Storage API was returning
a string. The thing I love about this line is that you can almost read it from left to
right to understand what is going on, based on the description above.


```python
# "Base 64 encode this thing in big endian byte order"
base64.b64encode(struct.pack(">I", self.digest))

# Oh, but also decode it so we return a string
base64.b64encode(struct.pack(">I", self.digest)).decode("utf-8")
```

## All Together Now!

Okay, so we've figured out the library to use, and how to add it to the file object
class to provide to Google Storage, let's put all the pieces together! Here
are the first set of imports that we need:

```python
import os
import base64
import struct
from crc32c import crc32
```

And here is our special calculator class to wrap the file object, and expose
a "write" function that then does an update of our digest with the
same chunk. Notice that when we initialize, we also set the digest to 0,
as we saw in all the examples for using crc32c.

```python
class Crc32cCalculator:
    """The Google Python client doesn't provide a way to stream a file being
       written, so we can wrap the file object in an additional class to
       do custom handling. This is so we don't need to download the file
       and then stream read it again to calculate the hash.
   """

    def __init__(self, fileobj):
        self._fileobj = fileobj
        self.digest = 0

    def write(self, chunk):
        self._fileobj.write(chunk)
        self._update(chunk)

    def _update(self, chunk):
        """Given a chunk from the read in file, update the hexdigest
        """
        self.digest = crc32(chunk, self.digest)

    def hexdigest(self):
        """Return the hexdigest of the hasher.
           The Base64 encoded CRC32c is in big-endian byte order.
           See https://cloud.google.com/storage/docs/hashes-etags
        """
        return base64.b64encode(struct.pack(">I", self.digest)).decode("utf-8")
```

Finally, notice that we expose a hexdigest() function so the class has similar functionality
to one provided by hashlib. Now let's use this class with the blob.download_to_file
in a download function to get a final solution. You can
look at the <a href="https://github.com/snakemake/snakemake/pull/273" target="_blank">Snakemake PR</a>
to get a more real world context. The function below uses the class above to download the file
and ensure that the crc32c checksums match.

```python
def download(blob, file_name):
    """download a blob object to some file_name.
       We assume the download directory and blob both exist for 
       simplicity of this snippet
    """
    # Continue trying to download until hash matches
    while not os.path.exists(file_name):

        with open(file_name, "wb") as blob_file:
            parser = Crc32cCalculator(blob_file)
            blob.download_to_file(parser)
           
        # Compute local hash and verify correct
        if parser.hexdigest() != blob.crc32c:
            os.remove(file_name)

    return file_name
```

Used as follows:

```python
from google.cloud import storage
client = storage.Client()
bucket = client.get_bucket('bucket_name')
blob = bucket.blob('the_awesome_blob.txt')
file_name = "the_downloaded_awesome.txt"
downloaded_file = download(blob, file_name)
```

Obviously the example above is overly simple - you would want to check that
the directory exists for the file to be downloaded, and that the blob.exists()
as well. Finally, you'd probably want to have some maximum number of retries,
clear messages to the user, and other error parsing.

## What would I like to see?

It would be much simpler if the Google Storage Python team could provide
a function to stream to a file directly. For example:

```python
digest = 0
with open(file_name, "wb") as fd:
    for chunk in blob.stream_chunks(chunk_size=1024 * 1024 * 10):
        fd.write(chunk)
        digest = crc32(chunk, digest)

checksum = base64.b64encode(struct.pack(">I", self.digest)).decode("utf-8")
assert checksum == blob.crc32c
```

That would be so much easier! But that function doesn't exist, so until
then, this seems like a reasonable solution.

## Thank you!

Thank you again to <a href="https://github.com/rtobar" target="_blank">rtobar</a>
for your speedy help - I wasn't expecting to get invested so quickly in working
on this later in the evening, and it was so much fun. This is probably my 
favorite kind of problem to work on - when there isn't a plug and play solution,
and you are able to do a little digging (and get help from friends!) to ultimately
find a solution, and learn a little bit too.
