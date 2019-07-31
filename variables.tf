variable "provider_token" {
  type = string
}

variable "provider_ssh_key_names" {
  type = list(string)
}

variable "ssh_private_key_path" {
  type = string
}

variable "master_nodes_count" {
  type    = string
  default = "1"
}

variable "worker_nodes_count" {
  type    = string
  default = "2"
}

variable "kube_service_addresses" {
  type    = string
  default = "10.96.0.0/16"
}

variable "kube_pods_subnet" {
  type    = string
  default = "172.16.0.0/16"
}


variable "kube_overlay_interface" {
  type    = string
  default = "kube-ipvs0"
}