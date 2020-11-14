output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.this.id
}

output "subnet_id" {
  description = "Subnet ID"
  value       = aws_subnet.this.id
}

output "igw_id" {
  description = "Internet Gateway ID"
  value       = try(aws_internet_gateway.this[0].id, null)
}

output "rtb_id" {
  description = "Route table ID"
  value       = aws_route_table.this.id
}

output "acl_id" {
  description = "Network ACL ID"
  value       = aws_network_acl.this.id
}

output "eip_id" {
  description = "Elastic IP ID"
  value       = aws_eip.this.id
}

output "sg_id" {
  description = "Security group ID"
  value       = aws_security_group.this.id
}

output "key_id" {
  description = "Key ID"
  value       = aws_key_pair.this.id
}

output "instance_id" {
  description = "Instance ID"
  value       = aws_instance.this.id
}

output "public_ip" {
  description = "Frontend IP"
  value       = aws_eip.this.public_ip
}
