---
title: "Nushell Pokemon Plugin in Python"
date: 2019-10-18 3:30:00
categories: rse
---

I was having some trouble figuring out (based on looking at traces and rust source code)
what exactly kind of Json structure was expected by nushell for plugins. After
some random testing, I stumbled on the basics and want to share what I learned.
I also want to say thank you to <a href="https://twitter.com/andras_io" target="_blank">andras_io</a>
who I've been chatting up a storm on Discord, and having quite a bit of fun
untangling how this works!

## Config

When nushell first discovers a plugin, done by way of being on the path and having
a name like "nu_plugin_*," it will request to get the plugin config, something like this:

```bash
{"method": "config"}
```

And then your plugin might return a configuration object (shown below) with 
a set of named arguments, meaning that the user requests them by name (not positional arguments):
Here is an example config that shows three named arguments:

```bash
{
  "name": "pokemon",
  "usage": "Catch an asciinema pokemon on demand",
  "positional": [],
  "rest_positional": null,
  "named": {
    "switch": "Switch",
    "mandatory": {
      "Mandatory": "String"
    },
    "optional": {
      "Optional": "String"
    }
  },
  "is_filter": false
}
```

What are the arguments under named?

<ol class="custom-counter">
  <li>--switch shows a flag that is a boolean, so it's present (or not).</li>
  <li>--mandatory is an example of a required string</li>
  <li>--optional is an example of an optional string</li>
</ol>

When executed, it looks like this:

```bash
Catch an asciinema pokemon on demand

Usage:
  > pokemon {flags} 

flags:
  --switch
  --mandatory <String> (required parameter)
  --optional <String>
```

Each of these flags is defined under "named" in the plugin configuration above. 


## Sink

See the boolean is_filter is set to false in the configuration? There are two kinds of plugins. A filter
is akin to a pipe (for an example see <a href="https://vsoch.github.io/2019/nushell-plugin-golang/" target="_blank">nushell-plugin-golang</a>), and a sink is just going to execute the plugin and give it total access
to dump whatever it likes to stdout (akin to dumping in a sink I suppose?).
I'm not sure this is the best way to describe it, but it's how I'm trying to understand it.
Now let's look at an example. Given the above, the minimum valid command would have `--mandatory <value>`

```bash
$ pokemon --mandatory avocado
```

Here we are providing all the options!

```bash
$ pokemon --switch --mandatory MANDATORYARG --optional OPTIONALARG
```

Now let's look at how nu will take this input from the user, and pass it to the plugin 
(note that I pretty printed this for your viewing, it's normally a single flattened line):

```bash
{
  "jsonrpc": "2.0",
  "method": "sink",
  "params": [
    {
      "args": {
        "positional": null,
        "named": {
          "switch": {
            "tag": {
              "anchor": null,
              "span": {
                "start": 58,
                "end": 64
              }
            },
            "item": {
              "Primitive": {
                "Boolean": true
              }
            }
          },
          "mandatory": {
            "tag": {
              "anchor": null,
              "span": {
                "start": 20,
                "end": 32
              }
            },
            "item": {
              "Primitive": {
                "String": "MANDATORYARG"
              }
            }
          },
          "optional": {
            "tag": {
              "anchor": null,
              "span": {
                "start": 44,
                "end": 55
              }
            },
            "item": {
              "Primitive": {
                "String": "OPTIONALARG"
              }
            }
          }
        }
      },
      "name_tag": {
        "anchor": null,
        "span": {
          "start": 0,
          "end": 7
        }
      }
    },
    []
  ]
}
```

The bulk of the above are the requested arguments from the user to pass to sink.
An important note is that if a parameter isn't provided and is optional, 
it won't be parsed in the params string, so your code needs to deal with this
appropriately. I'm also not sure why a list is passed to params with the second (index 1) being empty.

## Pokemon Example

Let's have a little more fun and show a pokemon example. I developed this in
Python so I could use my [pokemon](https://github.com/vsoch/pokemon) library.
The source code for the example is at <a href="https://github.com/vsoch/nushell-plugin-pokemon" target="_blank">vsoch/nushell-plugin-pokemon</a> First I'll show you how it works:

<script id="asciicast-275414" src="https://asciinema.org/a/275414.js" data-speed="2" async></script>

In the above you'll notice I also implemented `pokemon --help` since people would likely try it,
and I was able to catch a pokemon, list pokemon (sorted and unsorted), generate an avatar,
and request a specific pokemon by name. We can look at the main logic of the Python script.

```python
for line in fileinput.input():

    x = json.loads(line)
    method = x.get("method")

    # Keep log of requests from nu
    logging.info("REQUEST %s" % line)
    logging.info("METHOD %s" % method)

    # Case 1: Nu is asking for the config to discover the plugin
    if method == "config":
        plugin_config = get_config()
        logging.info("plugin-config: %s" % json.dumps(plugin_config))
        print_good_response(plugin_config)
        break

    # Case 3: A filter must return the item filtered with a tag
    elif method == "sink":

        # Parse the parameters into a simpler format, example for each type
        # {'switch': True, 'mandatory': 'MANDATORYARG', 'optional': 'OPTIONALARG'}
        params = parse_params(x['params'])
        logging.info("PARAMS %s" % params)

        if params.get('catch', False):
            logging.info("We want to catch a random pokemon!")
            catch_pokemon()

        elif params.get('list', False):
            logging.info("We want to list Pokemon names.")
            list_pokemon()

        elif params.get('list-sorted', False):
            logging.info("We want to list sorted Pokemon names.")
            list_pokemon(do_sort=True)

        elif params.get('avatar', '') != '':
            logging.info("We want a pokemon avatar!")
            catch = get_avatar(params['avatar'])

        elif params.get('pokemon', '') != '':
            get_ascii(name=params['pokemon'])

        elif params.get('help', False):
            print(get_usage())

        else:
            print(get_usage())

        break

    else:
        break
```

The above is fairly simple - we are basically parsing what is passed from nu, and deriving the method to
determine what to do! Instead of needing begin_filter, end_filter, and filter
(if is_filter was true) we just need to have a method to return the config
and then deal with parsing the parameters for the config.

Importantly, each of the functions to get an avatar, list_pokemon and catch_pokemon
just prints content to the terminal (stdout). This we can do because the plugin
is a sink (is_filter is False).

For the complete code and more description for how to interact with the
container, view logs, and debug, see <a href="https://github.com/vsoch/nushell-plugin-pokemon" target="_blank">vsoch/nushell-plugin-pokemon</a>.

## So What?

I think nu could be really awesome for creating tools (and scripts that use them) 
for research and science. I'm hoping that by creating examples that might help you to get started,
you can do awesome things, because I certainly am not a very good scientist.
