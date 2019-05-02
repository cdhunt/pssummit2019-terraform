
resource "azurerm_resource_group" "rsg" {
  name     = "tf_${var.prefix}"
  location = "${var.location}"
}

resource "azurerm_storage_account" "standard-storage" {
  name                = "${var.prefix}stdstorage"
  location            = "${azurerm_resource_group.rsg.location}"
  resource_group_name = "${azurerm_resource_group.rsg.name}"

  account_tier              = "Standard"
  account_replication_type  = "LRS"
  enable_blob_encryption    = "true"
  enable_https_traffic_only = true
}