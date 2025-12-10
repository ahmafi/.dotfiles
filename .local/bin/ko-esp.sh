#!/bin/bash

dir="$HOME/esp/kaarone/esp"
esp_examples_dir="$HOME/esp/examples/"

if [[ -v TMUX ]]; then
    echo "Already attached to a session"
    exit 1
fi

tmux new-session -c "$dir" -n code -s kaarone_esp -d
tmux send-keys 'get_idf && nvim .' C-m

tmux new-window -c "$dir" -n run
tmux send-keys 'get_idf' C-m

tmux new-window -c "$dir" -n git
tmux send-keys 'me lazygit' C-m

tmux new-window -c "$esp_examples_dir" -n examples
tmux send-keys 'get_idf' C-m

tmux select-window -t code
tmux -2 attach-session
