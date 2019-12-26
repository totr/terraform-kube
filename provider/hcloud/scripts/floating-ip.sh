#!/bin/sh
set -e

cat > /etc/network/interfaces.d/60-floating-ip.cfg <<EOM
auto eth0:1
iface eth0:1 inet static
  address ${floating_ip}
  netmask 32
EOM

systemctl restart networking.service