#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
export XDG_CONFIG_HOME="$HOME/.config"
mkdir -p "$XDG_CONFIG_HOME"

link_if_exists() {
  local source_path="$1"
  local target_path="$2"

  if [ -e "$source_path" ] || [ -L "$source_path" ]; then
    ln -snf "$source_path" "$target_path"
  fi
}

link_if_exists "$REPO_ROOT/LazyVim" "$XDG_CONFIG_HOME/LazyVim"
link_if_exists "$REPO_ROOT/.bash_profile" "$HOME/.bash_profile"
link_if_exists "$REPO_ROOT/.bashrc" "$HOME/.bashrc"
link_if_exists "$REPO_ROOT/zsh/zshrc" "$HOME/.zshrc"
link_if_exists "$REPO_ROOT/zsh/zshenv" "$HOME/.zshenv"
link_if_exists "$REPO_ROOT/zsh/.p10k.zsh" "$HOME/.p10k.zsh"
link_if_exists "$REPO_ROOT/tmux/.tmux.conf" "$HOME/.tmux.conf"

APT_UPDATED=0
HAVE_APT=0
if command -v apt-get >/dev/null 2>&1; then
  HAVE_APT=1
fi

apt_update_once() {
  if [ "$APT_UPDATED" -eq 0 ]; then
    sudo apt-get update -y
    APT_UPDATED=1
  fi
}

ensure_apt_package() {
  local package="$1"
  local cmd="$2"

  if command -v "$cmd" >/dev/null 2>&1; then
    return 0
  fi

  if [ "$HAVE_APT" -eq 1 ]; then
    apt_update_once
    sudo apt-get install -y "$package"
  else
    echo "Skipping install of $package because apt-get is not available" >&2
    return 1
  fi
}

ensure_apt_package git git
ensure_apt_package curl curl
ensure_apt_package zsh zsh
ensure_apt_package tmux tmux
ensure_apt_package direnv direnv
ensure_apt_package neovim nvim
ensure_apt_package "fd-find" fdfind
ensure_apt_package ripgrep rg
ensure_apt_package bat batcat

if ! command -v node >/dev/null 2>&1 && [ "$HAVE_APT" -eq 1 ]; then
  apt_update_once
  sudo apt-get install -y nodejs npm
fi

install_starship() {
  if command -v starship >/dev/null 2>&1; then
    return 0
  fi

  local bin_dir="$HOME/.local/bin"
  mkdir -p "$bin_dir"
  curl -fsSL https://starship.rs/install.sh | sh -s -- -y -b "$bin_dir"
}

install_starship

if [ ! -d "$HOME/.oh-my-zsh" ]; then
  git clone --depth 1 https://github.com/ohmyzsh/ohmyzsh.git "$HOME/.oh-my-zsh"
fi

git submodule update --init --recursive

install_lazygit_binary() {
  if command -v lazygit >/dev/null 2>&1; then
    return 0
  fi

  local version="0.60.0"
  local os="$(uname -s)"
  local arch="$(uname -m)"

  if [ "$os" != "Linux" ] || [ "$arch" != "x86_64" ]; then
    echo "Skipping lazygit install: unsupported platform ${os}/${arch}" >&2
    return 0
  fi

  local url="https://github.com/jesseduffield/lazygit/releases/download/v${version}/lazygit_${version}_linux_x86_64.tar.gz"
  local tmpdir
  tmpdir="$(mktemp -d)"

  curl -fsSL "$url" -o "$tmpdir/lazygit.tar.gz"
  tar -xzf "$tmpdir/lazygit.tar.gz" -C "$tmpdir"
  mkdir -p "$HOME/.local/bin"
  install "$tmpdir/lazygit" "$HOME/.local/bin/lazygit"
  rm -rf "$tmpdir"
}

install_lazygit_binary

mkdir -p "$HOME/.local/bin"

if command -v fdfind >/dev/null 2>&1 && ! command -v fd >/dev/null 2>&1; then
  ln -sf "$(command -v fdfind)" "$HOME/.local/bin/fd"
fi

if command -v batcat >/dev/null 2>&1 && ! command -v bat >/dev/null 2>&1; then
  ln -sf "$(command -v batcat)" "$HOME/.local/bin/bat"
fi

install_fzf_from_repo() {
  if command -v fzf >/dev/null 2>&1; then
    return 0
  fi

  local target_dir="$HOME/.fzf"
  if [ ! -d "$target_dir" ]; then
    git clone --depth 1 https://github.com/junegunn/fzf.git "$target_dir"
  fi

  "$target_dir/install" --key-bindings --completion --no-update-rc
}

install_fzf_from_repo

bootstrap_lazyvim() {
  if ! command -v nvim >/dev/null 2>&1; then
    echo "Neovim not found; skipping LazyVim bootstrap" >&2
    return
  fi

  local app_name="${NVIM_APPNAME:-${NVIM_CONFIG_SUBPATH:-LazyVim}}"
  local config_dir="$XDG_CONFIG_HOME/$app_name"

  if [ ! -d "$config_dir" ]; then
    echo "LazyVim config directory $config_dir not found; skipping bootstrap" >&2
    return
  fi

  echo "Bootstrapping LazyVim plugins for app name $app_name"
  if ! NVIM_APPNAME="$app_name" nvim --headless "+Lazy! sync" +qa; then
    echo "Failed to bootstrap LazyVim plugins" >&2
  fi
}

bootstrap_lazyvim

current_shell=$(getent passwd "$(id -un)" | cut -d: -f7)
if [ -n "$current_shell" ]; then
  target_shell=$(command -v zsh)
  if [ -n "$target_shell" ] && [ "$current_shell" != "$target_shell" ]; then
    sudo chsh -s "$target_shell" "$(id -un)"
  fi
fi
