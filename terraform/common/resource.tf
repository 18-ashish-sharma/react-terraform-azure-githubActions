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

resource "azurerm_cdn_profile" "react-cdn-profile" {
  name                = "example-profile"
  location            = azurerm_resource_group.react-rg.location
  resource_group_name = azurerm_resource_group.react-rg.name
  sku                 = "Standard_Verizon"
}

resource "azurerm_cdn_endpoint" "react-cdn-endpoint" {
  name                = "example-endpoint"
  profile_name        = azurerm_cdn_profile.react-cdn-profile.name
  location            = azurerm_resource_group.react-rg.location
  resource_group_name = azurerm_resource_group.react-rg.name

  origin {
    name      = "onedoorway"
    host_name = azurerm_storage_account.react-storage-account.primary_blob_host
  }
}

data "azurerm_dns_zone" "react-dns-zone" {
  name                = "example-domain.com"
  resource_group_name = azurerm_resource_group.react-rg.name
}

resource "azurerm_dns_cname_record" "react-dns-cname-record" {
  name                = "react-onedoorway"
  zone_name           = data.azurerm_dns_zone.react-dns-zone.name
  resource_group_name = azurerm_resource_group.react-rg.name
  ttl                 = 3600
  target_resource_id  = azurerm_cdn_endpoint.react-cdn-endpoint.id
}

resource "azurerm_cdn_endpoint_custom_domain" "react-custom-domain" {
  name            = "react-onedoorway-domain"
  cdn_endpoint_id = azurerm_cdn_endpoint.react-cdn-endpoint.id
  host_name       = "${azurerm_dns_cname_record.react-dns-cname-record.name}.${data.azurerm_dns_zone.react-dns-zone.name}"
}