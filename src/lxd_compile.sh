#!/bin/bash

branch=${1-main}

apt -y install curl wget

curl https://raw.githubusercontent.com/Skynet-IDC/skynetcp/$branch/src/autocompile.sh > /tmp/autocompile.sh
chmod +x /tmp/autocompile.sh

mkdir -p /opt/skynetcp

# Building skynet
if bash /tmp/autocompile.sh --skynet --noinstall --keepbuild $branch; then
	cp /tmp/skynetcp-src/deb/*.deb /opt/skynetcp/
fi

# Building PHP
if bash /tmp/autocompile.sh --php --noinstall --keepbuild $branch; then
	cp /tmp/skynetcp-src/deb/*.deb /opt/skynetcp/
fi

# Building NGINX
if bash /tmp/autocompile.sh --nginx --noinstall --keepbuild $branch; then
	cp /tmp/skynetcp-src/deb/*.deb /opt/skynetcp/
fi
