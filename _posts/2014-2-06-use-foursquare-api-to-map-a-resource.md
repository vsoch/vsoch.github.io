---
title: "Use Foursquare API to Map a Resource"
date: 2014-2-06 21:09:29
tags:
  asd
  fusion
  mapping
---


I wanted to test out the foursquare API, so I made a simple goal of creating a “resource density map” for a search term of interest.  Given [my lab’s](http://wall-lab.stanford.edu/) expertise, I chose the search term “autism.”  I first downloaded a file with [all major US cities](http://notebook.gaslampmedia.com/download-zip-code-latitude-longitude-city-state-county-csv/), and then familiarized myself with the [foursquare API](https://developer.foursquare.com/).  You need to create an account and register an API, and then use your client ID and secret when you make calls.  I wrote a [pretty basic script](https://gist.github.com/vsoch/8852307#file-mapasd-r) to query for search term “autism” for these cities, and then save to a file for import into a Google Fusion Table (for easy mapping, you could map the data any way that you like!)

[![map1](http://vsoch.com/blog/wp-content/uploads/2014/02/map1-150x150.png)](https://www.google.com/fusiontables/embedviz?q=select+col2+from+1IGhfiMMT5MXXqWEjAwWIyPabzvD7hU_57waqCMg&viz=MAP&h=false&lat=32.671978496085785&lng=-72.97328222958981&t=1&z=4&l=col2&y=2&tmplt=2&hml=TWO_COL_LAT_LNG)  [![map2](http://vsoch.com/blog/wp-content/uploads/2014/02/map2-150x150.png)](https://www.google.com/fusiontables/embedviz?q=select+col2%2C+col3+from+1IGhfiMMT5MXXqWEjAwWIyPabzvD7hU_57waqCMg+limit+1000&viz=HEATMAP&h=true&lat=34.174729449243614&lng=-94.54322139057217&t=1&z=3&l=col2&y=3&tmplt=3&hmd=true&hmg=%2366ff0000%2C%2393ff00ff%2C%23c1ff00ff%2C%23eeff00ff%2C%23f4e300ff%2C%23f4e300ff%2C%23f9c600ff%2C%23ffaa00ff%2C%23ff7100ff%2C%23ff3900ff%2C%23ff0000ff&hmo=0.6000000238418579&hmr=10&hmw=0&hml=TWO_COL_LAT_LNG)


