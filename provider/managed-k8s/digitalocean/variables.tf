variable "project_name" {
  type = string
}

variable "provider_client_secret" {
  type = string
}

variable "provider_k8s_version" {
  type    = string
  default = "1.18.10-do.0"
}

variable "provider_region" {
  type    = string
  default = "fra1"
}

variable "provider_worker_node_type" {
  type    = string
  default = "g-4vcpu-16gb"
}

variable "provider_worker_nodes_count" {
  type    = string
  default = "2"
}

variable "provider_worker_system_node_type" {
  type    = string
  default = "g-2vcpu-8gb"
}

variable "provider_worker_system_nodes_count_min" {
  type    = string
  default = "2"
}

variable "provider_worker_system_nodes_count_max" {
  type    = string
  default = "3"
}