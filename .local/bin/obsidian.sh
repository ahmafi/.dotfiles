#!/bin/bash

dir="$HOME/obsidian/default"

if [[ -v TMUX ]]; then
    echo "Already attached to a session"
    exit 1
fi

tmux new-session -c "$dir" -n code -s obsidian -d
tmux send-keys 'nvim .' C-m

tmux new-window -c "$dir" -n git
tmux send-keys 'lazygit' C-m

tmux select-window -t code
tmux -2 attach-session
