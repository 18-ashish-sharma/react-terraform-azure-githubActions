locals {
  resource_group = "odw-frontend-${var.env}"
  name = "react-${var.env}"
  application_name = "odw-${var.env}-app"
  location = "eastus2"
  source = "https://github.com/18-ashish-sharma/terrafrom_react"
  account_tier              = (var.account_kind == "FileStorage" ? "Premium" : split("_", var.sku)[0])
  account_replication_type  = (local.account_tier == "Premium" ? "LRS" : split("_", var.sku)[1])
  resource_group_name       = "new-rg"
  storage_account_name      = "new-storage"
  if_static_website_enabled = var.enable_static_website ? [{}] : []
  tags = {
      env         = var.env,
      Application = "odw-frontend-service"
  }
}
