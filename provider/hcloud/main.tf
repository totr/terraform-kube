provider "hcloud" {
  version = "~> 1.15"
  token   = var.provider_client_secret
}

locals {
  cloud_config_path = "${path.module}/../templates/cloud-config.txt"
}

resource "tls_private_key" "access_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "hcloud_ssh_key" "terraform-key" {
  name       = "terraform-key"
  public_key = tls_private_key.access_key.public_key_openssh
}

resource "hcloud_server" "host" {
  name        = format(var.provider_hostname_format, var.project_name, count.index < var.master_nodes_count ? "master" : "worker", count.index + 1)
  image       = var.provider_server_image
  server_type = count.index < var.master_nodes_count ? var.provider_server_master_type : var.provider_server_worker_type
  count       = var.master_nodes_count + var.worker_nodes_count
  ssh_keys    = [hcloud_ssh_key.terraform-key.name]
  labels      = map("server_type", count.index < var.master_nodes_count ? "master" : "worker")
  user_data   = "${file(local.cloud_config_path)}"

  connection {
    host        = self.ipv4_address
    private_key = tls_private_key.access_key.private_key_pem
  }

  provisioner "remote-exec" {
    inline = [
      "until [ -f /var/lib/cloud/instance/boot-finished ]; do sleep 1; done"
    ]
  }
}

resource "hcloud_network" "privatenw" {
  name     = "private_network"
  ip_range = var.provider_private_network_ip_range
}

resource "hcloud_network_subnet" "privatesubnet" {
  network_id   = hcloud_network.privatenw.id
  type         = "server"
  network_zone = var.provider_network_zone
  ip_range     = var.provider_private_network_subnet_ip_range
}

resource "hcloud_server_network" "srvethn" {
  network_id = hcloud_network.privatenw.id
  server_id  = element(hcloud_server.host[*].id, count.index)
  ip         = cidrhost(hcloud_network_subnet.privatesubnet.ip_range, count.index + 2)
  count      = var.master_nodes_count + var.worker_nodes_count
}

resource "hcloud_floating_ip" "master" {
  type          = "ipv4"
  home_location = var.provider_floating_ip_location
}

resource "hcloud_floating_ip_assignment" "main" {
  floating_ip_id = hcloud_floating_ip.master.id
  server_id      = element(hcloud_server.host[*].id, 0)
}

resource "null_resource" "host_floating_ip" {
  count = var.master_nodes_count + var.worker_nodes_count

  connection {
    host        = element(hcloud_server.host[*].ipv4_address, count.index)
    private_key = tls_private_key.access_key.private_key_pem
  }

  provisioner "remote-exec" {
    inline = [
      templatefile("${path.module}/scripts/floating-ip.sh", {
        floating_ip = hcloud_floating_ip.master.ip_address
      })
    ]
  }
}