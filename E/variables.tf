variable "name_prefix" {
  default = "summit2019"
}

variable "location" {
  description = "Azure region to create the RSG in."
  default     = "East US"
}

variable "tags" {
  description = "A list of tags to apply to this RSG."
  type        = "map"

  default = {
    owner   = "Chris"
    purpose = "Demo"
  }
}