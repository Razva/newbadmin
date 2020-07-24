printf "${green}Removing Cockpit ... "
yum -y -q remove cockpit-* > /dev/null 2>&1
printf '%s\n' "done!${normal}"
