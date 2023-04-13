locals {
  service_account = "terraform@gcp-training-377619.iam.gserviceaccount.com"
}

data "google_iam_policy" "tf_no_auth" {
  binding {
    role = "roles/run.invoker"
    members = [
      "allUsers"
    ]
  }
}

resource "google_cloud_run_service_iam_policy" "tf_no_auth" {
    location = google_cloud_run_service.tf_cloud_run.location
    project = google_cloud_run_service.tf_cloud_run.project
    service = google_cloud_run_service.tf_cloud_run.name
    policy_data = data.google_iam_policy.tf_no_auth.policy_data
}

resource "google_cloud_run_service" "tf_cloud_run" {
  name     = "cloud-run-service"
  location = "us-central1"

  template {
    spec {
      containers {
        image = "us-docker.pkg.dev/cloudrun/container/hello"
      }
      service_account_name = local.service_account
    }
  }
  traffic {
    percent         = 100
    latest_revision = true
  }
}