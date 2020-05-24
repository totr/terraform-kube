resource "local_file" "ssh_key" {
    content     = "foo!"
    filename = "/root/.ssh/.id_rsa"
}

data "local_file" "data" {
    filename = local_file.ssh_key.filename
}

