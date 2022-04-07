terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
}

provider "azurerm" {
  features {}
}
terraform {
  backend "azurerm" {
    resource_group_name  = "rg-react-tf"
    storage_account_name = "reactdb"
    container_name       = "terraform-state"
    key                  = "terraform.tfstate"
  }
}

resource "azurerm_resource_group" "rg-react-azure" {
  name     = "rg-react-azure"
  location = "centralindia"
}
