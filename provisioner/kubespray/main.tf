locals {
	default_inventory_path = "inventories/default/"
	inventory_name = "hosts.ini"
	extra_agrs_file_name = "variables.json"
}

resource "local_file" "kubespray_inventory" {
  filename = "${local.default_inventory_path}${local.inventory_name}"

  content = templatefile("${path.module}/templates/hosts.ini", {
    all_nodes    = concat(var.master_nodes, var.worker_nodes)
    master_nodes = var.master_nodes
    worker_nodes = var.worker_nodes
		inventory_path = local.default_inventory_path
  })
}

resource "local_file" "kubespray_variable" {
  filename = "${local.default_inventory_path}${local.extra_agrs_file_name}"

  content = templatefile("${path.module}/templates/variables.json", {
    kube_service_addresses = var.kube_service_addresses
    kube_pods_subnet       = var.kube_pods_subnet
  })
}