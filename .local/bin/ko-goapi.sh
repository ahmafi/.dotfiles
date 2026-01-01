#!/bin/bash

dir="$HOME/esp/kaarone/goapi"

if [[ -v TMUX ]]; then
    echo "Already attached to a session"
    exit 1
fi

session=kaarone_goapi

tmux new-session -c "$dir" -n code -s "$session"  -d
tmux set -t "$session" status-style bg='#3363b0'
tmux send-keys 'nvim .' C-m

tmux new-window -c "$dir" -n run
tmux send-keys 'air start' C-m

tmux new-window -c "$dir" -n git
tmux send-keys 'me lazygit' C-m

tmux select-window -t code
tmux -2 attach-session
