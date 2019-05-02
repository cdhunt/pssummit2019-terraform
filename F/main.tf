provider "azurerm" {}

variable "second-site" {
  default = false # that looks like a bool...
}

resource "azurerm_resource_group" "rsg-pri" {
  name     = "summit2019F-0"
  location = "East US"
}

resource "azurerm_resource_group" "rsg-sec" {
  count    = "${var.second-site}"
  name     = "summit2019F-${count.index+1}"
  location = "East US 2"
}

/*
terraform plan -var second-site=1
terraform plan -var second-site=2
*/