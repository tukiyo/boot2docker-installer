IPADDR=$(awk -F '=' '/^IPADDR/{print $2}' ip.conf)
GATEWAY=$(awk -F '=' '/^GATEWAY/{print $2}' ip.conf)

echo ip addr add $IPADDR dev eth0
echo ip route add default via $GATEWAY
