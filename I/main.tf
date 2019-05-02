# Probably not a good idea to keep state files locally
# Put them in the cloud!

terraform {
  backend "azurerm" {}
}

provider "azurerm" {}

resource "azurerm_resource_group" "rsg" {
  name = "summit2019I"
  location ="East US"
}

/*
terraform init -backend-config="access_key=$env:storage_key" -backend-config=".\backend.tfvars"
*/