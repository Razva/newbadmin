#!/bin/bash

h2 $'Setting Hostname ...\n'
h3 'New hostname: ' ; read -r HOSTNAME
hostnamectl set-hostname $HOSTNAME --static
h2 $'Done!\n\n'
