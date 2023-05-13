
/*
  * Setting up Custom Network
*/
resource "google_compute_network" "tf_vpc1" {
  name = "custom-vpc"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "tf_subnet_a" {
  name = "subnet-a"
  ip_cidr_range = "10.2.1.0/24"
  region = "us-central1"
  network = google_compute_network.tf_vpc1.id
}

resource "google_compute_subnetwork" "tf_subnet_b" {
  name = "subnet-b"
  ip_cidr_range = "10.3.1.0/24"
  region = "us-west4"
  network = google_compute_network.tf_vpc1.id
}

resource "google_compute_firewall" "tf_firewall_ssh" {
  name = "custom-allow-ssh"
  network = google_compute_network.tf_vpc1.id

  allow {
    protocol = "tcp"
    ports = ["22"]
  }

   source_ranges = [ "0.0.0.0/0" ]
}

resource "google_compute_firewall" "tf_firewall_ping2a_from_1a_and_1b" {
  name = "custom-allow-internally"
  network = google_compute_network.tf_vpc1.id

  allow {
    protocol = "icmp"
  }
    source_ranges = [ "10.2.1.0/24", "10.3.1.0/24" ]

}

resource "google_compute_firewall" "tf_firewall_deny_access_to_instance1c" {
  name = "custom-deny-instance1c"
  network = google_compute_network.tf_vpc1.id
  deny {
    protocol = "icmp"
  }
    
    target_tags = ["allow-ping"]
    source_tags = ["deny-ping"]

}

resource "google_compute_instance" "tf_create_vm_subneta" {
  count = 3
  name         = "instance-1${element(["a", "b", "c"], count.index)}"
  machine_type = "f1-micro"
  zone         = "us-central1-a"

  /*
    * To set up network tags for first two VMs
  */
  tags = count.index > 1 ?["deny-ping"] : []

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
      labels = {
        my_label = "value"
      }
    }
  }

  network_interface {
    network = google_compute_network.tf_vpc1.id
    subnetwork = google_compute_subnetwork.tf_subnet_a.id
    access_config {
      // Ephemeral public IP
    }
  }
}

resource "google_compute_instance" "tf_create_vm_subnetb" {
  count = 2
  name         = "instance-2${element(["a", "b"], count.index)}"
  machine_type = "f1-micro"
  zone         = "us-west4-a"

  /*
    * To set up network tags for the second VM
  */
  tags = count.index < 1 ? ["allow-ping"] : [] 

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
      labels = {
        my_label = "value"
      }
    }
  }

  network_interface {
    network = google_compute_network.tf_vpc1.id
    subnetwork = google_compute_subnetwork.tf_subnet_b.id
    access_config {
      // Ephemeral public IP
    }
  }
}