---
title: "Sudo, make me a sandwich!"
date: 2011-1-06 09:24:48
tags:
  - comics
---


I love [this cartoon](http://xkcd.com/149/) from xkcd

[![](http://www.vsoch.com/blog/wp-content/uploads/2011/01/sandwich.png "sandwich")](http://www.vsoch.com/blog/wp-content/uploads/2011/01/sandwich.png)

As I dream up a new design for this, how about some sandwich python?

```
#!/usr/bin/python

class sandwich:

def __init__(self):
self.sandwich ={'bread':'None','made':False,'spread':'None','name':'None'}

def __repr__(self):
return "&lt;Name:%s,Made:%s,Spread:%s,Bread:%s&gt;"%(self.sandwich['name'],self.sandwich['made'],self.sandwich['spread'],self.sandwich['bread'])

def getFromPantry(self,fillings,bread):
self.sandwich['spread'] = fillings
self.sandwich['bread'] = bread

def makeSandwich(self,bread,spread,sname):
self.sandwich['made'] = True
self.sandwich['name'] = sname

def nomnom(self):
print self
print "Nom Nom!"

def main():
mysandwich = sandwich()
mysandwich.getFromPantry(('peanut butter','fluff','love'),'honey wheat')
mysandwich.makeSandwich('honey wheat',mysandwich.sandwich['spread'],'blisswich')
mysandwich.nomnom()
if __name__ == '__main__':
main()
```
