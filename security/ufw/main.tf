locals {
  ufw_script = templatefile("${path.module}/scripts/ufw.sh", {
    private_interface      = var.private_interface
    vpn_port               = var.vpn_port
    vpn_interface          = var.vpn_interface
    kube_overlay_interface = var.kube_overlay_interface
  })
}

resource "null_resource" "firewall" {
  count = var.server_count

  connection {
    host        = element(var.hosts, count.index)
    private_key = var.ssh_private_key
  }

  provisioner "remote-exec" {
    inline = [local.ufw_script]
  }
}