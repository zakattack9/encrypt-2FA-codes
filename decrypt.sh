#!/bin/bash

FILE=$1

if [ -z "$1" ]; then
  echo -n "Enter zip file to decrypt: "
  read FILE
fi

# read in archive filename passed into this script
7za x $FILE

# check if unzip command ran successfully before deleting the zip file
if [ $? -eq 0 ]; then
  # remove backup_codes.zip
  rm backup_codes.zip
  echo "Decrypted $FILE codes successfully!!!"
else
  echo "Failed to decrypt the zip file"
fi
