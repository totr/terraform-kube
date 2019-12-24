output "public_ips" {
  value = hcloud_server.host[*].ipv4_address
}

output "private_ips" {
  value = hcloud_server_network.srvethn[*].ip
}

output "hostnames" {
  value = hcloud_server.host[*].name
}

output "private_network_interface" {
  value = "ens10"
}

output "ssh_private_key" {
  value = tls_private_key.access_key.private_key_pem
}

output "floating_ip_id" {
  value = hcloud_floating_ip.master.id
}

output "floating_ip" {
  value = hcloud_floating_ip.master.ip_address
}

output "master_nodes" {
  value = flatten([
    for i in hcloud_server.host[*] : {
      name       = i.name
      public_ip  = i.ipv4_address
      private_ip = hcloud_server_network.srvethn[index(hcloud_server.host[*], i)].ip
    }
    if lookup(i.labels, "server_type") == "master"
  ])
}

output "worker_nodes" {
  value = flatten([
    for i in hcloud_server.host[*] : {
      name       = i.name
      public_ip  = i.ipv4_address
      private_ip = hcloud_server_network.srvethn[index(hcloud_server.host[*], i)].ip
    }
    if lookup(i.labels, "server_type") == "worker"
  ])
}