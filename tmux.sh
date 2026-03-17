#!/bin/bash

# attempts to gain sudo access if not already accquired

sudo -v

# exits the script if sudo access is not granted
sudo -n true 2>/dev/null || {
  echo "You must have the ability to run sudo commands to execute this script"
  exit 1
}

sudo apt update && sudo apt install tmux git

CONFIGDIR="$HOME/.config/tmux"

mkdir -p "$CONFIGDIR"
touch "$CONFIGDIR/tmux.conf"

# git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
