#!/bin/bash

edit_grub ()
{
	if [[ $1 -eq 1 ]]
	then
		sed -i.bak -e '/^$/d' -e '/^set.*$/d' -e '/^password.*$/d' $path
		temp=$(file /boot/grub/grub.cfg.bak)
		ch=$(echo $?)

		if [[ $ch -eq 0 ]]
		then
			rm /boot/grub/grub.cfg.bak
		fi

		temp=$(file $path.bak)
		ch=$(echo $?)

		if [[ $ch -eq 0 ]]
		then
			rm $path.bak
		fi	
	else
		echo "Enter username: "
		read username
		sed -i.bak -e '/^$/d' -e '/^set.*$/d' -e '/^password.*$/d' $path 
		printf "\nset superusers=\"%s\"\n" "$username" >> $path
		printf "password_pbkdf2 %s %s\n" "$username" "$str" >> $path
		cp /boot/grub/grub.cfg /boot/grub/grub.cfg.bak
	fi	

	update-grub
#	update-grub2
}

path="/etc/grub.d/40_custom"

if [[ $1 == --help ]]
then
	echo "./grub_passwd.sh [option]"
	printf "\tOption :\n\t\t-e\tEdit grub loader\n\t\t-r\tremove grub password\n"
	exit 0
elif [[ $1 == -r ]]
then
	edit_grub 1
	exit 0
fi

echo -n "Enter password: "
read -s passwd1
echo ""
echo -n "Reenter password: "
read -s passwd2
echo ""

if [[ $passwd1 == $passwd2 ]] && [[ -n $passwd1 ]] &&  [[ -n $passwd2 ]]
then
	temp=$(mktemp)
	printf "%s\n%s" "$passwd1" "$passwd2" > $temp
	str=$(grub-mkpasswd-pbkdf2 < $temp)
	rm -r $temp
	str=${str:68}
	len=$(wc -c $path | sed 's/\s.*$//')

	if [[ $len -gt 214 ]]
	then
		echo -n "Grub is already configure do want to edit (y/n/default): "
		read choice
		if [[ $choice == y ]]
		then
			edit_grub
		else
			exit 0
		fi
	else
		edit_grub
	fi
else
	echo "grub-mkpasswd-pbkdf2: error: passwords don't match."
fi

exit 0
