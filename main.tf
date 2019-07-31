provider "local" {
  version = "~> 1.3"
}

provider "null" {
  version = "~> 2.1"
}

provider "external" {
  version = "~> 1.2"
}

provider "template" {
  version = "~> 2.1"
}

module "provider" {
  source = "./provider/hcloud"

  provider_token         = var.provider_token
  provider_ssh_key_names = var.provider_ssh_key_names
  ssh_private_key_path   = var.ssh_private_key_path
  master_nodes_count     = var.master_nodes_count
  worker_nodes_count     = var.worker_nodes_count
}

module "vpn" {
  source = "./security/wireguard"

  ssh_private_key_path = var.ssh_private_key_path
  server_count         = var.master_nodes_count + var.worker_nodes_count
  hosts                = module.provider.public_ips
  private_ips          = module.provider.private_ips
  hostnames            = module.provider.hostnames
  overlay_cidr         = var.kube_service_addresses
}

module "firewall" {
  source = "./security/ufw"

  ssh_private_key_path   = var.ssh_private_key_path
  server_count           = var.master_nodes_count + var.worker_nodes_count
  hosts                  = module.provider.public_ips
  private_interface      = module.provider.private_network_interface
  vpn_interface          = module.vpn.vpn_interface
  vpn_port               = module.vpn.vpn_port
  kube_overlay_interface = var.kube_overlay_interface
}

module "provisioner" {
  source = "./provisioner/kubespray"

  master_nodes           = module.provider.master_nodes
  worker_nodes           = module.provider.worker_nodes
  kube_service_addresses = var.kube_service_addresses
  kube_pods_subnet       = var.kube_pods_subnet
}