read -p "Enter username: " username;
printf %s "Reseting directory permissions for $username ... "
find /home/$username/public_html -type d -exec chmod 755 {} +
printf '%s\n' "DONE!"
