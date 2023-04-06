/*
  * This script will help us to create a Network Load Balancer
*/

data "google_compute_network" "tf_default" {
  name = "default"
}

resource "google_compute_instance" "tf_vm_1" {
  name         = "blue-instance"
  machine_type = "f1-micro"
  zone         = "us-central1-a"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11-bullseye-v20221206"
    }
  }

  tags = ["network-lb"]

  network_interface {
    network = data.google_compute_network.tf_default.self_link
    access_config {
      // Ephemeral public IP
    }
  }
  metadata_startup_script = templatefile("./network-load-balancing/network-load-balancing.sh", {foldername = "blue"})
}

resource "google_compute_instance" "tf_vm_2" {
  name         = "green-instance"
  machine_type = "f1-micro"
  zone         = "us-central1-a"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11-bullseye-v20221206"
    }
  }

  tags = ["network-lb"]

  network_interface {
    network = data.google_compute_network.tf_default.self_link
    access_config {
      # Ephemeral public IP
    }
  }

  metadata_startup_script = templatefile("./network-load-balancing/network-load-balancing.sh", {foldername = "green"})
}

resource "google_compute_firewall" "tf_network_lb" {
  name        = "firewall-network-lb"
  network     = data.google_compute_network.tf_default.self_link
  target_tags = ["network-lb"]
  allow {
    protocol = "tcp"
    // include "22" only if you want to ssh into vm
    ports    = ["22", "80"]
  }

  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_address" "tf_static_ip" {
  name   = "network-lb-static-ip"
  region = "us-central1"
}

resource "google_compute_http_health_check" "tf_health_check" {
  name = "network-healthcheck"
  timeout_sec        = 5
  check_interval_sec = 5

  healthy_threshold   = 2
  unhealthy_threshold = 2

  request_path = "/"
  port = "80"
}

resource "google_compute_forwarding_rule" "tf_compute_forwarding_rule" {
  name                  = "netwrok-frontend"
  region                = "us-central1"
  ip_protocol           = "TCP"
  port_range            = "80"
  ip_address            = google_compute_address.tf_static_ip.self_link
  target                = google_compute_target_pool.tf_target_pool.self_link
}

                                                                                                                                          
resource "google_compute_target_pool" "tf_target_pool" {
  name = "network-lb"

  instances = [
    google_compute_instance.tf_vm_1.self_link,
    google_compute_instance.tf_vm_2.self_link
  ]

  health_checks = [google_compute_http_health_check.tf_health_check.name]
}