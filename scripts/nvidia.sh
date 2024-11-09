#!/bin/bash
set -e

print_message() {
    echo -e "\033[1;32m$1\033[0m"
}

if [[ $(id -u) -ne 0 ]]; then
    echo "This script must be run as root."
    exit 1
fi

print_message "Updating system repositories and packages..."
zypper refresh && zypper update -y

print_message "Adding NVIDIA repository..."
zypper addrepo --refresh https://download.nvidia.com/opensuse/tumbleweed NVIDIA

print_message "Refreshing repositories..."
zypper refresh

print_message "Installing NVIDIA proprietary driver..."
zypper install -y nvidia-glG05 nvidia-utils nvidia-devel

# Install the NVIDIA kernel module (this is the module for the current running kernel)
print_message "Installing NVIDIA kernel module..."
zypper install -y kernel-default-devel

# Install the NVIDIA driver specific to your kernel version
print_message "Installing kernel driver package..."
zypper install -y nvidia-driver

# Install optimus-manager or prime for hybrid graphics management (only for laptops with hybrid GPUs)
print_message "Installing NVIDIA Optimus tools (bumblebee or nvidia-prime)..."
zypper install -y bumblebee nvidia-prime

# Ensure Bumblebee services are running (if using Bumblebee)
print_message "Enabling Bumblebee services..."
systemctl enable bumblebeed
systemctl start bumblebeed

print_message "Disabling Nouveau driver (if necessary)..."
cat <<EOF > /etc/modprobe.d/disable-nouveau.conf
blacklist nouveau
options nouveau modeset=0
EOF

# Regenerate initramfs to ensure the changes take effect
print_message "Regenerating initramfs..."
mkinitrd

print_message "Nvidia Installation complete!"
