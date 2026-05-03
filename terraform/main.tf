resource "azurerm_resource_group" "rg" {
  name     = "rg-kubewealth-prod"
  location = "Central India" # Changed to a region with higher availability
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                = "aks-kubewealth"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = "kubewealth"

  # Explicitly set the Free Tier. 
  sku_tier = "Free"

  default_node_pool {
    name                        = "systempool"
    node_count                  = 1
    vm_size                     = "Standard_B2als_v2" # Changed to a widely available, low-cost SKU
    temporary_name_for_rotation = "tmpnoderot" # Added to prevent update errors

    # Shrink default disk size from 128GB to 32GB
    os_disk_size_gb             = 32

    # # Auto-scaling instead of fixed count (disable node_count)
    # auto_scaling_enabled        = true
    # min_count                   = 1
    # max_count                   = 2
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin    = "azure"
    load_balancer_sku = "standard"
  }
}