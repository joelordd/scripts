#/bin/bash

printf "Installing Softwares....\n"
sleep 2s
sudo yum -y install nfs-utils libnfsidmap > /dev/null
if [ $? == 1 ]; then printf "There was an error. 1.\n"; exit; fi

printf "Configuring Firewall....\n"
sleep 2s
sudo firewall-cmd --permanent --zone=public --add-service=ssh > /dev/null
if [ $? == 1 ]; then printf "There was an error. 2.\n"; exit; fi
sudo firewall-cmd --permanent --zone=public --add-service=mountd > /dev/null
if [ $? == 1 ]; then printf "There was an error. 3.\n"; exit; fi
sudo firewall-cmd --permanent --zone=public --add-service=rpc-bind > /dev/null
if [ $? == 1 ]; then printf "There was an error. 4.\n"; exit; fi
sudo firewall-cmd --permanent --zone=public --add-service=nfs > /dev/null
if [ $? == 1 ]; then printf "There was an error. 5.\n"; exit; fi
sudo firewall-cmd --complete-reload > /dev/null
if [ $? == 1 ]; then printf "There was an error. 6.\n"; exit; fi

printf "Enabling Services....\n"
sleep 2s
sudo systemctl enable rpcbind > /dev/null
sudo systemctl enable nfs-server > /dev/null

printf "Starting Services....\n"
sleep 2s
sudo systemctl start rpcbind
if [ $? == 1 ]; then printf "There was an error. 7.\n"; exit; fi
sudo systemctl start nfs-server
if [ $? == 1 ]; then printf "There was an error. 8.\n"; exit; fi
sudo systemctl start rpc-statd
sudo systemctl start nfs-idmapd
if [ $? == 1 ]; then printf "There was an error. 9.\n"; exit; fi

printf "Making Shared Folders....\n"
sleep 2s
sudo mkdir /pool /share
if [ $? == 1 ]; then printf "There was an error. 10.\n"; exit; fi
sudo chown nfsnobody:nfsnobody /pool
if [ $? == 1 ]; then printf "There was an error. 11.\n"; exit; fi
sudo chown nfsnobody:nfsnobody /share
if [ $? == 1 ]; then printf "There was an error. 12.\n"; exit; fi
sudo chmod 755 /pool
if [ $? == 1 ]; then printf "There was an error. 13.\n"; exit; fi
sudo chmod 755 /share

printf "Adding Exports....\n"
sleep 2s
sudo vim /etc/exports
sudo exportfs -a > /dev/null
if [ $? == 1 ]; then printf "There was an error. 14.\n"; exit; fi
sudo showmount -e
if [ $? == 1 ]; then printf "There was an error. 15.\n"; exit; fi

printf "\n\n%s\n" "DONE!!!!"
sleep 2s
exit