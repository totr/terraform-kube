locals {
  zone_id    = lookup(data.cloudflare_zones.domain_zones.zones[0], "id")
  subdomains = reverse(split(".", var.domain))
}

provider "cloudflare" {
  version = "~> 2.3"
  email   = var.email
  api_key = var.api_token
}

data "cloudflare_zones" "domain_zones" {
  filter {
    name   = format("%s.%s", local.subdomains[1], local.subdomains[0])
    status = "active"
    paused = false
  }
}

resource "cloudflare_record" "domain" {
  zone_id = local.zone_id
  name    = var.domain
  value   = var.floating_ip
  type    = "A"
  proxied = true
}

resource "cloudflare_record" "wildcard" {
  depends_on = [cloudflare_record.domain]

  zone_id = local.zone_id
  name    = format("%s.%s", "*", var.domain)
  value   = var.domain
  type    = "CNAME"
  proxied = false
}