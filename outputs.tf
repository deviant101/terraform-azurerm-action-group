output "id" {
  description = "The ID of the Action Group"
  value       = azurerm_monitor_action_group.action_group.id
}

output "name" {
  description = "The name of the Action Group"
  value       = azurerm_monitor_action_group.action_group.name
}

output "resource_group_name" {
  description = "The resource group name where the Action Group is created"
  value       = azurerm_monitor_action_group.action_group.resource_group_name
}
