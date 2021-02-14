provider "azurerm" {
  features {}

  subscription_id = var.provider_subscription_id
  tenant_id       = var.provider_tenant_id
  client_id       = var.provider_client_id
  client_secret   = var.provider_client_secret
  // TODO parenterId
}

resource "azurerm_resource_group" "default" {
  name     = format("%s-%s", var.project_name, "resources")
  location = var.provider_region
}

resource "azurerm_virtual_network" "default" {
  name                = format("%s-%s", var.project_name, "network")
  resource_group_name = azurerm_resource_group.default.name
  location            = azurerm_resource_group.default.location
  address_space       = [var.provider_private_network_ip_range]
}

// TODO ddos_protection_plan
// TODO front_door

resource "azurerm_subnet" "internal" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.default.name
  virtual_network_name = azurerm_virtual_network.default.name
  address_prefixes     = [var.provider_private_network_subnet_ip_range]
}

resource "azurerm_kubernetes_cluster" "default" {
  name                = format("%s-%s", var.project_name, "aks")
  kubernetes_version  = var.provider_k8s_version
  location            = azurerm_resource_group.default.location
  resource_group_name = azurerm_resource_group.default.name
  dns_prefix          = format("%s-%s", var.project_name, "aks")

  default_node_pool {
    name                 = "system"
    orchestrator_version = var.provider_k8s_version
    vm_size              = var.provider_worker_system_node_type
    node_count           = var.provider_worker_system_nodes_count
    vnet_subnet_id       = azurerm_subnet.internal.id
    availability_zones   = var.provider_availability_zones
    // TODO  The AKS API has removed support for tainting all nodes in the default node pool and it is no longer possible to configure this. To taint a node pool, create a separate one
    //node_taints = [
    //  "system-app=false:NoExecute"
    //]

    node_labels = {
      service  = "system"
      priority = "high"
    }
    tags = {
      project = var.project_name
    }
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin    = "kubenet"
    load_balancer_sku = "Standard"
  }

  tags = {
    project = var.project_name
  }
}

resource "azurerm_kubernetes_cluster_node_pool" "system_pool" {
  kubernetes_cluster_id = azurerm_kubernetes_cluster.default.id
  name                  = "application"
  mode                  = "User"
  orchestrator_version  = var.provider_k8s_version
  vm_size               = var.provider_worker_node_type
  node_count            = var.provider_worker_nodes_count
  vnet_subnet_id        = azurerm_subnet.internal.id
  availability_zones    = var.provider_availability_zones
  tags = {
    project = var.project_name
  }
}

data "azurerm_public_ip" "default" {
  name                = reverse(split("/", tolist(azurerm_kubernetes_cluster.default.network_profile.0.load_balancer_profile.0.effective_outbound_ips)[0]))[0]
  resource_group_name = azurerm_kubernetes_cluster.default.node_resource_group
}