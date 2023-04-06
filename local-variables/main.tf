/*
    * Local Variables
    ? Local Variables are named values which can be assigned and used in our code. 
    ? It mainly serves the purpose of reducing duplication within the Terraform code
*/

locals {
  disk_name                 = "disk"
  disk_type                 = "pd-ssd"
  zone                      = "us-central1"
  image                     = "debian-11-bullseye-v20220719"
  physical_block_size_bytes = 4096
  environment_dev           = "dev" 
  environment_prod          = "prod"
  disk_size                 = 20
  category                  = "billable"
}

resource "google_compute_disk" "dev_disk" {
  name  = "${local.environment_dev}-${local.disk_name}"
  type  = local.disk_type
  zone  = "${local.zone}-a"
  image = local.image
  labels = {
    environment = local.environment_dev
    category = local.category
  }
  physical_block_size_bytes = local.physical_block_size_bytes
  size                      = local.disk_size
}

resource "google_compute_disk" "prod_disk" {
  name  = "${local.environment_prod}-${local.disk_name}"
  type  = local.disk_type
  zone  = "${local.zone}-b"
  image = local.image
  labels = {
    environment = local.environment_prod
    category = local.category
  }
  physical_block_size_bytes = local.physical_block_size_bytes
  size                      = local.disk_size
}
