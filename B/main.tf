provider "azurerm" {
    version = "=1.24.0"
}

resource "azurerm_resource_group" "resource_group" {
  name = "${var.rsg_name}"
  location ="${var.location}"
  tags = "${var.tags}" # It's a map (hash) but you still use string interpolation
}


 /*
 terraform plan -var rsg_name=summit2019B -out B.plan
 terraform destroy -var rsg_name=summit2019B
 terraform plan -var rsg_name=summit2019B -var location="East US 2"
 terraform plan -var rsg_name=summit2019B -var location="East moon 7"
 The syntax might be valid, but that doesn't mean the value is
 There are still some things you don't know if they work until you try to apply

 variables can be defined multiple times in arguments, EVNVARS and files.
 Terraform uses the last value it finds, overriding any previous values.
 https://www.terraform.io/docs/configuration/variables.html#variable-definition-precedence
 0.11 MAPs are merge, in 0.12 MAPs are overriden like all other types
 */