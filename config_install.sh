#!/bin/bash

nvim_install_dir="/nvim"
current_path="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

setup_container() {
  # Install utilities
  apt update && apt install -y git zsh build-essential

  # Install oh-my-zsh
  RUNZSH=no CHSH=yes sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

  # Install mise-en-place
  curl https://mise.run | MISE_INSTALL_PATH=/usr/local/bin/mise sh

  # Add home configs
  cp -v -a -r $current_path/home/. $HOME/

  mise --cd ~/.config/mise/ trust 
  mise --cd ~/.config/mise/ install 

  # Add bash configs
  $current_path/bash/extend_bashrc.sh
  source ~/.bashrc
}

replace_configs() {
  mkdir -p $config_dir
  echo "Using config directory: $config_dir"
  cp -v -R $current_path/.config/ $config_dir 
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --config|-c)  config_dir="$2"; replace_configs; shift 2 ;;
    --init|-i)    setup_container; shift ;;
    --help|-h)    echo "Usage: $0 [--init|-i] [--config|-c path]"; exit 0 ;;
    -*)           echo "Error: Unknown option $1" >&2; exit 1 ;;
  esac
done
