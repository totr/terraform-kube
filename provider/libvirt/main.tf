# FIXME dynamic providers https://github.com/hashicorp/terraform/issues/3656,
# possibly using dynamic modules https://github.com/hashicorp/terraform/issues/17519

provider "libvirt" {
  version = "~> 0.6"
  uri     = "qemu+ssh://tt@10.211.55.5/system"
  alieas  = "hypervisor-1"
}

provider "libvirt" {
  version = "~> 0.6"
  uri     = "qemu+ssh://tt@10.211.55.5/system"
  alieas  = "hypervisor-2"
}

provider "libvirt" {
  version = "~> 0.6"
  uri     = "qemu+ssh://tt@10.211.55.5/system"
  alieas  = "hypervisor-3"
}

locals {
  hypervisors = ["libvirt.hypervisor-1", "libvirt.hypervisor-2", "libvirt.hypervisor-3"]
}

# https://www.reddit.com/r/Terraform/comments/cwp0d4/terraform_multi_region_question_can_i_just_use/

resource "libvirt_volume" "main" {
  name = "main-volume"
  pool = "images"
  source = var.provider_server_image
  format = "qcow2"
}

resource "libvirt_cloudinit_disk" "main" {
  name      = "main-init-disk"
  user_data = data.template_file.user_data.rendered
  # FIXME network_config = data.template_file.network_config.rendered
  pool = "data"
}

data "template_file" "user_data" {
  template = "${file(local.cloud_config_path)}"
}

#data "template_file" "network_config" {
#  template = file("/home/oxus/terraform/test-libvirt/network_config.cfg")
#}

resource "libvirt_domain" "host" {
  name = "ubuntu-terraform"
  memory = "512"
  vcpu = 1

  cloudinit = libvirt_cloudinit_disk.main.id

  network_interface {
    bridge = "br0"
  }

  # IMPORTANT
  # Ubuntu can hang is a isa-serial is not present at boot time.
  # If you find your CPU 100% and never is available this is why
  console {
    type        = "pty"
    target_port = "0"
    target_type = "serial"
  }

  console {
      type        = "pty"
      target_type = "virtio"
      target_port = "1"
  }

  disk {
      volume_id =  libvirt_volume.main.id
  }

  graphics {
    type = "spice"
    listen_type = "address"
    autoport = "true"
  }
}
