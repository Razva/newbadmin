!/bin/bash

# Color & Style

red=$'\e[91m'
green=$'\e[92m'
yellow=$'\e[93m'
normal=$'\e[0m'

h1() { printf '\n%s=== %s%s' "$green" "$1" "$normal"; }
h2() { printf '%s= %s%s\n' "$yellow" "$1" "$normal"; }

# General Information
clear
h1 'System information ...'
printf '\nCentOS Version: %s\n' "$red$(rpm -E %{rhel})$normal"
printf 'Current Hostname: %s\n' "$red$(hostname) $normal"
printf 'SELinux Status: %s\n' "$red$(grep "^SELINUX=" /etc/selinux/config) $normal"
printf 'Current Date & Time: %s\n' "$red$(date '+%H:%M:%S') |$(timedatectl | grep 'Time zone' | sed -E 's/ +/ /g') $normal"

h1 'Remove Cockpit? [Y/n] ' ; read -r ICOCKPIT
case ${ICOCKPIT,,} in
        [yY][eE][sS]|[yY]|"")
                wget --quiet https://raw.githubusercontent.com/Razva/newbadmin/master/centos/cockpit.sh
                source ./cockpit.sh
                rm -rf ./cockpit.sh
                ;;
        *) h2 'Skipping Cockpit ...'
esac

h1 'Update OS? [Y/n] ' ; read -r IUPDATE
case ${IUPDATE,,} in
        [yY][eE][sS]|[yY]|"")
                wget --quiet https://raw.githubusercontent.com/Razva/newbadmin/master/centos/update.sh
                source ./update.sh
                rm -rf ./update.sh
                ;;
        *) h2 'Skipping OS Updates ...';
esac

printf '\nEND!\n\n'
