#!/bin/bash
set -e

echo "Installing base packages..."
while read -r package; do
    sudo zypper install -y "$package"
done < packages/base-packages.txt

echo "Base packages installed successfully."
