provider "azurerm" {
    version = "=1.5.0"
}

terraform {
    backend "azurerm" {}
}