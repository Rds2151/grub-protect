# grub-protect
This script allows users to protect grub boot loader from compromise and set a security layer on it.

This script needs root privilege

## Usage
> chmod 764 grub_passwd.sh

> sudo ./grub_passwd.sh

Important command use in script 
> grub-mkpasswd-pbkdf2 (generate hashed password for GRUB)

> update-grub

## Option

./grub_passwd.sh [Option]

<details>
           <summary>Option</summary>
           <pre>  -e    Edit grub loader</pre>
           <pre>  -r    Remove grub password</pre>
         </details>
