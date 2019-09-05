locals {
  inventory = templatefile("${path.module}/templates/hosts.ini", {
    all_nodes    = concat(var.master_nodes, var.worker_nodes)
    master_nodes = var.master_nodes
    worker_nodes = var.worker_nodes
  })

  cluster_vars = templatefile("${path.module}/templates/k8s-cluster.yml", {
    kube_service_addresses = var.kube_service_addresses
    kube_pods_subnet       = var.kube_pods_subnet
  })

	addons_vars = templatefile("${path.module}/templates/addons.yml", {

  })
}