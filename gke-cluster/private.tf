# /*
#     * This Script will help us to create Private GKE Cluster
#     * With Custom Network
# */

# resource "google_compute_network" "tf_custom_network" {
#     name = "gke-network"
#     auto_create_subnetworks = false
# }

# resource "google_compute_subnetwork" "tf_custom_subnetwork" {
#   name = "gke-subnet-a"
  
#   ip_cidr_range = "10.0.1.0/24"
#   region = var.region
#   network = google_compute_network.tf_custom_network.self_link

#   secondary_ip_range = [ 
#     {
#         range_name  = "pod-network"
#         ip_cidr_range = "172.16.0.0/18"
#     },
#     {
#         range_name = "service-network"
#         ip_cidr_range = "172.16.64.0/20"
#     }
#   ]
# }

# resource "google_compute_firewall" "tf_firewall_1" {
#     name = "gke-firewall"
#     network = google_compute_network.tf_custom_network.self_link
  
#     allow {
#         protocol = "icmp"
#     }

#     allow {
#         protocol = "tcp"
#         ports = ["22","80"]
#     }

#   /*  
#     * This allow block is needed only if you are exposing the service via NodePort
#     * As this is private cluster we will have to create ingress controller and 
#     * configure it to route traffic to the NodePort Service 
#   */
# #   allow {
# #     protocol = "tcp"
# #     ports = ["30000-32767"]
# #   }

#     source_ranges = [ "0.0.0.0/0" ]
# }

# resource "google_container_cluster" "tf_cluster" {
#     name     = "poc-cluster"
#     location = var.zone

#     node_pool {
#         name = "gke-pool"
#         node_count = 2
#         node_config {
#             machine_type = var.machine_type
#             disk_size_gb = 50
#         }
#     }
    
#     network_policy {
#         enabled = true
#         provider = "CALICO"
#     }

#   // This is mandatory only if you are using network policy else optional
#     addons_config {
#         network_policy_config {
#             disabled = false
#         }

#         // HTTP Load Balancing is enabled by default set disabled = true to disable
#         # http_load_balancing {
#         #   disabled = true
#         # }
#     }

#     network = google_compute_network.tf_custom_network.self_link
#     subnetwork = google_compute_subnetwork.tf_custom_subnetwork.self_link

#     # This block turns the cluster to private cluster 
#     private_cluster_config {
#         enable_private_nodes   = true
#         enable_private_endpoint = false  
#         master_ipv4_cidr_block = "10.0.5.0/28"

#     }

#     ip_allocation_policy {
#         cluster_secondary_range_name = google_compute_subnetwork.tf_custom_subnetwork.secondary_ip_range[0].range_name
#         services_secondary_range_name = google_compute_subnetwork.tf_custom_subnetwork.secondary_ip_range[1].range_name
#     }
# }