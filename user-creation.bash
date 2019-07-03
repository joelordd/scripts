#/bin/bash

if [ ! -f /pool/sales ]; then
	sudo mkdir -p /pool/{sales,acct,hr,rnd,it,mgmt}
	if [ $? == 1 ]; then printf "There was an error. 1.\n"; fi
	
	groupadd -g 500 sales
	groupadd -g 501 acct
	groupadd -g 502 hr
	groupadd -g 503 rnd
	groupadd -g 504 it
	groupadd -g 505 mgmt 
fi

if [ $# -ne 1 ]; then printf "Error, you did not specify a filename.\n"; exit; fi

expire=2019-11-11
$filename=$1

if [ ! -s $filename ]; then printf "File either does not exist or is empty.\n"; exit; fi

while IFS=' ' read firstU lastU
do	 
	first=${firstU,,}
	last=${lastU,,}
	
	username=$(printf '%s\n' ${first:0:1}${last:0:7})
	length=${#username}
	
	check=$(sudo grep -c $username /etc/passwd)
	
	if [ $check -gt 0 ]; then
		i=0
		j=7
		
		while [ $check -gt 0 ]
		do
			i=$((i+1))
			j=$((j-1))
			username=$(printf '%s\n' ${first:0:$i}${last:0:$j})
			length=${#username}
		done
	
	dept=$(printf '%s\n' ${filename#4*}${filename%.*})
			
	sudo useradd -c "$name" -d /pool/${dept}/$username -g ${dept} $username
	sudo passwd -e $username
done
	
printf "DONE!!!!\n\n"
exit 