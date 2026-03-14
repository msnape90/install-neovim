#!/bin/bash

# TODO:
# test tectonic
# install wezterm
#
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

#### APT

# update and install c build tools
sudo apt update -y && sudo apt install git curl wget ninja-build \
  gettext cmake unzip build-essential libtool libtool-bin autoconf \
  automake pkg-config doxygen -y

# update and install neovim dependencies
sudo apt update -y && sudo apt install ripgrep fd-find xclip python3-pip \
  python3-venv gdb lldb gcc ncurses-term sqlite3 libsqlite3-dev \
  fzf luarocks lazygit imagemagick -y

#### NODE

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

# add npm globals bin to path
NPMBIN="$(npm config get prefix)/bin"
LINETOADD='export PATH="$PATH:'"$NPMBIN"'"'

grep -qxF "$LINETOADD" "$HOME/.bashrc" || echo "$LINETOADD" >>"$HOME/.bashrc"

source "$HOME/.bashrc"

# install npm packages
npm install -g neovim
npm install -g tree-sitter-cli
npm install -g @mermaid-js/mermaid-cli

### RUST

install rust and cargo
curl https://sh.rustup.rs -sSf | sh -s -- -y

. "$HOME/.cargo/env"

# add cargo to path
CARGO="$HOME/.cargo/bin"
LINETOADD='export PATH="$PATH:'"$CARGO"'"'

grep -qxF "$LINETOADD" "$HOME/.bashrc" || echo "$LINETOADD" >>"$HOME/.bashrc"

source "$HOME/.bashrc"

cargo install ast-grep --locked

# install tectonic dependencies
sudo apt-get install \
  libfontconfig1-dev libgraphite2-dev libharfbuzz-dev libicu-dev libssl-dev zlib1g-dev -y && \ # Install tectonic dependencies
mkdir -p $HOME/.local/bin && cd $HOME/.local/bin &&
  curl --proto '=https' --tlsv1.2 -fsSL https://drop-sh.fullyjustified.net | sh && \ # Install tectonic
cd -

### PYTHON

install uv
curl -LsSf https://astral.sh/uv/install.sh | sh
source $HOME/.local/bin/env
source "$HOME/.bashrc"

##### NERD FONT
# install nerd font
wget -P ~/.local/share/fonts https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/JetBrainsMono.zip &&
  cd ~/.local/share/fonts &&
  unzip JetBrainsMono.zip &&
  rm JetBrainsMono.zip &&
  fc-cache -fv

# set gnome terminal to nerd font
PROFILE_ID=$(gsettings get org.gnome.Terminal.ProfilesList default | tr -d \')
gsettings set "org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$PROFILE_ID/" font "'JetBrainsMonoNL Nerd Font Mono 13'"
gsettings set "org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$PROFILE_ID/" cell-width-scale 1.05

#### BUILD NEOVIM

mkdir -p ~/src &&
  git clone https://github.com/neovim/neovim.git ~/src/neovim &&
  cd ~/src/neovim &&
  git checkout stable
make CMAKE_BUILD_TYPE=RelWithDebInfo &&
  sudo make install

#### INSTALL LAZYVIM

mv ~/.config/nvim{,.bak}

# optional but recommended
mv ~/.local/share/nvim{,.bak}
mv ~/.local/state/nvim{,.bak}
mv ~/.cache/nvim{,.bak}

git clone https://github.com/LazyVim/starter ~/.config/nvim

rm -rf ~/.config/nvim/.git

# configure uv environment for lazygit
uv venv ~/.local/share/nvim/python3 &&
  source ~/.local/share/nvim/python3/bin/activate &&
  uv pip install pynvim &&
  mkdir -p /home/$USER/.config/nvim &&
  echo "vim.g.python3_host_prog = '/home/$USER/.local/share/nvim/python3/bin/python'" >>/home/$USER/.config/nvim/init.lua

# install wezterm
curl -fsSL https://apt.fury.io/wez/gpg.key | sudo gpg --yes --dearmor -o /usr/share/keyrings/wezterm-fury.gpg &&
  echo 'deb [signed-by=/usr/share/keyrings/wezterm-fury.gpg] https://apt.fury.io/wez/ * *' | sudo tee /etc/apt/sources.list.d/wezterm.list &&
  sudo chmod 644 /usr/share/keyrings/wezterm-fury.gpg

sudo apt update && sudo apt install wezterm-nightly -y
