output "rg_id" {
  description = "Resource group ID"
  value       = azurerm_resource_group.this.id
}

output "vnet_id" {
  description = "Virtual network ID"
  value       = azurerm_virtual_network.this.id
}

output "snet_id" {
  description = "Subnet ID"
  value       = azurerm_subnet.this.id
}

output "pip_id" {
  description = "Public IP ID"
  value       = azurerm_public_ip.this.id
}

output "route_id" {
  description = "Route table ID"
  value       = azurerm_route_table.this.id
}

output "nsg_id" {
  description = "Network security group ID"
  value       = azurerm_network_security_group.this.id
}

output "nic_id" {
  description = "Network interface ID"
  value       = azurerm_network_interface.this.id
}

output "vm_id" {
  description = "Virtual machine ID"
  value       = azurerm_linux_virtual_machine.this.id
}

output "public_ip" {
  description = "Frontend IP"
  value       = azurerm_public_ip.this.ip_address
}
