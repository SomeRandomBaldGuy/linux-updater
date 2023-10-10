#!/bin/bash

#This script functions as a universal updater for various distributions of Linux.

#This script will be installed in the /usr/local/bin to avoid conflicting with any system installed binaries.
#It will output logs to a purpose built log directory in the home folder, but that can be changed if you wish.

now=$(date)
version=/etc/os-release

echo "Hello, welcome to my updater script."
echo 
sleep 1

echo "The current system time and date is: $now"
echo "You are currently logged into: $HOSTNAME"
echo "You are currently logged in as: $USER"

#This section is only run if the system is using Pacman.
if grep -q "Arch" $version
then
	sudo pacman -Syu
fi

#This section is only run if the system is using the APT manager.
if grep -q "Debian" $version || grep -q "Ubuntu" $version
then
	sudo apt update
	sudo apt upgrade
fi

#This section is only run if the system uses the Portage package manager.
if grep -q "Gentoo" $version
then
	sudo emerge --sync
	sudo emerge --ask --update --deep --newuse @world
fi

#This section is only run if the system uses the DNF package manager.
if grep -q "Rocky" $version || grep -q "RHEL" $version
then
	sudo dnf update
fi
