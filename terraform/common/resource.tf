resource "azurerm_resource_group" "react-rg" {
  name = "react-${local.name}-np-${local.location}"
  location = local.location
}

resource "azurerm_storage_account" "react-storage-account" {
  name                     = "reactstorage10"
  resource_group_name      = azurerm_resource_group.react-rg.name
  location                 = azurerm_resource_group.react-rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "react-blob-container" {
  name                  = "reactblob"
  storage_account_name  = azurerm_storage_account.react-storage-account.name
  container_access_type = "private"
}


