resource "azurerm_resource_group" "react-rg" {
  name = "rg-${local.name}-np-${local.location}"
  location = local.location
  tags = local.common_tags
}

resource "azurerm_static_site" "static-app" {
  name = "web-${local.name}-np-${local.location}"
  resource_group_name = azurerm_resource_group.react-rg.name
  location = local.location
  tags = local.common_tags
}