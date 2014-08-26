read -p "Enter username: " username;
printf %s "Reseting file permissions for $username ... "
find /home/$username/public_html -type f -exec chmod 644 {} +
printf '%s\n' "DONE!"
