read -p "Enter username: " username;
printf %s "Killing all processes for $username ... "
ps -ef | grep $username | awk '{ print $2 }' | sudo xargs kill -9
printf '%s\n' "DONE!"
