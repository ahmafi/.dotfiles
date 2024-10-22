#!/bin/bash

dir="$HOME/projects/Goldika"

tmux new-session -c "$dir" -n server -s goldika_fullstack -d
tmux send-keys 'cd goldika-server' C-m
tmux send-keys 'nvim .' C-m

tmux new-window -c "$dir/goldika-client" -n client
tmux send-keys 'nvim .' C-m

tmux new-window -c "$dir/goldika-client" -n run
tmux send-keys 'mullvad-exclude bun run start' C-m
tmux split-window -v -c "$dir/goldika-server"
tmux send-keys 'docker compose up -d' C-m
tmux send-keys 'mullvad-exclude bun run start' C-m

tmux new-window -c "$dir/goldika-client" -n shell
tmux split-window -v -c "$dir/goldika-server"

tmux new-window -c "$dir" -n git
tmux send-keys 'lazygit' C-m

tmux select-window -t code
tmux -2 attach-session
