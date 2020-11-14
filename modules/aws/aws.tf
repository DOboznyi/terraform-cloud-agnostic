# resource "aws_resourcegroups_group" "this" {
#   name = join("-", concat(["rg"], var.naming_suffixes))

#   resource_query {
#     query = <<JSON
# {
#   "ResourceTypeFilters": [
#     "AWS::AllSupported"
#   ]
#   ,
#   "TagFilters": [
#     {
#       "Key": "${var.tags[0].key}",
#       "Values": ["${var.tags[0].value}"]
#     }
#   ]
# }
# JSON
#   }
#   tags = var.tags
# }

resource "aws_vpc" "this" {
  cidr_block = var.network_cidr

  tags = merge({
    "Name" = join("-", concat(["vpc"], var.naming_suffixes)) },
    var.tags
  )
}

resource "aws_subnet" "this" {
  vpc_id     = aws_vpc.this.id
  cidr_block = var.subnet_cidr

  tags = merge({
    "Name" = join("-", concat(["subnet"], var.naming_suffixes)) },
    var.tags
  )
}

resource "aws_internet_gateway" "this" {
  count  = var.enable_outbound_traffic ? 1 : 0
  vpc_id = aws_vpc.this.id

  tags = merge({
    "Name" = join("-", concat(["igw"], var.naming_suffixes))
    },
    var.tags
  )
}

resource "aws_route_table" "this" {
  vpc_id = aws_vpc.this.id

  tags = merge({
    "Name" = join("-", concat(["rtb"], var.naming_suffixes))
    },
    var.tags
  )
}

resource "aws_route" "this" {
  count                  = var.enable_outbound_traffic ? 1 : 0
  route_table_id         = aws_route_table.this.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this[0].id
}

resource "aws_route_table_association" "this" {
  subnet_id      = aws_subnet.this.id
  route_table_id = aws_route_table.this.id
}

resource "aws_network_acl" "this" {
  vpc_id     = aws_vpc.this.id
  subnet_ids = [aws_subnet.this.id]

  tags = merge({
    "Name" = join("-", concat(["acl"], var.naming_suffixes))
    },
    var.tags
  )
}

resource "aws_network_acl_rule" "this" {
  for_each       = { for rule in var.acl_rules : rule.name => rule }
  network_acl_id = aws_network_acl.this.id
  rule_number    = lookup(each.value, "number", null)
  egress         = title(lookup(each.value, "direction", null)) != "Inbound" ? true : false
  protocol       = lower(lookup(each.value, "protocol", null))
  rule_action    = lower(lookup(each.value, "action", null))
  cidr_block     = lookup(each.value, "cidr", null)
  from_port      = lookup(each.value, "from_port", null)
  to_port        = lookup(each.value, "to_port", null)
}

resource "aws_eip" "this" {
  instance = aws_instance.this.id
  vpc      = true
  tags = merge({
    "Name" = join("-", concat(["eip"], var.naming_suffixes))
    },
    var.tags
  )
}

resource "aws_security_group" "this" {
  name   = join("-", concat(["security", "group"], var.naming_suffixes))
  vpc_id = aws_vpc.this.id

  tags = var.tags
}

resource "aws_security_group_rule" "this" {
  for_each          = { for rule in var.acl_rules : rule.name => rule }
  security_group_id = aws_security_group.this.id

  type        = title(lookup(each.value, "direction", null)) == "Inbound" ? "ingress" : "egress"
  from_port   = lookup(each.value, "from_port", null)
  to_port     = lookup(each.value, "to_port", null)
  protocol    = lower(lookup(each.value, "protocol", null))
  cidr_blocks = [lookup(each.value, "cidr", null)]
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = [lookup(var.os_settings, "filter_name")]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = [lookup(var.os_settings, "owner_id")] # Canonical
}

resource "aws_key_pair" "this" {
  key_name   = join("-", concat(["ssh", "key"], var.naming_suffixes))
  public_key = var.ssh_key
}

resource "aws_instance" "this" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  key_name      = aws_key_pair.this.key_name

  vpc_security_group_ids      = [aws_security_group.this.id]
  subnet_id                   = aws_subnet.this.id
  associate_public_ip_address = true

  user_data = var.user_data

  tags = {
    "Name" = join("-", concat(["i"], var.naming_suffixes))
  }

  depends_on = [aws_internet_gateway.this]
}
