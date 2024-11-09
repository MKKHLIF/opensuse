#!/bin/bash

ROOT_DIR="$(dirname "$0")/../packages"

# Validate root directory
if [ ! -d "$ROOT_DIR" ]; then
    echo "Error: Directory '$ROOT_DIR' does not exist!"
    exit 1
fi

# Convert to absolute path
ROOT_DIR=$(realpath "$ROOT_DIR")
echo "Searching for package lists in: $ROOT_DIR"

# Create temporary files for different package types
OFFICIAL_PACKAGES=$(mktemp)
OPI_PACKAGES=$(mktemp)
FLATPAK_PACKAGES=$(mktemp)

check_official_repo() {
    zypper --non-interactive search -t package "$1" >/dev/null 2>&1
    return $?
}

check_flatpak() {
    flatpak remote-info flathub "$1" >/dev/null 2>&1
    return $?
}

# Process each .txt file recursively starting from ROOT_DIR
find "$ROOT_DIR" -type f -name "*.txt" -print0 | while IFS= read -r -d '' file; do
    echo "Processing file: $file"
    while IFS= read -r package; do
        # Skip empty lines
        [ -z "$package" ] && continue
        
        # Clean the package name
        package=$(echo "$package" | tr -d '[:space:]')
        
        # Check package availability and sort into appropriate files
        if check_official_repo "$package"; then
            echo "$package" >> "$OFFICIAL_PACKAGES"
            echo "Found in official repo: $package"
        elif zypper --non-interactive search -t package "$package-lang" >/dev/null 2>&1; then
            echo "$package" >> "$OFFICIAL_PACKAGES"
            echo "Found in official repo (language package): $package"
        elif check_flatpak "$package"; then
            echo "$package" >> "$FLATPAK_PACKAGES"
            echo "Found in Flatpak: $package"
        else
            echo "$package" >> "$OPI_PACKAGES"
            echo "Assuming OPI package: $package"
        fi
    done < "$file"
done

# Install packages in order of priority
echo -e "\nInstalling packages from official repositories..."
if [ -s "$OFFICIAL_PACKAGES" ]; then
    echo "Official packages to install:"
    cat "$OFFICIAL_PACKAGES"
    sudo zypper -y install $(cat "$OFFICIAL_PACKAGES")
fi

echo -e "\nInstalling packages from OPI..."
if [ -s "$OPI_PACKAGES" ]; then
    echo "OPI packages to install:"
    cat "$OPI_PACKAGES"
    while IFS= read -r package; do
        opi -n "$package"
    done < "$OPI_PACKAGES"
fi

echo -e "\nInstalling Flatpak packages..."
if [ -s "$FLATPAK_PACKAGES" ]; then
    echo "Flatpak packages to install:"
    cat "$FLATPAK_PACKAGES"
    flatpak install -y flathub $(cat "$FLATPAK_PACKAGES")
fi

# Cleanup temporary files
rm -f "$OFFICIAL_PACKAGES" "$OPI_PACKAGES" "$FLATPAK_PACKAGES"

echo -e "\nPackage installation complete!"
