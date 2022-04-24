#!/bin/bash

set -euxo pipefail

if [ -z "${DEVENV_OS:-}" ]; then
    DEVENV_OS=$(grep '^ID=' /etc/os-release | cut -d = -f 2)
fi
if [ -z "$DEVENV_OS" ]; then
    echo "Couldn't detect OS"
    exit 1
fi
echo "Detected OS: $DEVENV_OS"

# Environment-specific defaults
if [ -z "${DEVENV_ENV:-}" ]; then
    if [ -n "${GITPOD_WORKSPACE_ID:-}" ]; then # GitPod
        DEVENV_ENV=gitpod
    elif uname -a | grep -q microsoft; then # WSL
        DEVENV_ENV=wsl
    else
        DEVENV_ENV=default
    fi
fi
echo "Detected env: $DEVENV_ENV"
case "$DEVENV_ENV" in
gitpod)
    DEVENV_ENABLE_FONTS=${DEVENV_ENABLE_FONTS:-0}
    DEVENV_ENABLE_NODEJS=${DEVENV_ENABLE_NODEJS:-0}
    DEVENV_ENABLE_NVIM=${DEVENV_ENABLE_NVIM:-0}
    ;;
wsl)
    DEVENV_ENABLE_FONTS=${DEVENV_ENABLE_FONTS:-0}
    ;;
esac

# Fallback defaults
DEVENV_ENABLE_FONTS=${DEVENV_ENABLE_FONTS:-1}
DEVENV_ENABLE_NODEJS=${DEVENV_ENABLE_NODEJS:-1}
DEVENV_ENABLE_NVIM=${DEVENV_ENABLE_NVIM:-1}

COMMON_SYSTEM_PACKAGES=(
    ack
    bat
    curl
    fish
    fzf
    grc
    stow
    thefuck
)

ARCH_PACKAGES=(
    lsd
)

UBUNTU_PPAS=(
    ppa:fish-shell/release-3
)

UBUNTU_APT_PACKAGES=()

declare -A UBUNTU_DEBS=(
    [lsd]="https://github.com/Peltoche/lsd/releases/download/0.21.0/lsd_0.21.0_amd64.deb"
)

STOW_PACKAGES=(
    fish
    git
    x
)

if [ "$DEVENV_ENABLE_FONTS" = 1 ]; then
    ARCH_PACKAGES+=(
        noto-fonts
        ttf-twemoji
        ttf-twemoji-color
    )
    UBUNTU_PPAS+=(
        ppa:eosrei/fonts
    )
    UBUNTU_APT_PACKAGES+=(
        fonts-noto
        fonts-twemoji-svginot
    )
    STOW_PACKAGES+=(fonts)
fi

if [ "$DEVENV_ENABLE_NODEJS" = 1 ]; then
    COMMON_SYSTEM_PACKAGES+=(nodejs)
fi

if [ "$DEVENV_ENABLE_NVIM" = 1 ]; then
    COMMON_SYSTEM_PACKAGES+=(neovim)
    STOW_PACKAGES+=(nvim)
fi

DEVENV_CACHE_DIR="${DEVENV_CACHE_DIR:-${XDG_CACHE_HOME:-"$HOME/.cache"}/devenv}"
mkdir -p "$DEVENV_CACHE_DIR"

DIR=$(dirname "$0")

echo "Installing system packages"
case $DEVENV_OS in
arch)
    sudo pacman -Sy --needed base-devel git

    if ! pacman -Qi paru >/dev/null; then
        echo "Installing paru from AUR"
        PARU_REPO_DIR="${XDG_CACHE_HOME:-"$HOME/.cache"}/paru/clone/paru-bin"
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
    RELEASE=$(lsb_release -rs)

    for PPA in "${UBUNTU_PPAS[@]}"; do
        sudo add-apt-repository -y $PPA
    done

    sudo apt-get update

    if [ "$DEVENV_ENABLE_NODEJS" = 1 ]; then
        NODEJS_VERSION=$(apt-cache show --no-all-versions nodejs | grep '^Version:' | cut -d " " -f 2)
        if dpkg --compare-versions $NODEJS_VERSION lt 17; then
            curl -fsSL https://deb.nodesource.com/setup_current.x | sudo -E bash -
        fi
    fi

    sudo apt-get install -y build-essential

    if dpkg --compare-versions $RELEASE lt 20.10; then
        # Workaround for https://askubuntu.com/a/1300824
        sudo apt-get install -y -o Dpkg::Options::="--force-overwrite" bat
    fi

    sudo apt-get install -y "${COMMON_SYSTEM_PACKAGES[@]}" "${UBUNTU_APT_PACKAGES[@]}"

    # Ubuntu 20.04 has curl v7.68 which doesn't support --output-dir :(
    pushd "$DEVENV_CACHE_DIR"
    for PKG in "${!UBUNTU_DEBS[@]}"; do
        if ! dpkg -s $PKG >/dev/null 2>/dev/null; then
            DEB_URL="${UBUNTU_DEBS[$PKG]}"
            DEB=$(curl -f -L -O -w "%{filename_effective}" "$DEB_URL")
            sudo dpkg -i "$DEB"
        fi
    done
    popd
    ;;
esac

# Don't use $SHELL because it is only updated at next login
REAL_USER=$(id -un)
DEFAULT_SHELL=$(getent passwd $REAL_USER | cut -d : -f 7-)
if [ "$DEFAULT_SHELL" != "/usr/bin/fish" ]; then
    echo "Setting login shell"
    sudo chsh -s /usr/bin/fish $REAL_USER
fi

for PKG in "${STOW_PACKAGES[@]}"; do
    echo "Linking dotfiles for $PKG"
    stow --no-folding -t "$HOME" -d "$DIR/stow" -R "$PKG"
done

if ! fish -c "type -q omf"; then
    echo "Installing oh-my-fish"
    OMF_INSTALL="$DEVENV_CACHE_DIR/omf_install.fish"
    mkdir -p "$(dirname "$OMF_INSTALL")"
    curl -fo "$OMF_INSTALL" https://raw.githubusercontent.com/oh-my-fish/oh-my-fish/master/bin/install
    fish -P "$OMF_INSTALL" --noninteractive
fi

if ! fish -c "type -q fisher"; then
    echo "Installing Fisher"
    FISHER_INSTALL="$DEVENV_CACHE_DIR/fisher_install.fish"
    if [ ! -f "$FISHER_INSTALL" ]; then
        curl -fo "$FISHER_INSTALL" -L https://git.io/fisher
    fi
    fish -c "source \"$FISHER_INSTALL\" && fisher install jorgebucaran/fisher"
fi
fish -c "fisher update"

if [ "$DEVENV_ENABLE_NVIM" = 1 ]; then
    NVIM_AUTOLOAD_DIR="${XDG_DATA_HOME:-"$HOME/.local/share"}/nvim/site/autoload"
    if [ ! -f "$NVIM_AUTOLOAD_DIR/plug.vim" ]; then
        echo "Installing vim-plug"
        mkdir -p "$NVIM_AUTOLOAD_DIR"
        curl -fo "$NVIM_AUTOLOAD_DIR/plug.vim" https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    fi

    echo "Installing Vim plugins"
    nvim --headless +PlugUpgrade +PlugUpdate +qall
fi
