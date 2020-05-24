variable "provider_url" {
  type = string
}

variable "provider_client_secret" {
  type = string
}

variable "provider_admin_user" {
  type    = string
  default = "root"
}

variable "provider_server_image" {
  type    = string
  default = "https://cloud-images.ubuntu.com/releases/bionic/release/ubuntu-18.04-server-cloudimg-amd64.img"
}

variable "provider_server_master_type" {
  type    = string
  default = "s-2vcpu-2gb"
}

variable "provider_server_worker_type" {
  type    = string
  default = "s-4vcpu-8gb"
}

variable "provider_hostname_format" {
  type    = string
  default = "%s-%s-%s"
}

variable "provider_private_network_ip_range" {
  type    = string
  default = "10.0.0.0/8"
}

variable "provider_private_network_subnet_ip_range" {
  type    = string
  default = "10.0.0.0/24"
}

variable "project_name" {
  type = string
}

variable "master_nodes_count" {
  type = string
}

variable "worker_nodes_count" {
  type = string
}
