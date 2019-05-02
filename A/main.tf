# You just need a few lines to get started.

provider "azurerm" {}

resource "azurerm_resource_group" "rsg" {
  name = "summit2019"
  location ="East US"
}
