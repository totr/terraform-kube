output "ssh_private_key" {
	value = module.provider.ssh_private_key
}

output "kubespray_inventory" {
  value = module.provisioner.inventory
}
output "kubespray_variables" {
  value = module.provisioner.variables
}
