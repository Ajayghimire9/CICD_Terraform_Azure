resource "azurerm_data_factory" "adf" {
  name                = var.df_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  tags                = var.tags
  identity { type = "SystemAssigned" }
}
resource "azurerm_role_assignment" "factory_blob_access" {
  scope                = azurerm_storage_account.storage.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_data_factory.adf.identity[0].principal_id
}
resource "azurerm_data_factory_linked_service_azure_blob_storage" "storage" {
  name                 = "managed-identity-storage"
  data_factory_id      = azurerm_data_factory.adf.id
  service_endpoint     = azurerm_storage_account.storage.primary_blob_endpoint
  use_managed_identity = true
}
resource "azurerm_data_factory_dataset_binary" "dataset" {
  for_each            = azurerm_storage_container.create_container
  name                = "${each.key}_dataset"
  data_factory_id     = azurerm_data_factory.adf.id
  linked_service_name = azurerm_data_factory_linked_service_azure_blob_storage.storage.name
  azure_blob_storage_location {
    container = each.value.name
    path      = "incoming"
  }
}
resource "azurerm_data_factory_pipeline" "copy_data" {
  name            = "copy_data_pipeline"
  data_factory_id = azurerm_data_factory.adf.id
  activities_json = jsonencode([{
    name   = "CopyFromSourceToDestination"
    type   = "Copy"
    policy = { timeout = "0.01:00:00", retry = 2, retryIntervalInSeconds = 30 }
    typeProperties = {
      source = { type = "BinarySource", storeSettings = { type = "AzureBlobStorageReadSettings", recursive = true } }
      sink   = { type = "BinarySink", storeSettings = { type = "AzureBlobStorageWriteSettings" } }
    }
    inputs  = [{ referenceName = azurerm_data_factory_dataset_binary.dataset["source"].name, type = "DatasetReference" }]
    outputs = [{ referenceName = azurerm_data_factory_dataset_binary.dataset["destination"].name, type = "DatasetReference" }]
  }])
  depends_on = [azurerm_role_assignment.factory_blob_access]
}
output "data_factory_id" {
  value = azurerm_data_factory.adf.id
}
