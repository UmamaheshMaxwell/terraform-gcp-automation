/*
    * The Terraform language does not support user-defined functions, 
    * and so only the functions built in to the language are available for use
*/
/*
    ? for_each allows us to create multiple instances of a resource 
    ? or module based on a map or set of values.
*/

locals {
  instances = [
    { name : "custom-vm1", machine_type : "f1-micro", zone : "us-central1-a" },
    { name : "custom-vm2", machine_type : "e2-small", zone : "us-central1-b" },
    { name : "custom-vm3", machine_type : "e2-medium", zone : "us-central1-c"}
  ]
}

resource "google_compute_instance" "tf_instances" {
  for_each = {
    for key, value in local.instances : key => value
  }

  name         = each.value.name
  machine_type = each.value.machine_type
  zone         = each.value.zone
  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }
  network_interface {
    network = "default"
    access_config {

    }
  }
}

# resource "google_compute_instance" "tf_vm1" {

#   name         = "custom-vm1"
#   machine_type = "f1-micro"
#   zone         = "us-central1-a"
#   boot_disk {
#     initialize_params {
#       image = "debian-cloud/debian-11"
#     }
#   }
#   network_interface {
#     network = "default"
#     access_config {

#     }
#   }
# }

# resource "google_compute_instance" "tf_vm2" {
#   name         = "custom-vm2"
#   machine_type = "e2-small"
#   zone         = "us-central1-a"
#   boot_disk {
#     initialize_params {
#       image = "debian-cloud/debian-11"
#     }
#   }
#   network_interface {
#     network = "default"
#     access_config {

#     }
#   }
# }
# resource "google_compute_instance" "tf_v3" {
#   name         = "custom-vm3"
#   machine_type = "e2-medium"
#   zone         = "us-central1-a"
#   boot_disk {
#     initialize_params {
#       image = "debian-cloud/debian-11"
#     }
#   }
#   network_interface {
#     network = "default"
#     access_config {

#     }
#   }
# }
