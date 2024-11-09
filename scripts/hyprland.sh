#!/bin/bash
set -e

echo "Installing Hyprland packages..."

while read -r package; do
    sudo zypper install -y "$package"
done < packages/de/hyprland.txt

echo "Hyprland packages installed successfully."
