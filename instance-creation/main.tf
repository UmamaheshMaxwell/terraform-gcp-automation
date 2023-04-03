
/*
 * Crate a VM
*/
resource "google_compute_instance" "tf_vm" {
  name = "dev-vm"
  machine_type = var.machine_type
  zone = var.zone

  network_interface {
    network = "default"

    access_config {
      // Ephemeral public IP
    }
  }

  boot_disk {
    initialize_params {
      image = var.image
    }
  }
}