while read line; do exiqgrep -if ${line} | xargs exim -Mrm &> /dev/null; done < /etc/blockeddomains &> /dev/null
exim -bp|grep frozen|awk '{print $3}' |xargs exim -Mrm &> /dev/null
