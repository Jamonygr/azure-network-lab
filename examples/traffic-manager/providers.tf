terraform {
  required_version = "= 1.16.4"
  backend "local" { path = ".local/terraform.tfstate" }
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "= 4.57.0"
    }
  }
}
provider "azurerm" {
  subscription_id                 = var.subscription_id
  tenant_id                       = var.tenant_id
  use_cli                         = true
  resource_provider_registrations = "none"
  features {
    resource_group { prevent_deletion_if_contains_resources = true }
  }
}
