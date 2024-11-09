#!/bin/bash

# Define variables
DOTFILES_REPO="https://github.com/MKKHLIF/.dotfiles.git" 
DOTFILES_DIR="$HOME/.dotfiles"
STOW_DIR="$DOTFILES_DIR"       

# Clone the dotfiles repository if it doesn't exist
if [ ! -d "$DOTFILES_DIR" ]; then
  echo "Cloning dotfiles repository..."
  git clone "$DOTFILES_REPO" "$DOTFILES_DIR"
else
  echo "Dotfiles repository already exists at $DOTFILES_DIR"
fi

cd "$DOTFILES_DIR" || exit 1

# Stow each subdirectory in the dotfiles repo (e.g., 'bash', 'vim', 'tmux', etc.)
for dir in */; do
  if [ -d "$dir" ]; then
    echo "Creating symlinks for $dir..."
    stow -v -d "$STOW_DIR" -t "$HOME" "$dir"
  fi
done

echo "Dotfiles setup complete."
