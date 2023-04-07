variable "project" {
  type    = string
  default = "gcp-training-377619"
}

variable "name" {
  type        = string
  description = "This will be a instance name"
}

variable "region" {
  type    = string
  default = "us-central1"
}

variable "zone" {
  type    = string
  default = "us-central1-a"
}

variable "machine_type" {
  type    = string
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

variable "auto_create_subnetworks" {
  type = bool
}

variable "auto_delete" {
  type = bool
}

variable "maximum_transmission_unit" {
  type = number
}


variable "network_interface" {
  type = object({
    network       = string
    access_config = object({})
  })
}

variable "protocol" {
  type = tuple([string, string])
}

variable "ports" {
  type = tuple([string, string])
}

variable "tags" {
  type = set(string)
}

variable "labels" {
  type = map
}

variable "metadata" {
  type = map
}

variable "source_ranges" {
  type = list
}

variable "email" {
  type = string
}

