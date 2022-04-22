#!/bin/bash

set -e

STOW_PACKAGES=(
    fish
)

DIR=$(dirname "$0")

if [ -z "$XDG_CACHE_HOME" ]; then
    export XDG_CACHE_HOME="$HOME/.cache"
fi
if [ -z "$XDG_DATA_HOME" ]; then
    export XDG_DATA_HOME="$HOME/.local/share"
fi

if [ -f /etc/arch-release ]; then
    arch/install.sh
elif grep -q 'ID=ubuntu' /etc/os-release; then
    ubuntu/install.sh
fi

# Don't use $SHELL because it is only updated at next login
DEFAULT_SHELL=$(getent passwd $(id -un) | cut -d : -f 7-)
if [ "$DEFAULT_SHELL" != "/usr/bin/fish" ]; then
    echo "Setting login shell"
    chsh -s /usr/bin/fish
fi

for pkg in "${STOW_PACKAGES[@]}"; do
    echo "Linking dotfiles for $pkg"
    stow -t "$HOME" -d "$DIR/dotfiles" "$pkg"
done

if [ ! -d "$XDG_DATA_HOME/omf" ]; then
    echo "Installing oh-my-fish"
    OMF_INSTALL="$XDG_CACHE_HOME/devenv/omf_install"
    mkdir -p "$(dirname "$OMF_INSTALL")"
    curl -o "$OMF_INSTALL" -C - https://raw.githubusercontent.com/oh-my-fish/oh-my-fish/master/bin/install
    fish -P "$OMF_INSTALL" --noninteractive
fi
