#!/bin/bash

dir="$HOME/projects/market-khan-backend"

tmux new-session -c "$dir" -n code -s market-khan-backend -d
tmux send-keys 'nvim .' C-m

tmux new-window -c "$dir" -n run
tmux send-keys 'air' C-m

tmux new-window -c "$dir" -n git
tmux send-keys 'lazygit' C-m

tmux new-window -c "$dir" -n sql
tmux send-keys 'lazysql' C-m

tmux select-window -t code
tmux -2 attach-session
