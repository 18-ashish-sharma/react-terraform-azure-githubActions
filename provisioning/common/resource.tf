resource "azurerm_resource_group" "react-rg" {
  name     = "${local.resource_group}"
  location = local.location
}

resource "azurerm_storage_account" "react-storage-account" {
  name                      = "odw${var.env}storage"
  resource_group_name       = azurerm_resource_group.react-rg.name
  location                  = azurerm_resource_group.react-rg.location
  account_kind              = var.account_kind
  enable_https_traffic_only = var.enable_https_traffic
  min_tls_version           = var.min_tls_version
  account_tier              = "Standard"
  account_replication_type  = "LRS"

  dynamic "static_website" {
    for_each = local.if_static_website_enabled
    content {
      index_document     = var.index_path
      error_404_document = var.custom_404_path
    }
  }

  blob_properties {
    cors_rule {
      allowed_methods    = var.allowed_methods
      allowed_origins    = var.allowed_origins
      allowed_headers    = var.allowed_headers
      exposed_headers    = var.exposed_headers
      max_age_in_seconds = var.max_age_in_seconds
    }
  }

  identity {
    type = var.assign_identity ? "SystemAssigned" : null
  }

}

resource "azurerm_storage_container" "react-blob-container" {
  name                  = "odw-${var.env}-container"
  storage_account_name  = azurerm_storage_account.react-storage-account.name
  container_access_type = "private"
}

#---------------------------------------------------------
# Add CDN profile and endpoint to static website
#----------------------------------------------------------


resource "azurerm_cdn_profile" "react-cdn-profile" {
  count               = var.enable_static_website && var.enable_cdn_profile ? 1 : 0
  name                = var.cdn_profile_name
  resource_group_name = azurerm_resource_group.react-rg.name
  location            = local.location
  sku                 = var.cdn_sku_profile
}


resource "azurerm_cdn_endpoint" "react-cdn-endpoint" {
  count                         = var.enable_static_website && var.enable_cdn_profile ? 1 : 0
  name                          = "react-${var.env}-cdn-endpoint"
  profile_name                  = azurerm_cdn_profile.react-cdn-profile.0.name
  resource_group_name           = azurerm_resource_group.react-rg.name
  location                      = local.location
  origin_host_header            = azurerm_storage_account.react-storage-account.primary_web_host
  querystring_caching_behaviour = "IgnoreQueryString"

  origin {
    name      = "websiteorginaccount"
    host_name = azurerm_storage_account.react-storage-account.primary_web_host
  }

}

resource "azurerm_dns_zone" "dns" {
  name                = "${var.env}.np.ody.edstem.com"
  resource_group_name = azurerm_resource_group.react-rg.name
}

resource "azurerm_dns_cname_record" "target" {
  name                = "onedoorway-${var.env}-cname-target"
  zone_name           = azurerm_dns_zone.dns.name
  resource_group_name = azurerm_resource_group.react-rg.name
  ttl                 = 300
  record              = azurerm_storage_account.react-storage-account.primary_web_host
}

