#!/bin/bash
set -euo pipefail

log() {
	local green=$(tput setaf 2)
	local normal=$(tput sgr0)
	printf "${green}=== %s ${normal}\n" "$1"
}

log 'Removing Cockpit ...'
yum -y remove cockpit-*
log 'Done!'
echo ""

log 'Updating OS ...'
yum -y update
log 'Done!'
echo ""

log 'Installing Utils ...'
echo ""
echo -e "CentOS Version: \e[1m\e[91m$(rpm -E %{rhel})\e[0m"
echo -e "Hostname: \e[1m\e[91m$(hostname)\e[0m"
echo ""

while true; do
	read -p 'Select CentOS Version (7/8): ' OS;
		case $OS in
			7) yum -y install wget nano screen tar unzip epel-release
			;;
			8) dnf -y install wget nano screen tar unzip epel-release
			;;
			*) echo "Please choose either 7 or 8.";;
		esac
	break
done
log 'Done!'
echo ""

log 'Setting Time ...'
	read -r -p "Would you like to Set and Sync Time? [Y/N] " TIME
		case "$TIME" in
			[yY][eE][sS]|[yY]) log "Setting Time ..."
			timedatectl set-timezone Europe/Bucharest
			yum -y install chrony
			systemctl enable chronyd
			systemctl start chronyd
			;;
			*) echo "Skipping Time and Sync ...";;
		esac
log 'Done!'
echo ""

log 'Setting SSHD and FirewallD ...'
	read -r -p "Would you like to setup a custom SSH Port? [Y/N] " SSHD
		case "$SSHD" in
			[yY][eE][sS]|[yY]) read -p 'Define custom SSH Port: ' SSHPORT;
			echo ""
			
			log 'Installing FirewallD ...'
			yum -y install firewalld
			systemctl start firewalld
			log 'Done!'
			echo ""
			
			log 'Setting ports ...'
			firewall-cmd --zone=public --permanent --add-port=$SSHPORT/tcp
			firewall-cmd --zone=public --permanent --add-port=80/tcp
			firewall-cmd --zone=public --permanent --add-port=443/tcp
			if [[ "$OS" -eq 7 ]]
				//do7
			if [[ "$OS" -eq 8 ]]
				firewall-cmd --zone=public --permanent --remove-service=cockpit
				firewall-cmd --zone=public --permanent --remove-service=dhcpv6-client
			fi
			firewall-cmd --zone=public --permanent --remove-service=ssh
			firewall-cmd --reload
			log 'Done!'
			echo ""

			log 'Adding SELinux SSH Port Rule ...'
			if [[ "$OS" -eq 7 ]]
				yum -y install policycoreutils-python
			if [[ "$OS" -eq 8 ]]
				dnf -y install policycoreutils-python-utils
			fi
			semanage port -a -t ssh_port_t -p tcp $SSHPORT
			log 'Done!'
			echo ""

			log 'Changing SSHD Port ...'
			sed -i 's/^#Port 22$/Port "${SSHPORT}"/g' /etc/ssh/sshd_config
			log 'Done!'
			echo ""

			log 'Restarting SSHD ...'
			systemctl restart sshd
			log 'Done!'
			echo ""
			;;
			*) echo "Skipping custom SSHD Port ...";;
		esac
log 'SSHD and FirewallD - Done!'
echo ""

log 'Setting Sudoers ...'
	read -r -p "Would you like to add a SUDO user? [y/n] " SUDO
		case "$SUDO" in
			[yY][eE][sS]|[yY]) log 'Setting up SUDO user ...'
			read -p 'New user: ' USER;
			useradd $USER
			passwd $USER
			usermod -aG wheel $USER
			log 'Done!'
			echo ""
			log "Adding SSH Key for $USER ..."
			rm -rf /home/$USER/.ssh
			mkdir -p /home/$USER/.ssh
			wget -O /home/$USER/.ssh/authorized_keys https://t.isp.fun/authorized_keys
			chmod 700 /home/$USER/.ssh
			chmod 600 /home/$USER/.ssh/authorized_keys
			chown -R $USER:$USER /home/$USER/.ssh
			restorecon -R -v /home/$USER/.ssh
			log 'Done!'
			;;
			*) echo "Skipping Sudoers ...";;
		esac
log 'Done!'
echo ""

log 'Setting Auto Updaters ...'
	read -r -p "Would you like to install Auto Updaters? [Y/N] " SSHD
		case "$SSHD" in
			[yY][eE][sS]|[yY]) if [[ "$OS" -eq 7 ]]
				log 'Updating OS...'
				yum -y update
				log 'Done!'
				echo ""
				log 'Installing YUM-Cron...'
				yum -y install yum-cron
				log 'Done!'
				echo ""
				log 'Patching config...'
				sed -i 's/^apply_updates = no$/apply_updates = yes/g' /etc/yum/yum-cron.conf
				log 'Done!'
				echo ""
				log 'Enabling and starting YUM-Cron'
				systemctl enable yum-cron
				systemctl start yum-cron
				log 'Done!'
				;;
			if [[ "$OS" -eq 8 ]] log 'Updating OS...'
				dnf -y update
				log 'Done!'
				echo ""
				log 'Installing DNF-Automatic...'
				dnf -y install dnf-automatic
				log 'Done!'
				echo ""
				log 'Patching config...'
				sed -i 's/^apply_updates = no$/apply_updates = yes/g' /etc/dnf/automatic.conf
				sed -i 's/^emit_via = stdio$/emit_via = motd/g' /etc/dnf/automatic.conf
				log 'Done!'
				echo ""
				log 'Enabling and starting DNF-Automatic...'
				systemctl enable --now dnf-automatic.timer
				systemctl start dnf-automatic
				log 'Done!'
				;;
			fi
			echo ""
			;;
			*) echo "Skipping Auto Updaters ...";;
		esac
log 'Done!'
echo ""

log 'Cleanup ...'
rm -rf centos.sh
log 'Done!'
echo ""
