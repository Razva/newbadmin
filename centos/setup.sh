#!/bin/bash
set -euo pipefail

log() {
  local green=$(tput setaf 2)
  local normal=$(tput sgr0)
  printf "${green}=== %s ${normal}\n" "$1"
}

log 'Updating OS ...'
yum -y update
log 'Done!'

log 'Installing EPEL ...'
yum -y install epel-release
log 'Done!'

log 'Installing Utils ...'
while true; do
	read -p 'Select CentOS Version (7/8): ' os;
	case $os in
	  7) yum -y install wget nano screen firewalld install policycoreutils-python tar unzip;;
	  8) dnf -y install wget nano screen firewalld policycoreutils-python-utils tar unzip;;
	  *) echo "Please choose either 7 or 8.";;
	esac
    break
done
log 'Done!'

log 'Setting FIREWALLD Rules ...'
read -p 'Define custom SSH Port: ' sshport;
systemctl start firewalld
firewall-cmd --zone=public --permanent --add-port=$sshport/tcp
firewall-cmd --zone=public --permanent --add-port=80/tcp
firewall-cmd --zone=public --permanent --add-port=443/tcp
firewall-cmd --zone=public --permanent --remove-service=cockpit
firewall-cmd --zone=public --permanent --remove-service=dhcpv6-client
firewall-cmd --zone=public --permanent --remove-service=ssh
firewall-cmd --reload
log 'Done!'

log 'Adding SELINUX SSH Port Rule ...'
semanage port -a -t ssh_port_t -p tcp $sshport
log 'Done!'

log 'Editing SSHD Config ...'
nano -w /etc/ssh/sshd_config
log 'Done!'

log 'Restarting SSHD ...'
systemctl restart sshd
log 'Done!'

log 'Setting up SUDO user ...'
read -p 'New user: ' user;
useradd $user
passwd $user
usermod -aG wheel $user
log 'Done!'

log "Adding SSH Key for $user ..."
rm -rf /home/$user/.ssh
mkdir -p /home/$user/.ssh
wget -O /home/$user/.ssh/authorized_keys https://t.isp.fun/authorized_keys
chmod 700 /home/$user/.ssh
chmod 600 /home/$user/.ssh/authorized_keys
chown -R $user:$user /home/$user/.ssh
restorecon -R -v /home/$user/.ssh
log 'Done!'

log 'Cleanup ...'
rm -rf centos.sh
log 'Done!'