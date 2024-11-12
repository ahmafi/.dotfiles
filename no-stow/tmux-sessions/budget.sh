#!/bin/bash

dir="$HOME/projects/budget"

tmux new-session -c "$dir" -n code -s budget -d
tmux send-keys 'nvim .' C-m

tmux new-window -c "$dir" -n run
tmux send-keys 'docker container start budget-postgres' C-m
tmux send-keys 'pnpm run dev' C-m

tmux new-window -c "$dir" -n git
tmux send-keys 'lazygit' C-m

tmux select-window -t code
tmux -2 attach-session
