#!/bin/bash
set -e

if [[ $(id -u) -ne 0 ]]; then
    echo "This script must be run as root."
    exit 1
fi


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

sudo ./scripts/opi.sh
sudo ./scripts/flathub.sh

echo "Updating system repositories and packages..."
zypper refresh && zypper update -y

sudo ./scripts/packages.sh
sudo ./scripts/git.sh "$git_name" "$git_email"
sudo ./scripts/dotfiles.sh

if [[ "$install_nvidia" == "y" ]]; then
    ./scripts/nvidia.sh
fi

echo -e "\e[1;32mSetup complete!\e[0m"

echo -e -n "\e[1;31mDo you want to reboot now? (y/N) \e[0m"
read answer
if [[ $answer =~ ^[Yy]$ ]]; then
    sudo reboot
fi
