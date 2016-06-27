#!/bin/bash

#use this script wisely, the creator is not responsible for any damage done to your system using this script
#mb

#variables
#possibly change the location
FILE="~/scripts/lazymanupdatescript/.dependencies"
RED="\033[0;31m"
GREEN="\033[0;32m"
YELLOW="\033[1;33m"
BLUE="\033[0;34m"
PURPLE="\033[0;35m"
ENDCOLOR="\033[0m"
CYAN="\033[1;36m"
OLDCONF=$(dpkg -l|grep "^rc"|awk '{print $2}')

#some subroutines
root_check()
#is the running user root?
{
if [ $USER != root ]; then
  echo -e $RED"Error: must be root"
  echo -e $YELLOW"Exiting..."$ENDCOLOR
  exit 0
fi
}
aptitude_check ()
#check if package 'aptitude' is installed
{
  if command -v aptitude > /dev/null; then
    echo -e $GREEN"Detected aptitude"$ENDCOLOR
  else
    echo $RED"Installing aptitude..."$ENDCOLOR
    apt-get install -q -y aptitude
  fi
}
dpkg_check ()
#check if package 'dpkg' is installed
{
  if command -v dpkg > /dev/null; then
    echo -e $GREEN"Detected dpkg"$ENDCOLOR
  else
    echo $RED"Installing dpkg..."$ENDCOLOR
    apt-get install -q -y dpkg
  fi
}
awk_check ()
#check if package 'aptitude' is installed
{
  if command -v mawk > /dev/null; then
    echo -e $GREEN"Detected mawk"$ENDCOLOR
  else
    echo $RED"Installing awk..."$ENDCOLOR
    apt-get install -q -y mawk
  fi
}


#running subroutines
if [ -f "$FILE" ];
then
  echo "Dependencies already checked."
else
  echo "Checking now" /n
  root_check
  dpkg_check
  aptitude_check
  awk_check
  touch /home/nico/scripts/lazymanupdatescript/.dependencies
fi


# --- the actual script ---
echo ------
echo ------
#apt-get update with the option assume yes (-y) just showing new packets
echo " "
echo -e $RED "resynchronizing the package index..." $ENDCOLOR
echo " "
apt update -y | grep -E "^Holen|^Get"

#showing upgradable packages
echo " "
echo -e $GREEN "upgradable packages: \n" $ENDCOLOR
apt list --upgradable
echo " "

#upgrading packages
read -p "Upgrade packages? " -n 1 -r
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
  # n
  echo -e "skipping ... \n"
else
  # y
  echo -e "\n"
  echo ------
  echo -e $GREEN "upgrade" $ENDCOLOR 
  echo ------
  #automaticly updating the installed packages from available ressources
  #apt-get upgrade with the option assume yes (-y)
  apt upgrade -y
  #apt-get dist-upgrade with the option assume yes (-y)
  apt dist-upgrade -y
fi

#dependencies
read -p "Check all dependencies? " -n 1 -r
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
  # n
  echo -e "skipping ... \n"
else
  # y
  echo -e "\n"
  echo ------
  echo -e $YELLOW "dependencies" $ENDCOLOR
  echo ------
  #check for broken dependencies
  #apt-get check with the option assume yes (-y)
  apt-get check -y
  #apt-get install with the option fix-broken (-f) and fix-missing (-m) and assume yes (-y)
  apt install -f -m -y
fi

#cleaning
echo -e "\n"
echo "Cleaning involves :"
echo "* removing unused packages"
echo "* cleanig out package list cache"
echo -e "\n"
read -p "Should cleaning be done? " -n 1 -r
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
  # n
  echo -e "skipping ... \n"
else
  # y
  echo -e "\n"
  echo ------
  echo -e  $BLUE "cleaning" $ENDCOLOR
  echo ------
  #various cleaning options
  apt-get autoremove -y
  apt-get autoclean -y
  apt-get clean -y
  aptitude autoclean

  echo " "
  echo -e $RED "dumping local trash files..." $ENDCOLOR
  echo " "
  rm -rf /home/*/.local/share/Trash/*/** &> /dev/null
  rm -rf /root/.local/share/Trash/*/** &> /dev/null
  #cleaning user/ root temp files
fi

#removing old config files and checking if reboot is needed
read -p "Are you sure? " -n 1 -r
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
  # n
  echo -e "skipping ... \n"
else
  # y
  echo -e "\n"
  echo ------
  echo -e $PURPLE "Removing old config files" $ENDCOLOR
  echo ------
  #removing unused config files !!NO ASSUME YES HERE TO PREVENT BROKEN STUFF!!
  aptitude purge $OLDCONF

  #check if reboot is needed
  echo ------
  echo -e $CYAN "Should I consider a reboot?" $ENDCOLOR
  echo ------
  if [ -f /var/run/reboot-required ]; then
    echo -e $CYAN 'reboot is required'$ENDCOLOR
    else
    echo -e $CYAN 'no reboot required'$ENDCOLOR
  fi
fi

#clearing variables
unset RED REDBACK GREEN GREENBACK YELLOW BLUE PURPLE ENDCOLOR CYAN OLDCONF FILE
