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

variable "tags" {
  description = "A mapping of tags to assign to the resources"
  type        = map(string)
  default     = {}
}
