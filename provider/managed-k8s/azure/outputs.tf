output "kubeconfig" {
  value = azurerm_kubernetes_cluster.default.kube_config_raw
}

output "loadbalancer_ip" {
  value = data.azurerm_public_ip.default.ip_address
}

output "loadbalancer_kubernetes_annotations" {
  value = {
    "service.beta.kubernetes.io/azure-load-balancer-tcp-idle-timeout" = "30"
  }
}