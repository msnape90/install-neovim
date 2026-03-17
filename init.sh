#!/bin/bash

# attempts to gain sudo access if not already accquired

sudo -v

# exits the script if sudo access is not granted
sudo -n true 2>/dev/null || {
  echo "You must have the ability to run sudo commands to execute this script"
  exit 1
}

sudo apt update && sudo apt install netselect-apt -y
rmdir /tmp/aptsources >/dev/null 2>&1
mkdir -p /tmp/aptsources >/dev/null 2>&1
pushd /tmp/aptsources
echo "searching for fastest debian apt repo"
sudo netselect-apt >/dev/null 2>&1 && "fastest deb repo found"
popd >/dev/null 2>&1

# find the fist occurance (1st line) of a file the conatins string then awk the second column dilimited by space
OLDDEBSOURCE=$(grep "http" /etc/apt/sources.list -m 1 | awk '{print $2}')
NEWDEBSOURCE=$(grep "http" /tmp/aptsources/sources.list -m 1 | awk '{print $2}')

# backup current sources file
sudo cp /etc/apt/sources.list /etc/apt/sources.list.bak

# replace the first occurance of the old deb source with the new one ( the z option dosnt seen to work in script)
sudo sed -iz "s#$OLDDEBSOURCE#$NEWDEBSOURCE#" /etc/apt/sources.list

echo "updated /etc/apt/sources.list to the fastest repo. if error occurs restore from /etc/apt/sources.list.bak"
