variable "resource_group_name" {
  type = string
}
variable "location" {
  type = string
}
variable "db_server_name" {
  type = string
}
variable "db_name" {
  type = string
}
variable "admin_username" {
  type = string
}
variable "admin_password" {
  type      = string
  sensitive = true
}
