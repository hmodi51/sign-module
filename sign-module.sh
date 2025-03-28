#!/bin/bash

keypath = ~/.modkeys

echo -e "enter module name (.ko module)"

read module

echo -e "Do you already have a key ( y or n )"

read ans

if [[ $ans == "y"  ]] || [[ $ans == "yes" ]]; then
    echo -e "enter the path to key"
    read key
elif [[ $ans == "n" ]] || [[ $ans == "no" ]]; then
    echo -e enter your common name
    read commonName
    echo -e "generating keys"
    openssl req -new -x509 -newkey ed25519 -keyout
fi


