#!/bin/bash
# Author: Joseph Lord
# Date: 11/18/2018
# Description: Creates multiple users with an expired password
# Options: None

while true
do
	read -p "Input username:" usr
	echo
	read -p "Input password:" pass

	useradd $usr
	passwd -e $pass
	
	read -p "Continue? (y/n)" cont
	echo
	if [ "$cont" = "no" || "$cont" = "n" ]; then printf "Exiting.\n\n"; exit; fi
done
