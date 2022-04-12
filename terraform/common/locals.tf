locals {
  resource_group = "odw-frontend-${var.env}"
  name = "react-${var.env}"
  application_name = "odw-${var.env}-app"
  location = "eastus2"
  
  tags = {
      env         = var.env,
      Application = "odw-frontend-service"
  }
}
