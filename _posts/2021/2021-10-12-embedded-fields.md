---
title: "TIL: Embedded Fields in Structs for Go"
date: 2021-10-12 21:30:00
---

Here is a quick "Today I learned" about how to mimic inheritance in Go. For example, in 
Python if we have a class, we can easily inherit attributes and functions from it
for some subclass. Here is a parent class "Fruit" and a child class "Avocado" that inherits the
attributes name and color, and the function IsReady.

```python

#!/usr/bin/env python3

class Fruit:
    def __init__(self, name, color):
        self.name = name
        self.color = color

    def Announce(self):
        print(f"I am {self.color}, and I am {self.name}")


class Avocado(Fruit):

    def __init__(self, name, color, is_ripe):
        super().__init__(name, color)
        self.is_ripe = is_ripe

    def IsReady(self):
        if self.is_ripe:
            print(f"I am {self.color}, and I am {self.name}, and I am ripe!")
        else:
            print(f"I am {self.color}, and I am {self.name}, and I am NOT ripe!")    

def main():

    avocado = Avocado(name = "Harry the avocado", color = "green", is_ripe=True)
    avocado.Announce()
    # I am green, and I am Harry the avocado

    avocado.IsReady()
    # I am green, and I am Harry the avocado, and I am ripe! 
   
if __name__ == "__main__":
    main()
```

Notice the constructor in main - we just hand the name, color, and the variable for if it's ripe
to the Avocado class, and it works! We inherit functions and attributes from the parent class.
But what about Go? I wanted an easy way to do this in Go, because otherwise creating structures with
shared attributes or functionality felt very redundant. So here is the first thing I tried:

```go
package main

import (
	"fmt"
)

type Fruit struct {
	Name string
	Color	string
}

func (f* Fruit) Announce() {
	fmt.Printf("I am %s, and I am %s\n", f.Color, f.Name)
}

type Avocado struct {
	Fruit
	IsRipe bool
}

func (a * Avocado) IsReady() {
	if a.IsRipe {
		fmt.Printf("I am %s, and I am %s, and I am ripe!\n", a.Color, a.Name)
	} else {
		fmt.Printf("I am %s, and I am %s, and I am NOT ripe!\n", a.Color, a.Name)
	}

}

func main() {
	// avocado := Avocado{Name: "Harry the avocado", Color: "green", IsRipe: true}	
	avocado.Announce()
	avocado.IsReady()
}
```

And that totally didn't work! I saw this:

```go
./main.go:19:21: cannot use promoted field Fruit.Name in struct literal of type Avocado
./main.go:19:48: cannot use promoted field Fruit.Color in struct literal of type Avocado
```

Turns out, I was close. I actually needed to provide Fruit in the constructor for Avocado, like this:

```go
// Instead, pass the "base" type to the underlying type
avocado := Avocado{Fruit: Fruit{Name: "Harry the avocado", Color: "green"}, IsRipe: true}
```

Is this kind of funky? Yeah, and <a href="https://github.com/golang/go/issues/9859" target="_blank">others think so too</a>.
But I'm really grateful for the functionality because I can create a bunch of different struct types that have most in
common, but maybe don't share a few things. Could there be other issues that arise? Maybe. I haven't hit them yet. :)
There's a nice article <a href="https://go101.org/article/type-embedding.html" target="_blank">here</a> that I'm perusing to learn more.
<a href="https://gist.github.com/vsoch/dd34ac96dc463c0a2f18c53aea67cf37" target="_blank">Here is the entire set of files</a> in a gist if you want to play around.
