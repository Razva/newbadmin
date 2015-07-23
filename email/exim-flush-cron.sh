#!/bin/sh
# Before running this script you NEED to setup /etc/blockeddomains
# as instructed at http://www.linuxbrigade.com/block-account-sending-mail-whmcpanel/
while read line; do exiqgrep -if ${line} | xargs exim -Mrm &> /dev/null; done < /etc/blockeddomains &> /dev/null
while read line; do exiqgrep -ir ${line} | xargs exim -Mrm &> /dev/null; done < /etc/blockeddomains &> /dev/null
exim -bp|grep frozen|awk '{print $3}' |xargs exim -Mrm &> /dev/null
