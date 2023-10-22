#!/bin/bash

#This script functions as a universal updater for various distributions of Linux.
#This script will be installed in the /usr/local/bin to avoid conflicting with any system installed binaries.
#if you wish to limit who can edit this script you may need to run "sudo chown" and modify it to your needs.
#It will output logs to a purpose built log directory in /var/log such as "updater" with both pass and fail logs.

now=$(date)
version=/etc/os-release
logfile=/var/log/updater/success.log
errorfile=/var/log/updater/error.log
passed="The script has completed successfully. Please cheack $logfile for details."
failed="An error has occurred while updating. Please check $errorfile for details."
completion="The script will now close, thank you.

#This function will check the exit code of the update command and run accordingly.
check_exit_status() {
     if [ $? -ne 0 ]
     then 
          echo $failed
     else
          echo $passed
     fi
}

echo "Hello, welcome to my updater script."
echo 
sleep 1
echo "The current system time and date is: $now"
echo "You are currently logged into: $HOSTNAME"
echo "You are currently logged in as: $USER"
echo 
sleep 1
echo "The script will now check your distribution, and apply any available updates."
echo 
sleep 1

#This section is only run if the system is using Pacman.
#This makes use of the 'yes' package to automatically accept the user prompt to update.
#It will continually output "yes" while the package is running until it has completed.
if grep -q "Arch" $version
then
     yes | sudo pacman -Syu 1>>$logfile 2>>$errorfile
     check_exit_status
fi

#This section is only run if the system is using the APT manager.
if grep -q "Debian" $version || grep -q "Ubuntu" $version
then
     sudo apt update && sudo apt upgrade -y 1>>$logfile 2>>$errorfile
     check_exit_status
fi

#This section is only run if the system uses the Portage package manager.
#The -uDN flags stand for "--upate","--deep", and "--newuse".
if grep -q "Gentoo" $version
then
     sudo emerge --sync && sudo emerge -uDN @world 1>>$logfile 2>>$errorfile
     check_exit_status
fi

#This section is only run if the system uses the DNF package manager.
if grep -q "Rocky" $version || grep -q "RHEL" $version
then
     sudo dnf update -y 1>>$logfile 2>>$errorfile
     check_exit_status
fi

echo
sleep 1
echo $completion

#This script doesn't use any of the removal commands such as 'apt autoremove' for Debian or '--depclean' for Gentoo.
#I omitted those functions due to how damaging they can be if done incorrectly. 
#If you wish to add those features you would need to add them after the respective update command.
