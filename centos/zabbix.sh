#!/bin/bash
set -euo pipefail

log() {
	local green=$(tput setaf 2)
	local normal=$(tput sgr0)
	printf "${green}=== %s ${normal}\n" "$1"
}

log 'Current OS version is ...'
cat /etc/centos-release
echo ""

while true; do
	log 'Selecting OS ...'
	read -p 'Select CentOS Version (7/8): ' os;
	echo ""
	case $os in
		7) log 'Installing CentOS 7 Agent...'
			rpm -Uvh https://repo.zabbix.com/zabbix/5.0/rhel/7/x86_64/zabbix-release-5.0-1.el7.noarch.rpm
    			yum clean all
    			yum install zabbix-agent
			log 'Done!'
   		;;
		8) log 'Installing CentOS 8 Agent...'
			rpm -Uvh https://repo.zabbix.com/zabbix/5.0/rhel/8/x86_64/zabbix-release-5.0-1.el8.noarch.rpm
			dnf clean all
			dnf install zabbix-agent
			log 'Done!'
		;;
		*) log 'Please choose either 7 or 8.'
			echo ""
		;;
		esac
	break
done
