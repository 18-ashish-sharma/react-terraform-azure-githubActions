resource "azurerm_resource_group" "react-rg" {
  name = "rg-${local.name}-np-${local.location}"
  location = local.location
}

# resource "azurerm_static_site" "static-app" {
#   name = "web-${local.name}-np-${local.location}"
#   resource_group_name = azurerm_resource_group.react-rg.name
#   location = local.location
#   tags = local.common_tags
# }


# Generate a random integer to create a globally unique name
resource "random_integer" "ri" {
  min = 10000
  max = 99999
}


# Create the Linux App Service Plan


resource "azurerm_app_service_plan" "appserviceplan" {
  name                = "webapp-asp-${random_integer.ri.result}"
  location            = azurerm_resource_group.react-rg.location
  resource_group_name = azurerm_resource_group.react-rg.name
  sku {
    tier = "Free"
    size = "F1"
  }
}


# Create the web app, pass in the App Service Plan ID, and deploy code from a public GitHub repo

resource "azurerm_app_service" "webapp" {
  name                = "webapp-${random_integer.ri.result}-${local.name}-np"
  location            = azurerm_resource_group.react-rg.location
  resource_group_name = azurerm_resource_group.react-rg.name
  app_service_plan_id = azurerm_app_service_plan.appserviceplan.id
}