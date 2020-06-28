output "loadbalancer_ip" {
  value = module.provider.loadbalancer_ip
}

output "loadbalancer_uuid" {
  value = module.provider.loadbalancer_uuid
}

output "loadbalancer_kubernetes_annotation" {
  value = module.provider.loadbalancer_kubernetes_annotation
}

output "kubeconfig" {
  value = module.provider.kubeconfig
}
