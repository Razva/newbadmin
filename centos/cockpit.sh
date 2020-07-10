dnf install cockpit &&
systemctl enable --now cockpit.socket &&
firewall-cmd --permanent --zone=public --add-service=cockpit &&
firewall-cmd --reload
