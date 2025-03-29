# sign-module

This bash script is written as part of signing kernel module. The idea behind this was as some linux disibutions have secure boot enabled due to which you can not load kernel modules and it might give some error like:

    Required key not available

and that is because **Secure Boot** is enabled on your OS due to which it requires your module to be signed and verified.

One easy way is to disable **Secure Boot** and the other way is to create a key and then sign it and then register it in **Secure Boot** and then enroll in MOK.

Now the latter is for obviosuly a lengthy process so thats why I created this script which will do the work in minutes without disabling Secure Boot.

There are some requirements which needs to be installed:
* mokutil
* openssl
* kernel modules should also be installed

and thats all. I would suggest to rename this script to something without sh extension like (signm) and then copy it to `/usr/local/bin/` so that you dont have to copy the script everywhere in your directories and will make things much easier.

This steps to follow were referenced from: https://superuser.com/a/1513506