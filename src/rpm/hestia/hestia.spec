%define debug_package %{nil}
%global _hardened_build 1

Name:           skynet
Version:        1.9.0~alpha
Release:        1%{dist}
Summary:        skynet Control Panel
Group:          System Environment/Base
License:        GPLv3
URL:            https://www.skynetcp.com
Source0:        skynet-%{version}.tar.gz
Source1:        skynet.service
Vendor:         skynetcp.com
Requires:       redhat-release >= 8
Requires:       bash, chkconfig, gawk, sed, acl, sysstat, (setpriv or util-linux), zstd, jq, jailkit, bubblewrap
Conflicts:      vesta
Provides:       skynet = %{version}
BuildRequires:  systemd

%description
This package contains the skynet Control Panel.

%prep
%autosetup -p1 -n skynetcp

%build

%install
%{__rm} -rf $RPM_BUILD_ROOT
mkdir -p %{buildroot}%{_unitdir} %{buildroot}/usr/local/skynet
cp -R %{_builddir}/skynetcp/* %{buildroot}/usr/local/skynet/
%{__install} -m644 %{SOURCE1} %{buildroot}%{_unitdir}/skynet.service

%clean
%{__rm} -rf $RPM_BUILD_ROOT

%pre
# Run triggers only on updates
if [ -e "/usr/local/skynet/data/users/" ]; then
    # Validate version number and replace if different
    skynet_V=$(rpm --queryformat="%{VERSION}" -q skynet)
    if [ ! "$SKYNET_V" = "%{version}" ]; then
        sed -i "s/VERSION=.*/VERSION='$SKYNET_V'/g" /usr/local/skynet/conf/skynet.conf
    fi
fi

%post
%systemd_post skynet.service

if [ ! -e /etc/profile.d/skynet.sh ]; then
    skynet='/usr/local/skynet'
    echo "export skynet='$SKYNET'" > /etc/profile.d/skynet.sh
    echo 'PATH=$PATH:'$SKYNET'/bin' >> /etc/profile.d/skynet.sh
    echo 'export PATH' >> /etc/profile.d/skynet.sh
    chmod 755 /etc/profile.d/skynet.sh
    source /etc/profile.d/skynet.sh
fi

if [ -e "/usr/local/skynet/data/users/" ]; then
    ###############################################################
    #                Initialize functions/variables               #
    ###############################################################

    # Load upgrade functions and refresh variables/configuration
    source /usr/local/skynet/func/upgrade.sh
    upgrade_refresh_config

    ###############################################################
    #             Set new version numbers for packages            #
    ###############################################################
    # skynet Control Panel
    new_version=$(rpm --queryformat="%{VERSION}" -q skynet)

    # phpMyAdmin
    pma_v='5.0.2'

    ###############################################################
    #               Begin standard upgrade routines               #
    ###############################################################

    # Initialize backup directories
    upgrade_init_backup

    # Set up console display and welcome message
    upgrade_welcome_message

    # Execute version-specific upgrade scripts
    upgrade_start_routine

    # Update Web domain templates
    upgrade_rebuild_web_templates | tee -a $LOG

    # Update Mail domain templates
    upgrade_rebuild_mail_templates | tee -a $LOG

    # Update DNS zone templates
    upgrade_rebuild_dns_templates | tee -a $LOG

    # Upgrade File Manager and update configuration
    upgrade_filemanager | tee -a $LOG

    # Upgrade SnappyMail if applicable
    upgrade_snappymail | tee -a $LOG

    # Upgrade Roundcube if applicable
    upgrade_roundcube | tee -a $LOG

    # Upgrade PHPMailer if applicable
    upgrade_phpmailer | tee -a $LOG

    # Update Cloudflare IPs if applicable
    upgrade_cloudflare_ip | tee -a $LOG

    # Upgrade phpMyAdmin if applicable
    upgrade_phpmyadmin | tee -a $LOG

    # Upgrade phpPgAdmin if applicable
    upgrade_phppgadmin | tee -a $LOG

    # Upgrade blackblaze-cli-took if applicable
    upgrade_b2_tool | tee -a $LOG

	# update whitelabel logo's
	update_whitelabel_logo | tee -a $LOG

    # Set new version number in skynet.conf
    upgrade_set_version

    # Perform account and domain rebuild to ensure configuration files are correct
    upgrade_rebuild_users

    # Restart necessary services for changes to take full effect
    upgrade_restart_services

    # Add upgrade notification to admin user's panel and display completion message
    upgrade_complete_message
fi

%preun
%systemd_preun skynet.service

%postun
%systemd_postun_with_restart skynet.service

%files
%defattr(-,root,root)
%attr(755,root,root) /usr/local/skynet
%{_unitdir}/skynet.service

%changelog
* Sun May 14 2023 Istiak Ferdous <hello@istiak.com> - 1.8.0-1
- skynetcp RHEL 9 support

* Thu Jun 25 2020 Ernesto Nicolás Carrea <equistango@gmail.com> - 1.2.0
- skynetcp CentOS 8 support
