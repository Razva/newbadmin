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

while true; do
	log 'Selecting OS ...'
	read -p 'Select CentOS Version (7/8): ' os;
	echo ""
	case $os in
		7) log 'Installing YUM-Cron...'
			yum -y install yum-cron
			sed -i 's/^apply_updates = no$/apply_updates = yes/g' /etc/yum/yum-cron.conf
			systemctl enable yum-cron
			systemctl start yum-cron
   		;;
		8) log 'Installing Chrony...'
			dnf -y install dnf-automatic
		;;
		*) log 'Please choose either 7 or 8.'
			echo ""
		;;
		esac
	break
done

log 'All done!'
rm -rf aupdate.sh
