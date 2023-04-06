/*
   * Think of output variables as return value of a Terraform module. 

   ? 1. We can use outputs to expose a subset of a child module’s resource attributes to a parent module. 
   ? 2. We can use outputs to print values from a root module in the CLI output after running terraform apply.
   ? 3. If you are using a remote state, other configurations can access the outputs of a root module, via the terraform_remote_state data source
*/

resource "google_compute_network" "tf_vpc" {
  name = "custom-vpc"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "tf_subnet_a" {
  name = "subnet-a"
  ip_cidr_range = "10.2.1.0/24"
  region = "us-central1"
  network = google_compute_network.tf_vpc.id
}

resource "google_compute_instance" "tf_instance" {
  name         = "test-vm"
  machine_type = "e2-medium"
  zone = "us-central1-a"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }


  network_interface {
    network = google_compute_network.tf_vpc.id
    subnetwork = google_compute_subnetwork.tf_subnet_a.id
    access_config {
      // Ephemeral public IP
    }
  }
}

