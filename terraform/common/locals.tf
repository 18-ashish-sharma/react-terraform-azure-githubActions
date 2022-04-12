locals {
  resource_group = "odw-frontend-${var.env}"
  name = "react-${var.env}"
  application_name = "odw-${var.env}-app"
  location = "centralindia"
  
  tags = {
      env         = var.env,
      Application = "odw-frontend-service"
  }
}
