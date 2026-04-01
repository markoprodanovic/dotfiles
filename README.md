# Dotfiles

<table>
  <tr>
    <td><img src="assets/multi-pane-setup.png" alt="Multi-pane setup" /></td>
    <td><img src="assets/sesh-manager.png" alt="Sesh manager" /></td>
  </tr>
</table>

Personal config files for:

- Ghostty terminal
- tmux
- Starship prompt
- Sesh session manager
- Neovim | [LazyVim](https://www.lazyvim.org/)

## Installation

Clone the repo and run the install script:
```bash
./install.sh
```

You'll be prompted to identify if this is a work or personal machine. This determines which sesh sessions are available (stored in `machine_type`).

## Machine-Specific Sessions

Sesh sessions are configured per machine type:
- `sesh-work.toml` - Work laptop sessions (magento-main, magento-cloud, etc.)
- `sesh-personal.toml` - Personal laptop sessions (vek-moderne-arhitekture, etc.)

To change machine type, edit `machine_type` and run `./install.sh` again.
