variable "provider_token" {
  type = string
}

variable "provider_server_image" {
  type    = string
  default = "ubuntu-18.04"
}

variable "provider_server_type" {
  type    = string
  default = "cx21"
}

variable "provider_hostname_format" {
  type    = string
  default = "kube-%s-%s"
}

variable "provider_private_network_ip_range" {
  type    = string
  default = "10.0.0.0/8"
}

variable "provider_private_network_subnet_ip_range" {
  type    = string
  default = "10.0.0.0/24"
}

variable "provider_network_zone" {
  type    = string
  default = "eu-central"
}

variable "provider_floating_ip_location" {
  type    = string
  default = "nbg1"
}

variable "master_nodes_count" {
  type = string
}

variable "worker_nodes_count" {
  type = string
}