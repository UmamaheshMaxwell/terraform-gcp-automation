/*
  * Connect to GCP
*/
provider "google" {
  project     = var.project
  region      = var.region
  credentials = var.credentials
}

# module "instance_creation" {
#   source = "./instance-creation"
#   name = "dev-vm"
#   zone = var.zone
#   machine_type = var.machine_type
#   image = var.image
# }

# module "instance_template_data" {
#   source = "./instance-template"
# }

# # instance_groups depend on instance_template_data
# module "instance_groups" {
#   source = "./instance-groups"
#   instance_template = module.instance_template_data.instance_template.id
# }

# module "vpc_peering" {
#   source = "./vpc-peering"
# }

# module "network_load_balancig" {
#   source = "./network-load-balancing"
# }

# module "cloud_sql" {
#   source = "./cloud-sql"
# }

module "input_variables" {
  source                    = "./input-variables"
  name                      = var.name
  zone                      = var.zone
  machine_type              = var.machine_type
  image                     = var.image
  network_interface         = var.network_interface
  tags                      = var.tags
  auto_create_subnetworks   = var.auto_create_subnetworks
  maximum_transmission_unit = var.maximum_transmission_unit
  auto_delete               = var.auto_delete
  protocol                  = var.protocol
  ports                     = var.ports
  labels                    = var.labels
  metadata                  = var.metadata
  source_ranges             = var.source_ranges
}
