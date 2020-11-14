module "aws" {
  source                  = "./modules/aws"
  count                   = contains(var.clouds, "aws") ? 1 : 0
  network_cidr            = var.network_cidr
  subnet_cidr             = var.subnet_cidr
  acl_rules               = var.acl_rules
  enable_outbound_traffic = var.enable_outbound_traffic
  ssh_key                 = var.ssh_key
  user_data               = lookup(var.user_data, "aws", "")
  naming_suffixes         = var.naming_suffixes
  instance_type           = lookup(var.instance_type, "aws", "t2.micro")
  tags                    = var.tags
}

module "azure" {
  source                  = "./modules/azure"
  count                   = contains(var.clouds, "azure") ? 1 : 0
  network_cidr            = var.network_cidr
  subnet_cidr             = var.subnet_cidr
  acl_rules               = var.acl_rules
  enable_outbound_traffic = var.enable_outbound_traffic
  ssh_key                 = var.ssh_key
  user_data               = lookup(var.user_data, "azure", "")
  naming_suffixes         = var.naming_suffixes
  instance_type           = lookup(var.instance_type, "azure", "Standard_B1s")
  region                  = var.region
  tags                    = var.tags
}
