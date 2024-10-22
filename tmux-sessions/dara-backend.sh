#!/bin/bash

dir="$HOME/projects/dara-backend"

tmux new-session -c "$dir" -n code -s dara-backend -d
tmux send-keys 'nvim .' C-m

tmux new-window -c "$dir" -n run

tmux new-window -c "$dir" -n git
tmux send-keys 'lazygit' C-m

tmux select-window -t code
tmux -2 attach-session
