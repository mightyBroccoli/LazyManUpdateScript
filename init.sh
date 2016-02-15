#!/bin/bash
# simple update script paired with github

#test for root
if [ $USER != root ]; then
  echo -e "Error: must be root"
  echo -e "Exiting..."
  exit 0
fi

dir="/root/scripts/"

#creating a  new folder if not existing already
if [[ ! -e $dir ]]; then
	echo -e "creating scripts folder at /root/scripts/"
    mkdir $dir
	cd $dir
elif [[ ! -d $dir ]]; then
    echo "$dir already exists but is not a directory" 1>&2
fi

#pulling the latest version from github
git pull https://github.com/mightyBroccoli/LazyManUpdateScript.git
