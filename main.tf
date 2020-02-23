provider "local" {
  version = "~> 1.4"
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

provider "tls" {
  version = "~> 2.1"
}

module "provider" {
  source = "./provider/hcloud"

  provider_client_secret      = var.provider_client_secret
  provider_server_master_type = var.provider_server_master_type
  provider_server_worker_type = var.provider_server_worker_type
  master_nodes_count          = var.master_nodes_count
  worker_nodes_count          = var.worker_nodes_count
}

#module "provider" {
#  source = "./provider/azure"
#
#  provider_subscription_id   = var.azure_provider_subscription_id
#  provider_tenant_id         = var.azure_provider_tenant_id
#  provider_client_id         = var.azure_provider_client_id
#  provider_client_secret     = var.provider_client_secret
#  provider_server_master_type = var.provider_server_master_type
#  provider_server_worker_type = var.provider_server_worker_type
#  project_name               = var.project_name
#  master_nodes_count         = var.master_nodes_count
#  worker_nodes_count         = var.worker_nodes_count
#}

module "vpn" {
  source = "./security/wireguard"

  server_count    = var.master_nodes_count + var.worker_nodes_count
  hosts           = module.provider.public_ips
  admin_user      = module.provider.admin_user
  ssh_private_key = module.provider.ssh_private_key
  private_ips     = module.provider.private_ips
  hostnames       = module.provider.hostnames
  overlay_cidr    = var.kube_service_addresses
}

module "firewall" {
  source = "./security/ufw"

  server_count           = var.master_nodes_count + var.worker_nodes_count
  hosts                  = module.provider.public_ips
  admin_user             = module.provider.admin_user
  ssh_private_key        = module.provider.ssh_private_key
  private_interface      = module.provider.private_network_interface
  vpn_interface          = module.vpn.vpn_interface
  vpn_port               = module.vpn.vpn_port
  kube_overlay_interface = var.kube_overlay_interface
}

module "dns" {
  source = "./dns/cloudflare"

  floating_ip = module.provider.floating_ip
  domain      = var.domain
  email       = var.email
  api_token   = var.dns_api_token
}

module "provisioner" {
  source = "./provisioner/kubespray"

  master_nodes           = module.provider.master_nodes
  worker_nodes           = module.provider.worker_nodes
  admin_user             = module.provider.admin_user
  vpn_ips                = module.vpn.vpn_ips
  floating_ip            = module.provider.floating_ip
  kube_network_plugin    = var.kube_network_plugin
  kube_service_addresses = var.kube_service_addresses
  kube_pods_subnet       = var.kube_pods_subnet
}