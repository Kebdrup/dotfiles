#!/bin/bash

nvim_install_dir="/nvim"
current_path="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

setup_container() {
  # Install utilities
  apt update && apt install -y curl git zsh build-essential

  # Install oh-my-zsh
  RUNZSH=no CHSH=yes sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

  # Install mise-en-place
  curl https://mise.run | MISE_INSTALL_PATH=/usr/local/bin/mise sh

  # Add home configs
  cp -v -a -r $current_path/home/. $HOME/

  mise install --cd ~/.config/mise/

  # Add bash configs
  $current_path/bash/extend_bashrc.sh
}

replace_configs() {
  cp -v -R $current_path/.config/ $HOME/.config
  mise trust "$current_path/.config/mise/mise.toml"
  mise trust ~/.config/mise/mise.toml
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --config|-c)  replace_configs; shift ;;
    --init|-i)    setup_container; shift ;;
    --help|-h)    echo "Usage: $0 [--init|-i] [--config|-c path]"; exit 0 ;;
    -*)           echo "Error: Unknown option $1" >&2; exit 1 ;;
  esac
done
