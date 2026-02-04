#!/bin/bash

dir="$HOME/projects/shoplee/webapp"

if [[ -v TMUX ]]; then
    echo "Already attached to a session"
    exit 1
fi
session=sh_webapp

tmux new-session -c "$dir" -n code -s "$session"  -d
tmux set -t "$session" status-style bg='#23272f'
tmux send-keys 'nvim .' C-m

tmux new-window -c "$dir" -n run
tmux send-keys 'me bun dev' C-m

tmux new-window -c "$dir" -n git
tmux send-keys 'me lazygit' C-m

tmux select-window -t code
tmux -2 attach-session
