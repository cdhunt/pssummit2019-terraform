provider "azurerm" {}

resource "azurerm_resource_group" "rsg" {
  name = "summit2019"
  location ="East US"
}

module "network" {
  source  = "Azure/network/azurerm"
  version = "2.0.0"
    resource_group_name = "${azurerm_resource_group.rsg.name}"
    location            = "${azurerm_resource_group.rsg.location}"
    address_space       = "10.0.0.0/24"
    subnet_prefixes     = ["10.0.1.0/25"]
    subnet_names        = ["subnet1"]
}

/*
terraform plan
/*

# https://registry.terraform.io/modules/Azure/network/azurerm/2.0.0
# https://www.terraform.io/docs/configuration/modules.html#module-versions
# https://github.com/Azure/terraform-azurerm-network/blob/master/main.tf
