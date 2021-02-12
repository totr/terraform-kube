locals {
  zone_id    = lookup(data.cloudflare_zones.domain_zones.zones[0], "id")
  subdomains = reverse(split(".", var.a_domain))
}

provider "cloudflare" {
  email   = var.admin_email
  api_key = var.api_token
}

data "cloudflare_zones" "domain_zones" {
  filter {
    name   = format("%s.%s", local.subdomains[1], local.subdomains[0])
    status = "active"
    paused = false
  }
}

resource "cloudflare_record" "wildcard_domain" {
  zone_id = local.zone_id
  name    = var.a_domain
  value   = var.ip_address
  type    = "A"
  proxied = false
}

resource "cloudflare_record" "domain" {
  depends_on = [cloudflare_record.domain]

  zone_id = local.zone_id
  name    = var.cname_domain
  value   = var.root_domain
  type    = "CNAME"
  proxied = true
}
