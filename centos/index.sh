#!/bin/bash

# Color & Style
log() {
	local green=$(tput setaf 2)
	local normal=$(tput sgr0)
	printf '%s=== %s%s\n' "$green" "$1" "$normal"
}

red=$(tput setaf 1)
normal=$(tput sgr0)

# General Information
log 'System information ...'
printf "CentOS Version: ${red} 'rpm -E %{rhel}' ${normal}"




echo -e "Current Hostname: \e[1m\e[91m$(hostname)\e[0m"
echo -e "SELinux: \e[1m\e[91m$(cat /etc/selinux/config | grep "^SELINUX=")\e[0m"
echo -e "Current Date & Time: \e[1m\e[91m$ (date '+%H:%M:%S'| xargs echo -n; timedatectl | grep 'Time zone') \e[0m"|sed -E 's/ +/ /g'
