#!/bin/bash

if command -v breaktimer >/dev/null 2>&1; then
	echo "✅ breaktimer Already installed"
	exit
fi

echo "🛠️ Installing breaktimer"
curl -LO https://github.com/tom-james-watson/breaktimer-app/releases/latest/download/BreakTimer.deb
sudo apt install -y ./BreakTimer.deb
rm BreakTimer.deb
