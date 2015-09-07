---
title: "Vector Quantization"
date: 2013-7-29 18:53:14
tags:
  k-means
  vector-quantization
  vq
---


**Vector Quantization** is a method to compress data, and it's considered a lossy technique because we are creating a new representation for a set of N observations that loses some of our information.  This happens because we represent each of our observations based on a "prototype vector."  You can think of it like doing [k-means clustering](http://www.vbmis.com/learn/?p=94 "K-Means Clustering"), and then representing each observation vector based on its centroid, and throwing away the raw data.  A simple algorithm goes something like this:

1. <span style="line-height: 13px;">Divide observations into groups having approximately the same number of points closest to them (or I don't see why you couldn't use k-means or some variation of that)</span>

Repeat until convergence {

1. Define a vector of sensitivity values for each centroid (some small value)
2. Pick a sample point at random, find the centroid with the smallest distance - sensitivity
3. Move the centroid a little bit toward the sample point
4. Set the centroids sensitivity to zero so it will be less likely to be chosen again

}

What does convergence mean?  We can use [simulated annealing](http://en.wikipedia.org/wiki/Simulated_annealing#Pseudocode), which broadly lets us find a good global optimum in a search space by temporarily accepting less optimal solutions.  We do this by having a function, P, that takes in the energies of two states (a measure of their goodness) and a "temperature" T, that must start off higher (close to 1) when the algorithm starts, and eventually go to zero.  This function P needs to be positive when our transition state is more optimal than our current state.  When T is large, we are willing to step uphill (because it might be a local optimum!) and when T is small, we only go downhill (we reach the end of our [annealing schedule](http://en.wikipedia.org/wiki/Simulated_annealing#The_annealing_schedule), and are ready to converge to a solution).

In the context of Vector Quantization, using an annealing schedule probably means that we look at training by moving a vector based on one point as a state, and the next state being the next move we make with our next point.  We stop adjusting with new points when some metric (the function P) that evaluates the energy of each state (taking into account our annealing schedule) is less than a randomly generated probability.  See the [pseudocode](http://en.wikipedia.org/wiki/Simulated_annealing#Pseudocode) for more clear explanation.

### Benefits of Vector Quantization

This is cool because you can see how the densities can easily be updated with live data, and you can also see how we could deal with missing data.  If we match a new point to the closest centroid (based on the information that we do have), we can then ascribe the average of the missing parameters to the data point.


