read -p "Enter link: " link;
/usr/local/apache/bin/ab  -n 9999999 -c 100 $link
