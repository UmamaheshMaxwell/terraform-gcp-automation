/*
    * ******************* This script sets up cloud SQL ********************** *
    * Note : Your service account needs to have a role Service Networking Admin
    * else you will have to have a custome role created with 
    * servicenetworking.services.addPeering permission 
*/
provider "google" {
  project     = var.project
  region      = var.region
  credentials = file(var.credentials)
}

resource "google_compute_network" "tf_private_network" {
  provider = google
  name     = "private-network"
}

resource "google_compute_global_address" "tf_private_ip" {
  provider      = google
  name          = "private-ip-address"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = google_compute_network.tf_private_network.id
}

resource "google_service_networking_connection" "tf_private_vpc" {
  provider                = google
  network                 = google_compute_network.tf_private_network.id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.tf_private_ip.name]
}

resource "google_sql_database_instance" "tf_sql_instance" {
  provider         = google
  name             = "terraform-sql"
  database_version = "MYSQL_8_0"

  root_password = "Gcp@2023"

  # This flag only protects instances from deletion within Terraform.
  deletion_protection = false // defaut value is true

  # To protect your instances from accidental deletion across all surfaces 
  # (API, gcloud, Cloud Console and Terraform), use the API 
  # settings.deletion_protection_enabled = true

  depends_on = [google_service_networking_connection.tf_private_vpc]

  settings {
    deletion_protection_enabled = false // defaut value is true
    disk_type                   = "PD_SSD"
    disk_size                   = 10
    disk_autoresize             = false

    tier = "db-f1-micro" 
    # To create a custom machine type we can use the below statement
    # tier = "db-custom-12-61440" // 12 is CPUS and 61440 is around 60 GB of Memory

    ip_configuration {
      ipv4_enabled                                  = true // To enable public IP
      private_network                               = google_compute_network.tf_private_network.id
      enable_private_path_for_google_cloud_services = true
      authorized_networks {
        name  = "mysql-workbench" // any name of your choice
        value = "1.2.3.4" // Your public IP
      }
    }
  }
}
resource "google_sql_database" "database" {
  name     = "studentdb"
  instance = google_sql_database_instance.tf_sql_instance.name
}
/*
    * Second-generation instances include a default 'root'@'%' user with no password. 
    * This user will be deleted by Terraform on instance creation. 
    * You should use google_sql_user to define a custom user with a restricted 
    * host and strong password.
*/
resource "google_sql_user" "tf_sql_user" {
  instance = google_sql_database_instance.tf_sql_instance.name
  name     = "uma"
  password = "Gcp@2023"
}



