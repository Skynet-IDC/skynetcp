sudo chmod -R 777 ./install/install*
sudo chmod -R 777 ./src/hst_*
apt -y install acl idn2 bubblewrap at

./autocompile.sh --all --noinstall --keepbuild '~localsrc'

bash install-ubuntu.sh --hostname cp2.skynetidc.com --email hoadq@skynetidc.vn --username hoadq --password 12345678 --with-debs /tmp/skynetcp-src/deb/ --interactive no --force

