#!/bin/bash

DOTFILES_REPO="git@github.com:MKKHLIF/.dotfiles.git"
DOTFILES_DIR="$HOME/.dotfiles"

handle_error() {
    echo "Error: $1" >&2
    exit 1
}

if [ ! -d "$DOTFILES_DIR" ]; then
    echo "Cloning dotfiles repository..."
    git clone "$DOTFILES_REPO" "$DOTFILES_DIR" || handle_error "Failed to clone repository"
else
    echo "Dotfiles repository already exists!"
fi

cd "$DOTFILES_DIR" || handle_error "Failed to change to dotfiles directory"

for dir in */; do
    if [ -d "$dir" ]; then
        echo "Creating symlinks for $dir..."
        stow "$dir" || handle_error "Failed to stow $dir"
    fi
done

echo "Dotfiles setup complete!"
