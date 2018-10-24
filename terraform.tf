variable "project_name" {}
variable "resource_group_name" {}

provider "azurerm" { }

data "azurerm_resource_group" "main" {
  name = "${var.resource_group_name}"
}

data "azurerm_storage_account" "main" {
  name = "terraformtesting"
  resource_group_name = "${var.resource_group_name}"
}

