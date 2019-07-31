provider "hcloud" {
  version = "~> 1.11"
  token   = var.provider_token
}

resource "hcloud_server" "host" {
  name        = format(var.provider_hostname_format, count.index < var.master_nodes_count ? "master" : "worker", count.index + 1)
  image       = var.provider_server_image
  server_type = var.provider_server_type
  count       = var.master_nodes_count + var.worker_nodes_count
  ssh_keys    = var.provider_ssh_key_names
  labels      = map("server_type", count.index < var.master_nodes_count ? "master" : "worker")

  connection {
    host        = self.ipv4_address
    private_key = file(var.ssh_private_key_path)
  }

  provisioner "remote-exec" {
    inline = [
      "while fuser /var/lib/apt/lists/lock >/dev/null 2>&1; do sleep 1; done",
      "apt-get update",
      "apt-get install -yq ufw python-minimal python-setuptools"
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