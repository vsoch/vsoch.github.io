---
title: "Signal to Noise Ratio (SNR)"
date: 2013-6-16 21:00:05
tags:
  mri
  signal-to-noise-ratio
  snr
---


Sometimes, things are exactly what they seem.  This is one of those cases  The signal to noise ratio (SNR) is a metric that is used in MRI to describe how much of a signal is noise, and how much is "true" signal.  Since "true" signal is what we are interested in and noise is not, the SNR of an image is a reflection of its quality.  A large SNR means that our "true signal" is relatively big compared to our noise, and a small SNR means the exact opposite.

### How do we change SNR?

- SNR can be used as a metric to assess image quality, but more importantly, we would want to know how to change it.  Here are a few tricks to **increase SNR:**
- average several measurements of the signal, because if noise is random, then random contributions will cancel out to leave the "true" signal
- sample larger volumes (increase field of view or slice thickness)... albeit when you do this... you lose spatial resolution!
- increase the strength of the magnetic field (this is an example of the type (i.e., GET A BIGGER MAGNET!)

### How do we measure SNR?

I've never done this, but I've just read about it.  You would want to record signal from a homogeneous region with high signal intensity, and record the standard deviation for the image background (outside of your region).  Then calculate:

> SNR = Mean Signal/Standard Deviation of Background Noise

When I was more involved with scanning at Duke, we used to have a Quality report generated automatically for each scan that included the SNR.  I would guess that most machine setups these days will calculate it automatically for you.


