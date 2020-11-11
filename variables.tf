variable "cidr" {
    type = string
    default = "0.0.0.0/0"
    description = "Alowed SSH access CIDR"
}

variable "tags" {
  description = "A mapping of tags to assign to the resources"
  type        = map(string)
  default     = {}
}
