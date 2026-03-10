#!/bin/bash

echo "starting Neovim Install"

# Ensures the script is not running as sudo or root

CURRENTUSER=$(whoami)

if [[ $CURRENTUSER == "root" ]]; then
  echo "Do not run this script as root/sudo"
  exit
fi

# attempts to gain sudo access if not already accquired

sudo -v

# exits the script if sudo access is not granted
sudo -n true 2>/dev/null || {
  echo "You must have the ability to run sudo commands to execute this script"
  exit 1
}

# update and install curent available apt packages
sudo apt update -y && sudo apt install git curl wget ninja-build \
  gettext cmake unzip build-essential libtool libtool-bin autoconf \
  automake pkg-config doxygen ripgrep fd-find xclip python3-pip \
  python3-venv gdb lldb gcc ncurses-term sqlite3 libsqlite3-dev \
  fzf luarocks lazygit imagemagick -y

####

# install nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.4/install.sh | bash

# set up nvm to run in current terminal
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                   # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion

# configure nvm
nvm install --lts
nvm use --lts
nvm alias default 'lts/*'
source ~/.bashrc

npmbin=$(npm config get prefix)/bin
PATH="$PATH:$npmbin"
source ~/.bashrc
