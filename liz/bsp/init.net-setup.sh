#!/system/bin/sh
echo heartbeat > /sys/class/leds/led0/trigger

# Setup networking when boot starts
ifconfig usb0 10.10.10.10 netmask 255.255.255.0 up
route add default gw 10.10.10.1

# Open up port 5555 for adb
iptables -I INPUT -p tcp --dport 5555 -j ACCEPT -w

# Shill enables dnsmasq so we can access hosts on the Internet.
# Bionic hard-wires DNS requests to go to 0.0.0.0, so this acts as a DNS proxy.

#dnsmasq --no-hosts --listen-address=127.0.0.1 --no-resolv --server=8.8.8.8 \
#  --pid-file < /dev/null

setprop net.init 1
