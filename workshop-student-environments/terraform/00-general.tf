##############################################################################################################
#
# Workshop student environment
#
##############################################################################################################

variable "LOCATION" {
  description = "Azure region"
}

variable "ACCOUNTCOUNT" {
  description = "Number of student accounts to create"
}

variable "CUSTOMDOMAIN" {
  description = "Verified custom domain to use for user accounts"
}

##############################################################################################################
# Minimum terraform version
##############################################################################################################

terraform {
  required_version = ">= 0.12"
}

##############################################################################################################
# Deployment in Microsoft Azure
##############################################################################################################

provider "azurerm" {
  version = ">= 2.0.0"
  features {}
}

provider "azuread" {
}

##############################################################################################################