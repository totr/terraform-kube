provider "digitalocean" {
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

resource "digitalocean_project" "main" {
  name      = var.project_name
  resources = concat(list(digitalocean_loadbalancer.public.urn), digitalocean_droplet.host[*].urn)
}

resource "digitalocean_ssh_key" "terraform-key" {
  name       = format("%s-%s", var.project_name, "terraform-key")
  public_key = tls_private_key.access_key.public_key_openssh
}

resource "digitalocean_loadbalancer" "public" {
  name   = format("%s-%s", var.project_name, "load-balancer")
  region = var.provider_region

  forwarding_rule {
    entry_port     = 80
    entry_protocol = "tcp"

    target_port     = var.lb_forwarding_target_http_port
    target_protocol = "tcp"
  }

  forwarding_rule {
    entry_port     = 443
    entry_protocol = "tcp"

    target_port     = var.lb_forwarding_target_https_port
    target_protocol = "tcp"
  }

  forwarding_rule {
    entry_port     = 22
    entry_protocol = "tcp"

    target_port     = var.lb_forwarding_target_ssh_port
    target_protocol = "tcp"
  }

  healthcheck {
    port     = var.lb_forwarding_target_health_port
    protocol = "tcp"
  }

  droplet_ids = [for host in digitalocean_droplet.host[*] : host.id if contains(host.tags, "worker")]
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
  user_data          = "${file(local.cloud_config_path)}"

  connection {
    host        = self.ipv4_address
    private_key = tls_private_key.access_key.private_key_pem
  }

  provisioner "remote-exec" {
    inline = [
      "until [ -f /var/lib/cloud/instance/boot-finished ]; do sleep 1; done",
      "curl -sSL https://repos.insights.digitalocean.com/install.sh | sudo bash"
    ]
  }
}
