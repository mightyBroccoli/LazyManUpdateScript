#!/bin/bash
# simple update script paired with github

#test for root
if [ $USER != root ]; then
  echo -e "Error: must be root"
  echo -e "Exiting..."
  exit 0
fi

#testing for a file in /root/scripts
if command -v find ~/ -name "update.sh" > /dev/null; then
	echo -e "old script detected"
	echo -e "backup old skript..."
	cp -f ~/skritps/update.sh /root/skripts/update.sh.old
	rm ~/skripts/update.sh
	touch ~/skripts/update.sh
else
#if no file is found creakting a new folder and sym link in /root/
	echo -e "creating skripts folder at /root/skripts/"
	mkdir /root/skripts
	
	echo -e "creating a new file in /root/skripts/"
	touch ~/skripts/update.sh
	
	echo -e "creating symbolic link at /root/"
	rm /root/update.sh
	ln -s /root/skripts/update.sh /root/update.sh
fi

# getting the newest version from github
curl https://raw.githubusercontent.com/mightyBroccoli/upgrade_script/master/update.sh >> ~/skripts/update.sh

