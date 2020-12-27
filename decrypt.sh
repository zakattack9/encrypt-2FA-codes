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
  printf "\nDecrypted $FILE codes successfully!!!\n"

  if [ ! -f "./encrypt.sh" ]; then
    printf "\nGenerating encrypt script...\n"
    curl $ENCRYPT_SCRIPT_RAW -o encrypt.sh
    chmod +x encrypt.sh
  fi

  printf "\nDelete decrypt script?\n"
  printf "Enter (y)es or (n)o\n"
  read cleanup

  if [[ $cleanup == "y" ]]; then
    printf "\nCleaning up...\n"
    rm -- "$0"
  fi
else
  printf "\nFailed to decrypt the zip file :(\n"
  rm -rf ./setup_codes ./recovery_codes
fi
