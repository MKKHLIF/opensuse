#!/bin/bash
set -e

print_message() {
    echo -e "\033[1;32m$1\033[0m"
}

# Check if the script is run as root
if [[ $(id -u) -ne 0 ]]; then
    echo "This script must be run as root."
    exit 1
fi

# Update system repositories and packages
print_message "Updating system repositories and packages..."
zypper refresh && zypper update -y

# Add NVIDIA repository if not already added
if ! zypper repos | grep -q 'NVIDIA'; then
    print_message "Adding NVIDIA repository..."
    zypper addrepo --refresh https://download.nvidia.com/opensuse/tumbleweed NVIDIA
else
    print_message "NVIDIA repository already exists. Skipping addition."
fi

# Refresh repositories
print_message "Refreshing repositories..."
zypper refresh

# Install NVIDIA driver and recommended packages automatically
print_message "Installing NVIDIA driver and dependencies..."
zypper install-new-recommends --repo NVIDIA

# If using Optimus (hybrid graphics), install bumblebee
print_message "Installing Optimus tools (bumblebee or nvidia-prime)..."
zypper install -y bumblebee

# Enable Bumblebee services if using Bumblebee
print_message "Enabling Bumblebee services..."
systemctl enable bumblebeed
systemctl start bumblebeed

print_message "Disabling Nouveau driver..."
# Check if the file already contains the necessary lines
if ! grep -q 'blacklist nouveau' /etc/modprobe.d/disable-nouveau.conf; then
    # If not, write the lines to disable Nouveau
    cat <<EOF > /etc/modprobe.d/disable-nouveau.conf
blacklist nouveau
options nouveau modeset=0
EOF
    print_message "Nouveau driver has been disabled."
else
    print_message "Nouveau driver is already disabled."
fi


# Regenerate initramfs to apply changes
print_message "Regenerating initramfs..."
dracut --force

# Final message
print_message "NVIDIA installation complete!"
