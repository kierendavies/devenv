#!/bin/bash

set -e

STOW_PACKAGES=(
    fish
)

DIR=$(dirname "$0")

echo "Updating package repos and installing base packages"
sudo pacman -Sy --needed base-devel git

if ! pacman -Qi paru > /dev/null; then
    echo "Installing paru"
    PARU_REPO_DIR="$XDG_CACHE_HOME/paru/clone/paru-bin"
    if [ ! -d "$PARU_REPO_DIR/.git" ]; then
        git clone https://aur.archlinux.org/paru-bin.git "$PARU_REPO_DIR"
    fi
    pushd "$PARU_REPO_DIR"
    git pull
    makepkg -sic
    popd
fi

echo "Installing packages"
paru -S --needed - < $DIR/pkglist.txt

# Don't use $SHELL because it is only updated at next login
DEFAULT_SHELL=$(getent passwd $(id -un) | cut -d : -f 7-)
if [ "$DEFAULT_SHELL" != "/usr/bin/fish" ]; then
    # chsh already prints a message
    chsh -s /usr/bin/fish
fi

if [ ! -d "$XDG_DATA_HOME/omf" ]; then
    echo "Installing oh-my-fish"
    OMF_INSTALL="$XDG_CACHE_HOME/devenv/omf_install"
    mkdir -p "$(dirname "$OMF_INSTALL")"
    curl -o "$OMF_INSTALL" -C - https://raw.githubusercontent.com/oh-my-fish/oh-my-fish/master/bin/install
    fish -P "$OMF_INSTALL" --noninteractive
fi

for pkg in "${STOW_PACKAGES[@]}"; do
    echo "Linking dotfiles for $pkg"
    stow -t "$HOME" -d "$DIR/../dotfiles" -R "$pkg"
done
