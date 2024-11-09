#!/bin/bash
set -e

echo "Installing packages..."
while read -r package; do
    sudo zypper install -y "$package"
done < packages/packages.txt

while read -r package; do
    sudo zypper install -y "$package"
done < packages/dev.txt

echo "Packages installed successfully."
