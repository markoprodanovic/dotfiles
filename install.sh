#!/bin/bash

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

# Symlink $1 -> $2, preserving anything real that is already there.
# Re-running against an existing correct symlink is a no-op.
link_config() {
    local src="$1" dest="$2"
    if [ -L "$dest" ]; then
        ln -sfn "$src" "$dest"
    elif [ -e "$dest" ]; then
        local backup="${dest}.backup.$(date +%Y%m%d%H%M%S)"
        echo "Existing file at $dest — backing up to $backup"
        mv "$dest" "$backup"
        ln -s "$src" "$dest"
    else
        ln -s "$src" "$dest"
    fi
}

# Create necessary directories
mkdir -p ~/Library/Application\ Support/com.mitchellh.ghostty
mkdir -p ~/.config
mkdir -p ~/.config/sesh
mkdir -p ~/.config/herdr
mkdir -p ~/.config/herdr-sesh
mkdir -p ~/.config/hunk
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

# Install herdr if not already installed
if ! command -v herdr &>/dev/null; then
    echo "Installing herdr..."
    brew install herdr
else
    echo "herdr already installed"
fi

# fzf/jq/git-lfs are needed by the herdr sesh plugin
for dep in fzf jq git-lfs; do
    if ! command -v "$dep" &>/dev/null; then
        echo "Installing $dep..."
        brew install "$dep"
    else
        echo "$dep already installed"
    fi
done

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
if [ -e ~/.config/nvim ] && [ "$(readlink ~/.config/nvim)" != "$DOTFILES_DIR/nvim" ]; then
    echo "Existing Neovim config detected at ~/.config/nvim"
    read -r -p "Replace it with dotfiles config? (y/n) " REPLACE_NVIM
    if [ "$REPLACE_NVIM" = "y" ]; then
        rm -rf ~/.config/nvim
        ln -sf "$DOTFILES_DIR/nvim" ~/.config/nvim
    else
        echo "Skipping Neovim config"
    fi
elif [ ! -e ~/.config/nvim ]; then
    ln -sf "$DOTFILES_DIR/nvim" ~/.config/nvim
else
    echo "Neovim config already linked"
fi
rm -rf ~/.config/sesh/scripts
ln -sf "$DOTFILES_DIR/sesh/scripts" ~/.config/sesh/scripts

# herdr — link only config.toml; the rest of ~/.config/herdr is runtime
# state (sockets, logs, session.json) that must stay machine-local.
link_config "$DOTFILES_DIR/herdr/config.toml" ~/.config/herdr/config.toml

# herdr-sesh plugin config (preview style, picker options)
link_config "$DOTFILES_DIR/herdr-sesh/config.toml" ~/.config/herdr-sesh/config.toml

# hunk
link_config "$DOTFILES_DIR/hunk/config.toml" ~/.config/hunk/config.toml

# Sesh plugin (third-party, installed from GitHub). Only installs when absent,
# so an existing/pinned version is never replaced.
if command -v herdr &>/dev/null; then
    if herdr plugin list 2>/dev/null | grep -q 'fullerzz.sesh'; then
        echo "sesh plugin already installed"
    else
        echo "Installing sesh plugin..."
        herdr plugin install fullerzz/herdr-plugin-sesh --yes || \
            echo "sesh plugin install failed - run it manually to see why"
    fi
fi

# Pick up the config if a herdr server is already running
if command -v herdr &>/dev/null; then
    herdr server reload-config &>/dev/null || true
fi

# Lazygit config
mkdir -p "$HOME/Library/Application Support/lazygit"
ln -sf "$DOTFILES_DIR/lazygit/config.yml" "$HOME/Library/Application Support/lazygit/config.yml"

# Install tmux plugins
echo "Installing tmux plugins..."
~/.tmux/plugins/tpm/bin/install_plugins
