output "rg1" {
  value = azurerm_resource_group.rg1.name
}

output "rg2" {
  value = azurerm_resource_group.rg2.name
}

output "vm1" {
  value = azurerm_linux_virtual_machine.vm1.name
}

output "vm2" {
  value = azurerm_linux_virtual_machine.vm2.name
}

output "vm1_public_ip" {
  value = azurerm_public_ip.vm1_public_ip.ip_address
}

output "vm2_public_ip" {
  value = azurerm_public_ip.vm2_public_ip.ip_address
}

output "vm1_private_ip" {
  value = azurerm_network_interface.vm1_nic.private_ip_address
}

output "vm2_private_ip" {
  value = azurerm_network_interface.vm2_nic.private_ip_address
}

output "unmasked_ssh_username" {
  value = nonsensitive(var.admin_username)
}
