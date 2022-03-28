#!/bin/bash

set -e

COMMON_SYSTEM_PACKAGES=(
    ack
    bat
    curl
    fish
    fzf
    grc
    stow
    thefuck
    vim
)

ARCH_PACKAGES=(
    starship
)

STOW_PACKAGES=(
    fish
    vim
)

DIR=$(dirname "$0")

if [ -z "$XDG_CACHE_HOME" ]; then
    XDG_CACHE_HOME="$HOME/.cache"
fi
if [ -z "$XDG_CONFIG_HOME" ]; then
    XDG_CONFIG_HOME="$HOME/.config"
fi
if [ -z "$XDG_DATA_HOME" ]; then
    XDG_DATA_HOME="$HOME/.local/share"
fi

OS_ID=$(grep '^ID=' /etc/os-release | cut -d= -f2)
echo "Detected OS: $OS_ID"

echo "Installing system packages"
case $OS_ID in
arch)
    sudo pacman -Sy --needed base-devel git

    if ! pacman -Qi paru >/dev/null; then
        echo "Installing paru from AUR"
        PARU_REPO_DIR="$XDG_CACHE_HOME/paru/clone/paru-bin"
        if [ ! -d "$PARU_REPO_DIR/.git" ]; then
            git clone https://aur.archlinux.org/paru-bin.git "$PARU_REPO_DIR"
        fi
        pushd "$PARU_REPO_DIR"
        git pull
        makepkg -sic
        popd
    fi

    paru -S --needed "${COMMON_SYSTEM_PACKAGES[@]}"
    ;;
ubuntu)
    sudo apt update
    sudo apt install -y ${COMMON_SYSTEM_PACKAGES[@]}

    if [ ! -x "$(command -v starship)" ]; then
        echo "Installing starship"
        # Snap doesn't work on WSL :(
        curl -sS https://starship.rs/install.sh | sh -s -- --yes
    fi
    ;;
esac

# Don't use $SHELL because it is only updated at next login
DEFAULT_SHELL=$(getent passwd $(id -un) | cut -d : -f 7-)
if [ "$DEFAULT_SHELL" != "/usr/bin/fish" ]; then
    echo "Setting login shell"
    chsh -s /usr/bin/fish
fi

for pkg in "${STOW_PACKAGES[@]}"; do
    echo "Linking dotfiles for $pkg"
    stow -t "$HOME" -d "$DIR/dotfiles" -R "$pkg"
done

if [ ! -d "$XDG_DATA_HOME/omf" ]; then
    echo "Installing oh-my-fish"
    OMF_INSTALL="$XDG_CACHE_HOME/devenv/omf_install.fish"
    mkdir -p "$(dirname "$OMF_INSTALL")"
    curl -o "$OMF_INSTALL" -C - https://raw.githubusercontent.com/oh-my-fish/oh-my-fish/master/bin/install
    fish -P "$OMF_INSTALL" --noninteractive
fi

if [ ! -f "$XDG_CONFIG_HOME/fish/functions/fisher.fish" ]; then
    echo "Installing Fisher"
    FISHER_INSTALL="$XDG_CACHE_HOME/devenv/fisher_install.fish"
    curl -o "$FISHER_INSTALL" -C - -L https://git.io/fisher
    fish -c "source \"$FISHER_INSTALL\" && fisher install jorgebucaran/fisher"
fi

echo "Updating Fisher plugins"
fish -c "fisher update"
