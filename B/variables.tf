# Terraform variables are like ARM parameters

variable "rsg_name" {}

# Type can be infered from the default value
# You can optionally provide a description
variable "location" {
    description = "Azure region to create the RSG in."
    default = "East US"
}

# Valid type values are string, list, and map
# No numeric or boolean types? We'll talk about that later
variable "tags" {
  description = "A list of tags to apply to this RSG."
  type = "map"
    default = {
        owner = "Chris"
        purpose = "Demo"
    }
}
