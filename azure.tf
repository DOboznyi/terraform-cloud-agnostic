resource "azurerm_resource_group" "this" {
  name     = "rg-test"
  location = "westeurope" # var.region

  tags = var.tags
}

resource "azurerm_virtual_network" "this" {
  name                = "vnet-test"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  address_space       = [var.network_cidr]

  tags = var.tags
}

resource "azurerm_subnet" "this" {
  name                 = "snet-test"
  resource_group_name  = azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = [var.subnet_cidr]
}

resource "azurerm_public_ip" "this" {
  name                = "pip-test"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  allocation_method   = "Dynamic"

  tags = var.tags
}

resource "azurerm_route_table" "this" {
  name                = "rt-test"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name

  tags = var.tags
}

resource "azurerm_route" "this" {
  count               = var.enable_outbound_traffic ? 1 : 0
  name                = "route-test"
  resource_group_name = azurerm_resource_group.this.name
  route_table_name    = azurerm_route_table.this.name
  address_prefix      = "0.0.0.0/0"
  next_hop_type       = "Internet"
}

resource "azurerm_network_security_group" "this" {
  name                = "nsg-test"
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
  name                        = lookup(each.value, "name", null)
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
  name                = "nic-this"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name

  ip_configuration {
    name                          = "ipconfig1"
    public_ip_address_id          = azurerm_public_ip.this.id
    subnet_id                     = azurerm_subnet.this.id
    private_ip_address_allocation = "Dynamic"
  }

  tags = var.tags
}

resource "azurerm_linux_virtual_machine" "this" {
  name                = "vm-test"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  size                = "Standard_B1s"
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
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  tags = var.tags
}

resource "azurerm_virtual_machine_extension" "this" {
  name                 = "user_data"
  virtual_machine_id   = azurerm_linux_virtual_machine.this.id
  publisher            = "Microsoft.Azure.Extensions"
  type                 = "CustomScript"
  type_handler_version = "2.0"

  settings = <<SETTINGS
    {
        "script": "${base64encode(templatefile("${path.module}/start.tmpl", { cloud = "azure" }))}"
    }
SETTINGS


  tags = var.tags
}
