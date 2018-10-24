variable "database_user_dev" { default = "postgres" }
variable "database_name_dev" { default = "api" }

# Function App

resource "azurerm_app_service_plan" "dev" {
  name                = "${var.project_name}-plan-dev"
  resource_group_name = "${data.azurerm_resource_group.main.name}"
  location            = "${data.azurerm_resource_group.main.location}"
  kind                = "linux"

  sku {
    tier = "Standard"
    size = "S1"
  }
}

resource "azurerm_function_app" "dev" {
  name                      = "${var.project_name}-dev"
  location                  = "${data.azurerm_resource_group.main.location}"
  resource_group_name       = "${data.azurerm_resource_group.main.name}"
  storage_connection_string = "${data.azurerm_storage_account.main.primary_connection_string}"
  app_service_plan_id       = "${azurerm_app_service_plan.dev.id}"
  version                   = "~2"

  app_settings {
    WEBSITE_NODE_DEFAULT_VERSION = "10.6.0"
    DATABASE_URL = "postgres://${var.database_user_dev}@${azurerm_postgresql_server.dev.name}:${random_id.dev.hex}-@${azurerm_postgresql_server.dev.fqdn}:5432/${var.database_name_dev}"
  }
}

# PostgreSQL database

resource "random_id" "dev" {
  keepers = {
    project_name = "${var.project_name}"
  }
  byte_length = 32
}

resource "azurerm_postgresql_server" "dev" {
  name                = "${var.project_name}-dev"
  resource_group_name = "${data.azurerm_resource_group.main.name}"
  location            = "${data.azurerm_resource_group.main.location}"

  sku {
    name = "B_Gen5_2"
    capacity = 2
    tier = "Basic"
    family = "Gen5"
  }

  storage_profile {
    storage_mb = 5120
    backup_retention_days = 7
    geo_redundant_backup = "Disabled"
  }

  version = "10.0"

  administrator_login = "${var.database_user_dev}"
  administrator_login_password = "${random_id.dev.hex}-"

  ssl_enforcement = "Enabled"
}

resource "azurerm_postgresql_firewall_rule" "dev" {
  name                = "public"
  resource_group_name = "${data.azurerm_resource_group.main.name}"
  server_name         = "${azurerm_postgresql_server.dev.name}"
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "255.255.0.0"
}

resource "azurerm_postgresql_database" "dev" {
  name                = "${var.database_name_dev}"
  resource_group_name = "${data.azurerm_resource_group.main.name}"
  server_name         = "${azurerm_postgresql_server.dev.name}"
  charset             = "UTF8"
  collation           = "English_United States.1252"
}
