output "standard_storage_account_id" {
  value       = "${azurerm_storage_account.standard-storage.id}"
  description = "Standard storage account Resource ID"
}

output "standard_storage_account_name" {
  value       = "${azurerm_storage_account.standard-storage.name}"
  description = "Standard storage account Resource name"
}

output "standard_storage_account_key" {
  value       = "${azurerm_storage_account.standard-storage.primary_access_key}"
  description = "Standard storage account primary access key"
  sensitive   = true
}

output "standard_blob_endpoint" {
  value       = "${azurerm_storage_account.standard-storage.primary_blob_endpoint}"
  description = "Standard storage account primary location for blob storage"
}
