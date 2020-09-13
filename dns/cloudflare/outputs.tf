output "dns_servers_ips" {
  value = concat(
    split("\n", trimspace(data.http.cloudflare_ip4_addrs.body)),
    split("\n", trimspace(data.http.cloudflare_ip6_addrs.body))
  )
}