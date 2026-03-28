#!/usr/bin/env bash

# Rename the initial window and set up split panes
tmux rename-window "term"
tmux split-window -v "npm run dev"
tmux select-pane -U

# Create "claude" window and launch claude
tmux new-window -n "claude"
tmux send-keys "claude" Enter

# Create "version-control" window and launch lazygit
tmux new-window -n "version-control"
tmux send-keys "lazygit" Enter

# Focus the "term" window and clear the startup command output
tmux select-window -t "term"
tmux send-keys "clear" Enter
