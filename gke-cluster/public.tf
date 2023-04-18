/*
    * This Script will help us to create Public GKE Cluster
    * With default Network
*/

resource "google_container_cluster" "tf_gke" {
  name = var.cluster_name
  location = var.zone // This will create a zonal cluster
  //location = var.region // This will create a regional cluster

  node_pool {
    name = var.node_pool
    node_count = 2
    node_config {
        machine_type = var.machine_type
        disk_size_gb = 50
    }
  }

  // This is optional 
  network_policy {
    enabled = true
    provider = "CALICO"
    
  }

  // This is mandatory if you are using network policy else optional
  addons_config {
    network_policy_config {
      disabled = false
    }
  }
}

# resource "google_storage_bucket" "tf_storage_bucket" {
#   name = "terraform-bucket-377619"
#   location = "US"
#   public_access_prevention = "enforced"
#   storage_class = "STANDARD"
#   versioning {
#     enabled = true
#   }
# }

# terraform {
#   backend "gcs" {
#     bucket = "terraform-bucket-377619"
#     prefix = "terraform/state"
#     credentials = "account.json"
#   }
# }