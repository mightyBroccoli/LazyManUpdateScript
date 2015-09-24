#!/bin/bash
# simple update script paired with github

#test for root
if [ $USER != root ]; then
  echo -e "Error: must be root"
  echo -e "Exiting..."
  exit 0
fi

#testing for a file in /root/

if command -v find ~/ -name "update.sh" > /dev/null; then
	echo -e "old script detected"
	cp ~/update.sh /root/update.sh.old
	rm ~/update.sh
	touch ~/update.sh
else
	echo -e "creating new a new file in /root/"
	touch ~/update.sh
fi

# getting the newest version from github

curl https://raw.githubusercontent.com/mightyBroccoli/upgrade_script/master/update.sh >> ~/update.sh

