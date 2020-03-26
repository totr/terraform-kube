variable "server_count" {
  type = string
}
variable "hosts" {
  type = list(string)
}

variable "admin_user" {
  type = string
}

variable "ssh_private_key" {
  type = string
}

variable "private_interface" {
  type = string
}

variable "vpn_interface" {
  type = string
}

variable "vpn_port" {
  type = string
}

variable "kube_overlay_interface" {
  type = string
}

variable "lb_forwarding_target_http_port" {
  type = number
}

variable "lb_forwarding_target_https_port" {
  type = number
}

variable "lb_forwarding_target_health_port" {
  type = number
}

variable "lb_forwarding_target_ssh_port" {
  type = number
}