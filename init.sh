#!/usr/bin/env bash

ROOT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)

function link_file() {
    file_name=$1
    target_name=$2

    if [ -f "$HOME/$target_name" ]; then
        echo "WARN: File already exists at $HOME/$target_name"
    elif [ -d "$HOME/$target_name" ]; then
        echo "WARN: Directory already exists at $HOME/$target_name"
    else
        if ! ln -s "$ROOT_DIR/$file_name" "$HOME/$target_name"; then
            echo "ERROR: Could not create sym link for $file_name at $HOME/$target_name"
        fi
    fi
}

set -eu

user_zshrc="$HOME/.zshrc"

if [ ! -f "$user_zshrc" ]; then
    touch "$user_zshrc"
fi

if ! grep -Fxq "### Added by dotfiles" "$user_zshrc"; then
    {
        echo ""
        echo "### Added by dotfiles"
        echo "source \"$ROOT_DIR/zsh/main.zsh\""
        echo ""
    } >>"$user_zshrc"
fi

git submodule update --init

if ! [ -f "bat/themes/Catppuccin Mocha.tmTheme" ]; then
    mkdir -p bat/themes/
    curl -L -o "bat/themes/Catppuccin Mocha.tmTheme" https://raw.githubusercontent.com/catppuccin/bat/refs/heads/main/themes/Catppuccin%20Mocha.tmTheme
fi

if ! [ -f "k9s/skins/catppuccin-mocha-transparent.yaml" ]; then
    mkdir -p k9s/skins/
    curl -L -o k9s/skins/catppuccin-mocha-transparent.yaml https://raw.githubusercontent.com/catppuccin/k9s/refs/heads/main/dist/catppuccin-mocha-transparent.yaml
fi

link_file "bat" ".config/bat"
link_file "bottom" ".config/bottom"
link_file "k9s" ".config/k9s"
link_file "lazygit" ".config/lazygit"
link_file "lazydocker" ".config/lazydocker"
link_file "nvim" ".config/nvim"
link_file "tmux" ".config/tmux"

if command -v bat >/dev/null; then
    bat cache --build
else
    echo "WARN: could not build bat cache: bat is not installed"
fi
