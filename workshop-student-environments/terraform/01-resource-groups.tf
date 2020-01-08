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
  location = "${var.LOCATION}"
  count    = 35
}

resource "azuread_user" "users" {
  user_principal_name = "student${count.index}@fortilab.be"
  display_name        = "student${count.index}"
  mail_nickname       = "student${count.index}"
  password            = "StudentPassword123!"
  count               = 35
}

resource "azurerm_role_assignment" "iam" {
  scope                = "${azurerm_resource_group.resourcegroup[count.index].id}"
  role_definition_name = "Owner"
  principal_id         = "${azuread_user.users[count.index].id}"
  count                = 35
}