#!/bin/bash
set -e

# Welcome message
echo -e "\e[1;32m" # Set text color to dark green
echo "  ____                   _____ _    _ _____ _____ "
echo " / __ \                 / ____| |  | / ____|  ___|"
echo "| |  | |_ __   ___ _ _| (___ | |  | | (___ | |__  "
echo "| |  | | '_ \ / _ \ '_ \\___ \| |  | |\___ \|  __| "
echo "| |__| | |_) |  __/ | | |___) | |__| |____) | |___ "
echo " \____/| .__/ \___|_| |_|____/ \____/|_____/|_____|"
echo "       | |"
echo "       |_|"
echo -e "\e[0m" # Reset text color

# Ask for NVIDIA installation
read -p "Do you want to install NVIDIA drivers? (y/n): " install_nvidia

# Ask for Git identity
read -p "Enter your Git name: " git_name
read -p "Enter your Git email: " git_email

# Run scripts based on user input
if [[ "$install_nvidia" == "y" ]]; then
    ./scripts/install/install-nvidia.sh
fi

./scripts/install/install-packages.sh
./scripts/install/install-flathub.sh
./scripts/install/install-obs.sh
./scripts/setup/setup-git.sh "$git_name" "$git_email"
./scripts/setup/setup-dotfiles.sh
./scripts/setup/cleanup.sh

# Completion message in green
echo -e "\e[1;32mSetup complete!\e[0m"
