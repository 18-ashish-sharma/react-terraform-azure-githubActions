locals {
  resource_group = "odw-frontend-${var.env}"
  name = "react-${var.env}"
  application_name = "odw-${var.env}-app"
  location = "eastus2"
  source = "https://github.com/18-ashish-sharma/terrafrom_react"
  
  tags = {
      env         = var.env,
      Application = "odw-frontend-service"
  }
}
