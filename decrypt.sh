#!/bin/bash

ENCRYPT_SCRIPT_RAW="https://raw.githubusercontent.com/zakattack9/encrypt-backup-codes/master/encrypt.sh"
FILE=$1

if [ -z "$1" ]; then
  if [ -f "./backup_codes.zip" ]; then
    FILE="backup_codes.zip"
  else
    echo -n "Enter zip file to decrypt: "
    read FILE
  fi
fi

# read in archive filename passed into this script
7za x $FILE

# check if unzip command ran successfully before deleting the zip file
if [ $? -eq 0 ]; then
  # remove backup_codes.zip
  rm backup_codes.zip
  echo "Decrypted $FILE codes successfully!!!"

  echo "Delete decrypt script and generate encrypt script?"
  echo "Enter (y)es or (n)o"
  read cleanup

  if [[ $cleanup == "y" ]]; then
    echo "Cleaning up..."
    curl $ENCRYPT_SCRIPT_RAW -o encrypt.sh
    chmod +x encrypt.sh
    rm -- "$0"
  fi
else
  echo "Failed to decrypt the zip file"
fi
