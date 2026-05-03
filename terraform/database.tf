resource "random_password" "db_password" {
  length  = 16
  special = true
}

resource "azurerm_postgresql_flexible_server" "postgres" {
  name                   = "psql-kubewealth-prod"
  resource_group_name    = azurerm_resource_group.rg.name
  location               = azurerm_resource_group.rg.location
  version                = "16"
  administrator_login    = "azureuser"
  administrator_password = random_password.db_password.result
  
  # The B1ms SKU keeps cost minimal for production-like environments
  sku_name   = "B_Standard_B1ms"
  storage_mb = 32768
}

resource "azurerm_postgresql_flexible_server_firewall_rule" "allow_aks" {
  name             = "allow-all-azure-internal-ips"
  server_id        = azurerm_postgresql_flexible_server.postgres.id
  start_ip_address = "0.0.0.0" # Accessible via private VNet in a real implementation
  end_ip_address   = "255.255.255.255"
}