nano -w /etc/udev/rules.d/75-persistent-net-generator.rules

SUBSYSTEM=="net", ACTION=="add", ATTR{address}=="xx:xx:xx:xx:xx:xx", NAME="ethX"

nano -w /etc/network/interfaces

reboot
