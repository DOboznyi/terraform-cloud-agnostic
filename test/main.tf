data "http" "myip" {
  url = "http://ipv4.icanhazip.com"
}

module "test" {
  source = "../"
  acl_rules = [
    {
      name      = "inbound_http"
      number    = 100
      direction = "inbound"
      protocol  = "tcp"
      action    = "allow"
      from_port = 80
      to_port   = 80
      cidr      = "${chomp(data.http.myip.body)}/32"
    },
    {
      name      = "inbound_https"
      number    = 102
      direction = "inbound"
      protocol  = "tcp"
      action    = "allow"
      from_port = 443
      to_port   = 443
      cidr      = "${chomp(data.http.myip.body)}/32"
    },
    {
      name      = "inbound_ssh"
      number    = 103
      direction = "inbound"
      protocol  = "tcp"
      action    = "allow"
      from_port = 22
      to_port   = 22
      cidr      = "${chomp(data.http.myip.body)}/32"
    },
    {
      name      = "inbound_response"
      number    = 104
      direction = "inbound"
      protocol  = "tcp"
      action    = "allow"
      from_port = 1024
      to_port   = 65535
      cidr      = "0.0.0.0/0"
    },
    {
      name      = "outbound_http"
      number    = 100
      direction = "outbound"
      protocol  = "tcp"
      action    = "allow"
      from_port = 80
      to_port   = 80
      cidr      = "0.0.0.0/0"
    },
    {
      name      = "outbound_https"
      number    = 101
      direction = "outbound"
      protocol  = "tcp"
      action    = "allow"
      from_port = 443
      to_port   = 443
      cidr      = "${chomp(data.http.myip.body)}/32"
    },
    {
      name      = "outbound_ssh"
      number    = 102
      direction = "outbound"
      protocol  = "tcp"
      action    = "allow"
      from_port = 22
      to_port   = 22
      cidr      = "${chomp(data.http.myip.body)}/32"
    },
    {
      name      = "outbound_response"
      number    = 103
      direction = "outbound"
      protocol  = "tcp"
      action    = "allow"
      from_port = 1024
      to_port   = 65535
      cidr      = "0.0.0.0/0"
  }, ]
  ssh_key = file("~/.ssh/id_rsa.pub")

  tags = {
    delete_me = "true"
  }
}
