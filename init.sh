#!/bin/bash
# simple update script paired with github

#test for root
if [ $USER != root ]; then
  echo -e "Error: must be root"
  echo -e "Exiting..."
  exit 0
fi

#testing for a file in /root/scripts
if command -v find ~/ -name 'update.sh' | xargs cp --suffix=.old -t /root/scripts/ > /dev/null; then
	echo -e "old script detected"
	echo -e "backup old script..."
	rm ~/scripts/update.sh
	touch ~/scripts/update.sh
else
#if no file is found creakting a new folder and sym link in /root/
	echo -e "creating scripts folder at /root/scripts/"
	mkdir /~/scripts/
	
	echo -e "creating a new file in /root/scripts/"
	touch ~/scripts/update.sh
	
	rm ~/update.sh
	ln -s ~/scripts/update.sh /root/update.sh
fi

# getting the newest version from github
curl https://raw.githubusercontent.com/mightyBroccoli/upgrade_script/master/update.sh >> ~/scripts/update.sh

