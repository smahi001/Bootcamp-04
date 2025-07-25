variable "resource_group_name" {
  type = string
}
variable "location" {
  type = string
}
variable "storage_account_name" {
  type = string
}
variable "replication_type" {
  type    = string
  default = "LRS"
  validation {
    condition     = contains(["LRS", "GRS", "RAGRS", "ZRS", "GZRS", "RAGZRS"], upper(var.replication_type))
    error_message = "Invalid replication_type. Must be one of LRS, GRS, RAGRS, ZRS, GZRS, RAGZRS."
  }
}
