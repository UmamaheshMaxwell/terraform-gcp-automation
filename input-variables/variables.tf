variable "name" {
  type        = string
  description = "This will be a instance name"
}

variable "zone" {
  type        = string
  description = "This will be a specific zone"
}

variable "machine_type" {
  type        = string
  description = "This will be a machine type"
}

variable "image" {
  type        = string
  description = "This will be a image"
}


variable "auto_delete" {
  type = bool
}

variable "maximum_transmission_unit" {
  type = number
}

variable "auto_create_subnetworks" {
  type = bool
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

