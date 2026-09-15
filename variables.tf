variable "resource_group_name" {
  type        = string
  description = "Resource group for this demonstration."
  default     = "rg-data-foundation-dev"
}
variable "location" {
  type        = string
  description = "Azure deployment region."
  default     = "westeurope"
}
variable "tags" {
  type        = map(string)
  description = "Ownership and environment metadata."
  default     = { environment = "development", project = "data-foundation" }
}
variable "storage_account_name" {
  type        = string
  description = "Globally unique lowercase alphanumeric name, 3-24 characters."
  validation {
    condition     = can(regex("^[a-z0-9]{3,24}$", var.storage_account_name))
    error_message = "Use 3-24 lowercase letters or digits."
  }
}
variable "df_name" {
  type        = string
  description = "Globally unique Data Factory name."
}
variable "source_folder_name" {
  type        = string
  description = "Source blob container."
  default     = "source"
}
variable "destination_folder_name" {
  type        = string
  description = "Destination blob container."
  default     = "destination"
}
