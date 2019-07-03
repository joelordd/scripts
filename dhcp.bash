# Title: DHCP Setup
# Date: 9/22/2018
# Original Author: Joseph Lord
# Description: This will setup and comfigure a dhcp server.

printf "\nThis script installs and configures DHCP. \n\n"
sleep 5s

printf "Installing dhcpd.... \n\n"
sleep 2s
sudo yum -y install dhcpd &> /dev/null

printf "Configuring dhcpd.conf.... \n\n"
sleep 2s
sudo touch /etc/dhcp/dhcpd.conf
sudo bash -c 'cat > /etc/dhcp/dhcpd.conf << EOL
#
# DHCP Server Configuration File
#

ddns-update-style interim;
ignore client-updates;

172.16.1.0 netmask 255.255.255.0 {
	option routers 172.16.1.1;
	range dynamic-bootp 172.16.21.254;
	option domain-name "csusbcoyote.net";
	option domain-name-servers 139.182.2.1,139.182.2.6;
	option time-offset -28800; #Pacific Time
	default-lease-time 600;
	max-lease-time 7200;
}
EOL'

printf "Restarting dhcpd.... \n\n"
sleep 2s
sudo systemctl restart dhcpd
sudo systemctl enable dhcpd

printf "DONE!!! \n"
sleep 1s
printf "Thank you for using my script! \n"
sleep 2s