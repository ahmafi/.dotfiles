#!/bin/bash

dir="$HOME/esp/kaarone/goapi"

if [[ -v TMUX ]]; then
    echo "Already attached to a session"
    exit 1
fi

tmux new-session -c "$dir" -n code -s kaarone_goapi -d
tmux send-keys 'nvim .' C-m

tmux new-window -c "$dir" -n run

tmux new-window -c "$dir" -n git
tmux send-keys 'me lazygit' C-m

tmux select-window -t code
tmux -2 attach-session
