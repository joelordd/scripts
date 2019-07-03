#!/bin/bash
# Title: LAMP Server Construction
# OG Author: Joseph Lord
# Date: 10/11/2018

#error=$ ( if [ $? == 1 ]; then printf "There was an error, fix it.\n"; fi ) doesnt work
#error=$(printf "There was an error, fix it.\n") doesnt work

printf "%s\n\n" "This script will install and configure a lamp server!" "Intalling Softwares...."
sleep 2s
sudo yum -y install httpd mariadb mariadb-server php php-mysql &> /dev/null
if [ $? == 1 ]; then printf "There was an error, fix it. 1\n"; exit; fi
sudo yum -y install php-pdo php-gd php-mbstring &> /dev/null
if [ $? == 1 ]; then printf "There was an error, fix it. 2\n"; exit; fi

printf "Updating firewall-cmd....\n\n"
sleep 2s
sudo firewall-cmd –permanent –add-service=http &> /dev/null
sudo firewall-cmd –permanent –add-service=https &> /dev/null
sudo systemctl restart firewalld &> /dev/null
if [ $? == 1 ]; then printf "There was an error, fix it. 3\n"; exit; fi

printf "Starting HTTPS....\n\n"
sleep 2s
sudo systemctl restart httpd
if [ $? == 1 ]; then printf "There was an error, fix it. 4\n"; exit; fi
sudo systemctl enable httpd &> /dev/null

printf "Installing OpenSSL....\n\n"
sleep 2s
sudo yum -y install mod_ssl openssl &> /dev/null
if [ $? == 1 ]; then printf "There was an error, fix it. 5\n"; exit; fi
sudo mkdir –p –m 755 /var/www/secure
if [ $? == 1 ]; then printf "There was an error, fix it. 6\n"; exit; fi
sudo chmod 755 /var/www/secure
if [ $? == 1 ]; then printf "There was an error, fix it. 7\n"; exit; fi

printf "Deleting Old Certs/Keys....\n\n"
sleep 2s
sudo rm –vf /etc/pki/tls/private/*.key
if [ $? == 1 ]; then printf "There was an error, fix it. 8\n"; exit; fi
sudo rm –vf /etc/pki/tls/certs/*.crt
if [ $? == 1 ]; then printf "There was an error, fix it. 9\n"; exit; fi

printf "Generating New Cert/Key....\n\n"
sleep 2s
sudo openssl req -x509 -nodes  -days  730  -newkey rsa:2048  -keyout /etc/pki/tls/private/www.csusbcoyote.net.key -out  /etc/pki/tls/certs/www.csusbcoyote.net.crt
if [ $? == 1 ]; then printf "There was an error, fix it. 10\n"; exit; fi

printf "Change SSL.conf file....\n\n"
sleep 2s
sudo vim /etc/httpd/conf.d/ssl.conf
sudo systemctl restart httpd
if [ $? == 1 ]; then printf "There was an error, fix it. 11\n"; exit; fi

printf "Configuring MariaDB....\n\n"
sleep 2s
sudo systemctl start mariadb
if [ $? == 1 ]; then printf "There was an error, fix it. 12\n"; exit; fi
sudo systemctl enable mariadb &> /dev/null
sudo mysql_secure_installation
if [ $? == 1 ]; then printf "There was an error, fix it. 13\n"; exit; fi

printf "Installing epel-release....\n\n"
sleep 2s
sudo yum –y install epel-release &> /dev/null
if [ $? == 1 ]; then printf "There was an error, fix it. 14\n"; exit; fi
sudo vim /etc/yum.repo.d/epel.repo
sudo yum -y update &> /dev/null
if [ $? == 1 ]; then printf "There was an error, fix it. 15\n"; exit; fi

printf "Configuring phpMyAdmin....\n\n"
sleep 2s
sudo yum –y install phpMyAdmin &> /dev/null
if [ $? == 1 ]; then printf "There was an error, fix it. 16\n"; exit; fi
sudo vim /etc/httpd/conf.d/phpMyAdmin.conf
sudo vim /etc/phpMyAdmin/config.inc.php
sudo systemctl restart httpd
if [ $? == 1 ]; then printf "There was an error, fix it. 17\n"; exit; fi

printf "DONE!!!!!\n"
sleep 2s
exit
