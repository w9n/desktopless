ip=169.254.9.9

mac(){
    hexdump -n3 -e'/3 "00:60:2f" 3/1 ":%02X"' /dev/random
}


dhcp=$ip,$ip,255.255.255.0,9999h
bridge_ip="${ip%.*}.254"
subnet=24
bridge_name=br0

ip link add $bridge_name address $(mac) type bridge
ip address add $bridge_ip/$subnet dev br0
ip link set br0 up

cat > /dnsmasq.conf <<- EOM
    bind-interfaces
    dhcp-authoritive
    interface=$bridge_name
    listen-address=$bridge_ip
    dhcp-range=$dhcp
    except-interface=lo
    dhcp-option=6,8.8.8.8
    log-queries
    log-dhcp
EOM

echo "dnsmasq.conf written to /dnsmasq.conf"
dnsmasq --conf-file=/dnsmasq.conf

iptables -A FORWARD -i $bridge_name ! -o $bridge_name -j ACCEPT
iptables -A FORWARD -i $bridge_name -o $bridge_name -j ACCEPT
iptables -t nat -A PREROUTING -p tcp --dport 5930 -j ACCEPT
iptables -t nat -A PREROUTING -i eth0 -j DNAT --to-destination $ip
iptables -t nat -A POSTROUTING -s $bridge_ip/$subnet ! -d $bridge_ip/$subnet -j MASQUERADE

echo "allow $bridge_name" >> /etc/qemu/bridge.conf
