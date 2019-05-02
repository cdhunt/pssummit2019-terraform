provider "azurerm" {
  version = "=1.24.0"
}

variable "tags" {
  description = "A list of tags to apply to this RSG."
  type        = "map"

  default = {
    owner   = "Chris"
    purpose = "Demo"
  }
}

# Terraform locals are like ARM variables
locals {
  storage_name = "unique57r1ng"
  rsg_name = "summit2019D"
}

# Data resources read data from other sources
data "azurerm_resource_group" "rsg_data" {
  name = "${local.rsg_name}"
}

resource "azurerm_storage_account" "storage" {
  name                = "${local.storage_name}"
  location            = "${data.azurerm_resource_group.rsg_data.location}"
  resource_group_name = "${local.rsg_name}"

  tags = "${data.azurerm_resource_group.rsg_data.tags}"

  account_tier             = "Standard"
  account_replication_type = "LRS"
}
