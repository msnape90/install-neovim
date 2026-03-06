#!/bin/bash

echo "starting Neovim Install"

# Check if SUDO_USER is empty (not run with sudo)
if [ -z "$SUDO_USER" ]; then
  echo "Error: This script must be run with sudo. Use: sudo ./script.sh" >&2
  exit 1
fi

# If we reach here, run with sudo
echo "Success: Running with sudo. Original user: $SUDO_USER"

# update and install curent available apt packages
sudo apt update -y && sudo apt install git curl wget ninja-build \
  gettext cmake unzip build-essential libtool libtool-bin autoconf \
  automake pkg-config doxygen ripgrep fd-find xclip python3-pip \
  python3-venv gdb lldb gcc ncurses-term sqlite3 libsqlite3-dev \
  fzf luarocks lazygit imagemagick -y

# install nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.4/install.sh | bash

# configure nvm
nvm install --lts
nvm use --lts
nvm alias default 'lts/*'
npmbin=$(npm config get prefix)/bin
PATH="$PATH:$npmbin"
