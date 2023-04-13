# terraform {
#   required_providers {
#     google = {
#         source = "hashicorp/google"
#         version = "4.58.0"
#     }
#   }
# }


# terraform {
#   required_providers {
#     # mysql = {
#     #   source  = "petoju/mysql"
#     #   version = "~> 3.0.32"
#     # }
#     mysql = {
#       source  = "terraform-providers/mysql"
#       version = ">= 1.9"
#     }
#   }
# }


# provider "mysql" {
#   endpoint = "cloudsql://gcp-training-377619:us-central1:test-sql:3306"
#   username = "root"
#   password = "Gcp@2023"
# }

# resource "mysql_database" "tf_sql_db" {
#   name = "studentdb"
# }

# resource "mysql_user" "tf_sql_dev_user" {
#   user               = "uma"
#   plaintext_password = "Gcp@2023"
# }

# resource "mysql_grant" "tf_grant_user" {
#   user       = mysql_user.tf_sql_dev_user.user
#   database   = "studentdb"
#   privileges = ["SELECT", "INSERT", "UPDATE"]
# }

# terraform {
#   required_providers {
#     docker = {
#       source  = "kreuzwerker/docker"
#       version = "3.0.2"
#     }
#   }
# }
