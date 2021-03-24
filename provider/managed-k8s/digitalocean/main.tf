provider "digitalocean" {
  token = var.provider_client_secret
}

resource "digitalocean_project" "main" {
  count = "${var.default_box ? 1 : 0}"
  name      = var.project_name
  resources = list(digitalocean_loadbalancer.public.urn)
}

resource "digitalocean_vpc" "default" {
  count = "${var.default_box ? 1 : 0}"
  name   = format("%s-%s", var.project_name, "network")
  region = var.provider_region

  # see https://github.com/digitalocean/terraform-provider-digitalocean/issues/488
  timeouts {
    delete = "10m"
  }
}

data "digitalocean_vpc" "get" {
  name   = format("%s-%s", var.project_name, "network")
}

resource "digitalocean_kubernetes_cluster" "default" {
  name     = format("%s-%s", var.project_name, var.cluster_name)
  region   = var.provider_region
  version  = var.provider_k8s_version
  vpc_uuid = data.digitalocean_vpc.get.id

  node_pool {
    name       = "application-pool"
    tags       = ["app", format("%s-%s", var.project_name, var.cluster_name)]
    size       = var.provider_worker_node_type
    node_count = var.provider_worker_nodes_count
  }
}

resource "digitalocean_kubernetes_node_pool" "system_pool" {
  cluster_id = digitalocean_kubernetes_cluster.default.id

  name        = "system-pool"
  size        = var.provider_worker_system_node_type
  node_count  = var.provider_worker_system_nodes_count
  tags        = ["system", format("%s-%s", var.project_name, var.cluster_name)]

  labels = {
    service  = "system"
    priority = "high"
  }
}

resource "digitalocean_loadbalancer" "public" {
  name        = format("%s-%s-%s", var.project_name, var.cluster_name, "load-balancer")
  region      = var.provider_region
  droplet_tag = format("%s-%s", var.project_name, var.cluster_name)
  vpc_uuid    = data.digitalocean_vpc.get.id

  forwarding_rule {
    entry_port      = 80
    entry_protocol  = "tcp"
    target_port     = 30080
    target_protocol = "tcp"
  }

  forwarding_rule {
    entry_port      = 443
    entry_protocol  = "tcp"
    target_port     = 30443
    target_protocol = "tcp"
  }

  forwarding_rule {
    entry_port      = 22
    entry_protocol  = "tcp"
    target_port     = 30022
    target_protocol = "tcp"
  }

  healthcheck {
    port     = 30020
    protocol = "tcp"
  }

}