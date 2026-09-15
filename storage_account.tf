resource "azurerm_storage_account" "storage" {
  name                            = var.storage_account_name
  resource_group_name             = azurerm_resource_group.rg.name
  location                        = azurerm_resource_group.rg.location
  account_tier                    = "Standard"
  account_replication_type        = "LRS"
  min_tls_version                 = "TLS1_2"
  allow_nested_items_to_be_public = false
  tags                            = var.tags
  blob_properties {
    delete_retention_policy { days = 7 }
  }
}
resource "azurerm_storage_container" "create_container" {
  for_each              = { source = var.source_folder_name, destination = var.destination_folder_name }
  name                  = each.value
  storage_account_name  = azurerm_storage_account.storage.name
  container_access_type = "private"
}
output "storage_account_id" {
  value = azurerm_storage_account.storage.id
}
