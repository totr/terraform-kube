variable "provider_token" {
  type = "string"
}

variable "provider_ssh_key_names" {
  type = "list"
}

variable "ssh_private_key_path" {
  type = "string"
}

variable "k8s_master_nodes_count" {
  type = "string"
  default = "1"
}

variable "k8s_worker_nodes_count" {
  type = "string"
  default = "2"
}