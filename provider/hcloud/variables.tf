variable "provider_token" {
  type = "string"
}

variable "provider_ssh_key_names" {
  type = "list"
}

variable "ssh_private_key_path" {
  type = "string"
}

variable "provider_server_image" {
  type = "string"
	default = "ubuntu-18.04"
}

variable "provider_server_type" {
  type = "string"
	default = "cx21"
}

variable "provider_hostname_format" {
	type = "string"
  default = "kube-%s-%s"
}

variable "k8s_master_nodes_count" {
	type = "string"
}

variable "k8s_worker_nodes_count" {
	type = "string"
}