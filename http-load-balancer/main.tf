/*
    * This script will help us to create a HTTP Load Balancer
*/
terraform {
  required_providers {
    godaddy = {
      source  = "n3integration/godaddy"
      version = "~> 1.9.1"
    }
  }
}

provider "godaddy" {
  key    = jsondecode(file("./godaddy.json")).key
  secret = jsondecode(file("./godaddy.json")).secret
}

data "google_compute_network" "tf_default" {
  name = "default"
}

/*
    * Create an instance template
*/
resource "google_compute_instance_template" "tf_instance_template1" {

  name         = "http-lb-template-1"
  machine_type = "e2-small"

  disk {
    source_image = "ubuntu-os-cloud/ubuntu-1804-lts"
  }

  network_interface {
    network = data.google_compute_network.tf_default.self_link
    access_config {
      // Ephemeral public IP
    }
  }
  metadata_startup_script = file("./http-load-balancer/http-load-balancer.sh")
}

resource "google_compute_instance_template" "tf_instance_template2" {

  name         = "http-lb-template-2"
  machine_type = "e2-small"

  disk {
    source_image = "ubuntu-os-cloud/ubuntu-1804-lts"
  }

  network_interface {
    network = data.google_compute_network.tf_default.self_link
    access_config {
      // Ephemeral public IP
    }
  }
  metadata_startup_script = file("./http-load-balancer/http-load-balancer.sh")
}

/*
    * Create an instance group
*/
resource "google_compute_region_instance_group_manager" "tf_instance_group1" {
  name = "http-central-group"

  base_instance_name        = "http-lb-central"
  target_size               = 2
  region                    = "us-central1"
  distribution_policy_zones = ["us-central1-a", "us-central1-b"]

  // Setting port for backend service
  named_port {
    name = "http-lb-port"
    port = 80
  }

  version {
    instance_template = google_compute_instance_template.tf_instance_template1.self_link
  }

  auto_healing_policies {
    health_check      = google_compute_http_health_check.tf_http_health_check.id
    initial_delay_sec = 300
  }
}

/*
    * Create an instance group
*/
resource "google_compute_region_instance_group_manager" "tf_instance_group2" {
  name = "http-singpore-group"

  base_instance_name        = "http-lb-singapore"
  target_size               = 2
  region                    = "asia-southeast1"
  distribution_policy_zones = ["asia-southeast1-b", "asia-southeast1-c"]

  // Setting port for backend service
  named_port {
    name = "http-lb-port"
    port = 80
  }

  version {
    instance_template = google_compute_instance_template.tf_instance_template2.self_link
  }

  auto_healing_policies {
    health_check      = google_compute_http_health_check.tf_http_health_check.id
    initial_delay_sec = 300
  }
}

resource "google_compute_http_health_check" "tf_http_health_check" {
  name               = "http-lb-health-check"
  timeout_sec        = 5
  check_interval_sec = 5

  healthy_threshold   = 2
  unhealthy_threshold = 2

  request_path = "/"
  port         = "80"
}

resource "google_compute_global_address" "tf_external_ip" {
  name = "http-external-ip"
}

# /*
#     * To create front-end configuration for HTTP
# */

# # http proxy

# resource "google_compute_target_http_proxy" "tf_http_proxy" {
#   name     = "http-proxy"
#   url_map  = google_compute_url_map.tf_url_map.id
# }

# # url map
# # UrlMaps are used to route requests to a backend service based on rules 
# # that you define for the host and path of an incoming URL.
# resource "google_compute_url_map" "tf_url_map" {
#   name            = "http-url-map"
#   default_service = google_compute_backend_service.tf_http_backend.id
# }

# # forwarding rule
# resource "google_compute_global_forwarding_rule" "tf_forwarding_rule" {
#   name                  = "http-frontend"
#   ip_protocol           = "TCP"
#   load_balancing_scheme = "EXTERNAL"
#   port_range            = "80"
#   target                = google_compute_target_http_proxy.tf_http_proxy.id
#   ip_address            = google_compute_global_address.tf_external_ip.id
# }

/*
    * To create front-end configuration for HTTPS
*/

# url map
# UrlMaps are used to route requests to a backend service based on rules 
# that you define for the host and path of an incoming URL.
resource "google_compute_url_map" "tf_url_map" {
  name            = "https-url-map"
  default_service = google_compute_backend_service.tf_http_backend.id

  host_rule {
    hosts = ["devopswithkube.com"]

    path_matcher = "path-matcher"
  }

  path_matcher {
    name            = "path-matcher"
    default_service =  google_compute_backend_service.tf_http_backend.id

    path_rule {
      paths   = ["/nature/*"]
      service = google_compute_backend_bucket.tf_backend_bucket_1.id
    }

    path_rule {
      paths   = ["/dogs/*"]
      service = google_compute_backend_bucket.tf_backend_bucket_2.id
    }
  }
}

resource "google_compute_managed_ssl_certificate" "tf_ssl_certificate" {
  name = "https-certs"
  managed {
    domains = ["devopswithkube.com"]
  }
}

resource "google_compute_target_https_proxy" "tf_https_proxy" {
  name             = "https-proxy"
  url_map          = google_compute_url_map.tf_url_map.id
  ssl_certificates = [google_compute_managed_ssl_certificate.tf_ssl_certificate.id]
}

# forwarding rule
resource "google_compute_global_forwarding_rule" "tf_forwarding_rule" {
  name                  = "https-frontend"
  ip_protocol           = "TCP"
  load_balancing_scheme = "EXTERNAL"
  port_range            = "443"
  target                = google_compute_target_https_proxy.tf_https_proxy.id
  ip_address            = google_compute_global_address.tf_external_ip.id
}

locals {
  backends = [
    { group : google_compute_region_instance_group_manager.tf_instance_group1.instance_group },
    { group : google_compute_region_instance_group_manager.tf_instance_group2.instance_group }
  ]
}

/*
    * To create backend configuration
*/

resource "google_compute_backend_service" "tf_http_backend" {
  name                            = "http-backend"
  protocol                        = "HTTP"
  port_name                       = "http-lb-port"
  timeout_sec                     = 30
  session_affinity                = "CLIENT_IP"
  connection_draining_timeout_sec = 300
  health_checks                   = [google_compute_http_health_check.tf_http_health_check.id]
  dynamic "backend" {
    for_each = local.backends
    content {
      group = backend.value.group
    }
  }
  # backend {
  #   group = google_compute_region_instance_group_manager.tf_instance_group1.instance_group
  # }
  # backend {
  #   group = google_compute_region_instance_group_manager.tf_instance_group2.instance_group
  # }

}

/*
    * To create backend storage
*/

resource "google_storage_bucket" "tf_bucket_1" {
  name                        = "http-backend-bucket1"
  location                    = "us-east1"
  uniform_bucket_level_access = true
  storage_class               = "STANDARD"
  // delete bucket and contents on destroy.
  force_destroy = true
}

resource "google_storage_bucket" "tf_bucket_2" {
  name                        = "http-backend-bucket2"
  location                    = "us-east1"
  uniform_bucket_level_access = true
  storage_class               = "STANDARD"
  // delete bucket and contents on destroy.
  force_destroy = true
}

resource "google_storage_bucket_object" "tf_image_nature" {
  name         = "nature/Nature.jpeg"
  source       = "./http-load-balancer/images/nature/Nature.jpeg"
  content_type = "image/jpeg"
  bucket = google_storage_bucket.tf_bucket_1.name
}

resource "google_storage_bucket_object" "tf_nature_home" {
  name         = "nature/home.html"
  source       = "./http-load-balancer/images/nature/home.html"
  content_type = "image/jpeg"
  bucket = google_storage_bucket.tf_bucket_1.name
}

resource "google_storage_bucket_object" "tf_image_dog" {
  name         = "dogs/CuteDog.jpg"
  source       = "./http-load-balancer/images/dogs/CuteDog.jpg"
  content_type = "image/jpeg"
  bucket = google_storage_bucket.tf_bucket_2.name
}


resource "google_storage_bucket_object" "tf_dog_home" {
  name         = "dogs/home.html"
  source       = "./http-load-balancer/images/dogs/home.html"
  content_type = "image/jpeg"
  bucket = google_storage_bucket.tf_bucket_2.name
}

# Make buckets public
resource "google_storage_bucket_iam_member" "tf_bucket_memeber1" {
  bucket = google_storage_bucket.tf_bucket_1.name
  role   = "roles/storage.objectViewer"
  member = "allUsers"
}

resource "google_storage_bucket_iam_member" "tf_bucket_memeber2" {
  bucket = google_storage_bucket.tf_bucket_2.name
  role   = "roles/storage.objectViewer"
  member = "allUsers"
}

# Create LB backend buckets
resource "google_compute_backend_bucket" "tf_backend_bucket_1" {
  name        = "nature"
  description = "Contains nature image"
  bucket_name = google_storage_bucket.tf_bucket_1.name
  enable_cdn = true
}

resource "google_compute_backend_bucket" "tf_backend_bucket_2" {
  name        = "dogs"
  description = "Contains dog image"
  bucket_name = google_storage_bucket.tf_bucket_2.name
  enable_cdn = true
}


/*
    * Setting up Cloud DNS
*/

resource "google_dns_managed_zone" "tf_managed_zone" {
  name     = "prod-zone"
  dns_name = "devopswithkube.com."
  dnssec_config {
    state = "on"
  }
}

resource "google_dns_record_set" "tfs_frontend" {
  name = "${google_dns_managed_zone.tf_managed_zone.dns_name}"
  managed_zone = google_dns_managed_zone.tf_managed_zone.name
  type = "A"
  ttl  = 300
  rrdatas = [google_compute_global_address.tf_external_ip.address]
}

resource "google_dns_record_set" "tf_cname" {
  name         = "www.${google_dns_managed_zone.tf_managed_zone.dns_name}"
  managed_zone = google_dns_managed_zone.tf_managed_zone.name
  type         = "CNAME"
  ttl          = 300
  rrdatas      = ["devopswithkube.com."]
}

data "google_dns_managed_zone" "tf_managed_zone" {
  name = google_dns_managed_zone.tf_managed_zone.name
}

data "google_dns_record_set" "tf_record_set" {
  managed_zone = data.google_dns_managed_zone.tf_managed_zone.name
  name = "${google_dns_managed_zone.tf_managed_zone.dns_name}"
  type = "NS"
}

resource "godaddy_domain_record" "tfs_domain_record" {
  domain = "devopswithkube.com"
  addresses = [google_compute_global_address.tf_external_ip.address]
  nameservers = data.google_dns_record_set.tf_record_set.rrdatas
} 