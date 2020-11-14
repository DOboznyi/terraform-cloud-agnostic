variable "network_cidr" {
  type        = string
  default     = "10.0.0.0/16"
  description = "Network CIDR"
}

variable "subnet_cidr" {
  type        = string
  default     = "10.0.0.0/24"
  description = "subnet CIDR"
}

variable "acl_rules" {
  description = "Network ACLs"
  type        = list(map(string))

  default = []
}

variable "enable_outbound_traffic" {
  description = "Enable possibility to reach internet from VPC or VNet"
  type        = bool
  default     = true
}

variable "ssh_key" {
  description = "SSH public key for connecting to VM"
  type        = string
}

variable "clouds" {
  description = "A list of clouds where resources will be deployed"
  type        = list(string)
  default     = []
}

variable "user_data" {
  description = "Initial script for virtual machine"
  type        = map(string)
  default = {
    "aws"   = "",
    "azure" = ""
  }
}

variable "naming_suffixes" {
  description = "List of suffixes which will be used in objects naming"
  type        = list(string)
  default     = []
}

variable "instance_type" {
  type        = map(string)
  description = "Type of instance"
  default = {
    "aws"   = "t2.micro",
    "azure" = "Standard_B1s"
  }
}

variable "os_settings" {
  type        = map(map(string))
  description = "Type of instance"
  default = {
    "aws" = {
      "filter_name" = "ubuntu/images/hvm-ssd/ubuntu-*-18.04-amd64-server-*",
      "owner_id"    = "099720109477"
    },
    "azure" = {
      "publisher" = "Canonical"
      "offer"     = "UbuntuServer"
      "sku"       = "18.04-LTS"
      "version"   = "latest"
    }
  }
}

variable "region" {
  type        = string
  description = "Region where resources will be created. Required only for Azure"
  default     = "westeurope"
}

variable "tags" {
  description = "A mapping of tags to assign to the resources"
  type        = map(string)
  default     = {}
}
