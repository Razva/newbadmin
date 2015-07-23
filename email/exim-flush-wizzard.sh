read -p "Enter domain: " domain;
printf %s "Flushing emails for $domain ..."
exim -bp|grep $domain|awk '{print $3}' |xargs exim -Mrm >/dev/null 2>&1
printf '%s\n' "DONE!"
