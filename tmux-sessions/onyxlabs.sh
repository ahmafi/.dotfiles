#!/bin/bash

dir="$HOME/project/onyxlabs"

tmux new-session -c "$dir" -n code -s onyxlabs -d
tmux send-keys 'nvim .' C-m

tmux new-window -c "$dir" -n run
tmux send-keys 'pnpm run dev' C-m

tmux new-window -c "$dir" -n git
tmux send-keys 'lazygit' C-m

tmux select-window -t code
tmux -2 attach-session
