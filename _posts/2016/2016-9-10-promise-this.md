---
title: "Promise me this..."
date: 2016-9-10 5:45:00
---

Promise me this, promise me that. 
If you Promise inside of a JavaScript Object, 
your `this` is not going to be 'dat!


### The desired functionality
Our goal is to update some Object variable using a Promise. This is a problem that other JavaScript developers are likely to face. Specifically, let's say that we have an Object, and inside the Object is a function that uses a JavaScript Promise:

```
function someObject() {
    this.value = 1;
    this.setValue = function(filename) {
        this.readFile(filename).then(function(newValue){
            /* update this.value to be value */
        });
    }
}
```

In the example above, we define an Object called someObject, and then want to use a function `setValue` to read in some `filename` and update the Object's `value` (this.value) to whatever is read in the file. The reading of the file is done by the function `readFile`, which does it's magic and returns the new value in the variable `newValue`. If you are familiar with JavaScript Promises, you will recognize the `.then(**do something**)` syntax, which means that the function `readFile` returns a Promise. You will also know that inside of the `.then()` function we are in the JavaScript Promise space. First, let's pretend that our data file is very stupid, and is a text file with a single value, 2:

##### data.txt
```
2
```

First we will create the Object, and see that the default value is set to 1:

```
var myObject = new someObject()
myObject.value

>> 1
```

Great! Now let's define our file that has the updated value (`2`), and call the function `setValue`:

```
var filename = "data.txt"
myObject.setValue(filename)
```

We would then expect to see the following:

```
myObject.value

>> 2
```


### The intuitive solution
My first attempt is likely what most people would try - referencing the Object variable as `this.value` to update it inside the Promise, which looks like this:


```
function someObject() {
    this.value = 1;
    this.setValue = function(filename) {
        this.readFile(filename).then(function(newValue){
            this.value = newValue;
        });
    }
}
```

But when I ran the more complicated version of this toy example, I didn't see the value update. In fact, since I hadn't defined an initial value, my Object variable was still undefined. For this example, we would see that the Object value isn't updated at all:

```
var filename = "data.txt"
myObject.setValue(filename)
myObject.value

>> 1
```

### Debugging the error
Crap, what is going on? Once I checked that I wasn't referencing the Object variable anywhere else, I <a href="http://stackoverflow.com/questions/34381595/accessing-this-of-an-object-inside-promise-callback-then" target="_blank">asked the internet</a>, and didn't find any reasonable solution that wouldn't require making my code overly complicated or weird. I then decided to debug the issue properly myself. The first assumption I questioned was the idea that the `this` inside of my Promise probably wasn't the same Object `this` that I was trying to refer to. When I did a `console.log(this)`, I saw the following:

```
Window {external: Object, chrome: Object, document: document, wb: webGit, speechSynthesis: SpeechSynthesis…}
```

uhh... what? My window object? I should have seen the someObject variable `myObject`, which is what I'd have seen refencing `this` anywhere within someObject (but clearly outside of a Promise):

```
someObject {value: 1}
```

This (no pun intended) means that I needed something like a pointer to carry into the function, and refer to the object. Does JavaScript do pointers?

### Solution: a quasi pointer
JavaScript doesn't actually have pointers in the way that a CS person would think of them, but you can pass Objects and they refer to the same thing in memory. So I came up with two solutions to the problem, and both should work. One is simple, and the second should be used if you need to be passing around the Object (`myObject`) through your Promises.


#### Solution 1: create a holder
We can create a `holder` Object for the `this` variable, and reference it inside of the Promise:

```
function someObject() {
    this.value = 1;
    this.setValue = function(filename) {
        var holder = this;
        this.readFile(filename).then(function(newValue){
            holder.value = newValue;
        });   
    }
}
```

This will result in the functionality that we want, and we will actually be manipulating the `myObject` by way of referencing `holder`. Ultimately, we replace the value of `1` with `2`.

#### Solution 2: pass the object into the promise
If we have some complicated chain of Promises, or for some reason if we can't access the holder variable (I haven't proven or asserted this to be an issue, but came up with this solution in case someone else finds it to be one) then we need to pass the Object into the Promise(s). In this case, our function might look like this:

```
function someObject() {
    this.value = 1;
    this.setValue = function(filename) {
        this.readFile(filename,this).then(function(response){

            // Here is the newValue
            response.newValue

            // Here is the passed myObject
            var myObject = response.args;

            // Set the value into my Object
            myObject.value = response.newValue;

        });        
    }
}
```

and in order for this to work, the function `readFile` needs to know to add the input parameter `this` as `args` to the response data. For example, here it is done with a web worker:

```
this.readFile = function (filename,args) {

    return new Promise((resolve, reject) => {
        const worker = new Worker("js/worker.js");
        worker.onerror = (e) => {
            worker.terminate();
            reject(e);
        };
        worker.onmessage = (e) => {
            worker.terminate();
            e.data.args = args;
            resolve(e.data);
        }
        worker.postMessage({args:filename,command:"getData"});
    });
};
```

In the above code, we are returning a Promise, and we create a Worker (`worker`), and have a message sent to him with a command called "getData" and the args `filename`. For this example, all you need to know is that he returns an Object (`e`) that has `data` (`e.data`) that looks like this:

##### e.data
```
{
  "newValue": 2
}
```

so we basically add an "args" field that contains the input args (`myObject`), and return a variable that looks like this:

```
{

  "newValue": 2,
  "args": myObject

}
```

and then wha-la, in our returning function, since the `response` variable holds the data structure above, we can then do this last little bit:

```
// Here is the passed myObject
var myObject = response.args;

// Set the value into my Object
myObject.value = response.newValue;
```

Pretty simple! This of course would only work given that an object is returned as the response, because obviously you can't add an object onto a string or number. In retrospect, I'm not sure this was deserving of an entire post, but I wanted to write about it because it's weird and confusing until you look at the `this` inside the Promise. I promise you, it's just that simple :)
