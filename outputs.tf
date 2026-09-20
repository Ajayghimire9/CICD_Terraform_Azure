output "resource_group_name" {
  description = "Resource group hosting the data platform."
  value       = azurerm_resource_group.rg.name
}

output "data_factory_name" {
  description = "Azure Data Factory instance provisioned by the platform."
  value       = azurerm_data_factory.adf.name
}

output "storage_account_name" {
  description = "Data lake storage account provisioned by the platform."
  value       = azurerm_storage_account.storage.name
  sensitive   = false
}
