/*
   * Input variables 
   ? Number
   ! String
   ? Bool
   ! List(<TYPE>)
   ? Set(<TYPE>)
   ! Map(<TYPE>)
   ? Object({ATTR_NAME=type,...})
   ! Tuple([<type>,..])
*/

resource "google_compute_network" "tf_vpc1" {
  name = "vpc-1"
  auto_create_subnetworks = var.auto_create_subnetworks
  mtu = var.maximum_transmission_unit
}

resource "google_compute_subnetwork" "tf_subnet_a" {
  name = "subnet-a"
  ip_cidr_range = "10.2.1.0/24"
  region = "us-central1"
  network = google_compute_network.tf_vpc1.id
}

resource "google_compute_firewall" "tf_firewall_1" {
  name = "custom-allow-vpc1"
  network = google_compute_network.tf_vpc1.id
  allow {
    protocol = var.protocol[0]
  }

  allow {
    protocol = var.protocol[1]
    ports = var.ports
  }

   source_ranges = var.source_ranges
}

resource "google_compute_instance" "tf_vm" {
  name = var.name
  machine_type = var.machine_type
  zone = var.zone

  tags = var.tags
  metadata = var.metadata
  labels = var.labels

  network_interface {
    network = google_compute_network.tf_vpc1.id
    subnetwork = google_compute_subnetwork.tf_subnet_a.id
    access_config {
      // Ephemeral public IP
    }
  }
  
  boot_disk {
    initialize_params {
      image = var.image
    }
    auto_delete = true
  }
}