##############################################################################################################
#
# Workshop student environment
#
##############################################################################################################

##############################################################################################################
# Resource Group
##############################################################################################################
resource "azurerm_resource_group" "resourcegroup" {
  name     = "student${count.index}-RG"
  location = var.LOCATION
  count    = var.ACCOUNTCOUNT
}

resource "azuread_user" "users" {
  user_principal_name = "student${count.index}@${var.CUSTOMDOMAIN}"
  display_name        = "student${count.index}"
  mail_nickname       = "student${count.index}"
  password            = "StudentPassword123!"
  count               = var.ACCOUNTCOUNT
}

resource "azurerm_role_assignment" "iam" {
  scope                = azurerm_resource_group.resourcegroup[count.index].id
  role_definition_name = "Owner"
  principal_id         = azuread_user.users[count.index].id
  count                = var.ACCOUNTCOUNT
}

##############################################################################################################
#
# Virtual Machine
#
##############################################################################################################

resource "azurerm_virtual_network" "vnet" {
  name                         = "student${count.index}-VNET"
  address_space                = ["10.0.0.0/16"]
  location                     = var.LOCATION
  resource_group_name          = azurerm_resource_group.resourcegroup[count.index].name
  count    		       = var.ACCOUNTCOUNT
}

resource "azurerm_subnet" "subnet1" {
  name                         = "student${count.index}-SERVER-SUBNET"
  resource_group_name  	       = azurerm_resource_group.resourcegroup[count.index].name
  virtual_network_name         = azurerm_virtual_network.vnet[count.index].name
  address_prefixes             = ["10.0.100.0/24"]
  count    		       = var.ACCOUNTCOUNT
}

resource "azurerm_network_security_group" "lnx_nsg" {
  name                = "student${count.index}-LINUX-VM-NSG"
  location            = var.LOCATION
  resource_group_name = azurerm_resource_group.resourcegroup[count.index].name
  count    		       = var.ACCOUNTCOUNT
}

resource "azurerm_network_security_rule" "lnx_nsg_allowallout" {
  name                        = "AllowAllOutbound"
  resource_group_name         = azurerm_resource_group.resourcegroup[count.index].name
  network_security_group_name = azurerm_network_security_group.lnx_nsg[count.index].name
  priority                    = 100
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  count                       = var.ACCOUNTCOUNT
}

resource "azurerm_network_security_rule" "lnx_nsg_allowallin" {
  name                        = "AllowAllInbound"
  resource_group_name         = azurerm_resource_group.resourcegroup[count.index].name
  network_security_group_name = azurerm_network_security_group.lnx_nsg[count.index].name
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  count                       = var.ACCOUNTCOUNT
}

resource "azurerm_public_ip" "lnxapip" {
  name                         = "student${count.index}-LINUX-VM-ip"
  location                     = var.LOCATION
  resource_group_name          = azurerm_resource_group.resourcegroup[count.index].name
  allocation_method            = "Static"
  sku                          = "Standard"
  count                        = var.ACCOUNTCOUNT
}

resource "azurerm_network_interface" "lnxaifc" {
  name                            = "student${count.index}-LINUX-VM-ifc"
  location                     	  = var.LOCATION
  resource_group_name             = azurerm_resource_group.resourcegroup[count.index].name
  enable_ip_forwarding            = false
  count    		       = var.ACCOUNTCOUNT

  ip_configuration {
    name                          = "interface1"
    subnet_id                     = azurerm_subnet.subnet1[count.index].id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.lnxapip[count.index].id
  }
}

resource "azurerm_network_interface_security_group_association" "lnx_nsg_map" {
  network_interface_id      = azurerm_network_interface.lnxaifc[count.index].id
  network_security_group_id = azurerm_network_security_group.lnx_nsg[count.index].id
  count                       = var.ACCOUNTCOUNT
}

resource "azurerm_virtual_machine" "lnxavm" {
  name                            = "student${count.index}-LINUX-VM"
  location                        = var.LOCATION
  resource_group_name             = azurerm_resource_group.resourcegroup[count.index].name
  network_interface_ids           = [azurerm_network_interface.lnxaifc[count.index].id]
  vm_size                         = "Standard_B1s"
  count    		          = var.ACCOUNTCOUNT

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  storage_os_disk {
    name              = "student${count.index}-LINUX-VM-OSDISK"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "student${count.index}-LINUX-VM"
    admin_username = "student${count.index}"
    admin_password = "StudentPassword123!"
    custom_data    = data.template_file.lnx_a_custom_data.rendered
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }
}

data "template_file" "lnx_a_custom_data" {
  template = file("${path.module}/customdata-lnx.tpl")
  vars = {
  }
}