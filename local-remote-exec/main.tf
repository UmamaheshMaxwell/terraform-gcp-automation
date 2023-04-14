# /*
#  * Crate a VM
# */
# resource "google_compute_instance" "tf_vm" {
#   name         = "terraform-vm"
#   machine_type = "e2-small"
#   zone         = "us-central1-a"

#   network_interface {
#     network = "default"

#     access_config {
#       // Ephemeral public IP
#     }
#   }

#   boot_disk {
#     initialize_params {
#       image = "debian-cloud/debian-11"
#     }
#   }

#   provisioner "local-exec" {
#     command = "echo Name: ${google_compute_instance.tf_vm.name} >> ./local-remote-exec/details.txt"
#   }

#   provisioner "local-exec" {
#     command = "echo -e 'InstanceId:${google_compute_instance.tf_vm.instance_id}\nNetworkIP:${google_compute_instance.tf_vm.network_interface[0].network_ip}\nPublicIP:${google_compute_instance.tf_vm.network_interface[0].access_config[0].nat_ip}\nProvision:${google_compute_instance.tf_vm.scheduling[0].provisioning_model}' >> ./local-remote-exec/details.txt"
#   }
#   provisioner "local-exec" {
#     command = "echo 'line1\nline2' > filo.txt"
#   }
# }

# resource "google_compute_network" "tf_vpc1" {
#   name                    = "vpc-1"
#   auto_create_subnetworks = false


#   provisioner "local-exec" {
#     # self = google_compute_network.tf_vpc1
#     command = "echo ${self.name} is created >> ./local-remote-exec/details.txt"
#   }

#   # This will get executed when you run terraform destroy 
#   provisioner "local-exec" {
#     when = destroy
#     command = "echo resource is destroyed >> ./local-remote-exec/details.txt"
#   }
# }


resource "null_resource" "health_check" {

 provisioner "local-exec" {
    command = "./local-remote-exec/healthcheck.sh"
    interpreter = [
      "bash"
    ]
  }
}