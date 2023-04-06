output "vpc" {
  value = google_compute_network.tf_vpc.id
}

output "subnet" {
  value = google_compute_subnetwork.tf_subnet_a.id
}

output "public_ip" {
  value = google_compute_instance.tf_instance.network_interface[0].access_config[0].nat_ip
}