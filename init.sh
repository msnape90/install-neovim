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
mkdir -p /tmp/sources >/dev/null 2>&1
pushd /tmp/sources
sudo netselect-apt
popd >/dev/null 2>&1
