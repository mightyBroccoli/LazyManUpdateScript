#!/bin/bash

#use this script wisely, the creator is not responsible for any damage done to your system using this script
#mb

#variables
RED="\033[0;31m"
GREEN="\033[0;32m"
YELLOW="\033[1;33m"
BLUE="\033[0;34m"
PURPLE="\033[0;35m"
ENDCOLOR="\033[0m"
OLDCONF=$(dpkg -l|grep "^rc"|awk '{print $2}')

#introduction of  methods

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
aptitude_check

root_check()
#test for root
{
if [ $USER != root ]; then
  echo -e $RED"Error: must be root"
  echo -e $YELLOW"Exiting..."$ENDCOLOR
  exit 0
fi
}
root_check

echo " "
echo -e $RED "resynchronizing the package index..." $ENDCOLOR
echo " "
apt-get update -y | grep -E "^Holen|^Get"
#update with assume yes (y) just showing new packets

echo ------
echo -e $GREEN "upgrade" $ENDCOLOR 
echo ------
apt-get upgrade -y
#upgrade assume yes (y)
apt-get dist-upgrade -y
#dist-upgrade assume yes (y)

echo ------
echo -e $YELLOW "dependencies" $ENDCOLOR
echo ------
apt-get check -y
#dependencies check assume yes (y)
apt-get install -f -m -y
#dependencies install fix-broke (f) and fix-missing (m) and assume yes (y)

echo ------
echo -e  $BLUE "cleaning" $ENDCOLOR
echo ------
apt-get autoremove -y
apt-get autoclean -y
apt-get clean -y
aptitude autoclean
#various cleaning options with assume yes (y)

echo " "
echo -e $RED "dumping local trash files..." $ENDCOLOR
echo " "
rm -rf /home/*/.local/share/Trash/*/** &> /dev/null
rm -rf /root/.local/share/Trash/*/** &> /dev/null
#cleaning user/ root temp files

echo ------
echo -e $PURPLE "Removing old config files" $ENDCOLOR
echo ------
aptitude purge $OLDCONF
#removing unused config files with assume yes

#clearing variables
unset RED GREEN YELLOW BLUE PURPLE ENDCOLOR OLDCONF
