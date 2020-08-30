provider "digitalocean" {
  version = "~> 1.22"
  token   = var.provider_client_secret
}

resource "digitalocean_project" "main" {
  name      = var.project_name
  resources = list(digitalocean_loadbalancer.public.urn)
}

resource "digitalocean_vpc" "default" {
  name   = format("%s-%s", var.project_name, "network")
  region = var.provider_region
}

resource "digitalocean_kubernetes_cluster" "default" {
  name     = var.project_name
  region   = var.provider_region
  version  = var.provider_k8s_version
  vpc_uuid = digitalocean_vpc.default.id

  node_pool {
    name       = "application-pool"
    tags       = ["app", var.project_name]
    size       = var.provider_worker_node_type
    node_count = var.provider_worker_nodes_count
  }
}

resource "digitalocean_kubernetes_node_pool" "system_pool" {
  cluster_id = digitalocean_kubernetes_cluster.default.id

  name       = "system-pool"
  size       = var.provider_worker_system_node_type
  min_nodes  = var.provider_worker_system_nodes_count_min
  max_nodes  = var.provider_worker_system_nodes_count_max
  tags       = ["system", var.project_name]
  auto_scale = true

  labels = {
    service  = "system"
    priority = "high"
  }
}

resource "digitalocean_loadbalancer" "public" {
  name        = format("%s-%s", var.project_name, "load-balancer")
  region      = var.provider_region
  droplet_tag = var.project_name
  vpc_uuid    = digitalocean_vpc.default.id

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