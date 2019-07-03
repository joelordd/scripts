#!/bin/bash
# Title: Secondary DNS Script
# Author: Joseph Lord
# Description: This script makes a secondary dns server

printf "Hello!  This script will now install and configure a secondary DNS server.\n"

echo "" > error.log

printf "\nUpdating firewall....\n"
sudo    firewall-cmd  --permanent  --add-port=53/tcp &> /dev/null
sudo    firewall-cmd  --permanent  --add-port=53/udp &> /dev/null
sudo    firewall-cmd  --complete-reload &> /dev/null

printf "Install DNS softwares....\n"
sudo yum -y install bind bind-utils bind-libs &> /dev/null

printf "Configuring named.conf....\n"
sudo bash -c 'cat >> /etc/named.conf << EOL
options {
	directory "/var/named";
	dump-file "data/cache_dump.db";
	statistics-file "data/named_stats.txt";
	memstatistics-file "data/named_mem_stats.txt"; 

	pid-file"/var/run/named/named.pid"; 
	allow-query          {  localhost;  172.16.1.0/24;};
	allow-transfer    {172.16.1.2;};
};  

logging  { 
	channel  default_debug  {
		file "data/named.run";
		severity  dynamic;
	};
};

zone  "."  IN  {
	type  hint;
	file "named.ca";
};

zone "csusbcoyote.net" IN  {
	type  slave;
	file "named.csusbcoyote.net.hosts";
	masters  { 172.16.1.2; };
	allow-transfer  { 172.16.1.2; };
};

zone "1.16.172.in-addr.arpa" IN  {
	type  slave;
	file "named.172.16.1.hosts";
	masters  { 172.16.1.2; };
	allow-transfer  { 172.16.1.2; };
};

include "/etc/named.rfc1912.zones";
include "/etc/named.root.key";
EOL'

printf "Restarting named service...\n"
sudo systemctl enable named
sudo systemctl restart named

if [ ! -s error.log ]
	then
		printf "DONE!!!! Thanks for using my script!\n"
else
	printf "Please check error.log for error messages."
fi
	
exit