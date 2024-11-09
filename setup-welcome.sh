#!/bin/bash
set -e

echo -e "\e[1;32m"
echo "  ____                   _____ _    _ _____ _____ "
echo " / __ \                 / ____| |  | / ____|  ___|"
echo "| |  | |_ __   ___ _ _| (___ | |  | | (___ | |__  "
echo "| |  | | '_ \ / _ \ '_ \\___ \| |  | |\___ \|  __| "
echo "| |__| | |_) |  __/ | | |___) | |__| |____) | |___ "
echo " \____/| .__/ \___|_| |_|____/ \____/|_____/|_____|"
echo "       | |"
echo "       |_|"
echo -e "\e[0m" 

echo -e "\e[1;31m"
read -p "Do you want to install NVIDIA drivers? (y/n): " install_nvidia

read -p "Enter your Git name: " git_name
read -p "Enter your Git email: " git_email

echo -e "\e[0m"

if [[ "$install_nvidia" == "y" ]]; then
    ./scripts/install/install-nvidia.sh
fi

./scripts/install/install-packages.sh
./scripts/install/install-flathub.sh
./scripts/install/install-obs.sh
./scripts/setup/setup-git.sh "$git_name" "$git_email"
./scripts/setup/setup-dotfiles.sh
./scripts/setup/cleanup.sh

echo -e "\e[1;32mSetup complete!\e[0m"
