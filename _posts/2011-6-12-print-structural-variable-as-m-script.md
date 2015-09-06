---
title: "Print Structural Variable as M Script"
date: 2011-6-12 17:01:20
tags:
  code-2
  matlab
  spm
  structure
---


I noticed that in the SPM batch editor you are able to create a structural variable called “matlabbatch,” and if you click on “View .m code” the GUI splats out the guts of the structural variable, for my viewing pleasure. I thought it would be nice to have that functionality to easily print any structural variable from your workspace either to the screen or to a .m file, for more careful viewing or editing, so I wrote a script to do that:

It uses the spm function gencode, which can be found under spm8\matlabbatch\gencode.m in your spmx installation directory.

code


