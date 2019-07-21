#!/bin/sh
set -e

ufw --force reset
ufw allow ssh
# TODO ufw allow in on ${private_interface} to any port vpn_port # vpn on private interface
# TODO ufw allow in on vpn_interface
# TODO ufw allow in on kubernetes_interface # Kubernetes pod overlay interface
ufw allow 6443 # Kubernetes API secure remote port
ufw allow 80
ufw allow 443
ufw default deny incoming
ufw --force enable
ufw status verbose