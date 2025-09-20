#!/bin/bash

branch=${1-main}

apt -y install curl wget

curl https://raw.githubusercontent.com/skynetcp/skynetcp/$branch/src/hst_autocompile.sh > /tmp/hst_autocompile.sh
chmod +x /tmp/hst_autocompile.sh

mkdir -p /opt/skynetcp

# Building skynet
if bash /tmp/hst_autocompile.sh --skynet --noinstall --keepbuild $branch; then
	cp /tmp/skynetcp-src/deb/*.deb /opt/skynetcp/
fi

# Building PHP
if bash /tmp/hst_autocompile.sh --php --noinstall --keepbuild $branch; then
	cp /tmp/skynetcp-src/deb/*.deb /opt/skynetcp/
fi

# Building NGINX
if bash /tmp/hst_autocompile.sh --nginx --noinstall --keepbuild $branch; then
	cp /tmp/skynetcp-src/deb/*.deb /opt/skynetcp/
fi
