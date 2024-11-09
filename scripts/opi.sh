#!/bin/bash
set -e

if [[ $(id -u) -ne 0 ]]; then
    echo "This script must be run as root."
    exit 1
fi

echo "Installing opi..."
sudo zypper install -y opi
echo "opi was installed successfully."
