variable "master_nodes" {
  type = list(object({
    name       = string
    public_ip  = string
    private_ip = string
  }))
}

variable "worker_nodes" {
  type = list(object({
    name       = string
    public_ip  = string
    private_ip = string
  }))
}

variable "vpn_ips" {
  type = map
}

variable "kube_network_plugin" {
  type = string
}

variable "kube_service_addresses" {
  type = string
}

variable "kube_pods_subnet" {
  type = string
}