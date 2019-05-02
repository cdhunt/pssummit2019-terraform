# Terraform doesn't care how you organize
# I care. Please do do it like this.

variable "rsg_name" {
    default = "summit2019-c"
}

variable "location" {
    description = "Azure region to create the RSG in."
    default = "East US"
}

provider "azurerm" {
    version = "=1.24.0"
}


output "rsg_id" {
  value = "${azurerm_resource_group.rsg.id}"
}

resource "azurerm_resource_group" "rsg" {
  name = "${var.rsg_name}"
  location ="${var.location}"
  tags = "${var.tags}"
}

variable "tags" {
  description = "A list of tags to apply to this RSG."
  type = "map"
    default = {
        owner = "Chris"
        purpose = "Demo"
    }
}

# If you have existing resoruces, you can import their state into Terraform to be managed.
# terraform import azurerm_resource_group.rsg /subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/myresourcegroup