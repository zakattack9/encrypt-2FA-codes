#!/bin/bash

DECRYPT_SCRIPT_RAW="https://raw.githubusercontent.com/zakattack9/encrypt-2FA-codes/master/decrypt.sh"
RECOVERY_CODES_DIR="./recovery_codes"
SETUP_CODES_DIR="./setup_codes"
ENCRYPTED_ZIP="backup_codes.zip"

# set encrypted zip to passed in filename
if [ ! -z "$1" ]; then
  ENCRYPTED_ZIP="$1.zip"
fi

if [ ! -d "$RECOVERY_CODES_DIR" ]; then
  # prompt for recovery codes directory and supress newline after echo (-n arg)
  read -e -p "Enter recovery codes directory to encrypt (use * for current directory or hit enter to skip): " RECOVERY_CODES_DIR
  echo ""
fi

if [ ! -d "$SETUP_CODES_DIR" ]; then
  # prompt for setup codes directory and supress newline after echo (-n arg)
  read -e -p "Enter setup codes directory to encrypt (use * for current directory or hit enter to skip): " SETUP_CODES_DIR
  echo ""
fi

PASSWORD="0"
PASSWORD_VERIFY="1"
while [[ ! $PASSWORD == $PASSWORD_VERIFY ]]; do
  # prompt for password to AES256 encrypt archive with
  read -s -p "Enter encrypt password: " PASSWORD

  # verify the inputted password
  echo ""; read -s -p "Verify encrypt password: " PASSWORD_VERIFY

  if [[ ! $PASSWORD == $PASSWORD_VERIFY ]]; then
    printf "\nPasswords do not match, try again.\n"
  fi
  echo ""
done

# use 7-zip to encrypt specified directory
7za a -tzip "-p$PASSWORD" -mem=AES256 $ENCRYPTED_ZIP $SETUP_CODES_DIR $RECOVERY_CODES_DIR

# check if zip command ran successfully before deleting the setup and recovery codes folders
if [ $? -eq 0 ]; then
  # remove plaintext setup and recovery codes folders
  rm -rf $SETUP_CODES_DIR $RECOVERY_CODES_DIR
  printf "\nEncrypted $SETUP_CODES_DIR and $RECOVERY_CODES_DIR successfully!!!\n"

  if [ ! -f "./decrypt.sh" ]; then
    printf "\nGenerating decrypt script...\n"
    curl $DECRYPT_SCRIPT_RAW -o decrypt.sh
    chmod +x decrypt.sh
  fi

  printf "\nDelete encrypt script?\n"
  printf "Enter (y)es or (n)o: "
  read cleanup

  if [[ $cleanup == "y" ]]; then
    printf "\nCleaning up...\n"
    rm -- "$0"
  fi
else
  printf "\nFailed to encrypt the specified directories :(\n"
fi
