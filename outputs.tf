output "rg_id" {
  description = "Resource group ID"
  value = {
    "aws"   = try(module.aws[0].rg_id, null),
    "azure" = try(module.azure[0].rg_id, null)
  }
}

output "network_id" {
  description = "Network ID"
  value = {
    "aws"   = try(module.aws[0].vpc_id, null),
    "azure" = try(module.azure[0].vnet_id, null)
  }
}

output "subnet_id" {
  description = "Subnet ID"
  value = {
    "aws"   = try(module.aws[0].subnet_id, null),
    "azure" = try(module.azure[0].snet_id, null)
  }
}

output "igw_id" {
  description = "Internet Gateway ID. Specific for AWS"
  value       = try(module.aws[0].igw_id, null)
}

output "route_table_id" {
  description = "Route table ID"
  value = {
    "aws"   = try(module.aws[0].rtb_id, null),
    "azure" = try(module.azure[0].route_id, null)
  }
}

output "acl_id" {
  description = "Network ACL ID"
  value = {
    "aws"   = try(module.aws[0].acl_id, null),
    "azure" = try(module.azure[0].nsg_id, null)
  }
}

output "public_ip_id" {
  description = "Public/Elastic IP ID"
  value = {
    "aws"   = try(module.aws[0].eip_id, null),
    "azure" = try(module.azure[0].pip_id, null)
  }
}

output "security_group_id" {
  description = "Security group ID. Specific for AWS"
  value       = try(module.aws[0].sg_id, null)
}

output "key_id" {
  description = "Key ID used as ssh key for VM in AWS. Specific for AWS"
  value       = try(module.aws[0].key_id, null)
}

output "instance_id" {
  description = "Instance ID"
  value = {
    "aws"   = try(module.aws[0].instance_id, null),
    "azure" = try(module.azure[0].vm_id, null)
  }
}

output "public_ip" {
  description = "Frontend IP"
  value = {
    "aws"   = try(module.aws[0].public_ip, null),
    "azure" = try(module.azure[0].public_ip, null)
  }
}

output "network_interface_id" {
  description = "Network interface ID. Specific for Azure"
  value       = try(module.azure[0].nic_id, null)
}
