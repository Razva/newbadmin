read -p "Enter domain: " domain;
printf %s "Flushing emails FROM $domain ..."
exiqgrep -if $domain | xargs exim -Mrm >/dev/null 2>&1
printf '%s\n' "DONE!"
printf %s "Flushing emails TO $domain ..."
exiqgrep -ir $domain | xargs exim -Mrm >/dev/null 2>&1
printf '%s\n' "DONE!"
