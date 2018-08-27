provider "azurerm" {
    version = "=1.13"
}

provider "random" {
    version = "=2.0"
}

terraform {
    backend "azurerm" {}
}

#* provider.azurerm: version = "~> 1.13"
#* provider.random: version = "~> 2.0"

