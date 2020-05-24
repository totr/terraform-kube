output "public_ips" {
  value = list("")
}

output "admin_user" {
  value = var.provider_admin_user
}

output "private_ips" {
  value = ""
}

output "hostnames" {
  value = ""
}

output "private_network_interface" {
  value = "eth1"
}

output "ssh_private_key" {
  value = ""
}

output "master_nodes" {
  value = list(object())
}

output "worker_nodes" {
  value = list(object())
}

output "cloud_provider_load_balancer" {
  value = false
}

output "dns_ip" {
  value = ""
}