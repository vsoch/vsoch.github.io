---
title: "Get rid of carriage returns using tr"
date: 2010-9-11 13:46:48
tags:
  bash
  carriage-return
  code
  tr
---


Kristin recently had a script that, for some mysterious reason, was in Windows format! (the error output obviously indicated the presence of carriage returns!). In my troubleshooting, this was the command that fixed it!

- tr -d ‘\15\32’ fixed_script.sh


