#!/bin/bash

nvim_install_dir="/nvim"

setup_container() {
  # Update and install dependencies
  apt update 

  # Install utilities
  apt install -y tmux git ripgrep zsh

  # Install oh-my-zsh
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

  # Install python
  apt install -y python3 python3-venv

  # Install nodejs
  if ! command -v node -v >/dev/null 2>&1
  then
    apt install -y curl
    curl -fsSL https://deb.nodesource.com/setup_22.x | bash -
    apt install -y nodejs
  fi

  # If neovim is not installed then install it
  if ! command -v nvim >/dev/null 2>&1
  then
    mkdir -p $nvim_install_dir
    wget https://github.com/neovim/neovim/releases/download/v0.11.1/nvim-linux-arm64.appimage -O $nvim_install_dir/nvim.appimage
    chmod u+x $nvim_install_dir/nvim.appimage
    (cd $nvim_install_dir; ./nvim.appimage --appimage-extract)
    ln -s $nvim_install_dir/squashfs-root/usr/bin/nvim /usr/bin/nvim && ln -s $nvim_install_dir/squashfs-root/usr/bin/nvim /usr/bin/vim
  fi

  # Depedencies for treesitter
  apt install -y npm build-essential
  echo "Installing tree-sitter-cli"
  npm install -g tree-sitter-cli

  # Add git config
  cp -v -a -r $HOME/neovim_dev/git/. $HOME/

  # Add bash configs
  $HOME/neovim_dev/bash/extend_bashrc.sh
}

# Copy configs
if [ "$1" == "" ] || [ $# -gt 1 ]; then
  echo "No config directory provided, skipping config files"
else
  config_dir="$1"
  mkdir -p $config_dir
  echo "Using config directory: $config_dir"
  cp -v -R ./.config/* $config_dir 
fi
