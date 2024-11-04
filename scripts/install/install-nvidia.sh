#!/bin/bash
set -e

echo "Adding NVIDIA repository..."
sudo zypper addrepo --refresh https://download.nvidia.com/opensuse/leap/15.3 NVIDIA

echo "Installing NVIDIA drivers..."
while read -r package; do
    sudo zypper install -y "$package"
done < packages/nvidia-packages.txt

echo "NVIDIA drivers installed successfully."
