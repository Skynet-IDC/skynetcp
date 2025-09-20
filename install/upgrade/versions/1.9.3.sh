#!/bin/bash

# Skynet Control Panel upgrade script for target version 1.9.3

#######################################################################################
#######                      Place additional commands below.                   #######
#######################################################################################
####### upgrade_config_set_value only accepts true or false.                    #######
#######                                                                         #######
####### Pass through information to the end user in case of a issue or problem  #######
#######                                                                         #######
####### Use add_upgrade_message "My message here" to include a message          #######
####### in the upgrade notification email. Example:                             #######
#######                                                                         #######
####### add_upgrade_message "My message here"                                   #######
#######                                                                         #######
####### You can use \n within the string to create new lines.                   #######
#######################################################################################

upgrade_config_set_value 'UPGRADE_UPDATE_WEB_TEMPLATES' 'false'
upgrade_config_set_value 'UPGRADE_UPDATE_DNS_TEMPLATES' 'false'
upgrade_config_set_value 'UPGRADE_UPDATE_MAIL_TEMPLATES' 'false'
upgrade_config_set_value 'UPGRADE_REBUILD_USERS' 'no'
upgrade_config_set_value 'UPGRADE_UPDATE_FILEMANAGER_CONFIG' 'true'

# Remove jailbash app armour file if abi 4.0 is no installed
if [ ! -f /etc/apparmor.d/abi/4.0 ]; then
	rm -f /etc/apparmor.d/bwrap-userns-restrict
fi

if [ -x /usr/sbin/jailbash ]; then
	$SKYNET/bin/v-delete-sys-ssh-jail
	$SKYNET/bin/v-add-sys-ssh-jail
fi

# Check if file exists
if [ -f "/etc/cron.d/skynetweb" ]; then
	# Just remove it
	rm -f /etc/cron.d/skynetweb
	# Check if not duplicate
	if [ -z "$(grep $BIN/v-update-letsencrypt "/var/spool/cron/crontabs/skynetweb")" ]; then
		min=$(generate_password '012345' '2')
		hour=$(generate_password '1234567' '1')
		sed -i -e "\$a*/5 * * * * sudo $BIN/v-update-letsencrypt" "/var/spool/cron/crontabs/skynetweb"
	fi
fi
