#!/bin/bash
set -euo pipefail

log() {
  local green=$(tput setaf 2)
  local normal=$(tput sgr0)
  printf "${green}=== %s ${normal}\n" "$1"
}

log 'Adding SELinux rules ...'
setsebool -P named_write_master_zones 1
log 'Done!'

log 'Installing BIND ...'
yum -y install bind bind-utils &&
log 'Done!'

log 'Adding FirewallD rules ...'
firewall-cmd --permanent --zone=public --add-port=53/tcp
firewall-cmd --permanent --zone=public --add-port=53/udp
firewall-cmd --permanent --zone=public --add-port=953/tcp
log 'Done!'

log 'Setting BIND ...'
mv /etc/named.conf /etc/named.conf.orig
wget -O /etc/named.conf https://raw.githubusercontent.com/Razva/newbadmin/master/plesk/named.conf
chown root:named /etc/named.conf*
log 'Done!'

log 'Enabling and Starting BIND ...'
systemctl enable bind
systemctl stop bind
systemctl start bind
log 'Done!'
log ''
log '!!! REMEMBER TO SETUP PLESK IP AND KEY IN NAMED.CONF !!!'
rm -rf bind-setup.sh
