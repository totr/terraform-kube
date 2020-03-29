locals {
  ufw_script = templatefile("${path.module}/scripts/ufw.sh", {
    #private_interface                = var.private_interface
    #vpn_port                         = var.vpn_port
    #vpn_interface                    = var.vpn_interface
    #kube_overlay_interface           = var.kube_overlay_interface
    lb_forwarding_target_http_port   = var.lb_forwarding_target_http_port
    lb_forwarding_target_https_port  = var.lb_forwarding_target_https_port
    lb_forwarding_target_health_port = var.lb_forwarding_target_health_port
    lb_forwarding_target_ssh_port    = var.lb_forwarding_target_ssh_port
  })
}

resource "null_resource" "firewall" {
  count = var.server_count

  connection {
    host        = element(var.hosts, count.index)
    private_key = var.ssh_private_key
    user        = var.admin_user
  }

  provisioner "remote-exec" {
    inline = [local.ufw_script]
  }
}