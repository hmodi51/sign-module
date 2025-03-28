#!/bin/bash

shopt -s nocasematch

keypath="$HOME/.modkeys"
privkey="$keypath/MOK.priv"
pubkey="$keypath/MOK.der"
kernelv="$(uname -r)"
kernel_header="/lib/modules/$kernelv/build"
sign_script="$kernel_header/scripts/sign-file"

echo -e "enter module name (.ko module)"

read module

if [[ ! -f $module ]]; then
    echo -e "Module not found"
    exit 1
fi

echo -e "Do you already have a key ( y or n )"

read ans

# === STEP 1: Generate Keys ===
if [[ $ans == "y"  ]] || [[ $ans == "yes" ]]; then
    if [[ ! -e $privkey ]]; then
        echo -e "private key not found"
        exit 1
    fi
    if [[ ! -e $pubkey ]]; then
        echo -e "public key or cert not found"
        exit 1
    fi
    echo -e "skipping Key Generation"
elif [[ $ans == "n" ]] || [[ $ans == "no" ]]; then
    echo -e "enter common name for cert"
    read commonName
    echo -e "generating keys"
    if [[ ! -d $keypath ]]; then
        echo "creating $keypath"
        mkdir -p $keypath
        chmod 700 $keypath
    fi
    openssl req -new -x509 -newkey rsa:2048 -keyout $privkey -outform DER -out $pubkey -nodes -days 36500 -subj "/CN=$commonName/"
    chmod 600 $privkey
    chown root:root $privkey
    echo -e "Key and certificate Generated"
fi

# === Step 2 : Sign Module ===
echo -e "Signing Module $module"

if [[ ! -f $sign_script ]]; then
    echo -e "Sign script $sign_script not found"
    exit 1
fi

echo -e "running sudo so if asked password then enter the root password"

sudo "$sign_script" sha512 "$privkey" "$pubkey" "$module"
echo -e "$module signed"

# === Step 3 : Registering for Secure Boot === 

echo -e "Registering for Secure Boot now"

echo -e "IMPORTANT!!!"

echo -e "It will again ask for password and it will not be your system or sudo password but the temporary password you will have to use once in next reboot"

sudo mokutil --import $pubkey

echo -e "Registration Successful"

# === Step 4: Enrolling MOK ===

echo -e "Now we will enroll MOK"

echo -e "Restart your computer"

echo -e "Upon restarting , a blue screen will appear"

echo -e "Choose Enroll MOK"

echo -e "Enter the password you set before"

echo -e "Reboot again and now public key is trusted by kernel"
