output "ssh_key" {
  value = var.local_file.data.content
}
output "url" {
  value = ""
  #value ="qemu+ssh://tt@10.211.55.5/system"
}