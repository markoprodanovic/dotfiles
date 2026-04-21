#!/usr/bin/env bash

# ── Window 1: term ──────────────────────────────────────────────
tmux rename-window "term"
tmux split-window -h -l 30% "kiro-cli chat"
tmux select-pane -L
tmux split-window -v -l 30%
tmux select-pane -U
tmux send-keys "nvim ." Enter

# ── Window 2: warden ───────────────────────────────────────────
tmux new-window -n "warden" "bash ~/.config/sesh/scripts/magento-main-warden.sh"

# ── Focus back on term window ──────────────────────────────────
tmux select-window -t 1
