variable "project" {
  default = "gcp-training-377619"
}

variable "region" {
  default = "us-central1"
}

variable "zone" {
  default = "us-central1-a"
}

variable "machine_type" {
    default = "f1-micro"
}

variable "network" {
  default = "vpc-network"
}

variable "image" {
  default = "debian-cloud/debian-10"
}

variable "credentials" {
  default = "credentials.json"
}

variable "instance_template" {

}