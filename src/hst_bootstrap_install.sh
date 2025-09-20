#!/bin/bash

# Clean installation bootstrap for development purposes only
# Usage:    ./hst_bootstrap_install.sh [fork] [branch] [os]
# Example:  ./hst_bootstrap_install.sh skynetcp main ubuntu

# Define variables
fork=$1
branch=$2
os=$3

# Download specified installer and compiler
wget https://raw.githubusercontent.com/$fork/skynetcp/$branch/install/hst-install-$os.sh
wget https://raw.githubusercontent.com/$fork/skynetcp/$branch/src/hst_autocompile.sh

# Execute compiler and build skynet core package
chmod +x hst_autocompile.sh
./hst_autocompile.sh --skynet $branch no

# Execute skynet Control Panel installer with default dummy options for testing
if [ -f "/etc/redhat-release" ]; then
	bash hst-install-$os.sh -f -y no -e admin@test.local -p P@ssw0rd -s skynet-$branch-$os.test.local --with-rpms /tmp/skynetcp-src/rpms
else
	bash hst-install-$os.sh -f -y no -e admin@test.local -p P@ssw0rd -s skynet-$branch-$os.test.local --with-debs /tmp/skynetcp-src/debs
fi
