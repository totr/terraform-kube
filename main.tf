provider "local" {
	version = "~> 1.3"
}

provider "null" {
	version = "~> 2.1"
}

module "provider" {
  source = "./provider/hcloud"

	provider_token 								= var.provider_token
	provider_ssh_key_names 				= var.provider_ssh_key_names
	ssh_private_key_path 					= var.ssh_private_key_path
	k8s_master_nodes_count				= var.k8s_master_nodes_count
	k8s_worker_nodes_count				= var.k8s_worker_nodes_count
}

module "security" {
  source = "./security/ufw"

	ssh_private_key_path 		= var.ssh_private_key_path
	server_count 						= var.k8s_master_nodes_count+var.k8s_worker_nodes_count
	server_connections 			= module.provider.server_ips
	private_interface 			= module.provider.private_network_interface
}

module "provisioner" {
  source = "./provisioner/ansible"

	k8s_master_nodes = module.provider.k8s_master_nodes
	k8s_worker_nodes = module.provider.k8s_worker_nodes
}