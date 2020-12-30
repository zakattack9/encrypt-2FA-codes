### The Problem
When enabling 2FA for online accounts, oftentimes you'll receive recovery codes that can be used as a backdoor in the event that your 2FA authenticator can't be accessed. Additionally, when setting up 2FA you can also save the TOTP shared secret key (oftentimes the QR code that gets scanned); this secret key can be used in the future to set up TOTP again for a specific account on an authenticator app without needing to reset 2FA on that account. 

The safest method of storing both the recovery and setup codes is to first encrypt these 2FA codes, then store the encrypted codes offline across multiple hard drives; to make this process easier, the `encrypt.sh` and `decrypt.sh` scripts in this repo will compress all relevant 2FA codes into a single encrypted zip file that can be stored across multiple hard drives and later decrypted/decompressed.

### Retrieving the Scripts
It is important to note that both the encrypt and decrypt scripts come with a self cleanup option and will auto-generate the respective encrypt/decrypt script depending on the current state of the 2FA codes. For example, if you're encrypting your 2FA codes, `encrypt.sh` will automatically generate `decrypt.sh` if it detects that it's not in the current directory where the encrypt script was run; likewise, if you're decrypting your 2FA codes, `decrypt.sh` will automatically generate `encrypt.sh` if it detects that it's not in the current directory where the decrypt script was run. With this in mind, the encrypt script can safely be deleted after encrypting since the decrypt script will have already been generated and vice versa.

```shell
# gets the encrypt script
curl https://raw.githubusercontent.com/zakattack9/encrypt-2FA-codes/master/encrypt.sh -o encrypt.sh && chmod +x encrypt.sh

# gets the decrypt script (this is optional since encrypt.sh will automatically do this)
curl https://raw.githubusercontent.com/zakattack9/encrypt-2FA-codes/master/decrypt.sh -o decrypt.sh && chmod +x decrypt.sh
```

### Running the Scripts
By default, the encrypted zip file is called `backup_codes.zip`—this can be overridden by directly passing in the desired zip filename to the scripts as seen below. When encrypting, `encrypt.sh` will automatically look for `./recovery_codes` and `./setup_codes` directories to compress/encrypt, if either directory doesn't exist, the script will ask for the respective directory name. A `./misc` directory is also encrypted along with the recovery and setup codes directories—it is an optional directory, but its intended use is for storing other information that should be encrypted as well.

```shell
# run the encrypt script with the above naming conventions
# it will ask to enter the directory name(s) if the naming conventions aren't used
./encrypt.sh

# alternatively, pass in a specific filename for the encrypted zip
./encrypt.sh not_named_backup_codes

# run the decrypt script with the above naming convention
# it will ask to enter the zip filename if backup_codes.zip isn't used
./decrypt.sh

# alternatively, pass in a specific file to decrypt
./decrypt.sh not_named_backup_codes.zip
```

### For MacOS
7-zip is used in these scripts to encrypt the files with AES256 which requires `7za` to be installed for MacOS machines. With `brew`, the `p7zip` package can be installed using the following commands.
```shell
brew update
brew install p7zip
# installs 7z, 7za, and 7zr
```
