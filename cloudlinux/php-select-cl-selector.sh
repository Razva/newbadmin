read -p "Enter username: " username;
read -p "Enter PHP version: " phpversion;
echo ==================
printf %s "Setting PHP version '$phpversion' for username '$username' ... ";
/usr/bin/cl-selector --select=php --version="$phpversion" --user="$username" >/dev/null 2>&1;
printf '%s\n' "DONE!"
echo ==================
echo "Here's the new status:"
/usr/bin/cl-selector --summary php --user "$username"
