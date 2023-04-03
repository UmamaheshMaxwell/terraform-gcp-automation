

resource "google_compute_network" "tf_vpc1" {
  name = "vpc-1"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "tf_subnet_a" {
  name = "subnet-a"
  ip_cidr_range = "10.2.1.0/24"
  region = "us-central1"
  network = google_compute_network.tf_vpc1.id
}

resource "google_compute_network" "tf_vpc2" {
  name = "vpc-2"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "tf_subnet_b" {
  name = "subnet-b"
  ip_cidr_range = "10.3.1.0/24"
  region = "europe-west2"
  network = google_compute_network.tf_vpc2.id
}

resource "google_compute_firewall" "tf_firewall_1" {
  name = "custom-allow-vpc1"
  network = google_compute_network.tf_vpc1.id
  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports = ["22", "80"]
  }

   source_tags = ["peering"]
}

resource "google_compute_firewall" "tf_firewall_2" {
  name = "custom-allow-vpc2"
  network = google_compute_network.tf_vpc2.id
  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports = ["22", "80"]
  }

  source_ranges = [ "0.0.0.0/0" ]
}

resource "google_compute_instance" "tf_vm_1" {
    name = "custom-vm-1"
    machine_type = "f1-micro"
    zone ="us-central1-a"

    boot_disk {
      initialize_params {
        image = "debian-cloud/debian-11"
      }
    }

    network_interface {
      network = google_compute_network.tf_vpc1.id
      subnetwork = google_compute_subnetwork.tf_subnet_a.id
      access_config {
        
      }
    }
    metadata_startup_script = file("./vpc-peering/install-nginx.sh")
}

resource "google_compute_instance" "tf_vm_2" {
  name = "custom-vm-2"
  machine_type = "f1-micro"
  zone = "europe-west2-b"

  boot_disk {
    initialize_params {
        image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    network = google_compute_network.tf_vpc2.id
    subnetwork = google_compute_subnetwork.tf_subnet_b.id
    access_config {
        
    }
  }
    metadata_startup_script = "${file("./vpc-peering/install-nginx.sh")}"
}

resource "google_compute_network_peering" "tf_np_1" {
  name = "vpc-peering-1"
  network = google_compute_network.tf_vpc1.self_link
  peer_network = google_compute_network.tf_vpc2.self_link
}

resource "google_compute_network_peering" "tf_np_2" {
  name = "vpc-peering-2"
  network = google_compute_network.tf_vpc2.self_link
  peer_network = google_compute_network.tf_vpc1.self_link
}