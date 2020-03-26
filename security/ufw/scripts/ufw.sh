#!/bin/sh
set -e

sudo ufw --force reset
sudo ufw allow ssh
sudo ufw allow in on ${private_interface} to any port ${vpn_port} # vpn on private interface
sudo ufw allow in on ${vpn_interface}
sudo ufw allow in on ${kube_overlay_interface} # Kubernetes pod overlay interface
sudo ufw allow 6443 # Kubernetes API secure remote port
sudo ufw allow 80
sudo ufw allow 443
sudo ufw allow ${lb_forwarding_target_http_port}
sudo ufw allow ${lb_forwarding_target_https_port}
sudo ufw allow ${lb_forwarding_target_health_port}
sudo ufw allow ${lb_forwarding_target_ssh_port}
sudo ufw default deny incoming
sudo ufw --force enable
sudo ufw status verbose