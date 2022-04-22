#!/bin/bash

set -e

DIR=$(dirname "$0")

echo "Updating package repos"
sudo apt update

echo "Installing packages"
xargs -a "$DIR/pkglist.txt" sudo apt install -y
