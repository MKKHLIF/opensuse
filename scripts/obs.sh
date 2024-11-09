#!/bin/bash
set -e

echo "Adding OBS repository..."
sudo zypper addrepo --refresh https://download.opensuse.org/repositories/multimedia:/apps/openSUSE_Leap_15.3/ OBS

echo "Installing OBS Studio..."
sudo zypper install -y obs-studio

echo "OBS Studio installed successfully."
