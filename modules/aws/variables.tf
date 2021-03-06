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

variable "user_data" {
  description = "Initial script for virtual machine"
  type        = string
  default     = ""
}

variable "naming_suffixes" {
  description = "List of suffixes which will be used in objects naming"
  type        = list(string)
  default     = []
}

variable "os_settings" {
  type        = map(string)
  description = "OS settings: owner, os name, version"
  default = {
    "filter_name" = "ubuntu/images/hvm-ssd/ubuntu-*-16.04-amd64-server-*",
    "owner_id"    = "099720109477"
  }
}

variable "instance_type" {
  type        = string
  description = "Type of instance"
  default     = "t2.micro"
}

variable "tags" {
  description = "A mapping of tags to assign to the resources"
  type        = map(string)
  default     = {}
}
