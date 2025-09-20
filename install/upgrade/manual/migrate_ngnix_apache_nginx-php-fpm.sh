#!/bin/bash

# Function Description
# Manual upgrade script from Nginx + Apache2 + PHP-FPM to Nginx + PHP-FPM

#----------------------------------------------------------#
#                    Variable&Function                     #
#----------------------------------------------------------#

# Includes
# shellcheck source=/etc/skynetcp/skynet.conf
source /etc/skynetcp/skynet.conf
# shellcheck source=/usr/local/skynet/func/main.sh
source $SKYNET/func/main.sh
# shellcheck source=/usr/local/skynet/conf/skynet.conf
source $SKYNET/conf/skynet.conf

#----------------------------------------------------------#
#                    Verifications                         #
#----------------------------------------------------------#

if [ "$WEB_BACKEND" != "php-fpm" ]; then
	check_result $E_NOTEXISTS "PHP-FPM is not enabled" > /dev/null
	exit 1
fi

if [ "$WEB_SYSTEM" != "apache2" ]; then
	check_result $E_NOTEXISTS "Apache2 is not enabled" > /dev/null
	exit 1
fi

#----------------------------------------------------------#
#                       Action                             #
#----------------------------------------------------------#

# Remove apache2 from config
sed -i "/^WEB_PORT/d" $SKYNET/conf/skynet.conf $SKYNET/conf/defaults/skynet.conf
sed -i "/^WEB_SSL/d" $SKYNET/conf/skynet.conf $SKYNET/conf/defaults/skynet.conf
sed -i "/^WEB_SSL_PORT/d" $SKYNET/conf/skynet.conf $SKYNET/conf/defaults/skynet.conf
sed -i "/^WEB_RGROUPS/d" $SKYNET/conf/skynet.conf $SKYNET/conf/defaults/skynet.conf
sed -i "/^WEB_SYSTEM/d" $SKYNET/conf/skynet.conf $SKYNET/conf/defaults/skynet.conf

# Remove nginx (proxy) from config
sed -i "/^PROXY_PORT/d" $SKYNET/conf/skynet.conf $SKYNET/conf/defaults/skynet.conf
sed -i "/^PROXY_SSL_PORT/d" $SKYNET/conf/skynet.conf $SKYNET/conf/defaults/skynet.conf
sed -i "/^PROXY_SYSTEM/d" $SKYNET/conf/skynet.conf $SKYNET/conf/defaults/skynet.conf

# Add Nginx settings to config
echo "WEB_PORT='80'" >> $SKYNET/conf/skynet.conf
echo "WEB_SSL='openssl'" >> $SKYNET/conf/skynet.conf
echo "WEB_SSL_PORT='443'" >> $SKYNET/conf/skynet.conf
echo "WEB_SYSTEM='nginx'" >> $SKYNET/conf/skynet.conf

# Add Nginx settings to config
echo "WEB_PORT='80'" >> $SKYNET/conf/defaults/skynet.conf
echo "WEB_SSL='openssl'" >> $SKYNET/conf/defaults/skynet.conf
echo "WEB_SSL_PORT='443'" >> $SKYNET/conf/defaults/skynet.conf
echo "WEB_SYSTEM='nginx'" >> $SKYNET/conf/defaults/skynet.conf

rm $SKYNET/conf/defaults/skynet.conf
cp $SKYNET/conf/skynet.conf $SKYNET/conf/defaults/skynet.conf

# Rebuild web config

for user in $($BIN/v-list-users plain | cut -f1); do
	echo $user
	for domain in $($BIN/v-list-web-domains $user plain | cut -f1); do
		$BIN/v-change-web-domain-tpl $user $domain 'default'
		$BIN/v-rebuild-web-domain $user $domain no
	done
done

systemctl restart nginx
