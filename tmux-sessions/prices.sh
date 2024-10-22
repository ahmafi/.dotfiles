#!/bin/bash

dir="$HOME/projects/prices"

tmux new-session -c "$dir" -n code -s prices -d
tmux send-keys 'nvim .' C-m

tmux new-window -c "$dir" -n run
# tmux send-keys 'docker container start price-jobs-redis' C-m
tmux send-keys 'docker container start budget-postgres' C-m
tmux send-keys 'bun run dev' C-m

tmux new-window -c "$dir" -n git
tmux send-keys 'lazygit' C-m

tmux select-window -t code
tmux -2 attach-session
