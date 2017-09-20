---
title: "Print Structural Variable as M Script"
date: 2011-6-12 17:01:20
tags:
  code
  matlab
  spm
  structure
---


I noticed that in the SPM batch editor you are able to create a structural variable called “matlabbatch,” and if you click on “View .m code” the GUI splats out the guts of the structural variable, for my viewing pleasure. I thought it would be nice to have that functionality to easily print any structural variable from your workspace either to the screen or to a .m file, for more careful viewing or editing, so I wrote a script to do that:

It uses the spm function gencode, which can be found under spm8\matlabbatch\gencode.m in your spmx installation directory.

<pre>
<code>
function db_print(DBvar,poption,outname)

% This function prints a database variable to the screen for editing in a
% .m file The user must input the variable to print as the input
% The script uses the gencode function from spm to read the variable
%--------------------------------------------------------------------------

% INPUT VARIABLES
% DBvar --- name of workspace variable to print
% poption --- print to 'screen' or 'file'
% outname --- name of output text file

% Get the name of the variable to print
DBprint = gencode(DBvar,outname);

% if user wants to print to screen
if strcmp(poption,'screen')
for i=1:length(DBprint)
  fprintf('%s\n',DBprint{i})
end

% if user wants to print to file
elseif strcmp(poption,'file')
  fid = fopen([ outname '.m' ],'w');
  for i=1:length(DBprint)
    fprintf(fid,'%s\n',DBprint{i});
end
fclose(fid);
end
end
</code>
</pre>


