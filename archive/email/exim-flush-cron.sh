#!/bin/sh
# Before running this script you NEED to setup /etc/blockeddomains
# as instructed at http://www.linuxbrigade.com/block-account-sending-mail-whmcpanel/
while read line; do /usr/sbin/exiqgrep -if ${line} | xargs /usr/sbin/exim -Mrm &> /dev/null; done < /etc/blockeddomains &> /dev/null
while read line; do /usr/sbin/exiqgrep -ir ${line} | xargs /usr/sbin/exim -Mrm &> /dev/null; done < /etc/blockeddomains &> /dev/null
/usr/sbin/exim -bp|grep frozen|awk '{print $3}' |xargs /usr/sbin/exim -Mrm &> /dev/null
