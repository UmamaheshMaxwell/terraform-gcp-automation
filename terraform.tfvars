
/*
  ? Number
*/
maximum_transmission_unit = 1460

/*
  ! String
*/
name         = "test-vm"
zone         = "us-central1-a"
machine_type = "f1-micro"
image        = "debian-cloud/debian-10"
/*
  ? Boolean
*/
auto_delete             = true
auto_create_subnetworks = false

/*
  ? List(<string>), List(<Object()>)
*/
source_ranges = ["0.0.0.0/0", "0.0.0.0/0", "17.5.7.3/32"]

/*
  ! The difference between a List and Set is that 
  ! Set values are all guaranteed to be unique. 
  ! Also, Sets do not have any particular ordering
  ? set  => ["a", "b"]      all elements are unique
  ? list => ["a", "b", "b"] the elements don't have to be unique
*/
/*
  ? Set(<TYPE>)
  * If the set's elements were strings, they will be in lexicographical order; 
  * sets of other element types do not guarantee any particular order of elements.
*/
tags = ["web", "server"]

/*
  ? Map(<TYPE>)
  * Maps are a collection of string keys and string values. These can be useful for 
  * selecting values based on predefined parameters such as the server configuration
*/

metadata = {
  component   = "frontend"
  environment = "development"
  state       = "active"
}

labels = {
  category = "generic"
  billing  = "monthly"
  tracking = "zonal"
}
/*
  ? Object({ATTR_NAME=type,...})
*/
network_interface = {
  access_config = {}
  network       = "default"
}
/*
  ! Tuple([<number>,<string>,<bool>,...])
*/

protocol = ["icmp", "tcp"]
ports    = ["22", "88"]


/*
  ? This email is for iam-roles
*/
email = "maheshmeka16@gmail.com"
