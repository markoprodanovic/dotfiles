#!/bin/bash

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

# Create necessary directories
mkdir -p ~/Library/Application\ Support/com.mitchellh.ghostty
mkdir -p ~/.config
mkdir -p ~/.config/sesh
mkdir -p ~/.tmux/plugins

# Install starship if not already installed
if ! command -v starship &>/dev/null; then
    echo "Installing starship..."
    brew install starship
else
    echo "starship already installed"
fi

# Install sesh if not already installed
if ! command -v sesh &>/dev/null; then
    echo "Installing sesh..."
    brew install sesh
else
    echo "sesh already installed"
fi

# Install TPM if it's not already installed
TPM_PATH=~/.tmux/plugins/tpm
if [ ! -d "$TPM_PATH" ]; then
    echo "Installing TPM..."
    git clone https://github.com/tmux-plugins/tpm "$TPM_PATH"
else
    echo "TPM already installed"
fi

# Determine machine type for sesh config
if [ ! -f "$DOTFILES_DIR/machine_type" ]; then
    echo "Is this a work or personal machine? (work/personal)"
    read -r MACHINE_TYPE
    echo "$MACHINE_TYPE" > "$DOTFILES_DIR/machine_type"
else
    MACHINE_TYPE=$(cat "$DOTFILES_DIR/machine_type")
fi

# Create symbolic links
ln -sf "$DOTFILES_DIR/ghostty/config" ~/Library/Application\ Support/com.mitchellh.ghostty/config
ln -sf "$DOTFILES_DIR/tmux/tmux.conf" ~/.tmux.conf
ln -sf "$DOTFILES_DIR/starship/starship.toml" ~/.config/starship.toml
ln -sf "$DOTFILES_DIR/sesh/sesh-${MACHINE_TYPE}.toml" ~/.config/sesh/sesh.toml
rm -rf ~/.config/nvim
ln -sf "$DOTFILES_DIR/nvim" ~/.config/nvim
rm -rf ~/.config/sesh/scripts
ln -sf "$DOTFILES_DIR/sesh/scripts" ~/.config/sesh/scripts

# Install tmux plugins
echo "Installing tmux plugins..."
~/.tmux/plugins/tpm/bin/install_plugins
