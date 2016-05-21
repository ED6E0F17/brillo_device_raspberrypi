#!/system/bin/sh
echo heartbeat > /sys/class/leds/led0/trigger

# Testing only: Setup wired networking
# RPI Model A/Zero gadget mode:
ifconfig usb0 10.10.10.10 netmask 255.255.255.0 up && ip route add default via 10.10.10.1 \
&& dnsmasq --no-hosts --listen-address=127.0.0.1 --no-resolv --server=10.10.10.1 --pid-file < /dev/null
# RPI Model B, 2B:
ifconfig eth0 192.168.1.10 netmask 255.255.255.0 up && ip route add default via 192.168.1.1 \
&& dnsmasq --no-hosts --listen-address=127.0.0.1 --no-resolv --server=192.168.1.1 --pid-file < /dev/null

# Shill enables dnsmasq so we can access hosts on the Internet.
# Bionic hard-wires DNS requests to go to 0.0.0.0, so this acts as a DNS proxy.

# Set completion property.
setprop net-setup.complete 1
