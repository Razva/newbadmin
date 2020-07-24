#!/bin/bash

# Color & Style
log() {
        local green=$(tput setaf 2)
        local normal=$(tput sgr0)
        printf '%s=== %s%s\n' "$green" "$1" "$normal"
}

red=$'\e[91m'
green=$'\e[92m'
normal=$'\e[0m'

# General Information
clear
log 'System information ...'
printf 'CentOS Version: %s\n' "$red$(rpm -E %{rhel})$normal"
printf 'Current Hostname: %s\n' "$red$(hostname) $normal"
printf 'SELinux Status: %s\n' "$red$(grep "^SELINUX=" /etc/selinux/config) $normal"
printf 'Current Date & Time: %s\n' "$red$(date '+%H:%M:%S') |$(timedatectl | grep 'Time zone' | sed -E 's/ +/ /g') $normal"

printf '%sRemove Cockipit? [Y/n] %s' "$green" "$normal" ; read ICOCKPIT
case "$ICOCKPIT" in
        [yY][eE][sS]|[yY])
                wget --quiet https://raw.githubusercontent.com/Razva/newbadmin/master/centos/cockpit.sh
                source ./cockpit.sh
                rm -rf ./cockpit.sh
                ;;
        *) printf '%s\n' "${green}Skipping Cockpit ...${normal}";
esac

printf '\nDone!\n\n'
