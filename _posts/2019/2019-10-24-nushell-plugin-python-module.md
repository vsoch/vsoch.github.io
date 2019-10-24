---
title: "Nushell Plugin Library for Python"
date: 2019-10-24 4:30:00
categories: rse
---

Okay, I've been going a little nuts with <a href="https://www.github.com/nushell/nushell" target="_blank">nushell</a>
lately, and the reason is because I have a thought process like:

<ol class="custom-counter">
  <li>Oh, I want to build this thing!</li>
  <li>Maybe there could be a tool to help to build the thing?</li>
  <li>Hmm, who is going to make it...</li>
  <li>I guess I can do it?</li>
</ol>

And then I go off and make the tool! In this case, I had tried creating standalone
plugins with <a href="https://vsoch.github.io/2019/nushell-plugins/" target="_blank">Python</a> 
and <a href="https://vsoch.github.io/2019/nushell-plugin-golang" target="_blank">GoLang</a>, and then I realized that it would be much easier to have a module to help me out. <a href="https://vsoch.github.io/2019/nushell-golang-plugin-library/" target="_blank">Yesterday</a> I did this for GoLang, so today I figured I'd give Python a shot!
And that's what I'll briefly show in this post. Note that every feature implemented by
the plugins interface isn't provided here (for example, I still need to add positional
arguments and support for pipes into a sink) but this is definitely something to get us started!
Check out the module here:

<a href="https://github.com/vsoch/nushell-plugin-python" target="_blank">vsoch/nushell-plugin-python</a>


Now let's go through a few examples. For full examples, you can see the <a href="https://github.com/vsoch/nushell-plugin-python/tree/master/examples" target="_blank">examples folder</a>. Each example includes container builds,
a Makefile, a README with instructions, and of course a Python script. When appropriate, there are containers
that will help you build a standalone executable.

## Filter Plugin

A basic filter plugin will instantiate the `FilterPlugin` class, and then
provide a function to run for the filter. Here is a quick example script.

```python
#!/usr/bin/env python3

from nushell.filter import FilterPlugin

# Your filter function will be called by the FilterPlugin, and should
# accept the plugin and the dictionary of params
def runFilter(plugin, params):
    '''runFilter will be executed by the calling SinkPlugin when method is "sink"
    '''
    # Get the string primitive passed by the user
    value = plugin.get_string_primitive()
    # Calculate the length
    intLength = len(value)
    # Print an integer response (can also be print_string_response)
    plugin.print_int_response(intLength)

# The main function is where you create your plugin and run it.
def main():

    # Initialize a new plugin
    plugin = FilterPlugin(name="len", 
                          usage="Return the length of a string")

    # Run the plugin by passing your filter function
    plugin.run(runFilter)

if __name__ == '__main__':
    main()
```

Notably, your filter function should taken a plugin and parsed command line
parameters (dictionary) as arguments. You can use the plugin to perform
several needed functions to send responses back to nushell, or log to `/tmp/nushell-plugin-<name>.log`:
Generally, the functions of interest will be to get or print a string or int response
that is passed to or from Nushell.

```python
# basic functions to get / print strings and ints
plugin.get_string_primitive()
plugin.get_int_primitive()
plugin.print_int_response()
plugin.print_string_response()
```

or to log something to the logfile:

```python
# The logger logs to /tmp/nu_plugin_<name>.log
plugin.logger.info("This is some information")
plugin.logger.debug("The answer is moo.")
plugin.logger.warning("Stinky socks!")
plugin.logger.error("It's all crashed.")
```

The default level is debug, and you can also disable logging when you create your
plugin.

```python
plugin = FilterPlugin(name="len", 
                      usage="Return the length of a string",
                      logging=False)
```

## Sink Plugin

A sink plugin will instantiate the `SinkPlugin` class, and then hand off
stdin (via a temporary file) to a sink function that you write.
Here is a dummy example.

```python
#!/usr/bin/env python3

from nushell.sink import SinkPlugin

# Your sink function will be called by the sink Plugin, and should
# accept the plugin and the dictionary of params
def sink(plugin, params):
    '''sink will be executed by the calling SinkPlugin when method is "sink"
    '''
    message = "Hello"
    excited = params.get("excited", False)
    name = params.get("name", "")
    # If we have a name, add to message
    message = "%s %s" %(message, name)
    # Are we excited?
    if excited:
        message += "!"
    print(message)


# The main function is where you create your plugin and run it.
def main():

    # Initialize a new plugin
    plugin = SinkPlugin(name="hello", 
                        usage="A friendly plugin")
    # Add named arguments (notice we check for in params in sink function)
    # add_named_argument(name, argType, syntaxShape=None, usage=None)
    plugin.add_named_argument("excited", "Switch", usage="add an exclamation point!")
    plugin.add_named_argument("name", "Optional", "String", usage="say hello to...")
    # Run the plugin by passing your sink function
    plugin.run(sink)

if __name__ == '__main__':
    main()
```

Notice that the main difference here is that we are adding named arguments.
A switch is basically a boolean, and an Optional (or Mandatory) argument can be a 
String, Int, or other <a href="https://github.com/nushell/nushell/blob/master/src/parser/hir/syntax_shape.rs#L49" target="_blank">valid types</a>.


## Single Binary

In that you are able to compile your module with <a href="https://pyinstaller.readthedocs.io/en/stable/operating-mode.html" target="_blank">pyinstaller</a> you can build your python script as a simple binary, and one that doesn't even need nushell installed as a Python module anymore. Why might you want to do this? It will mean that your plugin is a single file (binary) and you don't need to rely on modules elsewhere in the system. I suspect there are other ways to compile
python into a single binary (e.g., cython) but this was the first I tried, and fairly straight forward.
If you find a different or better way, please contribute to this code base!
The examples for <a href="https://github.com/vsoch/nushell-plugin-python/tree/master/examples/len" target="_blank">len</a>
(filter) and <a href="https://github.com/vsoch/nushell-plugin-python/tree/master/examples/hello" target="_blank">hello</a> (sink) demonstrate this, while <a href="https://github.com/vsoch/nushell-plugin-python/tree/master/examples/pokemon" target="_blank">pokemon</a> didn't work due to an external data file.

That's it! I can't believe I pulled this off in under a day, please contribute to make it better!
