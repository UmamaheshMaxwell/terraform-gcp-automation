# /*
#   * Connect to GCP
# */

# provider "google" {
#   project = var.project
#   region = var.region
#   credentials = var.credentials
# }

# /*
#  * Crate a VPC
# */
# resource "google_compute_network" "tf_vpc_network" {
#   name = var.network
#   auto_create_subnetworks = false
# }

# /*
#  * Crate a subnetwork
# */
# resource "google_compute_subnetwork" "tf_vpc_subnetwork" {
#   name = "subnet-a"
#   ip_cidr_range = "10.8.0.0/16"
#   network = google_compute_network.tf_vpc_network.id
# }

# /*
#  * Crate a firewall
# */
# resource "google_compute_firewall" "tf_vpc_firewall_icmp" {
#     name = "custom-allow-icmp"
#     network = google_compute_network.tf_vpc_network.id
#     allow {
#       protocol = "icmp"
#     }
#      source_ranges = ["0.0.0.0/0"]
# }

# resource "google_compute_firewall" "tf_vpc_firewall_tcp" {
#     name = "custom-allow-ssh"
#     network = google_compute_network.tf_vpc_network.id
#     allow {
#       protocol = "tcp"
#       ports = ["22", "80"]
#     }
#     source_ranges = ["0.0.0.0/0"]
    
# }

# /*
#     * Create an instance template
# */
# resource "google_compute_instance_template" "tf_instance_template" {
#   name = "instance-template"
#   machine_type = var.machine_type
  
#   disk {
#     source_image = var.image
#   }

#   network_interface {
#     network = google_compute_network.tf_vpc_network.id
#     subnetwork = google_compute_subnetwork.tf_vpc_subnetwork.id
#     access_config {
      
#     }
#   }

#   metadata_startup_script = "${file("./startup-script.sh")}"
# }

# /*
#     * Create an instance group
# */
# resource "google_compute_region_instance_group_manager" "tf_instance_group" {
#     name = "instance-group"

#     base_instance_name = "instance"
#     target_size = 3

#     version {
#       instance_template = google_compute_instance_template.tf_instance_template.id
#     }

#     auto_healing_policies {
#       health_check = data.google_compute_health_check.health_check.id
#       initial_delay_sec = 300
#     }
# }

# data "google_compute_health_check" "health_check" {
#   name = "lb-health-check"
# }

# resource "google_storage_bucket" "tf_gcs_bucket" {
#   name = "uma-bucket-34936c492c8d93d6"
#   location = "US"
#   storage_class = "standard"
#   public_access_prevention = "enforced"
#   versioning {
#     enabled = true
#   }
# }

# # resource "random_id" "bucket_id" {
# #   byte_length = 8
# # }

# terraform {
#   backend "gcs" {
#     bucket = "uma-bucket-34936c492c8d93d6"
#     prefix = "terraform/state"
#     credentials = "credentials.json"
#   }
# }

# /*
#  * Crate a VM
# */
# resource "google_compute_instance" "tf_vm" {
#   name = "custom-vm"
#   machine_type = var.machine_type
#   zone = var.zone

#   network_interface {
#     network = google_compute_network.tf_vpc_network.id
#     subnetwork = google_compute_subnetwork.tf_vpc_subnetwork.id
#     access_config {
#       nat_ip = google_compute_address.static_ip.address
#     }
#   }

#   boot_disk {
#     initialize_params {
#       image = "debian-cloud/debian-10"
#     }
#   }
# }

# resource "google_compute_address" "static_ip" {
#     name = "ip4-address"
# }