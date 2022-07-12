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

variable "TENANTID" {
  description = "Azure AD Tenant ID"
}

##############################################################################################################
# Minimum terraform version
##############################################################################################################

terraform {
  required_version = ">= 0.12"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=2.0.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = ">= 2.0.0"
    }
  }
}

provider "azurerm" {
  features {}
}

provider "azuread" {
  tenant_id = var.TENANTID
}

##############################################################################################################
