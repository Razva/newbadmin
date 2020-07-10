#!/bin/bash

log() {
  local green=$(tput setaf 2)
  local normal=$(tput sgr0)
  printf "${green}=== %s ${normal}\n" "$1"
}

log 'Updating OS ...'
yum -y update
log 'Done!'
echo ""
log 'Installing Cockpit'
yum -y install cockpit
systemctl enable --now cockpit.socket
log 'Done!'
echo ""
log 'Setting firewall ...'
firewall-cmd --permanent --zone=public --add-service=cockpit &&
firewall-cmd --reload
log 'Done!'
rm -rf cockpit.sh
