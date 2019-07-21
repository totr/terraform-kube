locals {
	ufw_script = templatefile("${path.module}/scripts/ufw.sh", { private_interface	= var.private_interface })
}

resource "null_resource" "firewall" {
  count = var.server_count

  connection {
    host  = element(var.server_connections, count.index)
    private_key = file(var.ssh_private_key_path)
  }

  provisioner "remote-exec" {
    inline = [local.ufw_script]
  }

}