locals {
	all_servers_title = "[all]"
	all_connections = join("\n", formatlist("%s ansible_host=%s ansible_user=root",
		concat(keys(var.k8s_master_nodes),keys(var.k8s_worker_nodes)),
		concat(values(var.k8s_master_nodes),values(var.k8s_worker_nodes))))
	kube_masters_title = "[kube-master]"
	kube_masters = join("\n", keys(var.k8s_master_nodes))
	kube_workers_title = "[kube-node]"
	kube_workers = join("\n", keys(var.k8s_worker_nodes))
	kube_cluster_title = "[k8s-cluster:children]"
	kube_cluster = join("\n", ["kube-master","kube-node"])
	etcd_title = "[etcd]"

}

resource "local_file" "ansible_inventory" {
	filename = "ansible-hosts.ini"
	
	content = join("\n",[local.all_servers_title, local.all_connections, "",local.kube_masters_title, local.kube_masters,
		"",local.etcd_title, local.kube_masters,"",local.kube_workers_title, local.kube_workers, "", local.kube_cluster_title, local.kube_cluster])
}