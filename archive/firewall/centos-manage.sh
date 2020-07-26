read -p "Zone: " zone;
read -p "Port: " port;
read -p "Protocol (tcp/udp): " protocol;
printf %s "Opening port $port, protocol $protocol on zone $zone..."
firewall-cmd --zone=$zone --permanent --add-port=$port/$protocol && firewall-cmd --reload
