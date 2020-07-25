#!/bin/bash

h1 $'General settings ...\n'
while true; do
	h2 'Select CentOS Version (7/8): ' ; read -r IVERSION
		case $IVERSION in
			7) echo "7"
			;;
			8) echo "8"
			;;
			*) h3 'Please choose either 7 or 8.'
			;;
		esac
	break
done
