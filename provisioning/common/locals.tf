locals {
  resource_group = "odw-frontend-${var.env}"
  name = "odw-${var.env}"
  application_name = "odw-${var.env}-app"
  location = "eastus2"
  if_static_website_enabled = var.enable_static_website ? [{}] : []
  tags = {
      env         = var.env,
      Application = "odw-frontend-service"
  }
}
