/*
    * Create an instance group
*/
resource "google_compute_region_instance_group_manager" "tf_instance_group" {
    name = "instance-group"

    base_instance_name = "instance"
    target_size = 3

    version {
      instance_template = var.instance_template
    }

    auto_healing_policies {
      health_check = google_compute_health_check.health_check.id
      initial_delay_sec = 300
    }
}

resource "google_compute_health_check" "health_check" {
  name = "lb-health-check"
  tcp_health_check {
    port = "80"
  }
}