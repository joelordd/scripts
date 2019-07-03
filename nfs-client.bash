#/bin/bash

printf "Installing Softwares....\n"
sleep 2s
sudo yum -y install nfs-utils libnfsidmap
if [ $? == 1 ]; then printf "There was an error. 1.\n"; exit; fi

printf "Starting Services....\n"
sleep 2s
sudo systemctl enable rpcbind > /dev/null
if [ $? == 1 ]; then printf "There was an error. 2.\n"; exit; fi
sudo systemctl start rpcbind
if [ $? == 1 ]; then printf "There was an error. 3.\n"; exit; fi

printf "Mounting Shared Folders....\n"
sleep 2s
sudo mkdir /pool /share
if [ $? == 1 ]; then printf "There was an error. 4.\n"; exit; fi
sudo mount beehive:/pool /pool
if [ $? == 1 ]; then printf "There was an error. 5.\n"; exit; fi
sudo mount beehive:/share /share
if [ $? == 1 ]; then printf "There was an error. 6.\n"; exit; fi
sudo mount | grep nfs

printf "Adding Beehive to Hosts....\n"
sleep 2s
sudo vim /etc/hosts

printf "Adding Files to fstab....\n"
sleep 2s
sudo vim /etc/fstab

printf "DONE! Rebooting Now!\n"
sleep 3s
sudo init 6