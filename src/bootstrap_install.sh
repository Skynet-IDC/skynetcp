#!/bin/bash

# Clean installation bootstrap for development purposes only
# Usage:    ./bootstrap_install.sh [fork] [branch] [os]
# Example:  ./bootstrap_install.sh skynetcp main ubuntu

# Define variables
fork=$1
branch=$2
os=$3

# Download specified installer and compiler
wget https://raw.githubusercontent.com/$fork/skynetcp/$branch/install/hst-install-$os.sh
wget https://raw.githubusercontent.com/$fork/skynetcp/$branch/src/autocompile.sh

# Execute compiler and build skynet core package
chmod +x autocompile.sh
./autocompile.sh --skynet $branch no

# Execute Skynet Control Panel installer with default dummy options for testing
if [ -f "/etc/redhat-release" ]; then
	bash hst-install-$os.sh -f -y no -e admin@test.local -p P@ssw0rd -s skynet-$branch-$os.test.local --with-rpms /tmp/skynetcp-src/rpms
else
	bash hst-install-$os.sh -f -y no -e admin@test.local -p P@ssw0rd -s skynet-$branch-$os.test.local --with-debs /tmp/skynetcp-src/debs
fi
