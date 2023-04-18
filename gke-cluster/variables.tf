variable "project" {
  default = "gke-training-377619"
}

variable "region" {
  default = "us-central1"
}

variable "zone" {
  default = "us-central1-a"
}

variable "credentials" {
  default = "account.json"
}

variable "cluster_name" {
  default = "k8s-cluster"
}

variable "machine_type" {
  default = "e2-small"
}

variable "node_pool" {
  default = "web-pool"
}

variable "prefix" {
  default = "terraform/state"
}