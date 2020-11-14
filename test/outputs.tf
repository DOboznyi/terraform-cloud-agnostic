output "rg_id" {
  description = "Resource group ID"
  value       = module.test.rg_id
}

output "network_id" {
  description = "Network ID"
  value       = module.test.network_id
}

output "subnet_id" {
  description = "Subnet ID"
  value       = module.test.subnet_id
}

output "igw_id" {
  description = "Internet Gateway ID. Specific for AWS"
  value       = module.test.igw_id
}

output "route_table_id" {
  description = "Route table ID"
  value       = module.test.route_table_id
}

output "acl_id" {
  description = "Network ACL ID"
  value       = module.test.acl_id
}

output "public_ip_id" {
  description = "Public/Elastic IP ID"
  value       = module.test.public_ip_id
}

output "security_group_id" {
  description = "Security group ID. Specific for AWS"
  value       = module.test.security_group_id
}

output "key_id" {
  description = "Key ID used as ssh key for VM in AWS. Specific for AWS"
  value       = module.test.key_id
}

output "instance_id" {
  description = "Instance ID"
  value       = module.test.instance_id
}

output "public_ip" {
  description = "Frontend IP"
  value       = module.test.public_ip
}

output "network_interface_id" {
  description = "Network interface ID. Specific for Azure"
  value       = module.test.network_interface_id
}
