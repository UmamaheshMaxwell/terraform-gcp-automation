# output "target_pool" {
#   description = "Self link of the target pool"
#   value       = google_compute_target_pool.tf_target_pool.self_link
# }

# output "service_account_name" {
#   value = data.google_service_account.tf_sa_name.email
# }

# output "instance_template" {
#   value = module.instance_template_data
# }

# output "vpc" {
#   value = module.output_variables.vpc
# }

# output "subnet" {
#   value = module.output_variables.subnet
# }

# output "public_ip" {
#   value = module.output_variables.public_ip
# }

output "nameservers" {
  value = module.http_load_balancing.nameservers
}
output "godaddy_key" {
  value = jsondecode(file("./godaddy.json")).key
}

output "godaddy_secret" {
  value = jsondecode(file("./godaddy.json")).secret
}