---
title: "Write SQL insert statements from excel file"
date: 2011-7-04 14:16:00
tags:
  code-2
  excel
  matlab
  sql
---


I’ve had this need multiple times, so I’ve written a quick matlab script that will allow you to to dump the contents of an excel file into a MySQL database. The call on command line should be as follows:

code

With the following variables defined as:

- input: the full name of the input excel file —–‘myfile.xls’ or ‘myfile.xlsx’
- sheet: the name of the sheet to read from —– ‘Sheet1’
- outfile: the name of your output file, which will be .txt by default
- database: the full name of your database, usually something like ‘mysitecom_databasename’
- table: the full name of the table —– ‘mytable’

The first row of the excel file, your column headers, are expected to be the corresponding field names, already created in your database. You should be able to open the output text file and copy the code into the “SQL’ tab under phpMyAdmin. In the case of an empty cell, this will be read as NaN, and the script checks for those, and prints an empty entry when it finds one. The script was tested for simple string and numerical entities, entered into a database with standard INT, VARCHAR (255), and DOUBLE data types. I’m sure there are some awkward types that you would want to translate from excel into a strangely formatted SQL command that the script can’t handle. Feel free to modify as needed!

[xls_to_sql.m](https://gist.github.com/vsoch/8247548#file-xls_to_sql-m)


