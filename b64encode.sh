#!/bin/bash

file=$1

if [[ -z ${file} ]]; then
    echo "No file to encode provided!"
    exit 1
else
    b64encoded=$(base64 ${file})
    if [[ $? -eq 0 ]]; then
        echo "$b64encoded" > "${file}.base64"
    fi
fi
