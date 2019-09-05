output "ssh_private_key" {
  value = module.provider.ssh_private_key
}

output "kubespray_inventory" {
  value = module.provisioner.inventory
}

output "kubespray_cluster_vars" {
  value = module.provisioner.cluster_vars
}

output "kubespray_addons_vars" {
  value = module.provisioner.addons_vars
}
