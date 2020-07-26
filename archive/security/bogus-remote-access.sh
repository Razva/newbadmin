read -p "Enter username: " username;
echo "The following IPs are generating bogus remote access attempts for username '$username':"
grep $username /usr/local/apache/logs/error_log | grep "File does not exist" | awk '{print $10}' | sed 's/:[^:]*$//g' | sort -n | uniq -c | sort -n | tail -15
