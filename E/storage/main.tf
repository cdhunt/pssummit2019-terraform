# Provider is inharited, but can be not define if you need different version contsraints

data "azurerm_resource_group" "rsg_data" {
  name = "${var.rsg_name}"
}

locals {
  storage_name = "${var.prefix}str"
}

resource "azurerm_storage_account" "storage" {
  name                = "${local.storage_name}"
  location            = "${data.azurerm_resource_group.rsg_data.location}"
  resource_group_name = "${var.rsg_name}"

  tags = "${data.azurerm_resource_group.rsg_data.tags}"

  account_tier             = "Standard"
  account_replication_type = "LRS"
}
