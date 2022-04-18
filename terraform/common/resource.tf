resource "azurerm_resource_group" "react-rg" {
  # count    = 1
  name     = "react-${local.name}-np-${local.location}"
  location = local.location
}

resource "azurerm_storage_account" "react-storage-account" {
  name                      = "reactstorage10"
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
  name                  = "reactblob"
  storage_account_name  = azurerm_storage_account.react-storage-account.name
  container_access_type = "private"
}

#---------------------------------------------------------
# Add CDN profile and endpoint to static website
#----------------------------------------------------------
resource "azurerm_cdn_profile" "cdn-profile" {
  count               = var.enable_static_website && var.enable_cdn_profile ? 1 : 0
  name                = var.cdn_profile_name
  resource_group_name = azurerm_resource_group.react-rg.name
  location            = local.location
  sku                 = var.cdn_sku_profile
  tags                = merge({ "Name" = format("%s", var.cdn_profile_name) }, var.tags, )
}


resource "azurerm_dns_zone" "example" {
  name                = "mydomain.com"
  resource_group_name = azurerm_resource_group.react-rg.name
}

resource "azurerm_dns_cname_record" "target" {
  name                = "target"
  zone_name           = azurerm_dns_zone.example.name
  resource_group_name = azurerm_resource_group.react-rg.name
  ttl                 = 300
  record              = "contoso.com"
}

resource "azurerm_dns_cname_record" "example" {
  name                = "test"
  zone_name           = azurerm_dns_zone.example.name
  resource_group_name = azurerm_resource_group.react-rg.name
  ttl                 = 300
  target_resource_id  = azurerm_dns_cname_record.target.id
}

resource "random_string" "unique" {
  count   = var.enable_static_website && var.enable_cdn_profile ? 1 : 0
  length  = 8
  special = false
  upper   = false
}


resource "azurerm_cdn_endpoint" "cdn-endpoint" {
  count                         = var.enable_static_website && var.enable_cdn_profile ? 1 : 0
  name                          = random_string.unique.0.result
  profile_name                  = azurerm_cdn_profile.cdn-profile.0.name
  resource_group_name           = azurerm_resource_group.react-rg.name
  location                      = local.location
  origin_host_header            = azurerm_storage_account.react-storage-account.primary_web_host
  querystring_caching_behaviour = "IgnoreQueryString"

  origin {
    name      = "websiteorginaccount"
    host_name = azurerm_storage_account.react-storage-account.primary_web_host
  }

}

# resource "azurerm_cdn_endpoint" "react-cdn-endpoint" {
#   name                = "example-endpoint"
#   profile_name        = azurerm_cdn_profile.react-cdn-profile.name
#   location            = azurerm_resource_group.react-rg.location
#   resource_group_name = azurerm_resource_group.react-rg.name

#   origin {
#     name      = "Storage"
#     host_name = azurerm_storage_account.react-storage-account.primary_blob_host
#   }
# }

# data "azurerm_dns_zone" "react-dns-zone" {
#   name                = "example-domain.com"
#   resource_group_name = azurerm_resource_group.react-rg.name
# }

# resource "azurerm_dns_cname_record" "react-dns-cname-record" {
#   name                = "react-onedoorway"
#   zone_name           = data.azurerm_dns_zone.react-dns-zone.name
#   resource_group_name = azurerm_resource_group.react-rg.name
#   ttl                 = 3600
#   target_resource_id  = azurerm_cdn_endpoint.react-cdn-endpoint.id
# }

# resource "azurerm_cdn_endpoint_custom_domain" "react-custom-domain" {
#   name            = "react-onedoorway-domain"
#   cdn_endpoint_id = azurerm_cdn_endpoint.react-cdn-endpoint.id
#   host_name       = "${azurerm_dns_cname_record.react-dns-cname-record.name}.${data.azurerm_dns_zone.react-dns-zone.name}"
# }

# resource "azurerm_dns_zone" "example" {
#   name                = "mydomain.com"
#   resource_group_name = azurerm_resource_group.react-rg.name
# }

# resource "azurerm_dns_cname_record" "target" {
#   name                = "target"
#   zone_name           = azurerm_dns_zone.example.name
#   resource_group_name = azurerm_resource_group.react-rg.name
#   ttl                 = 300
#   record              = "contoso.com"
# }

# resource "azurerm_dns_cname_record" "example" {
#   name                = "test"
#   zone_name           = azurerm_dns_zone.example.name
#   resource_group_name = azurerm_resource_group.react-rg.name
#   ttl                 = 300
#   target_resource_id  = azurerm_dns_cname_record.target.id
# }
