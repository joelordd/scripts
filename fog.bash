#!/bin/bash
# FOG Installation Script
# Author: Joseph Lord
# Date: 10/17/2018

printf "Adding Services to Firewall....\n\n"
sleep 2s
for service in http https tftp ftp mysql nfs mountd rpc-bind proxy-dhcp samba; do firewall-cmd --permanent --zone=public --add-service=$service &> /dev/null; 
done
if [ $? == 1 ]; then printf "There was a problem, 1.\n"; exit; fi

printf "Opening FOG Ports on Firewall....\n\n"
sleep 2s
firewall-cmd --permanent --add-port=49152-65532/udp &> /dev/null
if [ $? == 1 ]; then printf "There was a problem, 2.\n"; exit; fi

printf "Opening IGMP Traffic For Multicast....\n\n"
sleep 2s
firewall-cmd --permanent --direct --add-rule ipv4 filter INPUT 0 -p igmp -j ACCEPT &> /dev/null
if [ $? == 1 ]; then printf "There was a problem, 3.\n"; exit; fi
systemctl restart firewalld.service &> /dev/null
if [ $? == 1 ]; then printf "There was a problem, 4.\n"; exit; fi

printf "Disabling SELINUX....\n\n"
sleep 2s
setenforce 0
sed -i 's/SELINUX=enforcing/SELINUX=disabled/1' /etc/selinux/config &> /dev/null
if [ $? == 1 ]; then printf "There was a problem, 5.\n"; exit; fi

printf "Installing FOG....\n\n"
sleep 2s
yum -y install git vim-enhanced &> /dev/null
if [ $? == 1 ]; then printf "There was a problem, 6.\n"; exit; fi
cd ~
mkdir git &> /dev/null
cd git
git clone https://github.com/FOGProject/fogproject.git &> /dev/null
if [ $? == 1 ]; then printf "There was a problem, 7.\n"; exit; fi
cd fogproject/bin
./installfog.sh

printf "DONE!!!!\n\n"
sleep 2s
exit