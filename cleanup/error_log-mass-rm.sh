before=`df -h`
for user in `/bin/ls /var/cpanel/users`; do
echo "Clearing cPanel error_logs for: $user"
echo ‘>> Clearing Logs’
find /home/$user -name ‘error_log’ -exec rm -f {} \;
echo ‘=============’
done
/scripts/fixquotas
echo "============="
echo "Before:"
echo "============="
echo -e "$before"
echo "============="
echo "After:"
echo "============="
df -h
echo "============="