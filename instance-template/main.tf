/*
 * Crate a VPC
*/
resource "google_compute_network" "tf_vpc_network" {
  name = var.network
  auto_create_subnetworks = false
}

/*
 * Crate a subnetwork
*/
resource "google_compute_subnetwork" "tf_vpc_subnetwork" {
  name = "subnet-a"
  ip_cidr_range = "10.8.0.0/16"
  network = google_compute_network.tf_vpc_network.id
}

/*
 * Crate a firewall
*/
resource "google_compute_firewall" "tf_vpc_firewall_icmp" {
    name = "custom-allow-icmp"
    network = google_compute_network.tf_vpc_network.id
    allow {
      protocol = "icmp"
    }
     source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "tf_vpc_firewall_tcp" {
    name = "custom-allow-ssh"
    network = google_compute_network.tf_vpc_network.id
    allow {
      protocol = "tcp"
      ports = ["22", "80"]
    }
    source_ranges = ["0.0.0.0/0"]
    
}

/*
    * Create an instance template
*/
resource "google_compute_instance_template" "tf_instance_template" {
  name = "instance-template"
  machine_type = var.machine_type
  
  disk {
    source_image = var.image
  }

  network_interface {
    network = google_compute_network.tf_vpc_network.id
    subnetwork = google_compute_subnetwork.tf_vpc_subnetwork.id
    access_config {
      
    }
  }

  metadata_startup_script = "${file("./instance-template/startup-script.sh")}"
}

