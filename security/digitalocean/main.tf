provider "digitalocean" {
  version = "~> 1.22"
  token   = var.provider_client_secret
}

resource "digitalocean_firewall" "inbound_dns" {
  name = format("%s-%s", var.project_name, "firewall")
  tags = [var.project_name]

  inbound_rule {
    protocol         = "tcp"
    port_range       = "80"
    source_addresses = var.dns_servers_ips
  }

  inbound_rule {
    protocol         = "tcp"
    port_range       = "443"
    source_addresses = var.dns_servers_ips
  }

  inbound_rule {
    protocol         = "tcp"
    port_range       = "22"
    source_addresses = var.dns_servers_ips
  }

}