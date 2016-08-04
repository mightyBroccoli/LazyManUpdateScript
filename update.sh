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
  echo -e $RED"Error: must be root \n"
  echo -e $YELLOW"Exiting...\n"$ENDCOLOR
  exit 0
fi
}
aptitude_check ()
#check if package 'aptitude' is installed
{
  if command -v aptitude > /dev/null; then
    echo -e $GREEN"Detected aptitude"$ENDCOLOR
  else
    echo -e $RED"Installing aptitude...\n"$ENDCOLOR
    apt-get install -q -y aptitude
  fi
}
dpkg_check ()
#check if package 'dpkg' is installed
{
  if command -v dpkg > /dev/null; then
    echo -e $GREEN"Detected dpkg"$ENDCOLOR
  else
    echo -e $RED"Installing dpkg...\n"$ENDCOLOR
    apt-get install -q -y dpkg
  fi
}
awk_check ()
#check if package 'aptitude' is installed
{
  if command -v mawk > /dev/null; then
    echo -e $GREEN"Detected mawk"$ENDCOLOR
  else
    echo -e $RED"Installing awk...\n"$ENDCOLOR
    apt-get install -q -y mawk
  fi
}


#running subroutines
if [ -f "$FILE" ];
then
  echo -e "Dependencies already checked.\n"
else
  echo -e "Checking now \n"
  root_check
  dpkg_check
  aptitude_check
  awk_check
  touch ~/scripts/lazymanupdatescript/.dependencies
fi


# --- the actual script ---
echo ------
echo ------
#apt-get update with the option assume yes (-y) just showing new packets
echo -e $RED "\n resynchronizing the package index...\n" $ENDCOLOR
apt update -y | grep -E "^Holen|^Get"
#showing upgradable packages
echo -e $GREEN "\n upgradable packages: \n" $ENDCOLOR
apt list --upgradable
echo -e "\n"

#upgrading packages
if [ "$1" = "-y" ]
    then
        # assume yes
        echo -e "\n"
        echo ------
        echo -e $GREEN "upgrade" $ENDCOLOR 
        echo ------
        #automaticly updating the installed packages from available ressources
        #apt-get upgrade with the option assume yes (-y)
        apt upgrade -y
        #apt-get dist-upgrade with the option assume yes (-y)
        apt dist-upgrade -y    
    else
        # no
        read -n 3 -p "Upgrade packages (y/n)?" yn
        while true ; do
          case $yn in
              [Yy]* ) echo -e "\n";
                      echo ------;
                      echo -e $GREEN "upgrade" $ENDCOLOR;
                      echo ------;
                      #automaticly updating the installed packages from available ressources
                      #apt-get upgrade with the option assume yes (-y)
                      apt upgrade -y;
                      #apt-get dist-upgrade with the option assume yes (-y)
                      apt dist-upgrade -y;
                      break;;
              [Nn]* ) echo -e "\n skipping ... \n";
                      break;;
              * )     echo -e "\n";
					  echo "Please answer yes or no.";
					  break;;
          esac
        done
fi

#dependencies
if [ "$1" = "-y" ]
    then
        # assume yes
        echo -e "\n"
        echo ------
        echo -e $YELLOW "dependencies" $ENDCOLOR
        echo ------
        #check for broken dependencies
        #apt-get check with the option assume yes (-y)
        apt-get check -y
        #apt-get install with the option fix-broken (-f) and fix-missing (-m) and assume yes (-y)
        apt install -f -m -y   
    else
        # no
        read -n 3 -p "Check all dependencies (y/n)?" yn
        while true ; do
          case $yn in
              [Yy]* ) echo -e "\n";
                      echo ------;
                      echo -e $YELLOW "dependencies" $ENDCOLOR;
                      echo ------;
                      #check for broken dependencies
                      #apt-get check with the option assume yes (-y)
                      apt-get check -y;
                      #apt-get install with the option fix-broken (-f) and fix-missing (-m) and assume yes (-y)
                      apt install -f -m -y;
                      break;;
              [Nn]* ) echo -e "\n skipping ... \n";
                      break;;
              * )     echo -e "\n";
					  echo "Please answer yes or no.";
					  break;;
          esac
        done
fi

#cleaning
if [ "$1" = "-y" ]
    then
        # assume yes
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
        echo -e $RED "dumping local trash files... \n" $ENDCOLOR
        rm -rf /home/*/.local/share/Trash/*/** &> /dev/null
        rm -rf /root/.local/share/Trash/*/** &> /dev/null
        #cleaning user/ root temp files
    else
        # no
        echo -e "\n"
        echo -e "Cleaning involves :"
        echo -e "* removing unused packages"
        echo -e "* cleanig package list cache"
        echo -e "* cleaning users trash"
        echo -e "\n"
        read -n 3 -p "Should cleaning be done (y/n)?" yn
        while true ; do
          case $yn in
              [Yy]* ) echo -e "\n";
                      echo ------;
                      echo -e  $BLUE "cleaning" $ENDCOLOR;
                      echo ------;
                      #various cleaning options
                      apt-get autoremove -y;
                      apt-get autoclean -y;
                      apt-get clean -y;
                      aptitude autoclean;
                      echo " "
                      echo -e $RED "dumping local trash files... \n" $ENDCOLOR;
                      rm -rf /home/*/.local/share/Trash/*/** &> /dev/null;
                      rm -rf /root/.local/share/Trash/*/** &> /dev/null;
                      #cleaning user/ root temp files
                      break;;
              [Nn]* ) echo -e "\n skipping ... \n";
                      break;;
              * )     echo -e "\n";
					  echo "Please answer yes or no.";
					  break;;
          esac
        done
fi

#removing old config files and checking if reboot is needed
if [ "$1" = "-y" ]
    then
        # assume yes
        echo -e "\n"
        echo ------
        echo -e $PURPLE "Removing old config files" $ENDCOLOR
        echo ------
        #removing unused config files !!NO ASSUME YES HERE TO PREVENT BROKEN STUFF!!
        aptitude purge $OLDCONF
    else
        # no
        read -n 3 -p "Remove old config files (y/n)?" yn
        while true ; do
          case $yn in
              [Yy]* ) echo -e "\n";
                      echo ------;
                      echo -e $PURPLE "Removing old config files" $ENDCOLOR;
                      echo ------;
                      #removing unused config files !!NO ASSUME YES HERE TO PREVENT BROKEN STUFF!!
                      aptitude purge $OLDCONF;
                      break;;
              [Nn]* ) echo -e "\n skipping ... \n";
                      break;;
              * )     echo -e "\n";
					  echo "Please answer yes or no.";
					  break;;
          esac
        done
fi

 #check if reboot is needed
  echo ------
  echo -e $CYAN "Should I consider a reboot?" $ENDCOLOR
  echo ------
  if [ -f /var/run/reboot-required ]; then
    echo -e $CYAN 'reboot is required'$ENDCOLOR
    checkrestart
    else
    echo -e $CYAN 'no reboot required'$ENDCOLOR
  fi

#clearing variables
unset RED REDBACK GREEN GREENBACK YELLOW BLUE PURPLE ENDCOLOR CYAN OLDCONF FILE
