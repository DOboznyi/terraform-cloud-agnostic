resource "azurerm_resource_group" "this" {
  name     = join("-", concat(["rg"], var.naming_suffixes))
  location = "westeurope" # var.region

  tags = var.tags
}

resource "azurerm_virtual_network" "this" {
  name                = join("-", concat(["vnet"], var.naming_suffixes))
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  address_space       = [var.network_cidr]

  tags = var.tags
}

resource "azurerm_subnet" "this" {
  name                 = join("-", concat(["snet"], var.naming_suffixes))
  resource_group_name  = azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = [var.subnet_cidr]
}

resource "azurerm_public_ip" "this" {
  name                = join("-", concat(["pip"], var.naming_suffixes))
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  allocation_method   = "Dynamic"

  tags = var.tags
}

resource "azurerm_route_table" "this" {
  name                = join("-", concat(["route"], var.naming_suffixes))
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name

  tags = var.tags
}

resource "azurerm_route" "this" {
  count               = var.enable_outbound_traffic ? 1 : 0
  name                = join("-", concat(["rt"], var.naming_suffixes))
  resource_group_name = azurerm_resource_group.this.name
  route_table_name    = azurerm_route_table.this.name
  address_prefix      = "0.0.0.0/0"
  next_hop_type       = "Internet"
}

resource "azurerm_network_security_group" "this" {
  name                = join("-", concat(["nsg"], var.naming_suffixes))
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name

  tags = var.tags
}

resource "azurerm_subnet_network_security_group_association" "this" {
  subnet_id                 = azurerm_subnet.this.id
  network_security_group_id = azurerm_network_security_group.this.id
}

resource "azurerm_network_security_rule" "this" {
  for_each                    = { for rule in var.acl_rules : rule.name => rule }
  name                        = join("-", ["nsgr", lookup(each.value, "name", null)])
  priority                    = lookup(each.value, "number", null)
  direction                   = title(lookup(each.value, "direction", null))
  access                      = title(lookup(each.value, "action", null))
  protocol                    = title(lookup(each.value, "protocol", null))
  source_port_range           = "*"
  destination_port_range      = lookup(each.value, "from_port", null) != lookup(each.value, "to_port", null) ? join("-", [lookup(each.value, "from_port", null), lookup(each.value, "to_port", null)]) : lookup(each.value, "from_port", null)
  source_address_prefix       = title(lookup(each.value, "direction", null)) != "Inbound" ? "*" : lookup(each.value, "cidr", null)
  destination_address_prefix  = title(lookup(each.value, "direction", null)) == "Inbound" ? "*" : lookup(each.value, "cidr", null)
  resource_group_name         = azurerm_resource_group.this.name
  network_security_group_name = azurerm_network_security_group.this.name
}

resource "azurerm_network_interface" "this" {
  name                = join("-", concat(["nic"], var.naming_suffixes))
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name

  ip_configuration {
    name                          = join("-", concat(["ipconf"], var.naming_suffixes))
    public_ip_address_id          = azurerm_public_ip.this.id
    subnet_id                     = azurerm_subnet.this.id
    private_ip_address_allocation = "Dynamic"
  }

  tags = var.tags
}

resource "azurerm_linux_virtual_machine" "this" {
  name                = join("-", concat(["vm"], var.naming_suffixes))
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  size                = var.instance_type
  admin_username      = "adminuser"
  network_interface_ids = [
    azurerm_network_interface.this.id,
  ]

  admin_ssh_key {
    username   = "adminuser"
    public_key = var.ssh_key
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = lookup(var.os_settings, "publisher")
    offer     = lookup(var.os_settings, "offer")
    sku       = lookup(var.os_settings, "sku")
    version   = lookup(var.os_settings, "version")
  }

  tags = var.tags
}

resource "azurerm_virtual_machine_extension" "this" {
  count                = var.user_data == "" ? 0 : 1
  name                 = join("-", concat(["vme"], var.naming_suffixes))
  virtual_machine_id   = azurerm_linux_virtual_machine.this.id
  publisher            = "Microsoft.Azure.Extensions"
  type                 = "CustomScript"
  type_handler_version = "2.0"

  settings = <<SETTINGS
    {
        "script": "${var.user_data}"
    }
SETTINGS


  tags = var.tags
}
