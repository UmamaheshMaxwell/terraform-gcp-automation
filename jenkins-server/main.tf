
resource "google_compute_network" "tf_vpc" {
  name = "jenkins-vpc"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "tf_subnet" {
  name = "subnet-a"
  ip_cidr_range = "10.3.1.0/24"
  region = "us-central1"
  network = google_compute_network.tf_vpc.id
}

resource "google_compute_firewall" "tf_firewall" {
  name = "jenkins-allow-vpc"
  network = google_compute_network.tf_vpc.id
  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports = ["22", "80", "8080"]
  }

   source_ranges = [ "0.0.0.0/0" ]
}
resource "google_compute_instance" "tf_instance" {
    name = "jenkins-server"
    machine_type = "e2-small"
    zone ="us-central1-a"

    boot_disk {
      initialize_params {
        image = "centos-cloud/centos-7"
      }
    }

    network_interface {
      network = google_compute_network.tf_vpc.id
      subnetwork = google_compute_subnetwork.tf_subnet.id
      access_config {
         // Ephemeral public IP
      }
    }
    metadata_startup_script = file("./jenkins-server/install-jenkins.sh")
}