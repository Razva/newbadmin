read -p "Enter username: " username;
read -p "Enter Remote IP: " remoteip;
read -p "Enter Remote Port: " remoteport;
echo ==================
printf %s "RSYNC-ing '/home/$username/public_html' with remote '$remoteip @ $remoteport'. This can take a while ... ";
rsync -aSH --update -e "ssh -p $remoteport" root@$remoteip:/home/$username/public_html/ /home/$username/public_html
printf '%s\n' "DONE!"
printf %s "CHOWN-ing local '/home/$username/public_html' for user '$username'. This can take a while ... ";
chown -R $username:$username /home/$username/public_html
printf '%s\n' "DONE!"
printf %s "CHMOD-ing local '/home/$username/public_html' with flag 755 ... ";
chmod 755 /home/$username/public_html
printf '%s\n' "DONE!"
echo ==================
echo "The new status for /home/$username/public_html is:"
ls -la /home/$username/ | grep public_html