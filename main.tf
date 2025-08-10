terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.39.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
}

resource "azurerm_resource_group" "alex-bazar-rg" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_service_plan" "bazar-service" {
  name                = var.bazar-service-plan-name
  resource_group_name = azurerm_resource_group.alex-bazar-rg.name
  location            = azurerm_resource_group.alex-bazar-rg.location
  sku_name            = "F1"
  os_type             = "Linux"
}

resource "azurerm_linux_web_app" "bazar-app" {
  name                = var.bazar-app-name
  resource_group_name = azurerm_resource_group.alex-bazar-rg.name
  location            = azurerm_resource_group.alex-bazar-rg.location
  service_plan_id     = azurerm_service_plan.bazar-service.id

  site_config {
    application_stack {
      dotnet_version = "6.0"
    }
    always_on = false
  }

  connection_string {
    name  = "DefaultConnection"
    type  = "SQLAzure"
    value = "Data Source=tcp:${azurerm_mssql_server.bazar-mssql-server.fully_qualified_domain_name},1433;Initial Catalog=${azurerm_mssql_database.bazar-mssql-database.name};User ID=${azurerm_mssql_server.bazar-mssql-server.administrator_login};Password=${azurerm_mssql_server.bazar-mssql-server.administrator_login_password};Trusted_Connection=False; MultipleActiveResultSets=True;"
  }
}

resource "azurerm_app_service_source_control" "alex-bazar-source" {
  app_id                 = azurerm_linux_web_app.bazar-app.id
  repo_url               = var.repo_url
  branch                 = "main"
  use_manual_integration = true
}

resource "azurerm_mssql_server" "bazar-mssql-server" {
  name                         = var.mssqlserver_name
  resource_group_name          = azurerm_resource_group.alex-bazar-rg.name
  location                     = azurerm_resource_group.alex-bazar-rg.location
  version                      = "12.0"
  administrator_login          = var.mssqlserver_administrator_login
  administrator_login_password = var.mssqlserver_administrator_login_password
}

resource "azurerm_mssql_database" "bazar-mssql-database" {
  name           = var.mssqldatabase_name
  server_id      = azurerm_mssql_server.bazar-mssql-server.id
  collation      = "SQL_Latin1_General_CP1_CI_AS"
  max_size_gb    = 2
  sku_name       = "S0"
  zone_redundant = false
  license_type   = "LicenseIncluded"
}

resource "azurerm_mssql_firewall_rule" "alex-bazar-mssql-firewall" {
  name             = var.firewall_rule_name
  server_id        = azurerm_mssql_server.bazar-mssql-server.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "0.0.0.0"
}
