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

variable "provider_admin_user" {
  type    = string
  default = "adminuser"
}

variable "provider_server_image" {
  type    = string
  default = "18.04-LTS"
}

variable "provider_server_master_type" {
  type    = string
  default = "Standard_B2s"
}

variable "provider_server_worker_type" {
  type    = string
  default = "Standard_B2s"
}

variable "provider_storage_account_type" {
  type    = string
  default = "Standard_LRS"
}

variable "provider_hostname_format" {
  type    = string
  default = "%s-%s-%s"
}

variable "provider_private_network_ip_range" {
  type    = string
  default = "10.0.0.0/16"
}

variable "provider_private_network_subnet_ip_range" {
  type    = string
  default = "10.0.2.0/24"
}

variable "provider_network_zone" {
  type    = string
  default = "westeurope"
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