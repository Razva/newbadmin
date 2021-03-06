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

log 'Setting FirewallD ...'
firewall-cmd --permanent --zone=public --add-port=53/tcp
firewall-cmd --permanent --zone=public --add-port=53/udp
firewall-cmd --permanent --zone=public --add-port=953/tcp
firewall-cmd --reload
log 'Done!'

log 'Setting BIND ...'
mv /etc/named.conf /etc/named.conf.orig
wget -O /etc/named.conf https://raw.githubusercontent.com/Razva/newbadmin/master/plesk/named.conf
chown root:named /etc/named.conf*
systemctl enable named
systemctl stop named
log 'Done!'

log 'Editing BIND Config ...'
nano -w /etc/named.conf
log 'Done!'

log 'Starting BIND ...'
systemctl start named
systemctl status named
log 'Done!'

log ''
log 'BIND SUCCESSFULLY INSTALLED'

rm -rf bind-setup.sh
