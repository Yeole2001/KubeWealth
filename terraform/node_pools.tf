resource "azurerm_kubernetes_cluster_node_pool" "userpool" {
  # Renamed from 'spotpool' to 'userpool' to reflect the change
  name                  = "userpool"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.aks.id
  
  # Updated to the new low-cost ARM instance
  vm_size               = "Standard_B2als_v2"
  node_count            = 2
  os_disk_size_gb       = 32 
  
  node_labels = {
    "nodetype" = "user"
  }
}

# Node as Spot Instances
# resource "azurerm_kubernetes_cluster_node_pool" "spotpool" {
#   name                  = "spotpool"
#   kubernetes_cluster_id = azurerm_kubernetes_cluster.aks.id
#   vm_size               = "Standard_B2s"
#   node_count            = 2

#   # Shrink default disk size from 128GB to 32GB
#   os_disk_size_gb             = 32

#   # The Magic Sauce for Cost Optimization:
#   priority        = "Spot"
#   eviction_policy = "Delete"
#   spot_max_price  = -1 # Pay up to the regular price

#   node_labels = {
#     "nodetype" = "spot"
#   }

#   # Ensure the system doesn't accidentally put critical services here
#   node_taints = ["kubernetes.azure.com/scalesetpriority=spot:NoSchedule"]
# }