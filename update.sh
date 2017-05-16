#!/bin/bash
#
## Version 0.4.0
#
#
## Dependencies
#
# bash > 4.2
# bashutils
# realpath
# debian goodies
# awk
# aptitude / dpkg
#
#
## Usage
# edit all the user variables and possibly the tslog path to fit your needs
# use this script wisely, the creator is not responsible for any damage done to your system using this script
#mb

#user variables
FILE=$(realpath ~/scripts/lazymanupdatescript/.dependencies)
FILEPATH=$(realpath ~/scripts/lazymanupdatescript)
OLDCONF=$(dpkg -l|grep "^rc"|awk '{print $2}')

# Regular           Bold                Underline           High Intensity      BoldHigh Intens     Background          High Intensity Backgrounds
Bla='\e[0;30m';     BBla='\e[1;30m';    UBla='\e[4;30m';    IBla='\e[0;90m';    BIBla='\e[1;90m';   On_Bla='\e[40m';    On_IBla='\e[0;100m';
Red='\e[0;31m';     BRed='\e[1;31m';    URed='\e[4;31m';    IRed='\e[0;91m';    BIRed='\e[1;91m';   On_Red='\e[41m';    On_IRed='\e[0;101m';
Gre='\e[0;32m';     BGre='\e[1;32m';    UGre='\e[4;32m';    IGre='\e[0;92m';    BIGre='\e[1;92m';   On_Gre='\e[42m';    On_IGre='\e[0;102m';
Yel='\e[0;33m';     BYel='\e[1;33m';    UYel='\e[4;33m';    IYel='\e[0;93m';    BIYel='\e[1;93m';   On_Yel='\e[43m';    On_IYel='\e[0;103m';
Blu='\e[0;34m';     BBlu='\e[1;34m';    UBlu='\e[4;34m';    IBlu='\e[0;94m';    BIBlu='\e[1;94m';   On_Blu='\e[44m';    On_IBlu='\e[0;104m';
Pur='\e[0;35m';     BPur='\e[1;35m';    UPur='\e[4;35m';    IPur='\e[0;95m';    BIPur='\e[1;95m';   On_Pur='\e[45m';    On_IPur='\e[0;105m';
Cya='\e[0;36m';     BCya='\e[1;36m';    UCya='\e[4;36m';    ICya='\e[0;96m';    BICya='\e[1;96m';   On_Cya='\e[46m';    On_ICya='\e[0;106m';
Whi='\e[0;37m';     BWhi='\e[1;37m';    UWhi='\e[4;37m';    IWhi='\e[0;97m';    BIWhi='\e[1;97m';   On_Whi='\e[47m';    On_IWhi='\e[0;107m';

#some functions
root_check()
#is the running user root?
{
if [ "$USER" != root ]; then
  echo -e "$On_Red""Error: must be root \n"
  echo -e "$IRed""Exiting...\n""$Whi"
  exit 0
fi
}
dependencies_check ()
#check if package 'aptitude' is installed
{
if [ -f "$FILE" ];then
  echo -e "$BGre""Dependencies already checked.\n""$Whi"
else
  echo -e "Checking now \n"
  if command -v aptitude > /dev/null; then
    echo -e "$Gre""Detected aptitude""$Whi"
  else
    echo -e "$Red""Installing aptitude...\n""$Whi"
    apt-get install -q aptitude
  fi
  if command -v dpkg > /dev/null; then
    echo -e "$Gre""Detected dpkg""$Whi"
  else
    echo -e "$Red""Installing dpkg...\n""$Whi"
    apt-get install -q dpkg
  fi
  if command -v mawk > /dev/null; then
    echo -e "$Gre""Detected mawk""$Whi"
  else
    echo -e "$Red""Installing awk...\n""$Whi"
    apt-get install -q mawk
  fi
  mkdir -p "$FILEPATH"
  touch "$FILE"
fi
}
apt_upgrade ()
#automaticly updating the installed packages from available ressources
#apt-get upgrade with the option assume yes (-y)
{
echo -e "\n"
echo ------
echo -e "$BGre""upgrade" "$Whi" 
echo ------
apt upgrade -y
}
# 
apt_check ()
#check for broken dependencies
#apt-get check with the option assume yes (-y)
#apt-get install with the option fix-broken (-f) and fix-missing (-m) and assume yes (-y)
{
echo -e "\n"
echo ------
echo -e "$BYel""dependencies""$Whi"
echo ------
apt-get check -y
apt install -f -m -y 
}
recycle_stuff ()
#various cleaning steps
#cleaning user/ root temp files
{
echo -e "\n"
echo ------
echo -e  "$BBlu""cleaning""$Whi"
echo ------
apt-get autoremove -y
apt-get autoclean -y
apt-get clean -y
aptitude autoclean
echo " "
echo -e "$Red""dumping local trash files... \n""$Whi"
rm -rf /home/*/.local/share/Trash/*/** &> /dev/null
rm -rf /root/.local/share/Trash/*/** &> /dev/null
}
aptitude_purge ()
#removing unused config files !!NO ASSUME YES HERE TO PREVENT BROKEN STUFF!!
{
echo -e "\n"
echo ------
echo -e "$BPur""Removing old config files""$Whi"
echo ------
aptitude purge "$OLDCONF"
}
dist_upgrade()
#apt-get dist-upgrade to upgrade your distribution to next higher level
{
read -r -n 3 -p "Are you sure to upgrade your distribution (y/n)?" yn
while true ; do
  case $yn in
      [Yy]* ) apt dist-upgrade;
              break;;
      [Nn]* ) echo -e "\n skipping ... \n";
              break;;
      * )     echo -e "\n Please answer yes or no.";
              break;;
  esac
done    
}

#some subroutines
root_check
dependencies_check

#help output
if [ "$1" = "-h" ]; then
  echo -e "$BGre""-- -- -- Update Script -- -- --""$Whi"
  echo -e "$BPur"" -- -- Script flow -- --\n""$Whi"
  echo -e "1. updating the package index"
  echo -e " 1.1 displaying the upgradable packages"
  echo -e "2. updating all upgradable packages"
  echo -e "3. checking all dependencies of installed packages if something is missing or broken"
  echo -e "4. cleaning up trash files from all users"
  echo -e "5. removing all remaining config files from uninstalled packages"
  echo -e "6. checking if a reboot is necessary \n"

  echo -e "$BPur"" -- -- Usage: update.sh -- --\n""$Whi"
  echo -e "$Gre""-h $Whi			display this help message \n"
  echo -e "$Gre""-y $Whi			assume yes option to accept everything the script tries to do \n"
  echo -e "$Gre""--dist-upgrade $Whi		upgrading the distributing to the lastest stable release \n""$Whi"
  exit
fi

## distribution update ##
if [ "$1" = "--dist-upgrade" ]; then
    read -r -n 3 -p "Are you sure to dist upgrade (y/n)?" yn
    while true ; do
    case $yn in
        [Yy]* ) dist_upgrade;
                break;;
        [Nn]* ) echo -e "\n skipping ... \n";
                break;;
        * )     echo -e "$IRed""\n Please answer yes or no.";
                break;;
    esac
  done
fi

# --- the actual script ---
echo ------
echo ------
#apt-get update with the option assume yes (-y) just showing new packets
echo -e "$Red""\n resynchronizing the package index...\n""$Whi"
apt update -y | grep -E "^Holen|^Get"
#showing upgradable packages
echo -e "$IGre""\n upgradable packages: \n" "$Whi"
apt list --upgradable
echo -e "\n"

#upgrading packages
if [ "$1" = "-y" ]; then
	#assume yes
	apt_upgrade
else
  # no
  read -r -n 3 -p "Upgrade packages (y/n)?" yn
  while true ; do
    case $yn in
        [Yy]* ) apt_upgrade;
                break;;
        [Nn]* ) echo -e "\n skipping ... \n";
                break;;
        * )     echo -e "$IRed""\n Please answer yes or no.";
					      break;;
    esac
  done
fi

#dependencies
if [ "$1" = "-y" ];then
  # assume yes
  apt_check  
else
  # no
  read -r -n 3 -p "Check all dependencies (y/n)?" yn
  while true ; do
    case $yn in
        [Yy]* ) apt_check;
                break;;
        [Nn]* ) echo -e "\n skipping ... \n";
                break;;
        * )     echo -e "$IRed""\n Please answer yes or no.";
				        break;;
    esac
  done
fi

#cleaning
if [ "$1" = "-y" ];then
  # assume yes
	recycle_stuff
else
  # no
  echo -e "$BYel""\n Cleaning involves : \n"
  echo -e "$Red""* removing unused packages"
  echo -e "$Red""* cleanig package list cache"
  echo -e "$Red""* cleaning users trash \n""$Whi"
  read -r -n 3 -p "Should cleaning be done (y/n)?" yn
  while true ; do
    case $yn in
        [Yy]* ) recycle_stuff
                break;;
        [Nn]* ) echo -e "\n skipping ... \n";
                break;;
        * )     echo -e "$IRed""\n Please answer yes or no.";
				        break;;
    esac
  done
fi

#removing old config files and checking if reboot is needed
if [ "$1" = "-y" ];then
  # assume yes
	aptitude_purge
else
  # no
  read -r -n 3 -p "Remove old config files (y/n)?" yn
  while true ; do
    case $yn in
        [Yy]* ) aptitude_purge;
                break;;
        [Nn]* ) echo -e "\n skipping ... \n";
                break;;
        * )     echo -e "$IRed""\n Please answer yes or no.";
		  	        break;;
    esac
  done
fi

 #check if reboot is needed
echo ------
echo -e "$BCya""Should I consider a reboot?" "$Whi"
echo ------
if [ -f /var/run/reboot-required ]; then
  echo -e "$On_Red""reboot is required \n""$Whi"
else
  echo -e "$On_Gre""no reboot required \n""$Whi"
fi
checkrestart

#clearing variables
unset OLDCONF FILE FILEPATH
