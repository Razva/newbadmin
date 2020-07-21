#!/bin/bash
set -euo pipefail

log() {
	local green=$(tput setaf 2)
	local normal=$(tput sgr0)
	printf "${green}=== %s ${normal}\n" "$1"
}

log 'Showing current server information ...'
echo "OS: $(cat /etc/centos-release)"
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

log 'Patching config file ...'
sed -i 's/^Server=127.0.0.1$/Server=zbx-client.neutralisp.com/g' /etc/zabbix/zabbix_agentd.conf
sed -i "s/^Hostname=Zabbix server$/Hostname=$HOSTNAME/g" /etc/zabbix/zabbix_agentd.conf
log 'Done!'

log 'Adding firewall rule ...'
firewall-cmd --zone=public --permanent --add-port=10050/tcp
firewall-cmd --reload
log 'Done!'

log 'Enabling and starting service ...'
systemctl enable zabbix-agent
systemctl stop zabbix-agent
systemctl start zabbix-agent
log 'Done!'
echo ""
log "Agent IP Address: $(hostname -I)"
echo ""
rm -rf zabbix.sh
