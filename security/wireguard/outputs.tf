output "vpn_interface" {
  value = var.vpn_interface
}

output "vpn_port" {
  value = var.vpn_port
}

output "vpn_ips" {
  value = zipmap(var.private_ips, data.template_file.vpn_ips[*].rendered)
}