variable "provider_token" {
  type = string
}

variable "domain" {
  type = string
}

variable "email" {
  type = string
}

variable "dns_api_token" {
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

variable "kube_network_plugin" {
  type    = string
  default = "weave"
}

variable "kube_overlay_interface" {
  type    = string
  default = "weave"
}