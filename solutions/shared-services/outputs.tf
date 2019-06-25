output "shared_vnet_hub_name" {
  value       = module.shared-network-hub.vnet_hub_name
  description = "Generated name of the hub virtual network"
}

output "shared_vnet_hub_id" {
  value       = module.shared-network-hub.vnet_hub_id
  description = "Resource id of the hub virtual network"
}

output "shared_vnet_hub_rg" {
  value       = module.shared-network-hub.vnet_hub_rg
  description = "Generated name of the resource group for hub virtual network"
}

output "shared_firewall_hub_private_ip" {
  value = module.shared-network-hub.firewall_hub_private_ip
}

output "shared_firewall_hub_public_ip" {
  value = module.shared-network-hub.firewall_hub_public_ip
}
