variable "resource_group" {
  description = "The resource group"
  default = "ody"
}

variable "application_name" {
  description = "The Spring Boot application name"
  default     = "appody"
}

variable "location" {
  description = "The Azure location where all resources in this example should be created"
  default     = "centralindia"
}
variable "env" {}