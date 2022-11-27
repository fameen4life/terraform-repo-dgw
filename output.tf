/*output "blobid" {
    value = azurerm_storage_blob.example.id
}
output "resourcegroup" {
    value = azurerm_resource_group.example
}*/
/*output "rgnames" {
  value = azurerm_resource_group.example[*].name #splat expression works with list output only
} */

/*
# Splat expression
output "name" {
  value = local.rgdetails
}
output "rgnames" {
  value = local.rgnames
}
output "rglocation" {
  value = local.rglocation
}
output "element" {
  value = element(local.rgnames, 1)
}
output "index" {
  value = index(local.rgnames, "rg-3")
}
output "lookup" {
  value = lookup(local.testmap, "AZ-WEST", "key not found")
}
output "zipmap" {
  value = zipmap(local.rgnames, local.rglocation)
}  */