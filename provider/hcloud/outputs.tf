output "server_ips" {
  value = hcloud_server.host[*].ipv4_address
}

output "private_network_interface" {
  value = "eth0"
}

output "k8s_master_nodes" {
  value = {
		 for i in hcloud_server.host[*] : 
		 i.name => i.ipv4_address
     if lookup(i.labels,"k8s_server_type") == "master"
	}
}

output "k8s_worker_nodes" {
  value = {
		 for i in hcloud_server.host[*] : 
		 i.name => i.ipv4_address
     if lookup(i.labels,"k8s_server_type") == "worker"
	}
}
