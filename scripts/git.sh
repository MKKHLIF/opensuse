#!/bin/bash
set -e

if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <name> <email>"
    exit 1
fi

GIT_NAME="$1"
GIT_EMAIL="$2"

echo "Setting up Git identity..."
git config --global user.name "$GIT_NAME"
git config --global user.email "$GIT_EMAIL"

echo "Git identity set: Name='$GIT_NAME', Email='$GIT_EMAIL'"

# Generate SSH key
echo "Generating SSH key..."
ssh-keygen -t ed25519 -C "$GIT_EMAIL" -f "$HOME/.ssh/id_ed25519" -N ""

echo "SSH key generated. Add the following key to your Git provider:"
cat "$HOME/.ssh/id_ed25519.pub"

echo "Setup complete."
