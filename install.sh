#!/bin/bash

# Change the default shell to zsh

export XDG_CONFIG_HOME="$HOME"/.config

mkdir -p "$XDG_CONFIG_HOME"

ln -sf "$PWD/nvim" "$XDG_CONFIG_HOME"/LazyVim
ln -sf "$PWD/.bash_profile" "$HOME"/.bash_profile
ln -sf "$PWD/.bashrc" "$HOME"/.bashrc
ln -sf "$PWD/zsh/zshrc" "$HOME"/.zshrc
ln -sf "$PWD/tmux/.tmux.conf" "$HOME"/.tmux.conf

packages=(
  fd-find
  bat
  ripgrep
  starship
)

# Install the required packages
sudo apt update -y

for package in "${packages[@]}"; do
  echo "Installing Spackage..."
  sudo apt install "$package" -y
done

go install github.com/jesseduffield/lazygit@latest
go install github.com/jesseduffield/lazydocker@latest

mkdir -p ~/.local/bin

ln -s $(which fdfind) ~/.local/bin/fd
ln -s $(which batcat) ~/.local/bin/bat

chsh -s $(which zsh)
