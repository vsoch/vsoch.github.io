---
title: "Nushell Plugin Library for GoLang"
date: 2019-10-23 2:24:00
categories: rse
---

I decided to take a shot at creating the start to a Nushell Plugin library in GoLang. My <a href="https://vsoch.github.io/2019/nushell-plugin-golang/" target="_blank">first plugin</a> to derive length was a filter, and if you look at the 
<a href="https://github.com/vsoch/nushell-plugin-len/blob/master/main.go" target="_blank">main.go</a>, it 
would be really hard to start with that and try to roll your own plugin. It would be
even harder to try and implement a sink plugin, which has more complicated logic
that hands your program a temporary file to read from. I also didn't account for
named arguments.

I was able to re-create the same length plugin, and also two new sink plugins (<a href="https://github.com/vsoch/nu-plugin/tree/master/examples/hello" target="_blank">hello</a> and <a href="https://github.com/vsoch/nu-plugin/tree/master/examples/salad" target="_blank">salad</a>)
which are all shown below, and can be found as the library <a href="https://github.com/vsoch/nu-plugin" target="_blank">vsoch/nu-plugin</a>.

<script id="asciicast-276583" src="https://asciinema.org/a/276583.js" async></script>

## Sink Plugin 

For a quick example of how easy a sink plugin can be, take a look at
this example script! You should <a href="https://www.github.com/vsoch/nu-plugin" target="_blank">see the repository</a>
for details.

```go

package main
 
import (
	"fmt"
	nu "github.com/vsoch/nu-plugin/pkg/plugin"
)

// sink is your function to pass to the plugin to run
func sink(plugin *nu.SinkPlugin, params interface{}) {
	// a map[string]interface{} with keys, values
	namedParams := plugin.Func.GetNamedParams(params)
	message := "Hello"
	for name, value := range namedParams {
		if name == "name" {
			message = message + " " + value.(string)
		}
	}
	fmt.Println(message)
}

func main() {
	name := "hello"
	usage := "A friendly plugin"
	plugin := nu.NewSinkPlugin(name, usage)
	plugin.Config.AddNamedParam("name", "Optional", "String")
	plugin.Run(sink)
}
```

## Filter Plugin

A filter plugin is even easier, here is an example for length.

```go

package main
 
import nu "github.com/vsoch/nu-plugin/pkg/plugin"

// filter is passed to the plugin to run 
func filter(plugin *nu.FilterPlugin, params interface{}) {
	// can also be getIntPrimitive
	value := plugin.Func.GetStringPrimitive(params)
	// Put your logic here! In this case, we want a length
	intLength := len(value)
	// You must also return the tag with your response
	tag := plugin.Func.GetTag(params)
	// This can also be printStringResponse
	plugin.Func.PrintIntResponse(intLength, tag)
}

func main() {
	name := "len"
	usage := "Return the length of a string"
	plugin := nu.NewFilterPlugin(name, usage)
	// Run the filter function
	plugin.Run(filter)
}
```

I'm hoping that this can get others started with creating plugins in GoLang,
specifically for something related to data science. Check out the <a href="https://github.com/vsoch/nu-plugin/tree/master/examples" target="_blank">examples folder</a> for inspiration, and if you make
a plugin, please contribute it to the list in the readme!
