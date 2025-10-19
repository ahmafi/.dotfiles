#! /bin/bash

# https://luarocks.org/

wget https://luarocks.org/releases/luarocks-3.12.2.tar.gz
tar zxpf luarocks-3.12.2.tar.gz
cd luarocks-3.12.2 || exit
./configure && make && sudo make install
cd .. || exit
rm -r luarocks-3.12.2 luarocks-3.12.2.tar.gz
