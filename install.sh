#!/bin/bash

# Create necessary directories
mkdir -p ~/Library/Application\ Support/com.mitchellh.ghostty
mkdir -p ~/.config
mkdir -p ~/.tmux/plugins

# Install TPM if it's not already installed
TPM_PATH=~/.tmux/plugins/tpm
if [ ! -d "$TPM_PATH" ]; then
    echo "Installing TPM..."
    git clone https://github.com/tmux-plugins/tpm "$TPM_PATH"
else
    echo "TPM already installed"
fi

# Create symbolic links
ln -sf ~/dotfiles/ghostty/config ~/Library/Application\ Support/com.mitchellh.ghostty/config
ln -sf ~/dotfiles/tmux/tmux.conf ~/.tmux.conf
ln -sf ~/dotfiles/starship/starship.toml ~/.config/starship.toml

# Install tmux plugins
echo "Installing tmux plugins..."
~/.tmux/plugins/tpm/bin/install_plugins
