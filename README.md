# upgrade_script
A simple script for lazy people for updating, upgrading and installing the latest updates on thier systems with some fancy prompt.

# !/bin/bash or intruduction
Please use this script wisely and be responsible with it. Note that using this script, the creator or anybody commiting to this script, is not responsable for any harm done to your system. This script checks for the root user first befor doing anything.

# capabilities
```sh
$ ./update.sh -h
```
- showing the help part describing what the script does

```sh
$ ./update.sh --dist-upgrade
```
- trying a distribution update if available

```sh
$ ./update.sh -y
```
- the script assues yes and does all the steps with "yes" as the answer
# Installation
```sh
$ mkdir ~/scripts
$ cd ~/scripts
$ git clone https://mightyBroccoli@bitbucket.org/mightyBroccoli/lazymanupdatescript.git
$ ./update.sh -h
```

# Dependencies
- realpath
- aptitude
- dpkg
- awk

# variables
I decided I wanted some fancy prompt to look at when I run this script. Deal with it. This script uses some variables but cleans them up afterwards just so I have a big bag of "I dont need this anymore".

# not root?
my script is designed only for the system administrator to use. if there is an error or something happens that needs direct attention root is always there for you.