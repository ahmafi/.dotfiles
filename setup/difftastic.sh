#!/bin/bash

if command -v difft >/dev/null 2>&1; then
	echo "✅ Difftastic Already installed"
	exit
fi

echo "🛠️ Installing Cargo"
sudo apt install -y cargo-1.85

echo "🛠️ Installing Difftastic"
cargo install --locked difftastic
