resource "azurerm_resource_group" "rsg" {
  name     = "${var.name_prefix}E"
  location = "${var.location}"
  tags     = "${var.tags}"
}

module "storage" {
    source = "./storage"

    prefix = "${var.name_prefix}"
    rsg_name = "${azurerm_resource_group.rsg.name}"
}