output "public_ips" {
  value = digitalocean_droplet.host[*].ipv4_address
}

output "admin_user" {
  value = var.provider_admin_user
}

output "private_ips" {
  value = digitalocean_droplet.host[*].ipv4_address_private
}

output "hostnames" {
  value = digitalocean_droplet.host[*].name
}

output "private_network_interface" {
  value = "eth1"
}

output "ssh_private_key" {
  value = tls_private_key.access_key.private_key_pem
}

output "floating_ip" {
  value = digitalocean_floating_ip.master.ip_address
}

output "master_nodes" {
  value = flatten([
    for i in digitalocean_droplet.host[*] : {
      name       = i.name
      public_ip  = i.ipv4_address
      private_ip = i.ipv4_address_private
    }
    if contains(i.tags, "master") == true
  ])
}

output "worker_nodes" {
  value = flatten([
    for i in digitalocean_droplet.host[*] : {
      name       = i.name
      public_ip  = i.ipv4_address
      private_ip = i.ipv4_address_private
    }
    if contains(i.tags, "worker") == true
  ])
}