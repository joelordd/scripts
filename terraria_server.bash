#!/bin/bash

sudo yum -y install curl wget unzip vim-enhanced screen

sudo firewall-cmd --zone=public --permanent --add-port-7777/tcp
sudo firewall-cmd --reload

sudo iptables -A INPUT -p tcp --dport 7777 -j ACCEPT

cd /opt
sudo curl -O http://terraria.org/server/terraria-server-1353.zip

sudo mkdir /opt/terraria
sudo mv /opt/1353/Linux/ /opt/terraria
sudo rm -rf /opt/1353
sudo chown -R root:root /opt/terraria
sudo chmod +x /opt/terraria/Linux/TerrariaServer.bin.x86_64

sudo useradd -r -m -d /srv/terraria terraria
sudo mkdir /srv/terraria/Worlds

sudo touch /etc/systemd/system/terraria.service
sudo bash -c 'cat >> /etc/systemd/system/terraria.service << EOL
[Unit]
Description=server daemon for terraria

[Service]
Type=forking
User=terraria
KillMode=none
ExecStart=/usr/bin/screen -dmS terraria /bin/bash -c "/opt/terraria/TerrariaServer.bin.x86_64"
ExecStop=/usr/local/bin/terrariad exit

[Install]
WantedBy=multi-user.target
EOL'

sudo touch /usr/local/bin/terrariad
sudo bash -c 'cat >> /usr/local/bin/terrariad << EOL
#!/usr/bin/env bash

send="`printf \"$*\r\"`"
attach='script /dev/null -qc "screen -r terraria"'
inject="screen -S terraria -X stuff $send"

if [ "$1" = "attach" ] ; then cmd="$attach" ; else cmd="$inject" ; fi

if [ "`stat -c '%u' /var/run/screen/S-terraria/`" = "$UID" ]
then
    $cmd
else
    su - terraria -c "$cmd"
fi
EOL'

sudo chmod +x /usr/local/bin/terrariad

sudo systemctl start terraria
sudo systemctl enable terraria

sudo terrariad attach
