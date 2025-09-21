#!/bin/bash

for file in /usr/local/skynet/bin/*; do
	echo "$file" >> ~/skynet_cli_help.txt
	[ -f "$file" ] && [ -x "$file" ] && "$file" >> ~/skynet_cli_help.txt
done

sed -i 's\/usr/local/skynet/bin/\\' ~/skynet_cli_help.txt
