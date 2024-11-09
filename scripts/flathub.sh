#!/bin/bash
set -e

echo "Enabling Flathub repository..."
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

echo "Installing Flatpak packages..."
while read -r package; do
    flatpak install -y flathub "$package"
done < packages/flatpak-packages.txt

echo "Flatpak packages installed successfully."
