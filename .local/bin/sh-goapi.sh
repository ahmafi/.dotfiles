#!/bin/bash

dir="$HOME/projects/shoplee/goapi"

if [[ -v TMUX ]]; then
    echo "Already attached to a session"
    exit 1
fi

session=sh_goapi

tmux new-session -c "$dir" -n code -s "$session"  -d
tmux set -t "$session" status-style bg='#79d4fd'
tmux send-keys 'nvim .' C-m

tmux new-window -c "$dir" -n run
tmux send-keys 'air' C-m

tmux new-window -c "$dir" -n git
tmux send-keys 'me lazygit' C-m

tmux select-window -t code
tmux -2 attach-session

tmux new-window -c "$dir" -n db
tmux send-keys 'nvim -c DBUI' C-m
