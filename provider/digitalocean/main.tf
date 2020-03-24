provider "digitalocean" {
  version = "~> 1.15"
  token   = var.provider_client_secret
}

resource "digitalocean_project" "main" {
  name = var.project_name
}

resource "digitalocean_project_resources" "main" {
  count   = var.master_nodes_count + var.worker_nodes_count
  project = digitalocean_project.main.id
  resources = [
    digitalocean_floating_ip.master.urn,
    element(digitalocean_droplet.host[*].urn, count.index)
  ]
}

resource "tls_private_key" "access_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "digitalocean_ssh_key" "terraform-key" {
  name       = format("%s-%s", var.project_name, "terraform-key")
  public_key = tls_private_key.access_key.public_key_openssh
}

resource "digitalocean_floating_ip" "master" {
  region = var.provider_region
}

resource "digitalocean_floating_ip_assignment" "main" {
  ip_address = digitalocean_floating_ip.master.ip_address
  droplet_id = element(digitalocean_droplet.host[*].id, 0)
}

resource "digitalocean_droplet" "host" {
  name               = format(var.provider_hostname_format, var.project_name, count.index < var.master_nodes_count ? "master" : "worker", count.index + 1)
  region             = var.provider_region
  image              = var.provider_server_image
  size               = count.index < var.master_nodes_count ? var.provider_server_master_type : var.provider_server_worker_type
  backups            = false
  private_networking = true
  ssh_keys           = [digitalocean_ssh_key.terraform-key.id]
  tags               = [count.index < var.master_nodes_count ? "master" : "worker"]
  count              = var.master_nodes_count + var.worker_nodes_count

  connection {
    host        = self.ipv4_address
    private_key = tls_private_key.access_key.private_key_pem
  }

  provisioner "remote-exec" {
    inline = [
      "until [ -f /var/lib/cloud/instance/boot-finished ]; do sleep 1; done",
      "apt-get update",
      "apt-get install -yq ufw python-minimal python-setuptools python-netaddr"
    ]
  }
}