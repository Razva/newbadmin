#!/bin/bash
set -euo pipefail

log() {
	local green=$(tput setaf 2)
	local normal=$(tput sgr0)
	printf "${green}=== %s ${normal}\n" "$1"
}

log 'Showing current server information ...'
echo -e "CentOS Version: \e[1m\e[91m$(rpm -E %{rhel})\e[0m"
echo -e "Hostname: \e[1m\e[91m$(hostname)\e[0m"
echo -e "YUM-Cron: \e[1m\e[91m$(systemctl is-active yum-cron)\e[0m"
echo -e "DNF Automatic: \e[1m\e[91m$(systemctl is-active dnf-automatic)\e[0m"
echo ""

log 'Updating OS...'
yum -y update
log 'Done!'
echo ""

while true; do
	log 'Selecting OS ...'
	read -p 'Select CentOS Version (7/8): ' os;
	echo ""
	case $os in
		7) log 'Installing YUM-Cron...'
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
		8) log 'Installing DNF-Automatic...'
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
		*) log 'Please choose either 7 or 8.'
			echo "" && exit
		;;
		esac
	break
done

echo ""
rm -rf aupdate.sh
