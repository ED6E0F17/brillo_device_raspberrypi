#!/system/bin/sh
#
# Set up default firewall rules.

BINPATH=/system/bin

# IPv4 only rules.
iptables_icmp_setup() {
  ${BINPATH}/iptables -A INPUT -p icmp -j ACCEPT -w
}

iptables_mdns_setup() {
  ${BINPATH}/iptables -A INPUT -p udp --destination 224.0.0.251 --dport 5353 -j ACCEPT -w
}


# IPv6 only rules.
ip6tables_icmp_setup() {
  ${BINPATH}/ip6tables -A INPUT -p ipv6-icmp -j ACCEPT -w

  # Allow all outbound ICMPv6 traffic.  This is important for things like
  # neighbor discovery and address negotiation.
  ${BINPATH}/ip6tables -A OUTPUT -p ipv6-icmp -j ACCEPT -w
}

ip6tables_mdns_setup() {
  ${BINPATH}/ip6tables -A INPUT -p udp --destination FF02::FB --dport 5353 -j ACCEPT -w
}


# Install all IPv4 and IPv6 rules.
for iptables in ip{,6}tables; do
  iptables_bin=${BINPATH}/${iptables}
  [ -x ${iptables_bin} ] || continue

  # Set default policy to DROP.
  ${iptables_bin} -P INPUT DROP -w
  ${iptables_bin} -P FORWARD DROP -w
  ${iptables_bin} -P OUTPUT DROP -w

  # Accept everything on the loopback.
  ${iptables_bin} -I INPUT -i lo -j ACCEPT -w
  ${iptables_bin} -I OUTPUT -o lo -j ACCEPT -w

  # Accept return traffic inbound.
  ${iptables_bin} -I INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT -w

  # Accept icmp echo (NB: icmp echo ratelimiting is done by the kernel).
  ${iptables}_icmp_setup

  # Accept new and return traffic outbound.
  ${iptables_bin} -I OUTPUT -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT -w

  # Accept inbound mDNS traffic.
  ${iptables}_mdns_setup

  # Accept DHCP traffic (communicating as either client or server).
  ${iptables_bin} -I INPUT -p udp --dport 67:68 --sport 67:68 -j ACCEPT -w
  ${iptables_bin} -I OUTPUT -p udp --dport 67:68 --sport 67:68 -j ACCEPT -w
done


# Set completion property.
setprop firewall.init 1
