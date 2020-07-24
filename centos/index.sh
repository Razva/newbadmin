!/bin/bash

# Color & Style

red=$'\e[91m'
green=$'\e[92m'
yellow=$'\e[93m'
normal=$'\e[0m'

log() {
        printf '%s=== %s%s\n' "$green" "$1" "$normal"
}

# General Information
clear
log 'System information ...'
printf 'CentOS Version: %s\n' "$red$(rpm -E %{rhel})$normal"
printf 'Current Hostname: %s\n' "$red$(hostname) $normal"
printf 'SELinux Status: %s\n' "$red$(grep "^SELINUX=" /etc/selinux/config) $normal"
printf 'Current Date & Time: %s\n' "$red$(date '+%H:%M:%S') |$(timedatectl | grep 'Time zone' | sed -E 's/ +/ /g') $normal"

printf '%s\nRemove Cockpit? [Y/n] %s' "$green" "$normal" ; read -r ICOCKPIT
case ${ICOCKPIT,,} in
        [yY][eE][sS]|[yY]|"")
                wget --quiet https://raw.githubusercontent.com/Razva/newbadmin/master/centos/cockpit.sh
                source ./cockpit.sh
                rm -rf ./cockpit.sh
                ;;
        *) printf '%s\n' "${green}Skipping Cockpit ...${normal}";;
esac

printf '%s\nUpdate OS? [Y/n] %s' "$green" "$normal" ; read -r IUPDATE
case ${IUPDATE,,} in
        [yY][eE][sS]|[yY]|"")
                wget --quiet https://raw.githubusercontent.com/Razva/newbadmin/master/centos/update.sh
                source ./update.sh
                rm -rf ./update.sh
                ;;
        *) printf '%s\n' "${green}Skipping OS Updates ...${normal}";;
esac

printf '\nScript END!\n\n'
