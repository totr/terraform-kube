provider "cloudflare" {
  version = "~> 1.18"
  email = var.email
  token = var.api_token
}

resource "cloudflare_record" "domain" {
  domain  = var.domain
  name    = var.domain
  value   = element(var.public_ips, 0)
  type    = "A"
  proxied = true
}

resource "cloudflare_record" "wildcard" {
  depends_on = ["cloudflare_record.domain"]

  domain  = var.domain
  name    = "*"
  value   = var.domain
  type    = "CNAME"
  proxied = false
}