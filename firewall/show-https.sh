netstat -an | grep :443 | egrep '^tcp' | grep -v LISTEN | awk '{print $5}' | egrep '([0-9]{1,3}\.){3}[0-9]{1,3}' | sed 's/^\(.*:\)\?\(\([0-9]\{1,3\}\.\)\{3\}[0-9]\{1,3\}\).*$/\2/' | sort | uniq -c | sort -nr | sed 's/::ffff://' | head -20
