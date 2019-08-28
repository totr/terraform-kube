resource "null_resource" "wireguard" {
  count = var.server_count

  triggers = {
    count = var.server_count
  }

  connection {
    host        = element(var.hosts, count.index)
    private_key = var.ssh_private_key
  }

  provisioner "remote-exec" {
    inline = [
      "echo net.ipv4.ip_forward=1 >> /etc/sysctl.conf",
      "sysctl -p",
    ]
  }

  provisioner "remote-exec" {
    inline = [
      "apt-get install -yq software-properties-common build-essential",
      "add-apt-repository -y ppa:wireguard/wireguard",
      "apt-get update",
    ]
  }

  provisioner "remote-exec" {
    script = "${path.module}/scripts/install-kernel-headers.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "DEBIAN_FRONTEND=noninteractive apt-get install -yq wireguard-dkms wireguard-tools",
    ]
  }

  provisioner "file" {
    content = templatefile("${path.module}/templates/interface.conf", {
      address     = element(data.template_file.vpn_ips[*].rendered, count.index)
      private_key = element(data.external.keys[*].result.private_key, count.index)
      port        = var.vpn_port
      peers       = replace(join("\n", data.template_file.peer-conf[*].rendered), element(data.template_file.peer-conf[*].rendered, count.index), "")
    })
    destination = "/etc/wireguard/${var.vpn_interface}.conf"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod 700 /etc/wireguard/${var.vpn_interface}.conf",
    ]
  }

  provisioner "remote-exec" {
    inline = [
      join("\n", formatlist("echo '%s %s' >> /etc/hosts", data.template_file.vpn_ips[*].rendered, var.hostnames)),
      "systemctl is-enabled wg-quick@${var.vpn_interface} || systemctl enable wg-quick@${var.vpn_interface}",
      "systemctl daemon-reload",
      "systemctl restart wg-quick@${var.vpn_interface}",
    ]
  }

  provisioner "file" {
    content = templatefile("${path.module}/templates/overlay-route.service", {
      address      = element(data.template_file.vpn_ips[*].rendered, count.index)
      overlay_cidr = var.overlay_cidr
    })
    destination = "/etc/systemd/system/overlay-route.service"
  }

  provisioner "remote-exec" {
    inline = [
      "systemctl is-enabled overlay-route.service || systemctl enable overlay-route.service",
      "systemctl daemon-reload",
      "systemctl start overlay-route.service",
    ]
  }

}

data "template_file" "peer-conf" {
  count    = var.server_count
  template = file("${path.module}/templates/peer.conf")

  vars = {
    endpoint    = element(var.private_ips, count.index)
    port        = var.vpn_port
    public_key  = element(data.external.keys[*].result.public_key, count.index)
    allowed_ips = "${element(data.template_file.vpn_ips[*].rendered, count.index)}/32"
  }
}

data "external" "keys" {
  count = var.server_count

  program = ["sh", "${path.module}/scripts/gen_keys.sh"]
}

data "template_file" "vpn_ips" {
  count    = var.server_count
  template = "$${ip}"

  vars = {
    ip = cidrhost(var.vpn_iprange, count.index + 1)
  }
}