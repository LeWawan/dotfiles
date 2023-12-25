#!/usr/bin/env bash

# Lua + luarocks
cd
FILECHASUM="7d5ea1b9cb6aa0b59ca3dde1c6adcb57ef83a1ba8e5432c0ecd06bf439b3ad88"
curl -R -O https://www.lua.org/ftp/lua-5.4.6.tar.gz

# Verify checksum
if ! echo "$FILECHASUM lua-5.4.6.tar.gz" | shasum -a 256; then
	echo "Error: Checksum failed for lua-5.4.6.tar.gz"
	exit 1
fi

tar -zxf lua-5.4.6.tar.gz
cd lua-5.4.6

if [[ $(uname) == "Linux" ]]; then
	make linux test
elif [[ $(uname) == "Darwin" ]]; then
	make macosx test
else
	echo "Error: Unsupported device. Uname not recognized."
	exit 1
fi

sudo make install
sudo luarocks install http CRYPTO_DIR=/opt/homebrew/opt/openssl@3 OPENSSL_DIR=/opt/homebrew/opt/openssl@3

cd
wget https://luarocks.org/releases/luarocks-3.9.2.tar.gz
tar zxpf luarocks-3.9.2.tar.gz
cd luarocks-3.9.2
./configure --with-lua-include=/usr/local/include && sudo make && sudo make install
sudo luarocks install luasocket
sudo luarocks install lapis
