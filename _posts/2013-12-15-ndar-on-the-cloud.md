---
title: "NDAR on the Cloud"
date: 2013-12-15 20:35:55
tags:
  cloud
  database
  ndar
---


The National Database for Autism Research (NDAR) is moving toward a [cloud-based data service](http://ndar.nih.gov/cloud_overview.html) (the standard now is to log in and download data with a java applet).  What does this mean?  It means that you can either get data packaged and sent to you via [Amazon S3](http://aws.amazon.com/s3/), or NDAR will make a database instance for you, also from your Amazon account.

### Setup

You first need an [AWS account](http://aws.amazon.com/) (free for Amazon users), as well as having an account and [access to NDAR](http://ndar.nih.gov/ndarpublicweb/access.html) (quite a bit of work, but hands down one of the best databases out there).

 

### Create an Amazon EC2 Security Group

To make your database instance, you have to give NDAR permission.  This is where an [EC2 security group](http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-network-security.html) comes in, and following [the proper steps to take](http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-network-security.html#creating-security-group), log into your AWS Management console:[  
](http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-network-security.html)

- Open the Amazon EC2 console
- In the navigation pane on the left, click "Security Groups"
- Click Create Security Group, the big grey button at the top
- The name of the security group should be "NDAR," and the description can be anything

 

### Open up a Port for NDAR

Next, we need to [open up a port](http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-network-security.html#adding-security-group-rule) for inbound connections from NDAR.  Select the security group NDAR by clicking on it, and look at the bottom of the page to see details about the group:

- Click on the "Inbound" tab
- Next to "create a security rule," "Custom TCP Rule" should be selected
- Under "port range," add "1521"
- Click "Add Rule"
- Click "Apply Rule Changes"

### 

 

### Contact NDAR!

If you want to arrange a meeting for someone to help you through the next steps, you can [submit a help request.](https://ndar.zendesk.com/requests/new)  You can also give it a go on your own by:

- Clicking on the register tab (it will ask you to login) to see this screen:

[![register](http://www.vbmis.com/learn/wp-content/uploads/2013/12/register-300x125.png)](http://www.vbmis.com/learn/wp-content/uploads/2013/12/register.png)

- You can find your Amazon Web Services Account Number in the top right of the [Manage your Account portal](https://portal.aws.amazon.com/gp/aws/manageYourAccount).
- The External ID is just a tag to identify the connection, and it doesn't really matter what it is
- If everything is set up correctly, when you click "Attach AWS Account," it will tell you that it's been successfully added.
- Next, query NDAR as you normally would, and create a data package.
- Instead of launching their java applet, click on the "Launch to NDAR Hosted Database" button.

[![register](http://www.vbmis.com/learn/wp-content/uploads/2013/12/register1-300x72.png)](http://www.vbmis.com/learn/wp-content/uploads/2013/12/register1.png)

- Note: you can also go directly to the miNDAR tab and select an old data package you've created.
- In the next screen, you will be asked to select a "Dataspace Number."  NDAR will give you three, meaning that you can create three database instances:

[![register](http://www.vbmis.com/learn/wp-content/uploads/2013/12/register2-300x118.png)](http://www.vbmis.com/learn/wp-content/uploads/2013/12/register2.png)

- Select an empty slot (eg, Empty 2), and then click "Create New Password."  The password that you create will be needed to connect to your instance, so don't lose it.  Also note that the requirements are very stringent: I had to do it multiple times before the "Launch Cloud Database" button was un-grayed.  If it seems buggy, try clicking "reset" and trying again.
- You will then see the loading icon of doom while the instance is created.  Be patient - it can take a long time:

[![register](http://www.vbmis.com/learn/wp-content/uploads/2013/12/register3.png)](http://www.vbmis.com/learn/wp-content/uploads/2013/12/register3.png)

When it finishes, the "Loading..." will go away, and you will see something similar to the following:

 Your Oracle database is now ready. You can log in at mindar.xxxxxxxxxx.xx-xxxx-1.rds.amazonaws.com Port xxxx service MINDAR. You have been assigned the username: flast, flast2, and flast3. Use the corresponding login for the dataspace and the password created before deployment to log in.

That's it! You can now connect to your database from your software of choice.  Keep in mind that you might either have an SQL or an Oracle database, and those two things differ in how you connect to them.  I specifically asked for SQL, and so I am connecting using the [MySQLdb module in Python](https://pypi.python.org/pypi/MySQL-python), or [SQL Workbench](http://dev.mysql.com/downloads/tools/workbench/) for quick graphical stuffs.  Command line always works too.  If you have an Oracle database, I didn't try this, but it looks like you can use the [cx_oracle module](http://www.oracle.com/technetwork/articles/dsl/python-091105.html) for python.

### 

 

### What about the Data Dictionary?

Ideally, the data dictionary would come in one of the tables.  I don't think that this is (yet) a standard, but if you ask it seems like something that is possible to do.  Also keep in mind that each behavioral data has the variable names in the second row, and that you can find complete data dictionaries for all metrics on the [ndar website](ndar.nih.gov/ndar_data_dictionary.html). I was fully prepared to be downloading a gazillion text files and creating my own database data dictionary, but thank goodness I didn't need to!


