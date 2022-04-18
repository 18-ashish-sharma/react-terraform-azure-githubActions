output "storage_account_primary_connection_string" {
  value = azurerm_storage_account.react-storage-account.primary_connection_string
}

output test{
    value = local.test
}
# # output "hello world" {
# #   value = "www"
# # }