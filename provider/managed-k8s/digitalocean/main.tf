provider "digitalocean" {
  version = "~> 1.20"
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

resource "digitalocean_kubernetes_node_pool" "infra_pool" {
  cluster_id = digitalocean_kubernetes_cluster.default.id

  name       = "infra-pool"
  size       = var.provider_worker_infra_node_type
  min_nodes  = var.provider_worker_infra_nodes_count_min
  max_nodes  = var.provider_worker_infra_nodes_count_max
  tags       = ["infra", var.project_name]
  auto_scale = true

  labels = {
    service  = "infra"
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
    target_port     = 80
    target_protocol = "tcp"
  }

}