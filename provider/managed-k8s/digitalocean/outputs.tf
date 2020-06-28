output "loadbalancer_ip" {
  value = digitalocean_loadbalancer.public.ip
}

output "loadbalancer_uuid" {
  value = digitalocean_loadbalancer.public.id
}

output "loadbalancer_kubernetes_annotation" {
  value = "kubernetes.digitalocean.com/load-balancer-id"
}

output "kubeconfig" {
  value = digitalocean_kubernetes_cluster.default.kube_config.0.raw_config
}
