#!/bin/bash

set -e

if [ -f "/etc/arch-release" ]; then
    arch/install.sh
fi
