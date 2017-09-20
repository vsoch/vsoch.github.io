---
title: "Automated Reminder Emails and Text Messages with Matlab and Batch"
date: 2010-10-05 14:57:17
tags:
  automated
  batch
  email
  matlab
  reminder
  sms
  text
---


I’ve worked about 35 hours in the past four days putting together an automated reminder system for our lab. I basically have a batch script working with two matlab scripts, GMail calendars, and various data files to send automatic email and SMS reminders to participants in our study. The system isn’t yet implemented, but I’ve tested it and have everything in place to launch.

**Where is it run from?**

All scripts are located in a secure script directory in an Appointments subdirectory. The main batch script that coordinates the entire process is executed via a scheduled task, which would be set to run nightly in the wee hours of the morning. The requirements of the computer running the script are 1) access to the Appointment folder and 2) an installation of matlab.****

**How does it work?**

This Appointments Folder contains scripts and files necessary for sending out automatic, nightly reminder emails, text reminders, and email confirmations for imaging and computer battery data. This documentation will explain the contents of the folder, as well as the workings of the various scripts.

**Overview of Files**

**rem_email.bat** This batch script is responsible for downloading necessary appointment data from the private server, and running the matlab scripts to send out reminder and confirmation notifications. The script would be run nightly to ensure that new files have been downloaded and we have the most up to date information. It basically maps a drive to download new data, runs the matlab scripts to send out reminders, deletes temporary files produced by the scripts, and then closes the mapped drive. The script is as follows (with all paths and such replaced with text):


## [rem_email.m](https://gist.github.com/vsoch/8251564)

**schedule.csv:** Is scheduling information saved on a private server which we connect to and download for the scripts.

Takes in the following arguments: rem_email(days,cal,sendtxt,sendemail,contactemail)

- days: This is the number of days in advance that the reminder emails will be sent. (1 = 24 hrs, 2 = 48 hrs, etc)

- calendars: This is the calendar name that the reminders will be sent to, for each of the times indicated. This can currently be “Computer” or “Imaging.”

- sendtxt: ‘yes’ indicates we want to send a text message, no means no!

- sendemail: ‘yes’ indicates we want to send an email, no means no!

- contactemail: (optional) An email address that you want to be notified in the case of error

This script depends on the imaging and computer calendars to be formatted with the participant first and last name in the Title (Summary) field, and the appointment information copied from the clinical calendar into the description field the following format:

Name: Jane Doe  
 Phone: (999) 999-9999  
 E-mail: jane.doe@duke.edu

**The script works as follows:**

1. Downloads the latest computer or imaging calendar based on a private ical address, and saves the data as either ‘imaging.txt’ or ‘computer.txt.’
2. Reads schedule.csv (just downloaded) into matlab. In the case that this file doesn’t exist (due to a download error, etc) it records this into the error log, and contacts the ‘contactemail’ about the error.While reading in information from the calendar file, the script places the participant name, and appointment date and time into a structural array ONLY for appointments in the future.
3. All of this data is read in from particular locations in the calendar file, and formatted between numbers and strings so we can both do calculations (numbers) and print the variables (strings) into text in reminder emails, etc.
4. Important Notes about the formatting of the calendar: In the case that the script cannot find the person’s name as the first field under “Description” – it extracts it from the “SUMMARY” field – which is like the Title of the event on the calendar. If both these locations are missing the participant name, the script will exit with error
5. The script next uses the fields from the schedule.csv file as a lookup table, and finds participants by first and last name to match with individuals with future appointments only. Currently, we have no third check, so if two people have the exact same name, the script will find the one that appears earliest in the file. This hasn’t been an issue thus far, but if it becomes an issue I will troubleshoot a solution.
6. As the script matches participants in the structure (read in from the calendar file) with additional information read from the schedule.csv, it updates the structure, so at the end of this process we have a complete structural array with information for all subjects with future imaging or computer appointments. Since these are scheduled always within a week of the clinical appointment and never greater than a week apart, this structure should never get greater than perhaps 30. Even if it did, it wouldn’t be an issue.
7. Once we have this complete structure, we then need to figure out who to contact.
8. The script looks at the “days” variable, specified by the user, which is the number of days in advance to send the reminder for. It converts the date of the present date into a number, adds the “days” variable to that, and creates a “compare_date” variable.
9. We then cycle through the structural array of participants, and convert each person’s appointment date to a number, and then compare this number to the comparedate. In the case that we have a match (meaning that the participants appointment is indeed X (days) away, then we send the email.
10. If the person has indicated that it’s OK to text message them, and the script is set to sent text reminders (determined by the sendtxt variable) then we also use the script send_text_messages to send the text reminders.
11. Depending on whether we are doing the imaging or computer calendar, the email message varies in telling the participant the appointment type (“Imaging” or “Computer”) and the location to meet the experimenter.
12. We then record all participants contacted to an output log, and exit matlab to prepare for the next script.
13. The rem_email.bat file can send out different combinations of reminder emails and texts simply by running this script multiple times with various configurations, as is done if you look at the batch code above.


## [confirmation_email.m](https://gist.github.com/vsoch/8251564)

Takes in the following arguments: confirmation_email(contactemail)

This script works in the same basic manner as rem_email.m, except that it is hard coded to download the imaging and computer calendar, and then send out only reminder emails to subjects with appointments that were just created in the past 24 hours (new appointments that should be confirmed). It figures out this detail by reading in the CREATED field from the calendar text files, which contains the date and time of when the event was created on the calendar. Output goes to a second output log, and in case of error, the contactemail is notified.

**imaging.txt:** Is a temporary file created in an ical format (saved as a text for easy readability) that contains information from our imaging calendar on Gmail. This file is created by the script (if it doesn’t exist) and deleted at the end of the batch job.**  
**

**computer.txt: ** Is the equivalent temporary file, but for the computer battery calendar.  
 various LOG.txt files: Are output logs and error logs of reminder emails and texts sent. To be updated upon each script run.

These are new scripts, of course, and should be checked regularly for successful runs, and in the case of error, troubleshooted! In the long run I am hoping these will provide an easy and reliable toolset for sending reminder emails and text messages to participants, and doing away with missed appointments!
