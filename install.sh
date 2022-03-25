#!/bin/bash

set -e

if [ -z "$XDG_CACHE_HOME" ]; then
    export XDG_CACHE_HOME="$HOME/.cache"
fi
if [ -z "$XDG_DATA_HOME" ]; then
    export XDG_DATA_HOME="$HOME/.local/share"
fi

if [ -f "/etc/arch-release" ]; then
    arch/install.sh
fi
