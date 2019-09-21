---
title: "Inspect Singularity SIF with Web Assembly"
date: 2019-09-21 18:20:00
---

Today I woke up and decided that I wanted to load a container in the browser. I've
thrown around this idea for years - back in 2017 I created <a href="https://vsoch.github.io/2017/singularity-nginx/" target="_blank">Singularity Nginx</a> that would load and interact with a container via an API,
but that was technically a separate server issuing commands to the container on the host,
and not really so great. But today I woke up and was hungry for challenge. So that's
what I did.

<div style="padding:20px">
  <img src="/assets/images/posts/singularity-web/sifweb.png">
</div>

If you want to jump to the code, <a href="https://github.com/vsoch/sifweb" target="_blank">it's all here!</a>.
If you want to jump to the live demo, you can find it at <a href="https://vsoch.github.io/sifweb/" target="_blank">vsoch.github.io/sifweb/</a>. Here I'll talk about some of the challenges and details of the implementation.

## Web Assembly + GoLang

My spidey senses were telling me that I should try using <a href="https://emscripten.org/docs/getting_started/FAQ.html" target="_blank">emscripten</a> to compile GoLang into a wasm (Web Assembly). Since this
entire process was rather foreign to me, I started with a <a href="https://www.sitepen.com/blog/compiling-go-to-webassembly/" target="_blank">hello world</a> example. You can best understand the dependencies by looking at the <a href="https://github.com/vsoch/sifweb/blob/master/Dockerfile" target="_blank">Dockerfile</a> that I put together. The base container uses GoLang 1.13, and we need to do this for a newly added function
[CopyBytesToGo](https://tip.golang.org/pkg/syscall/js/#CopyBytesToGo). On top
of the base we install nginx, git, python, and build essential (providing make, etc.).

```

FROM golang:1.13
# docker build -t vanessa/sifweb .
RUN apt-get update && apt-get install -y nginx git python build-essential
```

We then install emscripten and add it to the path:

```

WORKDIR /opt
RUN git clone https://github.com/emscripten-core/emsdk.git && \
    cd emsdk && \
    git pull && \
    ./emsdk install latest && \
    ./emsdk activate latest

ENV PATH /opt/emsdk:/opt/emsdk/fastcomp/emscripten:/opt/emsdk/node/12.9.1_64bit/bin:$PATH
```

And then we add the content of our repository (the GoLang to be compiled plus the static html,
javascript, and css files) 

```

WORKDIR /var/www/html
COPY . /var/www/html
```

And finally, we use make on the Makefile, which will build the output wasm. Importantly,
we also need to add "application/wasm" to our container host's mime.types, otherwise the browser will spit
out an error that it doesn't recognize the content type.

```bash
RUN make && \
    mv docs/* /var/www/html && \
    echo "application/wasm                                                wasm" >> /etc/mime.types
```

Running the container means exposing port 80, and starting the web server nginx. Since
nginx by default will load static files in /var/www/html, since we added them there, we are good to go!

```

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
```

Here is what is in the Makefile - we literally just install one dependency and then
make the wasm.

```

all:
	go get github.com/google/uuid
	GOOS=js GOARCH=wasm go build -o docs/main.wasm
```

The sylabs sif library uses <a href="https://github.com/sylabs/sif/blob/e230d96e4fcc3e4b4013b251a5d4fa8eb3a732bd/pkg/sif/sif.go#L90" target="_blank">github.com/satori/go.uuid</a> for uuid functions, but I found this
had issues with GoLang 1.13 and opted to use google's. 

The output is to the "docs" folder only because this is an option to render on GitHub pages.

### Build Local

If you are running this locally, you'd also need to add the mime.type to your local
machine, and ensure that you have GoLang 1.13+. Then run make, and cd into the docs folder
and start a web server however you please! I usually just use python:

```bash
$ python -m http.server 9999
```

## Reading the File

The web portion has a drag and drop (or click and select) box that you can use to upload a file.
When the form is submit (meaning the drop or upload is done) this was the hardest bit to figure
out in the html - actually it took me most of the day to get the data format correct, so I'll share it with you.

If we look at the [loadContainer](https://github.com/sylabs/sif/blob/e230d96e4fcc3e4b4013b251a5d4fa8eb3a732bd/pkg/sif/load.go#L124) function for sylabs/sif, it is totally dependent on a file object. We can't actually
pass a file (at least that I'm aware of, easily) from the browser to GoLang, so instead I was trying to work
with <a href="https://developer.mozilla.org/en-US/docs/Web/API/FileReader#Methods" target="_blank">different
FileReader methods</a>. I tried many variations and many times got something that appeared to work,
but checking against the <a href="https://github.com/sylabs/sif">siftool</a> I hadn't read the right thing.
The trick was actually to use readAsArrayBuffer and convert the result to a UInt8Array in the browser,
and pass the final raw_data, the file name, and the number of bytes to the function "loadContainer"
in our GoLang:

```javascript

$('form').submit(function(event){
  var file = $('#file').prop('files')[0];
  var reader = new FileReader();

  reader.onload = (function(theFile) {
    return function(e) {
      console.log(e);

      // This is key! We need to read the Array Buffer as Uint8Array
      var raw_data = new Uint8Array(e.target.result, 0, e.target.result.byteLength);

      // name, bytes, total bytes
      loadContainer(file.name, raw_data, reader.result.byteLength);
    };
  })(file);

  // Read in the image file as a data URL.
  reader.readAsArrayBuffer(file);
  event.preventDefault();
})
```

loadContainer (now in GoLang) will take in the name, bytes, and total length

```go

func loadContainer(this js.Value, val []js.Value) interface{} {

	fmt.Println("The container binary is:", val[0])
        fmt.Println("Size:", val[2].Int())
	fmt.Println("ArrayBuffer:", val[1])
	
	fimg := FileImage{}

	// read the string of given size to bytes from the SIF file
	if err := fimg.loadBytes(val[1], val[2].Int()); err != nil {
		returnResult("Error loading bytes.")
		return nil
	}
...

```

and by the way it's bound to the global DOM in our main.go:

```go

package main
 
import "syscall/js"

func main() {

	c := make(chan struct{}, 0)
	js.Global().Set("loadContainer", js.FuncOf(loadContainer))
	<-c
}
```

and then in a helper function called in loadContainer, we use CopyBytesToGo to convert the js.Value to the byte array, and
pass this into a bytes.NewReader to populate fimg.Reader. What I was trying to do here
is emulate exactly what the final fimg.Reader gets, without having read from a file.

```go

// loadBytes loads an imageString from the browser and populates FileImage with data.
func (fimg *FileImage) loadBytes(value js.Value, size int) error {

	// We can use CopyBytesToGo, need golang 1.13+
	sif := make([]byte, size)
	fmt.Println(value)
	howmany := js.CopyBytesToGo(sif, value)
	fmt.Println(howmany)

	// Read in the string to bytes, n should equal size
	reader := bytes.NewReader(sif)
        n, _ := reader.Read(sif)
	fmt.Println(sif)

	// Save the data and size to the FileImage
	fimg.Filesize = int64(n)
	fimg.Filedata = sif
	fimg.Reader = bytes.NewReader(fimg.Filedata)

	return nil
}
```

The rest of loadContainer basically:

<ol class="custom-counter">
  <li>determines if it's a valid SIF based on SIFMAGIC!</li>
  <li>reads descriptors</li>
  <li>formats header metadata into a string to return</li>
</ol>


Actually, we don't really return - we just interact with the DOM directly from
GoLang. That looks like this (I wrote a function to populate the #result element)

```go

// returnResult back to the browser, in the innerHTML of the result element
func returnResult(output string) {
	js.Global().Get("document").
		Call("getElementById", "result").
		Set("innerHTML", output)
}
```

And that's it! It may seem simple, but not having any experience with Web Assembly,
not much with GoLang, and definitely consistent struggles with JavaScript,
I'm feeling like a badass right now! :D

> Yo dawg we just read a container binary into the browser!!

## Next Steps

Let's talk about next steps, because now that the basics are done, there is so much
more we can do! 

### FileReader Limits

Firstly, the example will crash if you load a fat container, and
this is obviously because the browser has <a href="https://stackoverflow.com/questions/53237829/how-to-load-large-local-files-using-javascript" target="_blank">upload limits</a>. What we need to do is
either:

<ol class="custom-counter">
  <li>smartly read chunks that we need</li>
  <li>read up to a maximum size where we can find the header</li>
  <li>some other partial reading strategy</li>
</ol>

to support larger images. I did a quick and dirty "read the entire thing" because
I knew it would work for busybox, and knew this would need to be refined.
We definitely don't need to read all that image data.

### Signatures and Partitions

Guess what - the SIF header is loaded with goodness! I wrote a [library in Python](https://pypi.org/project/sif/)
to extract the signature blocks, and that would be (I think) possible to do here too.


### Your Feedback!

Speaking of, I'd love to know your feedback about what kind of tools you'd like to see,
given that you can load and inspect some of these fields in the browser.  Let me know,
and <a href="https://github.com/vsoch/sifweb/issues" target="_blank">open an issue!</a>
I had amazing fun today, and am looking forward to turning this into something that
could be useful for you.


