provider "azurerm" {
  version         = "=1.43.0"
  subscription_id = var.provider_subscription_id
  tenant_id       = var.provider_tenant_id
  client_id       = var.provider_client_id
  client_secret   = var.provider_client_secret
}

resource "tls_private_key" "access_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "azurerm_resource_group" "default" {
  name     = format("%s-%s", var.project_name, "resources")
  location = var.provider_network_zone
}

resource "azurerm_availability_set" "default" {
  name                = format("%s-%s", var.project_name, "availability-set")
  location            = azurerm_resource_group.default.location
  resource_group_name = azurerm_resource_group.default.name
  managed             = true
}

resource "azurerm_virtual_network" "default" {
  name                = format("%s-%s", var.project_name, "network")
  resource_group_name = azurerm_resource_group.default.name
  location            = azurerm_resource_group.default.location
  address_space       = [var.provider_private_network_ip_range]
}

resource "azurerm_subnet" "internal" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.default.name
  virtual_network_name = azurerm_virtual_network.default.name
  address_prefix       = var.provider_private_network_subnet_ip_range
}

resource "azurerm_public_ip" "vm_ip" {
  count               = var.master_nodes_count + var.worker_nodes_count
  name                = format("%s-%s", format(var.provider_hostname_format, count.index < var.master_nodes_count ? "master" : "worker", count.index + 1), "pip")
  location            = azurerm_resource_group.default.location
  resource_group_name = azurerm_resource_group.default.name
  allocation_method   = "Dynamic"
}

resource "azurerm_network_interface" "default" {
  count               = var.master_nodes_count + var.worker_nodes_count
  name                = format("%s-%s", format(var.provider_hostname_format, count.index < var.master_nodes_count ? "master" : "worker", count.index + 1), "nic")
  location            = azurerm_resource_group.default.location
  resource_group_name = azurerm_resource_group.default.name

  ip_configuration {
    name                          = "primary"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = element(azurerm_public_ip.vm_ip[*].id, count.index)
  }
}

resource "azurerm_network_security_group" "default" {
  name                = format("%s-%s", var.project_name, "nsg")
  resource_group_name = azurerm_resource_group.default.name
  location            = azurerm_resource_group.default.location

  security_rule {
    name                       = "AllowSSHInBound"
    description                = "Allows inbound internet traffic to SSH port"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
    access                     = "Allow"
    priority                   = 100
    direction                  = "Inbound"
  }

  security_rule {
    name                       = "AllowHTTPSInBound"
    description                = "Allows inbound internet traffic to HTTPS port"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
    access                     = "Allow"
    priority                   = 200
    direction                  = "Inbound"
  }
}

resource "azurerm_linux_virtual_machine" "host" {
  count                 = var.master_nodes_count + var.worker_nodes_count
  name                  = format(var.provider_hostname_format, var.project_name, count.index < var.master_nodes_count ? "master" : "worker", count.index + 1)
  resource_group_name   = azurerm_resource_group.default.name
  location              = azurerm_resource_group.default.location
  size                  = count.index < var.master_nodes_count ? var.provider_server_master_type : var.provider_server_worker_type
  admin_username        = var.provider_admin_user
  network_interface_ids = [element(azurerm_network_interface.default[*].id, count.index)]
  tags                  = map("server_type", count.index < var.master_nodes_count ? "master" : "worker")
  availability_set_id   = azurerm_availability_set.default.id

  admin_ssh_key {
    username   = var.provider_admin_user
    public_key = tls_private_key.access_key.public_key_openssh
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = var.provider_storage_account_type
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = var.provider_server_image
    version   = "latest"
  }

}

resource "azurerm_public_ip" "balancer_ip" {
  name                = format("%s-%s", var.project_name, "public-ip")
  location            = var.provider_network_zone
  resource_group_name = azurerm_resource_group.default.name
  allocation_method   = "Static"
}

resource "azurerm_lb" "public" {
  name                = format("%s-%s", var.project_name, "balancer")
  location            = var.provider_network_zone
  resource_group_name = azurerm_resource_group.default.name

  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.balancer_ip.id
  }
}

resource "azurerm_lb_backend_address_pool" "default" {
  name                = format("%s-%s", var.project_name, "address-pool")
  resource_group_name = azurerm_resource_group.default.name
  loadbalancer_id     = azurerm_lb.public.id
}

resource "azurerm_network_interface_backend_address_pool_association" "default" {
  count                   = var.master_nodes_count + var.worker_nodes_count
  backend_address_pool_id = azurerm_lb_backend_address_pool.default.id
  ip_configuration_name   = "primary"
  network_interface_id    = element(azurerm_network_interface.default.*.id, count.index)
}

resource "azurerm_lb_nat_rule" "http_access" {
  resource_group_name            = azurerm_resource_group.default.name
  loadbalancer_id                = azurerm_lb.public.id
  name                           = "HTTPSAccess"
  protocol                       = "Tcp"
  frontend_port                  = 443
  backend_port                   = 443
  frontend_ip_configuration_name = azurerm_lb.public.frontend_ip_configuration[0].name
}