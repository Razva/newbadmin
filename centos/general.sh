#!/bin/bash

h1 $'General settings ...\n'
while true; do
	h2 'Select CentOS Version (7/8): ' ; read -r IVERSION
		case $IVERSION in
			7) OS=7
			break
			;;
			8) OS=8
			break
			;;
			*) h3 $'Please choose either 7 or 8.\n'
			;;
	esac
done

h3 $'Selected CentOS $OS. Continuing ...\n'
