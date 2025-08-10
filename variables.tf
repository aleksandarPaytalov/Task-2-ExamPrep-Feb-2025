variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Location of the resource group"
  type        = string
}

variable "subscription_id" {
  description = "value of the subscription id"
  type        = string
}

variable "bazar-service-plan-name" {
  description = "Name of the bazar service plan"
  type        = string
}

variable "bazar-app-name" {
  description = "Name of the bazar app"
  type        = string
}

variable "repo_url" {
  description = "value of the repo url"
  type        = string
}

variable "mssqlserver_name" {
  description = "value of the mssqlserver name"
  type        = string
}

variable "mssqlserver_administrator_login" {
  description = "value of the mssqlserver administrator login"
  type        = string
}

variable "mssqlserver_administrator_login_password" {
  description = "value of the mssqlserver administrator login password"
  type        = string
}

variable "mssqldatabase_name" {
  description = "value of the mssqldatabase name"
  type        = string
}

variable "firewall_rule_name" {
  description = "value of the firewall rule name"
  type        = string
}
