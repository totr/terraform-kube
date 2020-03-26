output "admin_user" {
  value = var.provider_admin_user
}

output "public_ips" {
  value = azurerm_linux_virtual_machine.host[*].public_ip_address
}

output "private_ips" {
  value = azurerm_linux_virtual_machine.host[*].private_ip_address
}

output "hostnames" {
  value = azurerm_linux_virtual_machine.host[*].name
}

output "dns_ip" {
  value = azurerm_public_ip.balancer_ip.ip_address
}

output "private_network_interface" {
  value = "eth0"
}

output "ssh_private_key" {
  value = tls_private_key.access_key.private_key_pem
}

output "master_nodes" {
  value = flatten([
    for i in azurerm_linux_virtual_machine.host[*] : {
      name       = i.name
      public_ip  = i.public_ip_address
      private_ip = i.private_ip_address
    }
    if lookup(i.tags, "server_type") == "master"
  ])
}

output "worker_nodes" {
  value = flatten([
    for i in azurerm_linux_virtual_machine.host[*] : {
      name       = i.name
      public_ip  = i.public_ip_address
      private_ip = i.private_ip_address
    }
    if lookup(i.tags, "server_type") == "worker"
  ])
}

output "cloud_provider_load_balancer" {
  value = true
}