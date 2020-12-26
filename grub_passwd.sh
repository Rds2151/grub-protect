#!/bin/bash

edit_grub ()
{
	echo "Enter username: "
	read username
	
	sed -i -e '/^set.*$/d' -e '/^password.*$/d' $path
	cp $path $path.bak
	printf "\nset superusers=\"%s\"\n" "$username" >> $path
	printf "password_pbkdf2 %s %s\n" "$username" "$str" >> $path
	cp /boot/grub/grub.cfg /boot/grub/grub.cfg.bak
	update-grub
#	update-grub2
}

path="/etc/grub.d/40_custom"

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
