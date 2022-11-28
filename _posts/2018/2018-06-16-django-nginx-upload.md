---
title: "Large Uploads with Django+Nginx Upload Module"
date: 2018-06-16 4:24:00
toc: false
category: hpc
---

Do you ever struggle with something, akin to a blueberry muffin that is slowly being squished
in a 10 year old's lunch box (and he's gone out to recess and left it in the sun), but then 
figure it out in a moment of painstaking glory? And while most humans would take a break, you
decide to skip rest and spend the next eight hours (on a Saturday) implementing a dummy example for the rest of the programmer muffins out there, so they don't go through the same suffering?

> This just happened.

We will brush aside my lack of awareness for time and well being, and dive into what <a href="https://github.com/vsoch/django-nginx-upload" target="_blank">I've just finished</a> and am excited to share! **TLDR** it's fast and pretty. So I'm happy.

<div>
<img src="https://github.com/vsoch/django-nginx-upload/raw/master/img/upload.png">
</div><br>

<strong>TLDR<strong>  I used the <a href="https://www.nginx.com/resources/wiki/modules/upload/" target="_blank">nginx upload</a> module to upload really big files to the server. Nginx handles 
the upload directly, and then forwards an amended request to the server. I implemented this for one of my own applications, and then provided this completely separate dummy example that hopefully you can learn from. The application is provided as a custom nginx Docker image and uwsgi (with Django) along with a client to push from the command line. All code is <a href="https://github.com/vsoch/django-nginx-upload" target='_blank'>available for you here</a>. If it is useful to you or you need a reference:

[![DOI](https://zenodo.org/badge/137612664.svg)](https://zenodo.org/badge/latestdoi/137612664)

# Django Nginx Upload

Today we are going to discuss and show one way to upload <strong>really big</strong> files to a web server, specifically a <a href="https://www.djangoproject.com" target="_blank">Django web application</a>.
Django is Python-based, and this makes it the perfect backend for webby tools that are intended for scientific or academic applications, where Python is used more than a language like GoLang, Ruby, etc. 

Let's say you have a server, and you want to upload files to it. This task is usually pretty easy because Django <a href="https://docs.djangoproject.com/en/2.0/topics/http/file-uploads/" target="_blank">makes it easy</a>. For my particular needs, it was a bit more complicated, because I needed to post files from the command line. 
This was possible using the <a href="https://toolbelt.readthedocs.io/en/latest/uploading-data.html" target="_blank">requests toolbelt</a> library because it can mimic multipart form data and stream a file.



## Rationale

I was working on the <a href="https://singularityhub.github.io/sregistry" target="_blank">Singularity Registry</a> server, and addressing a common issue: that the upload failed for large containers. I would
typically make a joke about fat containers (they are squashfs format after all, which makes them much smaller than if they were still ext3) but then I'd feel pretty badly that it didn't work.  Specifically, we were handling "sort of" large files by way of adjusting these fields in the `nginx.conf` (a nginx server configuration file): 

```bash

client_max_body_size 8000M;
client_body_buffer_size 8000M;
client_body_timeout 120;

```

It's a game we all play - when you first create the application, you forget to set this
entirely. At some point you get a suite of errors related to "this file is too big," you do a Google
search, find that you can define the max body (and buffer and timeout) and add to your configuration.
But if you have REALLY big files, you can still have the configuration above, and have the upload fail.
Then you start looking for other solutions. And crap, this is harder than I thought. And here we are!

There were several issues (<a target="_blank" href="https://github.com/singularityhub/sregistry/issues/108">#108</a>, 
<a href="https://github.com/singularityhub/sregistry-cli/issues/126" target="_blank">#126</a>, 
<a href="https://github.com/singularityhub/sregistry/issues/109" target="_blank">#109</a>, 
<a href="https://github.com/singularityhub/sregistry/issues/123" target="_blank">#123</a>) 
with discussion that ranged from using <a href="https://github.com/juliomalegria/django-chunked-upload" target="_blank">chunked upload</a>, and then the nginx upload module, and in retrospect you can read the issues to see how I stumbled trying to find the best approach. 
I at first didn't want to try the nginx module because it seemed too disconnected from Django, and the lack of tutorials and examples told me that it was probably hard to do. One of my colleagues directed me to try the chunked upload, so I happily tried that first.  Let's discuss what I did, and what I learned.

### Chunked Upload
The idea of a chunked upload speaks for itself - you break a file into chunks, and upload them separately instead of the entire thing in one go. This would work for our nginx web server because each piece wouldn't be larger than the limit of the body size, and as long as there was clear communication between the server and host about where to start/stop writing the file, it was a reasonable thing to do. I was able to get <a href="https://github.com/juliomalegria/django-chunked-upload" target="_blank">juliomalegria/django-chunked-upload</a> working very quickly. If you need a good "out of the box" module this is a good approach. It was very easy for me to plug the uploader into a pretty progress bar, and my result looked like this:

<div style="padding:20px">
<img src="https://github.com/vsoch/django-nginx-upload/raw/master/img/progress.png">
</div><br>

The author was also very wise to provide an <a href="https://github.com/juliomalegria/django-chunked-upload-demo" target="_blank">example</a>. But getting the same functionality from the command line would be challenging because the example implementation was using 
<a href="https://github.com/blueimp/jQuery-File-Upload" target="_blank">well known javascript file uploading libraries</a>. 
As I started working on it, I <a href="https://github.com/juliomalegria/django-chunked-upload/issues/41" target="_blank">posted an issue</a> but it didn't seem like the repository was active, so
I needed to be resourceful on my own. 

> How are we ever going to maintain all these repos? Forever?

As a side note, I think this solution could be very good if the work is extended to include an integration with the <a href="http://www.django-rest-framework.org/" target="_blank">Django Rest Framework</a> (or similar) for interaction from the command line. For the first time I tried, I got close, but I didn't get it entirely working. I wish I had kept the code where I was testing - it was easily thousands of line, and lots of curl! It defeated me, at least until I woke up the next morning and started with a fresh set of eyes.

### Chunk Upload (Restful)

Another user must have been in a similar situation to me, because he created a <a href="https://github.com/jkeifer/drf-chunked-upload" target="_blank">django restful framework chunked upload</a> module but did not provide very detailed documentation for its usage. 
Everyone learns differently, but I learn best by looking over example code, and posted an issue. We <a href="https://github.com/jkeifer/drf-chunked-upload/issues/6" target="_blank">came very close</a> but I wasn't able to guess what the PUT or POST calls should look like, and I sensed we weren't going to progress very quickly. To the apologies
of all people who have to interact with me, I have a sense of urgency about everything. If a strategy or resource is progressing slowly, I usually take matters into my own hands and try other things.

### Nginx Module

WIth the chunked upload, I couldn't get it working after a few days. I knew what I needed to do, which would be to really decompose the problem into the simplest function calls, and untangle the problem like a knot of hair. But before doing that, my mind kept going back to the nginx upload module. Nginx server blocks are terrifying, and I couldn't find examples with much explanation, but I thought I'd give it a try anyway. Programming languages, syntax, and even tools are similar to learning a language. It's all nonsense and you keep hitting yourself in the face with it, and then one day there is a moment of clarity and you just... speak.

> What is going on?

The module is really cool because it means that you upload a file directly to the server via nginx. Let's compare a traditional file upload to one using nginx upload:

#### Traditional

I think traditional is something like this. The web server has to receive the file and send it to the application for writing to the disk.

```bash

[ file on desktop ] -> [ POST to nginx ] --> [ read into memory buffer ] --> [ uwsgi writes to disk ]

```

#### Nginx Upload Module

This is what I think is going on with the nginx module. It writes the file directly to disk.

```bash

[ file on desktop ] -> [ POST to nginx ] --> [ nginx writes to disk ] --> [ callback to uwsgi ]

```

I'm not sure if it's correct to call the next post to the uwsgi application (Django) a callback, but that's sort of what it seems like.

> Step 0: Compile nginx with the module

Nginx doesn't come out of the box with this module! To compile it, take a look at the <a href="https://github.com/vsoch/django-nginx-upload/blob/master/nginx/install.sh" target="_blank">Dockerfile</a>
install script that I used to compile nginx. I definitely don't take credit for this, I found it on Docker Hub and tweaked for my needs. Thank goodness and <a href="https://github.com/rca/nginx-upload-with-progress-modules" target="_blank"> many thanks</a> to the creator, who looks like he also forked from someone else!

> Step 1: Define the upload block

We first needed to define the nginx block (the url, usually something like `/upload`) that will handle 
the post. That looks like this. I'll add comments to explain each section.

```bash

  # Upload form should be submitted to this location
  location /upload {

        # After upload, pass altered request body to this django view
        upload_pass   /complete/;

        # Store files to this directory
        # The directory is hashed, subdirectories 0 1 2 3 4 5 6 7 8 9 should exist
        upload_store /var/www/images/_upload 1;        
        upload_store_access user:rw group:rw all:rw;

        # Set specified fields in request body
        upload_set_form_field $upload_field_name.name "$upload_file_name";
        upload_set_form_field $upload_field_name.content_type "$upload_content_type";
        upload_set_form_field $upload_field_name.path "$upload_tmp_path";

        # Inform backend about hash and size of a file
        upload_aggregate_form_field "$upload_field_name.md5" "$upload_file_md5";
        upload_aggregate_form_field "$upload_field_name.size" "$upload_file_size";

        # Here is where you define additional fields to pass through to upload_complete
        upload_pass_form_field "^submit$|^description$";
        upload_pass_form_field "^name$";
        upload_pass_form_field "^terminal$";
        upload_cleanup 400-599;

    }
```

This seems really simple now that I'm looking at it after the fact, but there were
several small details that really tripped me up. With nginx, just one detail can
make the server return some error code and leave you a squished muffin. If you try going to the url
itself in the browser, you'll get a 405 (method not allowed) and you will definitely see 400 family
if you have permissions of the folders wrong. If there is something wrong with the callback view, you
can commonly see family 500 errors.

**upload_pass**

In all the examples that I saw, this usually referenced another server block. It took me a good block of time to (finally) figure out this was where the adjusted response would be sent **after** the upload finished. It didn't have to be some magic nginx nonsense, it could be a web address for the Django application. In Django terms, this is a view that you write that is expecting a form submission (but without the file, because we already uploaded that).

**upload_store**

This is a location that needs to be seen by both the nginx container **and** and uwsgi container, because the upload actually happens in the nginx one. You would want them to share some storage so that after the upload finishes, when you ping the endpoint defined at `upload_pass` the value for the path field is actually findable. There are likely different ways you could go about handling the saved file, but I chose the simple approach to save it to a Django ImageFile model (with an appropriate File field that writes to my application's storage). And do you notice the comment about
the directories? These are a sequence of folders that need to be created a priori. If you are using bash, there is a cool trick to do this:

```bash

mkdir -p /var/www/images/_upload/{0..9}

```

Note that this doesn't work with shell (sh). Since this is the base of the nginx image, the actual command to create the folders was run for the main uwsgi container. The nginx container shares the mapped folder, so both can see the directories.

**upload_store_access**

This isn't great practice to have permissions that look like this:

```bash

 chmod 777 -R /var/www/images/_upload

```
I'm pretty terrible with security, but I can imagine this would open up some vulnerabilities, especially if there isn't any other authentication or authorization. For this example, I actually removed all of this extra stuff because I assume everyone has a different need.  Check out the <a href="https://www.nginx.com/resources/wiki/modules/upload/" target="_blank">docs</a> to find the right blocks to set this up. Also check out some of the other cool ones (resumable uploads!). Based on <a href="https://serverfault.com/questions/483108/allow-uploads-only-to-authenticated-users-nginx-upload-module" target="_blank">this post</a> I think you would want to wrap the endpoint (`/upload`) with another authentication module.

**form fields**

These are parameters defined by the module, specifically for <a href="https://www.nginx.com/resources/wiki/modules/upload/#upload-set-form-field">upload_set_form_field</a>:

> Specifies a form field(s) to generate for each uploaded file in request body passed to backend. Both name and value could contain following special variables: * $upload_field_name – the name of original file field * $upload_content_type – the content type of file uploaded * $upload_file_name – the original name of the file being uploaded with leading path elements in DOS and UNIX notation stripped.


```bash

# Set specified fields in request body
upload_set_form_field $upload_field_name.name "$upload_file_name";
upload_set_form_field $upload_field_name.content_type "$upload_content_type";
upload_set_form_field $upload_field_name.path "$upload_tmp_path";

```

So the above says that if we have an input that looks like this:

```html

<input type="file" name="file1" id="file">

```

`$upload_field_name` would refer to `file1` and the resulting request POST to the server would provide the name of the uploaded file (`$upload_file_name`) in the field (`$file1.name`) (referenced above as `$upload_field_name`). It looks weird here, but I assure you it makes sense when you are actively testing and see it in action. 

The <a href="https://www.nginx.com/resources/wiki/modules/upload/#upload-set-form-field">upload_aggregate_form_field</a> is similar, but it's more of function that **drumroll** aggregates!:

> Specifies a form field(s) containing aggregate attributes to generate for each uploaded file in request body passed to backend. Both name and value could contain standard NGINX variables, variables from upload_set_form_field directive and following additional special variables: * $upload_file_md5 – MD5 checksum of the file * $upload_file_md5_uc – MD5 checksum of the file in uppercase letters * $upload_file_sha1 – SHA1 checksum of the file * $upload_file_sha1_uc – SHA1 checksum of the file in uppercase letters * $upload_file_crc32 – hexadecimal value of CRC32 of the file * $upload_file_size – size of the file in bytes * $upload_file_number – ordinal number of file in request body

```bash

# Inform backend about hash and size of a file
upload_aggregate_form_field "$upload_field_name.md5" "$upload_file_md5";
upload_aggregate_form_field "$upload_field_name.size" "$upload_file_size";

```

This means that with that same file field, we would get POST fields for `file1.md5` and `file1.size` as freebies. I have mixed feelings about if I want to keep the md5 / size for my application, because they are useful, but it adds a non significant amount of additional time to calculate (see the warning in the link above). I'm going to keep it for now, and see how the users like or (or not).

**custom form fields**

Finally, there are likely some special fields that are irrelevant to the file that you want to add.
You can do this with the `upload_pass_form_field`. They look like this:

```bash

upload_pass_form_field "^submit$|^description$";
upload_pass_form_field "^name$";
upload_pass_form_field "^terminal$";

```

These simply pass through and go to your Django view. From the above, the server block is actually
very simple - it's a matter of choosing an endpoint (and creating it in your Django application), making sure directories exist for nginx to write to (and the permissions are set correctly), and then matching
fields that you POST to this block and then to your server. For me, this meant starting with the simplest example, and then doing lots of printing and repeated testing until it was working just right.


# Usage

I'll briefly show how you can use the Dockerized images, and for more detail you can see the <a href="https://github.com/vsoch/django-nginx-upload" target="_blank">repo on Github</a>. You can bring up the nginx and uwsgi containers with `docker-compose`:


```bash
docker-compose up -d
```

Then to upload, you can use either the web interface or a command line utility I made for you, <a href="https://github.com/vsoch/django-nginx-upload/blob/master/push.py" target="_blank">push.py</a>.

I won't review this file in detail, but I'll show you the magic with the requests toolbelt Multipart Encoder. You first create it, and you give it fields that correspond to form fields, and even the file!

```python

encoder = MultipartEncoder(fields={'name': upload_to,
                                   'terminal': "yes",
                                   'file1': (upload_to, open(path, 'rb'), 'text/plain')})

```

You can then create a callback function that gets called between pings to the server. This is pretty useful for progress bars. You wrap the encoder and the callback in another monitor class...

```python

progress_callback = create_callback(encoder)
monitor = MultipartEncoderMonitor(encoder, progress_callback)

```

and then create some headers (if you needed to add Authorization, you would do that here:

```python

headers = {'Content-Type': monitor.content_type }

```

and post the request!

```python

response = requests.post(url, data=monitor, headers=headers)

```

It's super cool :)


## Command Line
Here is the usage for the push.py client:

```bash

usage: push.py [-h] [--host HOST] [--port PORT] [--schema SCHEMA] file

Dinosaur Nginx Upload Example

positional arguments:
  file                  full path to file to push

optional arguments:
  -h, --help            show this help message and exit
  --host HOST           the host where the server is running
  --port PORT, -p PORT  the port where the server is running
  --schema SCHEMA, -s SCHEMA
                        http:// or https://
usage: push.py [-h] [--host HOST] [--port PORT] [--schema SCHEMA] file
push.py: error: the following arguments are required: file

```

You shouldn't need to change the host or port or schema given running the Docker containers
locally, but I've added those arguments in case you want to extend the script to some other 
server. And here is an example to upload a container. Note that you will need requests and requests tool belt installed.

```bash

# Dependencies! Dependencies! Dependencies!
pip install requests
pip install requests-toolbelt

```
```bash

# Fat container
./push.py /home/vanessa/dfnworks.simg 
PUSH /home/vanessa/dfnworks.simg
[3682 of 3682 MB]
[Return status 200 Upload Complete]

```

If you don't like command lines, the same thing can happen from the web browser!

## Web Interface

When the application is running, you can navigate to `http://127.0.0.1` to see the portal. It's the massive purpely/pink box you see in the picture above! I was going for the embarrassed plum look. You can click or drop to add a file to upload.

<div>
<img src="https://github.com/vsoch/django-nginx-upload/raw/master/img/upload.png">
</div><br>


When the file finishes uploading, you will see the table! You can always navigate back to the
main page by clicking the home icon in the upper left.

<div>
<img src="https://github.com/vsoch/django-nginx-upload/raw/master/img/table.png">
</div><br>


# Deployment
If you deploy this, there are some customizations you need to take into account!

## Authentication / Authorization

We already discussed a bit. It is removed for this demo, and you should add it back. You can add this at the level of the nginx module, or via a view for the application.

## https

And of course this should be served with https. The server block is largely the same, but you would have another for port 443.

## Should you roll your own?
My preference for a lot of these scaled problems is to "outsource" to another service (e.g., use Google Storage and their APIs, or a third party like Github for authentication) but given that we still need to deploy local modular applications on our own filesystems, this seems like a reasonable solution. I "rolled my own" in this case because the application in question isn't being deployed on modern, open clouds, it's being deployed in old school HPC centers that aren't using the cloud resources. I also just like learning stuff. And the color purple.

## What needs more attention?

I've been thinking about how powerful software like nginx is, and how many modules are available that do really cool things. But it's a bit hard to get your head around at first. I never figure out nginx-y things the first time. Is this preventing people from exploring use cases? Or have I been under a rock? I think for the academic community it's (probably?) a case of the first. It means that there is great opportunity to improve science and tools around it by exploring some of these niche things. I wonder what we could do with some of those other modules? :)

<span style='font-size:30px'><a href="https://github.com/vsoch/django-nginx-upload" target="_blank">django-nginx-upload</a></span>

If you have any questions or need help, please don't be afraid to <a href="https://www.github.com/vsoch/django-nginx-upload/issues" target="_blank">reach out</a>. I hope that this is helpful for you!
