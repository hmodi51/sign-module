#!/bin/bash

keypath="~/.modkeys"
privkey="$keypath/MOK.priv"
pubkey="$keypath/MOK.der"
kernelv="$(uname -r)"
kernel_header="/lib/modules/$kernelv/build"
sign-script="$kernel_header/scripts/sign-file

echo -e "enter module name (.ko module)"

read module

echo -e "Do you already have a key ( y or n )"

read ans

if [[ $ans == "y"  ]] || [[ $ans == "yes" ]]; then
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
    openssl req -new -x509 -newkey ed25519 -keyout $privkey -outform DER -out $pubkey -nodes -days 36500 -subj "/CN=$commonName/"
    chmod 600 $privkey
    chown root:root privkey
    echo -e "Key and certificate Generated"
fi


