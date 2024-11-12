#!/bin/bash

dir="$HOME/projects/Goldika-Client"

tmux new-session -c "$dir" -n code -s goldika -d
tmux send-keys 'nvim .' C-m

tmux new-window -c "$dir" -n run
tmux send-keys 'mullvad-exclude yarn start' C-m

tmux new-window -c "$dir" -n git
tmux send-keys 'lazygit' C-m

tmux select-window -t code
tmux -2 attach-session
