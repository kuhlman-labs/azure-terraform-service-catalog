###
#  module composition
###

#resource group

module "resource_group" {
  source       = "../../resources/base/resource_group"
  service_name = "aks-cluster"
  region       = var.region
  environment  = var.environment
  tags         = var.tags
}

#subnets

module "subnet" {
  source               = "../../resources/network/subnet"
  resource_group       = var.virtual_network_resource_group
  region               = module.resource_group.location
  virtual_network_name = var.virtual_network_name
  name_prefixes        = ["snet-aks-nodes"]
  address_prefixes     = var.address_prefix_aks
  environment          = var.environment
}

#aks cluster

module "aks" {
  source                       = "../../resources/container/kubernetes_cluster"
  resource_group               = module.resource_group.name
  region                       = module.resource_group.location
  environment                  = var.environment
  node_pool_name               = "default"
  vm_size                      = var.vm_size
  availability_zones           = null
  node_count                   = 1
  vnet_subnet_id               = element(module.subnet.id, 0)
  log_analytics_workspace_id   = var.log_analytics_workspace_id
  aci_connector_linux_enabled  = false
  linux_profile_admin_username = "brkuhlma"
  linux_profile_key_data       = file("~/.ssh/id_rsa.pub")
  network_plugin               = "azure"
  network_policy               = "azure"
  service_cidr                 = var.service_cidr
  dns_service_ip               = var.dns_service_ip
  docker_bridge_cidr           = var.docker_bridge_cidr
  tags                         = var.tags
}

module "aks_node_pool_system" {
  source                = "../../resources/container/kubernetes_cluster_node_pool"
  kubernetes_cluster_id = module.aks.id
  node_pool_name        = "systempool"
  node_taints           = ["CriticalAddonsOnly=true:NoSchedule"]
  vm_size               = var.vm_size
  availability_zones    = [1, 2, 3]
  node_count            = var.node_count
  mode                  = "System"
  vnet_subnet_id        = element(module.subnet.id, 0)
  tags                  = var.tags
}

module "aks_node_pool_user" {
  source                = "../../resources/container/kubernetes_cluster_node_pool"
  kubernetes_cluster_id = module.aks.id
  node_pool_name        = "userpool"
  vm_size               = var.vm_size
  availability_zones    = [1, 2, 3]
  node_count            = var.node_count
  mode                  = "User"
  vnet_subnet_id        = element(module.subnet.id, 0)
  tags                  = var.tags
}

# Firewall Route

module "route_table" {
  source         = "../../resources/network/route_table"
  region         = module.resource_group.location
  environment    = var.environment
  resource_group = module.resource_group.name
  name_prefix    = "rt-aks-nodes"
  tags           = var.tags
}

module "route" {
  source                 = "../../resources/network/route"
  region                 = module.resource_group.location
  environment            = var.environment
  resource_group         = module.resource_group.name
  route_table_name       = module.route_table.name
  route_name             = "dg-to-firewall"
  address_prefix         = "0.0.0.0/0"
  next_hop_type          = "VirtualAppliance"
  next_hop_in_ip_address = var.next_hop_in_ip_address
}

module "subnet_route_table_association" {
  source         = "../../resources/network/subnet_route_table_association"
  subnet_id      = element(module.subnet.id, 0)
  route_table_id = module.route_table.id
}