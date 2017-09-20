---
title: "Loading Dynamic Variables in a Static Workspace in MATLAB"
date: 2010-11-27 11:31:14
tags:
  code-2
  matlab
  static
  variables
---


<span style="color: #000000;">I’m working on a set of scripts to do our full resting connectivity analysis with the [conn box from MIT](http://web.mit.edu/swg/software.htm), and of course this involves creating and processing design matrices on the cluster, and then when all is said and done, going back and changing the cluster paths to local ones. The scripts themselves are in a testing phase (and I will probably write about them when they are more finalized) but I wanted to share a silly error that I encountered while working on my script that changes paths in the design matrix.</span>

<span style="color: #000000;">The connectivity box produces an output .mat file (the design matrix that can be opened again in the GUI) that has a user specified name, so obviously the name will be stored within a variable in the script. Step 1 in my path changing script is to load this matrix. In the MATLAB GUI this is a simple load(mat_name), where mat_name might be something like “conn_rest.mat.” However, when I tried to do this in my script, I got the following error:</span>

<span style="color: #ff0000;">??? Error using ==> load</span>  
<span style="color: #ff0000;">Attempt to add “CONN_x” to a static workspace.</span>  
<span style="color: #ff0000;"> See MATLAB Programming, Restrictions on Assigning to Variables for details.</span>  
<span style="color: #ff0000;">Error in ==> conn_change_paths>change_conn at 151</span>  
<span style="color: #ff0000;">load(mat_name’)</span>  
<span style="color: #ff0000;">Error in ==> conn_change_paths at 136</span>  
<span style="color: #ff0000;"> change_conn(mat_name,oldpath,newpath,slash,old_slash);</span>

ï»¿<span style="color: #000000;">I would guess that this is a common error for many MATLAB users granted that many might want to load .mat files or variables that may have dynamic names in a static context at one time or another. What I don’t quite understand is what is so dangerous about doing this? The variable that I wanted to load from the .mat, called CONN_x, will always have the same name and fields. Perhaps MATLAB has a fear of loading mysterious matrices with an unknown number of variables? So, for my next attempt, I tried to reassure MATLAB that I only wanted to load one variable, and it had a static name (CONN_x):</span>

<span style="color: #3366ff;">load(mat_name,’CONN_x’)</span>

<span style="color: #000000;">which is telling it specifically to load the CONN_x variable from the .mat that is specified. I got the same error. So it seems that the only solution is to load CONN_x into a structure, doing something like this:</span>

<span style="color: #3366ff;">C= load(mat_name,’CONN_x’)</span>

<span style="color: #000000;">and of course this means that my variable is now references as C.CONN_x.fieldname instead of just CONN_x.fieldname. Given that the connectivity toolbox is hard-coded expecting CONN_x, we can’t have this extra C hanging around. We can fix this problem with:</span>

<span style="color: #3366ff;">CONN_x = C.CONN_x</span>

<span style="color: #000000;">The entire thing seems sort of silly, because MATLAB allows me to do something like</span><span style="color: #3366ff;">load(‘REX.mat’,’params’)</span><span style="color: #000000;">in a static context but not the exact same command using a variable .mat name. Matter of fact, and I can’t believe that I’m writing about something this silly! I decided to because I can imagine that many users would encounter this error, and in the rare case that a frustrated person stumbles on this post, it is well worth it!</span>


