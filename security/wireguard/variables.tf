variable "server_count" {
  type = string
}

variable "hosts" {
  type = list(string)
}

variable "hostnames" {
  type = list(string)
}

variable "ssh_private_key" {
	type = string
}


variable "private_ips" {
  type = list
}

variable "vpn_interface" {
  default = "wg0"
}

variable "vpn_port" {
  default = "51820"
}

variable "overlay_cidr" {
  type = string
}

variable "vpn_iprange" {
  default = "10.0.1.0/24"
}