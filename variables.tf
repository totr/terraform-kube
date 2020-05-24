variable "azure_provider_subscription_id" {
  type    = string
  default = ""
}

variable "azure_provider_tenant_id" {
  type    = string
  default = ""
}

variable "azure_provider_client_id" {
  type    = string
  default = ""
}

variable "provider_client_secret" {
  type = string
  default = ""
}

variable provider_server_master_type {
  type = string
  default = ""
}

variable provider_server_worker_type {
  type = string
  default = ""
}

variable "project_name" {
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
  default = "flannel"
}

variable "kube_overlay_interface" {
  type    = string
  default = "flannel"
}

variable "lb_forwarding_target_health_port" {
  type    = number
  default = 30010
}

variable "lb_forwarding_target_http_port" {
  type    = number
  default = 30080
}

variable "lb_forwarding_target_https_port" {
  type    = number
  default = 30443
}

variable "lb_forwarding_target_ssh_port" {
  type    = number
  default = 30022
}