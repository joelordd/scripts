#!/bin/bash
# Title: Initial CentOS Setup
# Date: 9/21/2018
# Original Author: Joseph Lord
# Description: This script will perform initial setup for CentOS.

echo "This script will perform initial setup for CentOS."

printf "\nChecking for internet connectivity.... \n\n"
sleep 2s
connect=$( ping -c2 google.com > /dev/null > error.log)
if $connect
	then
		printf "This machine has internet connectivity, yay! \n\n"
		sleep 2s
else
	printf "Something is wrong with your internet connection, please fix it then run this script again. \n"
	sleep 1s
	echo "Additional info: Your ip configuration is: "
	ip a | grep 'inet 172.16.1.'
	echo
	sleep 1s
	exit
fi

printf "Installing basic tools.... \n\n"
sleep 2s
sudo yum -y install net-tools nmap yum-utils wget unzip expect vim-enhanced > /dev/null > error.log

printf "Disabling SELINUX.... \n\n"
sleep 2s
sudo setenforce 0 > /dev/null > error.log
sudo sed -i 's/SELINUX=enforcing/SELINUX=disabled/1' /etc/selinux/config

printf "Import CentOS Key.... \n\n"
sleep 2s
sudo rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-*

while true; do
	read -p 'Updating CentOS requires restarting your machine.  Are you ready? (yes/no)' answer
	echo

	if [ "$answer" = "y" ] || [ "$answer" = "yes" ]
		then
			sudo yum -y update
			printf "Done!!!!!!! Restarting Now.... \n"
			sleep 2s
			sudo init 6
	elif [ "$answer" = "n" ] || [ "$answer" = "no" ]
		then
			printf "OK, this machine will not be updated.  Thanks for running my script! \n\n"
			exit
	else
		printf "ERROR: You did not respond with yes or no, please try again. \n"
		sleep 2s
	fi
done