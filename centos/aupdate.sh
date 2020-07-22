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
