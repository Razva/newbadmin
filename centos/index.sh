#!/bin/bash

# Dependencies
curl -Os https://raw.githubusercontent.com/Razva/newbadmin/master/centos/deps.sh
source ./deps.sh

# General variables
OS=$(rpm -E %{rhel})
SELINUX=$(getenforce)

# General Information
clear
h1 'System information ...'
printf '\nCentOS Version: %s\n' "$red$(rpm -E %{rhel})$normal"
printf 'Current Hostname: %s\n' "$red$(hostname)$normal"
printf 'SELinux Status: %s\n' "$red$(getenforce)$normal"
printf 'Current Date & Time: %s\n\n' "$red$(date '+%H:%M:%S') |$(timedatectl | grep 'Time zone' | sed -E 's/ +/ /g') $normal"

# Cockpit
h1 'Remove Cockpit? [Y/n] ' ; read -r ICOCKPIT
case ${ICOCKPIT,,} in
        [yY][eE][sS]|[yY]|"")
                curl -Os https://raw.githubusercontent.com/Razva/newbadmin/master/centos/cockpit.sh
                source ./cockpit.sh
                rm -rf ./cockpit.sh
                ;;
        *) h2 $'Skipping Cockpit ...\n\n'
esac

# OS Updates
h1 'Update OS? [Y/n] ' ; read -r IUPDATE
case ${IUPDATE,,} in
        [yY][eE][sS]|[yY]|"")
                curl -Os https://raw.githubusercontent.com/Razva/newbadmin/master/centos/update.sh
                source ./update.sh
                rm -rf ./update.sh
                ;;
        *) h2 $'Skipping OS Updates ...\n\n';
esac

# Hostname
h1 'Set Hostname? [Y/n] ' ; read -r IHOSTNAME
case ${IHOSTNAME,,} in
        [yY][eE][sS]|[yY]|"")
                curl -Os https://raw.githubusercontent.com/Razva/newbadmin/master/centos/hostname.sh
                source ./hostname.sh
                rm -rf ./hostname.sh
                ;;
        *) h2 $'Skipping Hostname ...\n\n';
esac

# Time
h1 'Set Time? [Y/n] ' ; read -r ITIME
case ${ITIME,,} in
        [yY][eE][sS]|[yY]|"")
                curl -Os https://raw.githubusercontent.com/Razva/newbadmin/master/centos/time.sh
                source ./time.sh
                rm -rf ./time.sh
                ;;
        *) h2 $'Skipping Time ...\n\n';
esac

h1 $'Cleanup ...\n\n'
rm -rf ./deps.sh
