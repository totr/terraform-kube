output "kubeconfig" {
  value = digitalocean_kubernetes_cluster.default.kube_config.0.raw_config
}

output "loadbalancer_ip" {
  value = digitalocean_loadbalancer.public.ip
}

output "loadbalancer_kubernetes_annotations" {
  value = {
    "kubernetes.digitalocean.com/load-balancer-id" = digitalocean_loadbalancer.public.id
  }
}