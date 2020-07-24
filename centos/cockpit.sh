printf "${green}Removing Cockpit ... "
yum -y remove cockpit-* > /dev/null 2>&1
printf '%s\n' "done!${normal}"
