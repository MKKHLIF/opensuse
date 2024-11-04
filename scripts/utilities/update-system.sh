#!/bin/bash
set -e

echo "Updating system packages..."
sudo zypper refresh
sudo zypper update

echo "System update complete."
