variable "project_name" {
  type = string
}

variable "provider_subscription_id" {
  type = string
}

variable "provider_tenant_id" {
  type = string
}

variable "provider_client_id" {
  type = string
}

variable "provider_client_secret" {
  type = string
}

variable "provider_private_network_ip_range" {
  type    = string
  default = "10.1.0.0/16"
}

variable "provider_private_network_subnet_ip_range" {
  type    = string
  default = "10.1.0.0/22"
}

variable "provider_k8s_version" {
  type    = string
  default = "1.18.14"
}

variable "provider_region" {
  type    = string
  default = "westeurope"
}

variable "provider_availability_zones" {
  type    = list(string)
  default = ["1", "2"]
}

variable "provider_worker_node_type" {
  type    = string
  default = "Standard_DS2_v2"
}

variable "provider_worker_nodes_count" {
  type    = string
  default = "2"
}

variable "provider_worker_system_node_type" {
  type    = string
  default = "Standard_DS2_v2"
}

variable "provider_worker_system_nodes_count" {
  type    = string
  default = "3"
}