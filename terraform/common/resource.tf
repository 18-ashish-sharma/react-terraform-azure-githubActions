resource "azurerm_resource_group" "react-rg" {
  name = "react-${local.name}-np-${local.location}"
  location = local.location
}

resource "azurerm_static_site" "static-app" {
  name = "web-${local.name}-np-${local.location}"
  resource_group_name = azurerm_resource_group.react-rg.name
  location = local.location
  source = local.source
  branch = "main"
  app-location = "/"
  output-location = "build" 
}


# # Generate a random integer to create a globally unique name
# resource "random_integer" "ri" {
#   min = 10000
#   max = 99999
# }


# # Create the Linux App Service Plan


# resource "azurerm_app_service_plan" "appserviceplan" {
#   name                = "webapp-asp-${random_integer.ri.result}"
#   location            = azurerm_resource_group.react-rg.location
#   resource_group_name = azurerm_resource_group.react-rg.name
#   sku {
#     tier = "Free"
#     size = "F1"
#   }
# }


# # Create the web app, pass in the App Service Plan ID, and deploy code from a public GitHub repo

# resource "azurerm_app_service" "webapp" {
#   name                = "webapp-${random_integer.ri.result}-${local.name}-np"
#   location            = azurerm_resource_group.react-rg.location
#   resource_group_name = azurerm_resource_group.react-rg.name
#   app_service_plan_id = azurerm_app_service_plan.appserviceplan.id
# }

# resource "random_string" "unique" {
#   length  = 4
#   lower   = true
#   number  = true
#   upper   = false
#   special = false
# }

# resource "azurerm_resource_group" "linux" {
#   name     = "rg-linux-${random_string.unique.result}"
#   location = "centralus"
# }

# resource "azurerm_app_service_plan" "linux" {
#   name                = "plan-linux-${random_string.unique.result}"
#   location            = azurerm_resource_group.linux.location
#   resource_group_name = azurerm_resource_group.linux.name
#   kind                = "Linux"
#   reserved            = true # Must be true for Linux plans

#   sku {
#     tier     = "Free"
#     size     = "F1"
#     capacity = 1 # Must be at least 1 when reserved is true
#   }
# }


# resource "azurerm_app_service" "linux" {
#   name                = "app-linux-${random_string.unique.result}"
#   location            = azurerm_resource_group.linux.location
#   resource_group_name = azurerm_resource_group.linux.name
#   app_service_plan_id = azurerm_app_service_plan.linux.id

#   site_config {
#     # Free tier only supports 32-bit
#     use_32_bit_worker_process = true
#     # Run "az webapp list-runtimes --linux" for current supported values, but
#     # always connect to the runtime with "az webapp ssh" or output the value
#     # of process.version from a running app because you might not get the
#     # version you expect
#     linux_fx_version = "NODE|16-lts"
#   }
# }