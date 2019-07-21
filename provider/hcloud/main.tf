provider "hcloud" {
	version = "~> 1.11"
	token 	= var.provider_token
}

resource "hcloud_server" "host" {
  name        = format(var.provider_hostname_format, count.index < var.k8s_master_nodes_count? "master" : "worker", count.index + 1)
  image       = var.provider_server_image
  server_type = var.provider_server_type
  count 			= var.k8s_master_nodes_count+var.k8s_worker_nodes_count
	ssh_keys		= var.provider_ssh_key_names
	labels			= map("k8s_server_type", count.index < var.k8s_master_nodes_count? "master" : "worker")

	connection {
    host = self.ipv4_address
		private_key = file(var.ssh_private_key_path)
  }

  provisioner "remote-exec" {
    inline = [
			"while fuser /var/lib/apt/lists/lock >/dev/null 2>&1; do sleep 1; done",
      "apt-get update",
      "apt-get install -yq ufw python-minimal python-setuptools"
    ]
  }
}