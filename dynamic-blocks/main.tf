/*
    * Dynamic Blocks
    ? Terraform dynamic blocks are a special Terraform block type that provide 
    ? the functionality of a for expression by creating multiple nested blocks. 
*/

# resource "google_compute_firewall" "tf_vpc_firewall" {
#     name = "custom-firewall"
#     network = "default"
#     allow {
#       protocol = "icmp"
#     }
#     allow {
#       protocol = "tcp"
#       ports = ["22", "80"]
#     }
#      source_ranges = ["0.0.0.0/0"]
# }

/*
    ? In the above code, there two allow blocks which we can  
    ? combine into single block using dynamic block as shown below
*/

locals {
  allow = [
    { protocol: "icmp", ports: []}, 
    { protocol: "tcp", ports: ["22", "80"] }]
}

resource "google_compute_firewall" "tf_vpc_firewall_icmp" {
        name = "custom-firewall"
        network = "default"
        dynamic "allow" {
            for_each = local.allow
            content {
                protocol = allow.value.protocol
                ports = allow.value.ports
            }
        }   
     source_ranges = ["0.0.0.0/0"]
}





