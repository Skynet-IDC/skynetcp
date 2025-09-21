
./hst_autocompile.sh --all --noinstall --keepbuild '~localsrc'

apt -y install acl idn2 bubblewrap at

bash hst-install-ubuntu.sh --hostname cp2.skynetidc.com --email hoadq@skynetidc.vn --username hoadq --password 12345678 --with-debs /tmp/skynetcp-src/deb/ --interactive no --force
