#!/bin/bash

wget https://github.com/hivemq/mqtt-cli/releases/download/v4.47.0/mqtt-cli-4.47.0.deb
sudo apt install -y ./mqtt-cli-4.47.0.deb
rm mqtt-cli-4.47.0.deb
