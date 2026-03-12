#!/usr/bin/env bash

tmux rename-window "term"
tmux split-window -v "bash ~/.config/sesh/scripts/magento-main-warden.sh"
tmux select-pane -U

tmux new-window -n "version-control"
tmux send-keys "lazygit" Enter

tmux select-window -t "term"
