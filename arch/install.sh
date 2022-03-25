#!/bin/bash

DIR=$(dirname "$0")

echo "Updating package repos and installing base packages"
sudo pacman -Sy --needed base-devel git

if ! pacman -Qi paru > /dev/null; then
    echo "Installing paru"

    if [ -n "$XDG_CACHE_HOME" ]; then
        PARU_CACHE_DIR="$XDG_CACHE_HOME/paru"
    else
        PARU_CACHE_DIR="$HOME/.cache/paru"
    fi
    PARU_REPO_DIR="$PARU_CACHE_DIR/clone/paru-bin"

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
